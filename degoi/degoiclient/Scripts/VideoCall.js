
function hideAllChatPopup(roomId) {
    for (var i = 0; i < popups.length; i++) {
        if (roomId === popups[i]) continue;
        var element = document.getElementById(popups[i]);
        element.style.display = "none";
    }
}

function displayAllChatPopup() {
    for (var i = 0; i < popups.length; i++) {
        var element = document.getElementById(popups[i]);
        element.style.display = "block";
    }
}

function resizeAllChatPopup() {
    for (var i = 0; i < popups.length; i++) {
        var element = document.getElementById(popups[i]);
        element.style.display = "block";
    }
}

function changeLayoutMessageBox(roomId) {
    //hide header messagebox
    var header = $(`#${roomId} .popup-head`);
    header.hide();

    //change size messagebox
    $(`#${roomId} .chatbox-messages`).first().css("height", $(window).height() - 60);
    $(`#${roomId}`).addClass("video-chat-box");
}


function calcSizeItemsInVideoCallScreen() {
    //CHAT BOX
    var videoChatboxHeight = $(window).height() - HEIGHT_MESSAGE_INPUT;
    $("#video-chatbox-message").css("height", videoChatboxHeight);
    $("#video-chatbox-message").css("width", "350px");

    // VIDEO CONTROL
    $("#video-control").css("left", ($(window).width() - 350) / 2 - 140);
    var width = 0;
    var height = 0;
    if (($(window).width() - 350) * 3 < $(window).height() * 4) {
        width = $(window).width() - 350;
        height = width * 3 / 4;
        $("#friend-cam").css("width", width);
        $("#friend-cam").css("height", height);
        $("#friend-cam").css("left", 0);
        $("#friend-cam").css("top", ($(window).height() - height) / 2);

    } else {
        height = $(window).height();
        width = height * 4 / 3;
        $("#friend-cam").css("width", width);
        $("#friend-cam").css("height", height);
        $("#friend-cam").css("top", 0);
        $("#friend-cam").css("left", ($(window).width() - 350 - width) / 2);
    }

    $("#video-call").css("background-color", "black");

}
