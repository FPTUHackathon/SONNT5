var signalr;
(() => {
    $.support.cors = true;
    var connection = $.hubConnection(Config.Api);
    var chatHub = connection.createHubProxy('chatHub');
    chatHub.on('duplicate', () => {
        $(document.body).html("<h1>Only 1 tab allowed</h1>");
    });
    chatHub.on('receiveMessage', (message, type, roomId) => {
        addMessage(message, type, roomId);
    });
    chatHub.on('updateUsers', (users) => {
        console.log(users);
    });
    connection.start().done(() => {
        console.log('connected to SignalR hub... connection id: ' + chatHub.connection.id);
    }).fail((event) => {
        console.log(event);
    });
    signalr = {
        connection: connection,
        chatHub: chatHub,
        sendMessage: (message, type, roomId) => {
            chatHub.invoke('sendMessage', message, type, roomId);
        }
    };
})();