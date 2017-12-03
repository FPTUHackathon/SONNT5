//----GLOBAL VARIABLE----
var HEIGHT_NAVIGATION = 52;
var HEIGHT_MESSAGE_INPUT = 59;
var listUsers = [];
var rooms = [];
var lastMsgTimestamps = [];
var isCalling = false;
var callingRoomId = -1;
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
        if (!list[i].Online) item.style = "background-color: gray";
        item.classList.add("sidebar-name");
        item.innerHTML = `<a href="javascript:register_popup('${list[i].Name}', '${list[i].UserId}');"> <img width="30" height="30" src="" /> <span>${list[i].Name}</span></a>`;
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
function close_popup(room) {
    for (var iii = 0; iii < popups.length; iii++) {
        if (room.RoomId == popups[iii]) {
            Array.remove(popups, iii);
            $(`#${room.RoomId}`).remove();
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

function create_popup(room) {
    
    var popupBox = $("<div></div>")[0];
    popupBox.classList.add("popup-box");
    popupBox.classList.add("chat-popup");
    popupBox.id = room.RoomId;
    rooms[room.RoomId] = room;

    popupBox.innerHTML = `<div class="popup-head">` +
        `<div class="popup-head-left" >${room.Name}` +
        `</div>` +
        `<div class="popup-head-right">` +
        `<a class="btn-callvideo" onclick="callPeople(rooms['${room.RoomId}'])" href="#"></a>` +
        `<a class="btn-closepopup" href="javascript:close_popup(rooms['${room.RoomId}']);"></a>` +
        `</div>` +
        `<div style="clear: both">` +
        `</div>` +
        `</div>` +
        `<div class="chatbox-messages" id="chatbox${room.RoomId}">` +
        `</div>` +
        `<div class="input-box">` +
        `<textarea placeholder="Enter message" onkeypress="chatKeyPress(event, rooms['${room.RoomId}'])"></textarea>` +
        `<form id="image${room.RoomId}">` +
        `<input id="imagesubmit${room.RoomId}" type="file" name="file" id="file" accept="image/*" onchange="formSubmit(\'image${room.RoomId}\')">` +
        `<input type="hidden" name="roomId" value="${room.RoomId}">` +
        `</form>` +
        `<form id="file${room.RoomId}">` +
        `<input id="filesubmit${room.RoomId}" type="file" name="file" id="file" onchange="formSubmit(\'file${room.RoomId}\')">` +
        `<input type="hidden" name="roomId" value="${room.RoomId}">` +
        `</form>` +
        `<a class="btn-addimage" href="#" onclick="$('#imagesubmit${room.RoomId}').click();return false;"></a> &nbsp` +
        `<a class="btn-addfile" href="#" onclick="$('#filesubmit${room.RoomId}').click();return false;"></a>` +
        `</div>`;

    $("body")[0].append(popupBox);
    $(`#image${room.RoomId}`).on('submit', (event) => {
        event.preventDefault();
        var fm = new FormData($(`#image${room.RoomId}`)[0]);
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
    });
    $(`#file${room.RoomId}`).on('submit', (event) => {
        event.preventDefault();
        var fm = new FormData($(`#file${room.RoomId}`)[0]);
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
    });
    lastMsgTimestamps[room.RoomId] = "";
    $(`#chatbox${room.RoomId}`).on("scroll", (event) => {
        var roomId = $(event.target).attr("id").split("chatbox")[1];
        if ($(event.target).scrollTop() < 22) signalr.ChatHub.invoke("getMessageHistory", room.RoomId, lastMsgTimestamps[room.RoomId]);
    });
    signalr.ChatHub.invoke("getMessageHistory", room.RoomId, lastMsgTimestamps[room.RoomId]);
    popups.unshift(room.RoomId);
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
function register_popup(name, userId, callback) {
    var userIds = [userId, user.UserId].sort().join(",");
    var form = $("<form></form>").append($(`<input type='text' name='sUserIds' value='${userIds}'/>`));
    degoiapi.room($(form).serialize(), (response) => {
        create_popup(response);
        callback(response);
    });
}

////---- MANAGE CHAT POPUP----

//---- VIDEO CALL INIT ----

function callPeople(room) {
    if (isCalling) {
        return;
    }
    var arr = room.UserIds.split(',');
    if (arr.length != 2) return;
    var target = user.UserId == arr[0] ? target = arr[1] : target = arr[0];

    showCall(room);
    
    $("#endCallBtn")[0].onclick = () => endCall(target);
    signalr.ChatHub.invoke("callUser", target);
}

function createAlertHavingCall(userdata) {
    var str = `<p>${userdata.Name} calling you.</p>  <button type="button" onclick="acceptCall('${userdata.UserId}')" class="btn btn-primary">Accept</button> &nbsp&nbsp&nbsp  <button type="button" onclick="cancelCall('${userdata.UserId}')" class="btn btn-danger">Cancel</button>`;
    var havingCall = $("<div id='having-call'></div>").html(str);
    $('body').append(havingCall);
}

function acceptCall(UserId) {
    //var room = getRoomByUserIdInCall(UserId);
    register_popup(null, UserId, (room) => {
        $("#having-call").remove();
        var videoCall = $("#video-call")[0];
        videoCall.style.display = 'block';
        signalr.GetMedia((stream) => {
            showCall(room);
            
            $("#endCallBtn")[0].onclick = () => endCall(UserId);
            signalr.ChatHub.invoke('answerCall', true, UserId);
        });
    });
}

function cancelCall(UserId) {

    $("#having-call").remove();
    signalr.ChatHub.invoke('answerCall', false, UserId);
}

function showCall(room) {
    isCalling = true;
    callingRoomId = room.RoomId;
    $(`#${room.RoomId}`).addClass("open-videocall");
    setTimeout(function () {
        $(`#${room.RoomId}`).removeClass("open-videocall");
        $(`#${room.RoomId}`).addClass("video-chat-box");
        $(`#${room.RoomId} .chatbox-messages`).first().css("height", $(window).height() - HEIGHT_MESSAGE_INPUT);
        $("#video-call").css("background-color", "black");
        $("#video-call").css("display", "block");
        calcSizeItemsInVideoCallScreen();
    }, 500);
}

function hideCall() {
    if ($(`#${callingRoomId}`).hasClass("video-chat-box")) {
        $(`#${callingRoomId}`).removeClass("video-chat-box");
        $(`#${callingRoomId} .chatbox-messages`).first().css("height", "300px");
    }
    isCalling = false;
    callingRoomId = -1;

    $(`.open-videocall`).remove();
    $("#video-call").css("display", "none");
    $("#my-cam")[0].src = "";
    $("#friend-cam")[0].src = "";
}

function cancelCall(UserId) {
    hideCall();
    $("#having-call").remove();
    signalr.ChatHub.invoke('answerCall', false, UserId);
}

function endCall(id) {
    hideCall();
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
    $("#video-call").css("background-color", "transparent");
    $("#video-call").css("width", 0);
    $("#video-call").css("height", 0);

    $(`#${callingRoomId}`).removeClass("video-chat-box");
    $(`#${callingRoomId} .chatbox-messages`).first().css("height", "300px");

    var myCam = $($("#my-cam")[0]);
    myCam.css("display", "none");
    var videoControl = $($("#video-control")[0]);
    videoControl.css("display", "none");
    var friendCam = $($("#friend-cam")[0]);
    friendCam.addClass('minimize');
    var btnFullScreen = $($("#full-screen")[0]);
    btnFullScreen.css("display", "block");
}

function openFullScreen() {

    $(`#${callingRoomId}`).addClass("open-videocall");
    setTimeout(function () {
        $(`#${callingRoomId}`).removeClass("open-videocall");
        $(`#${callingRoomId}`).addClass("video-chat-box");
        $(`#${callingRoomId} .chatbox-messages`).first().css("height", $(window).height() - HEIGHT_MESSAGE_INPUT);
        $("#video-call").css("background-color", "black");
        $("#video-call").css("display", "block");
        $("#video-call").css("width", "100%");
        $("#video-call").css("height", "100%");
        calcSizeItemsInVideoCallScreen();
        var myCam = $($("#my-cam")[0]);
    myCam.css("display", "block");
    var videoControl = $($("#video-control")[0]);
    videoControl.css("display", "block");
    var friendCam = $($("#friend-cam")[0]);
    friendCam.removeClass("minimize");
    var btnFullScreen = $($("#full-screen")[0]);
    btnFullScreen.css("display", "none");
    }, 500);


    

}

function disableVideo() {
    signalr.ToggleVideo();
}

function muted() {
    signalr.ToggleSound();
}
////---- VIDEO CALL CONTROLLER ----


//---- SEND MESSAGE ----

function createMessage(userId, message, type) {
    var stringHTML = "<ul>";
    switch (type) {
        case 2: {
            stringHTML += "<li>"
            if (userId == user.UserId) {
                stringHTML += `<span class="right"><a href="${message}" target="__blank"><img src="${message}" class="clear"></img></a></span></li>`;
            } else {
                stringHTML += `<span class="left"><a href="${message}" target="__blank"><img src="${message}" class="clear"></img></a></span></li>`;
            }
            break;
        }
        case 1: {
            stringHTML += "<li>"
            if (userId == user.UserId) {
                stringHTML += `<span class="right"><a href="${message}" target="__blank">${message.substring(message.lastIndexOf("/") + 1)}</a></span></li>`;
            } else {
                stringHTML += `<span class="left"><a href="${message}" target="__blank">${message.substring(message.lastIndexOf("/") + 1)}</a></span></li>`;
            }
            break;
        }
        default: {
            stringHTML += "<li>"
            if (userId == user.UserId) {
                stringHTML += `<span class="right">${message}</span><div class="clear"></div></li>`;
            } else {
                stringHTML += `<span class="left">${message}</span><div class="clear"></div></li>`;
            }
            break;
        }
    }
    stringHTML += "</ul>";
    return stringHTML;
}

function addMessage(room, userSend, message, date, type) {
    var item = $(`#${room.RoomId}`)[0];
    var name = room.Name;
    if (!item) item = create_popup(room);
    var chatbox = item.getElementsByClassName('chatbox-messages');
    //DEMO get message from array
    $(chatbox[0]).append(createMessage(userSend.UserId, message, type));
}

function formSubmit(id) {
    $(`#${id}`).submit();
}

function chatKeyPress(event, room) {
    if (event.charCode == 13) {
        signalr.ChatHub.invoke("sendMessage", $(event.target).val(), room.RoomId);
        $(event.target).val("");
    }
}
////---- SEND MESSAGE ----

function addMessageBefore(room, userId, message, date, type) {
    var item = $(`#${room.RoomId}`)[0];
    var name = room.Name;
    if (!item) item = create_popup(room);
    var chatbox = item.getElementsByClassName('chatbox-messages');
    //DEMO get message from array
    $(chatbox[0]).prepend(createMessage(userId, message, type));
}