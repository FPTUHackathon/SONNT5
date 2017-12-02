var signalr = (() => {
    var ConnectionManager = {
        mediaStream: {},
        signaler: {},
        connections: {},
        iceServers: [{ url: "stun:74.125.142.127:19302" }],
    };
    ConnectionManager.createConnection = (partnerUserId, partnerClientId) => {
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
            var frCam = $("#friend-cam")[0];
            attachMediaStream(frCam, event.stream);
        };
        connection.onremovestream = (event) => {
            console.log("WebRTC: removing stream");
        };
        ConnectionManager.connections[partnerUserId] = connection;
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
    ConnectionManager.newSignal = (partnerUserId, partnerClientId, data) => {
        var signal = JSON.parse(data), connection = ConnectionManager.getConnection(partnerUserId, partnerClientId);
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
    ConnectionManager.getConnection = (partnerUserId, partnerClientId) => {
        var connection = ConnectionManager.connections[partnerUserId] || ConnectionManager.createConnection(partnerUserId, partnerClientId);
        return connection;
    };
    //-----
    ConnectionManager.closeAllConnections = () => {
        for (var connectionId in ConnectionManager.connections) {
            ConnectionManager.closeConnection(connectionId);
        }
    };
    //-----
    ConnectionManager.closeConnection = (partnerUserId, partnerClientId) => {
        var connection = ConnectionManager.connections[partnerUserId];
        if (connection) {
            console.log("removing remote stream from partner window");
            var frCam = $("#friend-cam")[0];
            frCam.src = "";
            connection.close();
            delete ConnectionManager.connections[partnerUserId];
        }
    };
    //------
    ConnectionManager.initiateOffer = (partnerUserId, partnerClientId, stream) => {
        if (typeof stream === "undefined" || stream == null || $.isEmptyObject(stream)) {
            console.log('stream is null[2]');
            return;
        }
        var connection = ConnectionManager.getConnection(partnerUserId, partnerClientId);
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
    connection.qs = { 'access_token': localStorage.getItem("token") };
    var ChatHub = connection.createHubProxy("ChatHub");
    //-----------------CHAT HUB------------------------
    ChatHub.on("duplicate", () => {
        $(document.body).html("<h1>Only 1 tab allowed</h1>");
    });
    ChatHub.on("receiveMessage", (userSend, message, date, type, room) => {
        addMessage(room, userSend, message, date, type);
        if (!lastMsgTimestamps[room.RoomId]) lastMsgTimestamps[room.RoomId] = date;
    });
    ChatHub.on('updateUsers', (users) => {
        createChatSliderBar(users);
        listUsers = users;
    });
    ChatHub.on("incomingCall", (callingUser) => {
        console.log(`incoming call from: ${JSON.stringify(callingUser)}`);
        console.log(`calling user connId: ${callingUser.ConnectionId}`);
        createAlertHavingCall(callingUser);
    });
    ChatHub.on("callAccepted", (acceptingUser) => {
        console.log(`call accepted from: ${JSON.stringify(acceptingUser)}.  Initiating WebRTC call and offering my stream up...`);
        GetMedia((stream) => {
            ConnectionManager.initiateOffer(acceptingUser.UserId, acceptingUser.ConnectionId, ConnectionManager.mediaStream);
        });
        // user in call
    });
    ChatHub.on("callDeclined", (decliningUser, reason) => {
        if (decliningUser && decliningUser.ConnectionId) console.log(`call declined from: ${decliningUser.ConnectionId}`);
        else console.log(`can not call`)
        console.log(reason);
        hideCall();
        // user idle
    });
    ChatHub.on("callEnded", (callingUser, reason) => {
        console.log(`call with ${callingUser.ConnectionId} has ended: ${reason}`);
        hideCall();
        ConnectionManager.mediaStream.getTracks().forEach((track) => {
            track.stop();
        });
        ConnectionManager.closeConnection(callingUser.ConnectionId);
        //ConnectionManager.mediaStream = {};
    });
    ChatHub.on('updateUserList', (userList) => {
        console.log(userList)
    });
    ChatHub.on("receiveSignal", (callingUser, data) => {
        ConnectionManager.newSignal(callingUser.UserId, callingUser.ConnectionId, data);
    });
    ChatHub.on("history", (room, messages) => {
        for (var i = 0; i < messages.length; i++) {
            addMessageBefore(room, messages[i].UserId, messages[i].MessContent, new Date(messages[i].CreatedDate), messages[i].Status);
            lastMsgTimestamps[room.RoomId] = messages[i].CreatedDate;
        }
    });

    connection.start().done(() => {
        console.log('connected to SignalR ChatHub... connection id: ' + connection.id);
        user.ConnectionId = connection.id;
    }).fail((e) => {
        console.log(e);
    });

    function GetMedia(cb) {
        getUserMedia({
            video: true,
            audio: true
        },
            (stream) => {
                if (typeof stream === "undefined" || stream == null || $.isEmptyObject(stream)) {
                    console.log('stream is null[1]');
                    return;
                }
                console.log('initializing connection manager');
                ConnectionManager.signaler = ChatHub;
                ConnectionManager.mediaStream = stream;
                console.log('playing my local video feed');
                var videoElement = document.getElementById("my-cam");
                attachMediaStream(videoElement, ConnectionManager.mediaStream);
                if (cb) cb(stream);
            }, (e) => {
                ChatHub.invoke('hangUp');
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
        ChatHub: ChatHub,
        ToggleVideo: ToggleVideo,
        ToggleSound: ToggleSound,
        GetMedia: GetMedia
    };
})();