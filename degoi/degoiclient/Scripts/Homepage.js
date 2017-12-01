function addMessage(roomId, userr, message, date, type) {
    var item = document.getElementById(roomId);
    if (!item) item = create_popup(roomId, userr.Name, userr.UserId, userr.ConnectionId);
    var chatbox = item.getElementsByClassName('chatbox-messages');
    //DEMO get message from array
    var stringHTML = "<ul>";
    stringHTML += '<li>'
    if (userr.UserId == user.UserId) {
        stringHTML += '<span class="left">' + message + '</span><div class="clear"></div></li>';
    } else {
        stringHTML += '<span class="right">' + message + '</span><div class="clear"></div></li>';
    }
    $(chatbox[0]).append(stringHTML);
}


function createChatSliderBar(list) {
    var chatSlidebar = document.getElementById('chat-slidebar');
    $("#chat-slidebar").empty();
    var item = "";
    for (var i = 0; i < list.length; i++) {
        if (list[i].UserId == user.UserId) continue;
        var item = document.createElement("div");
        item.classList.add('sidebar-name');
        item.innerHTML = '<a href="javascript:register_popup(\'' + list[i].ConnectionId + '\', \'' + list[i].Name + '\', \'' + list[i].UserId + '\');"> <img width="30" height="30" src="" /> <span>' + list[i].Name + '</span></a>';
        chatSlidebar.appendChild(item);
        item = "";
    }
}

function createAlertHavingCall(id, name) {
    var havingCall = document.createElement("div");
    havingCall.id = "having-call";
    havingCall.innerHTML = '<p>' + name + ' calling you.</p>  <button type="button" onclick="acceptCall()" class="btn btn-primary">Accept</button> &nbsp&nbsp&nbsp  <button type="button" onclick="cancelCall()" class="btn btn-danger">Cancel</button>';
    var body = document.getElementsByTagName('body');
    body[0].appendChild(havingCall);
}

function acceptCall() {
    //TODO
    var videoCall = document.getElementById('video-call');
    videoCall.style.display = 'block';
    // console.log('acceptCall');//
    var havingCall = document.getElementById('having-call');
    havingCall.style.display = 'none';
}

function cancelCall() {
    //TODO
    var havingCall = document.getElementById('having-call');
    havingCall.style.display = 'none';
}
// <div id="having-call">
//   <p>User001 calling you.</p>
//   <button type="button" class="btn btn-primary">Accept</button>
//   <button type="button" class="btn btn-danger">Cancel</button>
// </div>

function sendImage(e) {

}

//this function can remove a array element.
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
    var right = 220;
    var iii = 0;
    for (iii; iii < popups.length; iii++) {
        if (popups[iii] != undefined) {
            var element = document.getElementById(popups[iii]);
            element.style.right = right + "px";
            right = right + 320;
            element.style.display = "block";
        }
    }

    //for (var jjj = iii; jjj < popups.length; jjj++) {
    //    var element = document.getElementById(popups[jjj]);
    //    element.style.display = "none";
    //}
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


    var popupBox = document.createElement("div");
    popupBox.classList.add("popup-box");
    popupBox.classList.add("chat-popup");

    popupBox.id = roomId;

    popupBox.innerHTML = '<div class="popup-head"><div class="popup-head-left">' + name + '</div><div class="popup-head-right"><button type="button" onclick="callPeople(\'' + connectionId + '\')" name="button">Call</button><a href="javascript:close_popup(\'' + roomId + '\');">&#10005;</a></div><div style="clear: both"></div></div><div class="chatbox-messages"></div><div class="input-box"><textarea placeholder="Enter message" onkeypress="chatKeyPress(event, \'' + roomId + '\')"></textarea></div>	';

    // <div class="popup-box chat-popup" id="">
    //   <div class="popup-head">
    //     <div class="popup-head-left">Name of user</div>
    //     <div class="popup-head-right">
    //       <button type="button" name="button">Call</button>
    //       <a href="javascript:close_popup(\''+ id +'\');">&#10005;</a>
    //     </div>
    //     <div style="clear: both"></div></div>
    //     <div class="chatbox-messages"></div>
    //     <div class="input-box">
    //       <textarea placeholder="Enter message"></textarea>
    //     </div>
    //   </div>

    document.getElementsByTagName("body")[0].appendChild(popupBox);

    popups.unshift(roomId);

    calculate_popups();

    return popupBox;
}

//creates markup for a new popup. Adds the id to popups array.
function register_popup(connectionId, name, userId) {
    var userIds = [userId, user.UserId].sort().join(",");

    var form = $("<form></form>").append($(`<input type='text' name='sUserIds' value='${userIds}'/>`));

    degoiapi.room($(form).serialize(), (response) => create_popup(response, name, userId, connectionId));
}

function chatKeyPress(event, id) {
    if (event.charCode == 13) {
        signalr.ChatHub.invoke("sendMessage", $(event.target).val(), 0, id);
        $(event.target).val("");
    }
}

//calculate the total number of popups suitable and then populate the toatal_popups variable.
function calculate_popups() {
    var width = window.innerWidth;
    if (width < 540) {
        total_popups = 0;
    }
    else {
        width = width - 200;
        //320 is width of a single popup box
        total_popups = parseInt(width / 320);
    }

    display_popups();

}

//recalculate when window is loaded and also when window is resized.

function callPeople(id) {
    var videoCall = document.getElementById('video-call');
    videoCall.style.display = 'block';
    signalr.GetMedia();
    signalr.ChatHub.invoke("callUser", id);
}

function exitFullScreen() {
    var videoChatbox = document.getElementById('video-chat-box');
    videoChatbox.style.display = 'none';
    var myCam = document.getElementById('my-cam');
    myCam.style.display = 'none';
    var videoControl = document.getElementById('video-control');
    videoControl.style.display = 'none';
    var friendCam = document.getElementById('friend-cam');
    friendCam.classList.add('minimize');
    var btnFullScreen = document.getElementById('full-screen');
    btnFullScreen.style.display = 'block';
}

function openFullScreen() {
    var videoChatbox = document.getElementById('video-chat-box');
    videoChatbox.style.display = 'block';
    var myCam = document.getElementById('my-cam');
    myCam.style.display = 'block';
    var videoControl = document.getElementById('video-control');
    videoControl.style.display = 'block';
    var friendCam = document.getElementById('friend-cam');
    friendCam.classList.remove('minimize');
    var btnFullScreen = document.getElementById('full-screen');
    btnFullScreen.style.display = 'none';
}

function endCall() {
    var videoCall = document.getElementById('video-call');
    videoCall.style.display = 'none';
    //TODO: remove stream
}

function disableVideo() {
    // TODO disable my video
}

function muted() {
    //TODO mute sound
}
