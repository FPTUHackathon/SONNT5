//----GLOBAL VARIABLE----
var HEIGHT_NAVIGATION = 52;
var HEIGHT_MESSAGE_INPUT = 59;
////----GLOBAL VARIABLE----

//----NAVIGATION----

////----NAVIGATION----

//----CHAT SLIDER BAR----

function chatSliderBarCalcHeight() {
    var result = $(window).height() - HEIGHT_NAVIGATION;
    $("#chat-slidebar").css("height",result);
}
function createChatSliderBar(list) {
    var chatSlidebar = document.getElementById("chat-slidebar");
    $("#chat-slidebar").empty();
    var item = "";
    for (var i = 0; i < list.length; i++) {
        if (list[i].UserId == user.UserId) continue;
        var item = document.createElement("div");
        item.classList.add("sidebar-name");
        item.innerHTML = `<a href="javascript:register_popup('${list[i].ConnectionId}', '${list[i].Name}', '${list[i].UserId}');"> <img width="30" height="30" src="" /> <span>${list[i].Name}</span></a>`;
        chatSlidebar.appendChild(item);
        item = "";
    }
}
////----CHAT SLIDER BAR----


//---- MANAGE CHAT POPUP----

Array.remove = function (array, from, to) {
    var rest = array.slice((to || from) + 1 || array.length);
    array.length = from < 0 ? array.length + from : from;
    return array.push.apply(array, rest);
};

//this variable represents the total number of popups can be displayed according to the viewport width
var total_popups = 0;

//arrays of popups ids
var popups = [];

//this is used to close a popup
function close_popup(id) {
    for (var iii = 0; iii < popups.length; iii++) {
        if (id == popups[iii]) {
            Array.remove(popups, iii);
            document.getElementById(id).style.display = "none";
            calculate_popups();
            return;
        }
    }
}

//displays the popups. Displays based on the maximum number of popups that can be displayed on the current viewport width
function display_popups() {
    var right = 290;
    var iii = 0;
    for (iii; iii < popups.length; iii++) {
        if (popups[iii] != undefined) {
            var element = document.getElementById(popups[iii]);
            element.style.right = right + "px";
            right = right + 320;
            element.style.display = "block";
        }
    }
}

function create_popup(roomId, name, userId, connectionId) {
    for (var iii = 0; iii < popups.length; iii++) {
        //already registered. Bring it to front.
        if (roomId == popups[iii]) {
            Array.remove(popups, iii);
            popups.unshift(roomId);
            calculate_popups();
            return;
        }
    }
    var popupBox = $("<div></div>")[0];
    popupBox.classList.add("popup-box");
    popupBox.classList.add("chat-popup");
    popupBox.id = roomId;

    popupBox.innerHTML = '<div class="popup-head">' +
        '<div class="popup-head-left" >' + name +
        '</div>' +
        '<div class="popup-head-right">' +
        '<a class="btn-callvideo" onclick="callPeople(\'' + roomId + '\',\'' + connectionId + '\')" href="#"></a>' +
        '<a class="btn-closepopup" href="javascript:close_popup(\'' + roomId + '\');"></a>' +
        '</div>' +
        '<div style="clear: both">' +
        '</div>' +
        '</div> ' +
        '<div class="chatbox-messages"> ' +
        '</div>' +
        '<div class="input-box">' +
        '<textarea placeholder="Enter message" onkeypress="chatKeyPress(event, \'' + roomId +
        '\')"></textarea>' +
        '<a class="btn-addimage" href="#"></a> &nbsp' +
        '<a class="btn-addfile" href="#"></a>' +
        '</div>';

    $("body")[0].append(popupBox);
    $(`#image${roomId}`).on('submit', (event) => {
        event.preventDefault();
        var fm = new FormData($(`#image${roomId}`)[0]);
        console.log(fm);
        $.ajax({
            url: 'https://localhost/degoiapi/api/Chat/Upload',
            type: 'post',
            data: fm,
            async: false,
            contentType: false,
            processData: false,
            success: (e) => console.log(e)
        });
        return false;
    })
    popups.unshift(roomId);
    calculate_popups();
    return popupBox;
}

function calculate_popups() {
    var width = window.innerWidth;
    if (width < 540) {
        total_popups = 0;
    }
    else {
        width = width - 200;
        total_popups = parseInt(width / 320);
    }
    display_popups();
}

//creates markup for a new popup. Adds the id to popups array.
function register_popup(connectionId, name, userId) {
    var userIds = [userId, user.UserId].sort().join(",");
    var form = $("<form></form>").append($(`<input type='text' name='sUserIds' value='${userIds}'/>`));
    degoiapi.room($(form).serialize(), (response) => create_popup(response, name, userId, connectionId));
}

////---- MANAGE CHAT POPUP----

//---- VIDEO CALL INIT ----

