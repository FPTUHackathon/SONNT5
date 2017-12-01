var signalr = (() => {
    var ConnectionManager = {
        mediaStream: {},
        signaler: {},
        connections: {},
        iceServers: [{ url: "stun:74.125.142.127:19302" }],
    };
    ConnectionManager.createConnection = (partnerClientId) => {
        console.log("WebRTC: creating connection...");
        var connection = new RTCPeerConnection({ iceServers: ConnectionManager.iceServers });
        connection.onicecandidate = (event) => {
            if (event.candidate) {
                console.log("WebRTC: new ICE candidate");
                ConnectionManager.signaler.invoke("sendSignal", JSON.stringify({ "candidate": event.candidate }), partnerClientId);
            } else {
                console.log("WebRTC: ICE candidate gathering complete");
            }
        };
        connection.onstatechange = () => {
            var states = {
                'iceConnectionState': connection.iceConnectionState,
                'iceGatheringState': connection.iceGatheringState,
                'readyState': connection.readyState,
                'signalingState': connection.signalingState
            };
            console.log(JSON.stringify(states));
        };
        connection.onaddstream = (event) => {
            console.log("WebRTC: adding stream");
            //---
            console.log("binding remote stream to the partner window");
            var otherVideo = document.getElementById("friend-cam");
            attachMediaStream(otherVideo, event.stream);
        };
        connection.onremovestream = (event) => {
            console.log("WebRTC: removing stream");
            //----
            console.log("removing remote stream from partner window");
            var otherVideo = document.getElementById("friend-cam");
            otherVideo.src = "";
        };
        ConnectionManager.connections[partnerClientId] = connection;
        return connection;
    };
    //------
    ConnectionManager.receivedSdpSignal = (connection, partnerClientId, sdp) => {
        console.log("WebRTC: processing sdp signal");
        connection.setRemoteDescription(new RTCSessionDescription(sdp),
            function () {
                if (connection.remoteDescription.type == "offer") {
                    console.log("WebRTC: received offer, sending response...");
                    connection.addStream(ConnectionManager.mediaStream);
                    connection.createAnswer(function (desc) {
                        connection.setLocalDescription(desc,
                            function () {
                                ConnectionManager.signaler.invoke("sendSignal",
                                    JSON.stringify({ "sdp": connection.localDescription }),
                                    partnerClientId);
                            });
                    },
                        function (error) { console.log(`Error creating session description: ${error}`); });
                } else if (connection.remoteDescription.type == "answer") {
                    console.log("WebRTC: received answer");
                }
            });
    };
    //----
    ConnectionManager.newSignal = (partnerClientId, data) => {
        var signal = JSON.parse(data), connection = ConnectionManager.getConnection(partnerClientId);
        console.log("WebRTC: received signal");
        if (signal.sdp) {
            ConnectionManager.receivedSdpSignal(connection, partnerClientId, signal.sdp);
        } else if (signal.candidate) {
            ConnectionManager.receivedCandidateSignal(connection, partnerClientId, signal.candidate);
        }
    };
    //-----
    ConnectionManager.receivedCandidateSignal = (connection, partnerClientId, candidate) => {
        console.log("WebRTC: processing candidate signal");
        connection.addIceCandidate(new RTCIceCandidate(candidate));
    };
    //-----
    ConnectionManager.getConnection = (partnerClientId) => {
        var connection = ConnectionManager.connections[partnerClientId] || ConnectionManager.createConnection(partnerClientId);
        return connection;
    };
    //-----
    ConnectionManager.closeAllConnections = () => {
        for (var connectionId in ConnectionManager.connections) {
            ConnectionManager.closeConnection(connectionId);
        }
    };
    //-----
    ConnectionManager.closeConnection = (partnerClientId) => {
        var connection = ConnectionManager.connections[partnerClientId];
        if (connection) {
            console.log("removing remote stream from partner window");
            var otherVideo = document.getElementById("friend-cam");
            otherVideo.src = "";
            connection.close();
            delete ConnectionManager.connections[partnerClientId];
        }
    };
    //------
    ConnectionManager.initiateOffer = (partnerClientId, stream) => {
        if (stream == null || stream == {}) {
            console.log('stream is null');
            return;
        }
        var connection = ConnectionManager.getConnection(partnerClientId);
        connection.addStream(stream);
        console.log("stream added on my end");
        connection.createOffer((desc) => {
            connection.setLocalDescription(desc,
                () => {
                    ConnectionManager.signaler.invoke("sendSignal", JSON.stringify({ "sdp": connection.localDescription }), partnerClientId);
                });
        },
            (error) => {
                console.log(`Error creating session description: ${error}`);
            });
    };
    //-----------------------HUBS----------------------
    $.support.cors = true;
    var connection = $.hubConnection(Config.Api);
    var ChatHub = connection.createHubProxy("ChatHub");
    var CallHub = connection.createHubProxy("CallHub");
    //-----------------CHAT HUB------------------------
    ChatHub.on("duplicate", () => {
        $(document.body).html("<h1>Only 1 tab allowed</h1>");
    });
    ChatHub.on("receiveMessage", (message, type, roomId) => {
        console.log(`${roomId} receive ${message} of ${type}`);
    });
    ChatHub.on('updateUsers', (users) => {
        createChatSliderBar(users);
    });
    connection.start().done(() => {
        console.log('connected to SignalR hub... connection id: ' + ChatHub.connection.id);
    }).fail((event) => {
        console.log(event);
    });
    //---------------CALL HUB--------------------------
    CallHub.on("incomingCall", (callingUser) => {
        console.log(`incoming call from: ${JSON.stringify(callingUser)}`);
        console.log(`calling user connId: ${callingUser.ConnectionId}`);
        GetMedia((stream) => {
            var videoCall = document.getElementById('video-call');
            videoCall.style.display = 'block';
            CallHub.invoke('answerCall', true, callingUser.ConnectionId);
        })
    });
    CallHub.on("callAccepted", (acceptingUser) => {
        console.log(`call accepted from: ${JSON.stringify(acceptingUser)}.  Initiating WebRTC call and offering my stream up...`);
        ConnectionManager.initiateOffer(acceptingUser.ConnectionId, ConnectionManager.mediaStream);
        // user in call
    });
    CallHub.on("callDeclined", (decliningConnectionId, reason) => {
        console.log(`call declined from: ${decliningConnectionId}`);
        console.log(reason);
        // user idle
    });
    CallHub.on("callEnded", (connectionId, reason) => {
        console.log("call with " + connectionId + " has ended: " + reason);
        ConnectionManager.closeConnection(connectionId);
        //user idle
    });
    CallHub.on('updateUserList', (userList) => {
        console.log(userList)
    });
    CallHub.on("receiveSignal", (callingUser, data) => {
        ConnectionManager.newSignal(callingUser.ConnectionId, data);
    });

    connection.start().done(() => {
        console.log('connected to SignalR ChatHub... connection id: ' + ChatHub.connection.id);
        console.log('connected to SignalR CallHub... connection id: ' + CallHub.connection.id);
    }).fail((e) => {
        console.log(e);
    });

    function GetMedia(cb) {
        getUserMedia({
            video: true,
            audio: true
        },
            (stream) => {
                if (stream == null || stream == {}) {
                    console.log('stream is null');
                    return;
                }
                console.log('initializing connection manager');
                ConnectionManager.signaler = CallHub;
                ConnectionManager.mediaStream = stream;
                console.log('playing my local video feed');
                var videoElement = document.getElementById("my-cam");
                attachMediaStream(videoElement, ConnectionManager.mediaStream);
                cb(stream);
            }, (e) => {
                CallHub.invoke('hangUp');
                console.log(e);
            });
    }

    var enableVid = true;
    var enableSound = true;

    function ToggleVideo() {
        ConnectionManager.mediaStream.getVideoTracks().forEach((track) => track.enabled = !enableVid);
        enableVid = !enableVid
    }

    function ToggleSound() {
        ConnectionManager.mediaStream.getAudioTracks().forEach((track) => track.enabled = !enableSound);
        enableVid = !enableSound
    }

    return {
        ConnectionManager: ConnectionManager,
        ChatHub: ChatHub,
        CallHub: CallHub,
        ToggleVideo: ToggleVideo,
        ToggleSound: ToggleSound,
        GetMedia: GetMedia
    };
})();