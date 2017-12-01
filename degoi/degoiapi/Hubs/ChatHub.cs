using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;
using degoiapi.Models.ChatModels;
using System.Threading.Tasks;
using Microsoft.AspNet.Identity;

namespace degoiapi.Hubs {
    [HubName("ChatHub")]
    [Authorize]
    public class ChatHub : Hub {
        public static readonly ObservableCollection<User> OnlineUsers = new ObservableCollection<User>();
        public static readonly List<Room> Rooms = new List<Room>();

        static ChatHub() {
            OnlineUsers.CollectionChanged += OnlineUsers_CollectionChanged;
        }

        private static void OnlineUsers_CollectionChanged(object sender, System.Collections.Specialized.NotifyCollectionChangedEventArgs e) {
            GlobalHost.ConnectionManager.GetHubContext<ChatHub>().Clients.All.UpdateUsers(OnlineUsers);
        }

        public override Task OnConnected() {
            var UserId = Context.User.Identity.GetUserId();
            var UserName = Context.User.Identity.GetUserName();
            var User = OnlineUsers.SingleOrDefault(u => u.UserId == UserId);
            if (User == null) OnlineUsers.Add(new User() {
                UserId = UserId,
                Name = UserName,
                ConnectionId = Context.ConnectionId
            });
            else Clients.Caller.Duplicate();
            return base.OnConnected();
        }

        public override Task OnDisconnected(bool stopCalled) {
            var UserId = Context.User.Identity.GetUserId();
            var UserName = Context.User.Identity.GetUserName();
            var User = OnlineUsers.Remove(OnlineUsers.SingleOrDefault(u => u.UserId == UserId && u.ConnectionId == Context.ConnectionId));
            return base.OnDisconnected(stopCalled);
        }

        public void SendMessage(string message, int type, string roomId) {
            var userIds = Rooms.SingleOrDefault(r => r.RoomId == roomId).UserIds; // db
            // db
            foreach (var userId in userIds) Clients.Client(userId).ReceiveMessage(message, type, roomId);
        }
    }
}