var isExtendChatbox = false;

var ChatSearchObj = {
    roomId: null,
    userId: null,
    listMessId: null,
    listMess: null,
    currentId: null,
    index: null,
}
function extendChatbox(roomID) {
    ChatSearchObj.userId = user.UserId
    if (isExtendChatbox) {
        // MINIMIZE 
        ChatSearchObj.roomId = null
        $(`#${roomID}`).removeClass("popup-box-extend");
        $(`#${roomID}`).css("height", 390);
        $(`#${roomID}`).css("width", 300);
        $(`#${roomID} .chatbox-messages`).css("height", 300);
        $(`#${roomID} .input-box`).css("width", "298px");
        $(`#${roomID} .input-box`).css("border-right", "0px");
        $(`.btn-callvideo`).show();
        $(`.btn-closepopup`).show();
        $(`#extend-msg-box-control`).hide();
        
        isExtendChatbox = false;
    } else {
        //EXTEND
        ChatSearchObj.roomId = roomID
        $(`#${roomID}`).addClass("popup-box-extend");
        $(`#${roomID}`).css("height", $(window).height() - 56);
        $(`#${roomID}`).css("width", $(window).width() - 270);
        $(`#${roomID} .chatbox-messages`).css("height", $(window).height() - 63 - 26 - 60);
        $(`#${roomID} .input-box`).css("width", "50%");
        $(`#${roomID} .input-box`).css("border-right", "1px solid #e1e2e5");
        $(`.btn-callvideo`).hide();
        $(`.btn-closepopup`).hide();
        $(`#extend-msg-box-control`).show();

        isExtendChatbox = true;
    }
}

function loadSearchMessage() {
    
}
//TODO get data from api

$(`#btn-search-message`).on("click",
    () => {
        degoiapi.MessageRoomSearch({
            UserId: user.UserId,
            RoomId: ChatSearchObj.roomId,
            Text: $(`#search-message-text`).val(),
        }, (response) => {
            ChatSearchObj.listMessId = response;
            ChatSearchObj.index = ChatSearchObj.listMessId.length - 1;
            ChatSearchObj.currentId = ChatSearchObj.listMessId[ChatSearchObj.index].MessageId;
            degoiapi.MessageRoomSearchMid({
                UserId: user.UserId,
                RoomId: ChatSearchObj.roomId,
                MessId : ChatSearchObj.currentId,
            }, (response) => {
                ChatSearchObj.listMess = response;
                LoadChatBox();
            }, () => {
                console.log("err");
            })
        }, () => {
            console.log("err");
        })
    });

$(`#btn-next-search-message`).on("click",
    () => {
        ChatSearchObj.index = (ChatSearchObj.index + 1 > ChatSearchObj.listMessId.length - 1) ? ChatSearchObj.listMessId.length - 1 : ChatSearchObj.index + 1;
        ChatSearchObj.currentId = ChatSearchObj.listMessId[ChatSearchObj.index].MessageId;
        degoiapi.MessageRoomSearchMid({
            UserId: user.UserId,
            RoomId: ChatSearchObj.roomId,
            MessId: ChatSearchObj.currentId,
        }, (response) => {
            var item = $(`#${ChatSearchObj.roomId}`)[0];
            var name = ChatSearchObj.listMess[0].RoomName;
            var chatbox = item.getElementsByClassName('chatbox-messages');
            $(chatbox[0]).empty();
            ChatSearchObj.listMess = response;
            if (ChatSearchObj.listMess.length > 0)
            LoadChatBox();
        }, () => {
            console.log("err");
        })
    });

$(`#btn-prev-search-message`).on("click",
    () => {
        ChatSearchObj.index = (ChatSearchObj.index - 1 < 0) ? 0 : ChatSearchObj.index - 1;
        ChatSearchObj.currentId = ChatSearchObj.listMessId[ChatSearchObj.index].MessageId;
        degoiapi.MessageRoomSearchMid({
            UserId: user.UserId,
            RoomId: ChatSearchObj.roomId,
            MessId: ChatSearchObj.currentId,
        }, (response) => {
            var item = $(`#${ChatSearchObj.roomId}`)[0];
            var name = ChatSearchObj.listMess[0].RoomName;
            var chatbox = item.getElementsByClassName('chatbox-messages');
            $(chatbox[0]).empty();
            ChatSearchObj.listMess = response;
            if (ChatSearchObj.listMess.length > 0)
            LoadChatBox();
        }, () => {
            console.log("err");
        })
    });

function LoadChatBox() {
    var item = $(`#${ChatSearchObj.roomId}`)[0];
    var name = ChatSearchObj.listMess[0].RoomName;
    var chatbox = item.getElementsByClassName('chatbox-messages');
    $(chatbox[0]).empty();
    console.log(ChatSearchObj.currentId);
    //DEMO get message from array
    for (mess of ChatSearchObj.listMess) {
        $(chatbox[0]).append(createMessage(mess.Id, mess.MessContent, mess.Status));
    }
    
}