function callPeople(roomId, id) {
    if (signalr.ConnectionManager.connections[id] != null) return;

    $(`#${roomId}`).addClass("open-videocall");
    var boxChat = $(`#${roomId}`)[0];
    setTimeout(function () {
        var videoCall = $("#video-call")[0];
        videoCall.style.display = 'block';
        $(`#${roomId}`).removeClass("open-videocall");
    }, 500);

    
    var videoChatboxHeight = $(window).height() - HEIGHT_MESSAGE_INPUT - HEIGHT_NAVIGATION;
    $("#video-chatbox-message").css("height", videoChatboxHeight);

    //var videoCall = $("#video-call")[0];
    //videoCall.style.display = 'block';
    $("#endCallBtn")[0].onclick = () => endCall(id);
    signalr.GetMedia();
    signalr.ChatHub.invoke("callUser", id);
}

function createAlertHavingCall(userdata) {
    var str = `<p>${userdata.Name} calling you.</p>  <button type="button" onclick="acceptCall('${userdata.ConnectionId}')" class="btn btn-primary">Accept</button> &nbsp&nbsp&nbsp  <button type="button" onclick="cancelCall('${userdata.ConnectionId}')" class="btn btn-danger">Cancel</button>`;
    var havingCall = $("<div id='having-call'></div>").html(str);
    $('body').append(havingCall);
}

function acceptCall(connectionId) {
    //TODO
    $("#having-call").remove();
    var videoCall = $("#video-call")[0];
    videoCall.style.display = 'block';
    signalr.GetMedia((stream) => {
        showCall();
        $("#endCallBtn")[0].onclick = () => endCall(connectionId);
        signalr.ChatHub.invoke('answerCall', true, connectionId);
    });
}

function showCall() {
    var videoCall = document.getElementById('video-call');
    videoCall.style.display = 'block';
}

function hideCall() {
    var videoCall = document.getElementById('video-call');
    videoCall.style.display = 'none';
}

function cancelCall(connectionId) {
    $("#having-call").remove();
    signalr.ChatHub.invoke('answerCall', false, connectionId);
}

function endCall(id) {
    var myCam = $("#my-cam")[0];
    var videoCall = $("#video-call")[0];
    myCam.src = "";
    videoCall.style.display = "none";
    signalr.ConnectionManager.closeConnection(id);
    signalr.ConnectionManager.mediaStream.getTracks().forEach((track) => {
        track.stop();
    });
    //signalr.ConnectionManager.mediaStream = {};
    signalr.ChatHub.invoke("hangUp");
}

////---- VIDEO CALL INIT----

//---- VIDEO CALL CONTROLLER ----

function exitFullScreen() {
    var videoChatbox = $("#video-chat-box")[0];
    videoChatbox.style.display = "none";
    var myCam = $("#my-cam")[0];
    myCam.style.display = "none";
    var videoControl = $("#video-control")[0];
    videoControl.style.display = "none";
    var friendCam = $("#friend-cam")[0];
    friendCam.classList.add('minimize');
    var btnFullScreen = $("#full-screen")[0];
    btnFullScreen.style.display = "block";
}

function openFullScreen() {
    var videoChatbox = $("#video-chat-box")[0];
    videoChatbox.style.display = "block";
    var myCam = $("#my-cam")[0];
    myCam.style.display = 'block';
    var videoControl = $("#video-control")[0];
    videoControl.style.display = "block";
    var friendCam = $("#friend-cam")[0];
    friendCam.classList.remove("minimize");
    var btnFullScreen = $("#full-screen")[0];
    btnFullScreen.style.display = "none";
}


function disableVideo() {
    signalr.ToggleVideo();
}

function muted() {
    signalr.ToggleSound();
}
////---- VIDEO CALL CONTROLLER ----


//---- SEND MESSAGE ----

function addMessage(roomId, userr, message, date, type) {
    var item = $(`#${roomId}`)[0];
    if (!item) item = create_popup(roomId, userr.Name, userr.UserId, userr.ConnectionId);
    var chatbox = item.getElementsByClassName('chatbox-messages');
    //DEMO get message from array
    var stringHTML = "<ul>";
    switch (type) {
    case 2: {
        stringHTML += "<li>"
        if (userr.UserId == user.UserId) {
            stringHTML += `<span class="right">${message}</span><img src="${message}" class="clear"></img></li>`;
        } else {
            stringHTML += `<span class="left">${message}</span><img src="${message}" class="clear"></img></div></li>`;
        }
        break;
    }
    default: {
        stringHTML += "<li>"
        if (userr.UserId == user.UserId) {
            stringHTML += `<span class="right">${message}</span><div class="clear"></div></li>`;
        } else {
            stringHTML += `<span class="left">${message}</span><div class="clear"></div></li>`;
        }
        break;
    }
    }
    stringHTML += "</ul>"
    $(chatbox[0]).append(stringHTML);
}



function formSubmit(id) {
    $(`#${id}`).submit();
}


function chatKeyPress(event, id) {
    if (event.charCode == 13) {
        signalr.ChatHub.invoke("sendMessage", $(event.target).val(), 0, id);
        $(event.target).val("");
    }
}
////---- SEND MESSAGE ----


