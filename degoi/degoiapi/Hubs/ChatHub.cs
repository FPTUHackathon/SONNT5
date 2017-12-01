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
        public static readonly List<UserCall> UserCalls = new List<UserCall>();
        public static readonly List<CallOffer> CallOffers = new List<CallOffer>();
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
            var user = OnlineUsers.SingleOrDefault(e => e.ConnectionId == Context.ConnectionId);
            // db
            foreach (var userId in userIds) {
                var usr = OnlineUsers.SingleOrDefault(u => u.UserId == userId);
                if (usr == null) return;
                Clients.Client(usr.ConnectionId).ReceiveMessage(user, message, DateTime.Now, type, roomId);
            }
        }

        public void CallUser(string targetConnectionId) {
            var callingUser = OnlineUsers.SingleOrDefault(u => u.ConnectionId == Context.ConnectionId);
            var targetUser = OnlineUsers.SingleOrDefault(u => u.ConnectionId == targetConnectionId);
            if (callingUser == null) {
                return;
            }
            if (targetUser == null) {
                Clients.Caller.callDeclined(targetConnectionId, "The user you called has left.");
                return;
            }
            if (callingUser.InCall) return;
            if (targetUser.InCall) return;
            if (GetUserCall(targetUser.ConnectionId) != null) {
                Clients.Caller.callDeclined(targetConnectionId, $"{targetUser.UserId} is already in a call.");
                return;
            }
            Clients.Client(targetConnectionId).incomingCall(callingUser);
            CallOffers.Add(new CallOffer {
                Caller = callingUser,
                Callee = targetUser
            });
        }

        public void AnswerCall(bool acceptCall, string targetConnectionId) {
            var callingUser = OnlineUsers.SingleOrDefault(u => u.ConnectionId == Context.ConnectionId);
            var targetUser = OnlineUsers.SingleOrDefault(u => u.ConnectionId == targetConnectionId);
            if (callingUser == null) {
                return;
            }
            if (targetUser == null) {
                Clients.Caller.callEnded(targetConnectionId, "The other user in your call has left.");
                return;
            }
            if (callingUser.InCall) return;
            if (targetUser.InCall) return;
            if (acceptCall == false) {
                Clients.Client(targetConnectionId).callDeclined(callingUser,
                    $"{callingUser.UserId} did not accept your call.");
                return;
            }
            var offerCount = CallOffers.RemoveAll(c => c.Callee.ConnectionId == callingUser.ConnectionId
                                                  && c.Caller.ConnectionId == targetUser.ConnectionId);
            if (offerCount < 1) {
                Clients.Caller.callEnded(targetConnectionId, $"{targetUser.UserId} has already hung up.");
                return;
            }
            if (GetUserCall(targetUser.ConnectionId) != null) {
                Clients.Caller.callDeclined(targetConnectionId,
                    $"{targetUser.UserId} chose to accept someone elses call instead of yours :(");
                return;
            }
            CallOffers.RemoveAll(c => c.Caller.ConnectionId == targetUser.ConnectionId);
            UserCalls.Add(new UserCall {
                Users = new List<User> { callingUser, targetUser }
            });
            Clients.Client(targetConnectionId).callAccepted(callingUser);
            SendUserListUpdate();
        }

        public void HangUp() {
            var callingUser = OnlineUsers.SingleOrDefault(u => u.ConnectionId == Context.ConnectionId);
            if (callingUser == null) {
                return;
            }
            var currentCall = GetUserCall(callingUser.ConnectionId);
            if (currentCall != null) {
                foreach (var user in currentCall.Users.Where(u => u.ConnectionId != callingUser.ConnectionId)) {
                    Clients.Client(user.ConnectionId).callEnded(callingUser.ConnectionId,
                        $"{callingUser.UserId} has hung up.");
                }
                currentCall.Users.RemoveAll(u => u.ConnectionId == callingUser.ConnectionId);
                if (currentCall.Users.Count < 2) {
                    UserCalls.Remove(currentCall);
                }
            }
            CallOffers.RemoveAll(c => c.Caller.ConnectionId == callingUser.ConnectionId);
            SendUserListUpdate();
        }

        // WebRTC Signal Handler
        public void SendSignal(string signal, string targetConnectionId) {
            var callingUser = OnlineUsers.SingleOrDefault(u => u.ConnectionId == Context.ConnectionId);
            var targetUser = OnlineUsers.SingleOrDefault(u => u.ConnectionId == targetConnectionId);
            if (callingUser == null || targetUser == null) {
                return;
            }
            var userCall = GetUserCall(callingUser.ConnectionId);
            if (userCall != null && userCall.Users.Exists(u => u.ConnectionId == targetUser.ConnectionId)) {
                Clients.Client(targetConnectionId).receiveSignal(callingUser, signal);
            }
        }

        #region Private Helpers
        private void SendUserListUpdate() {
            foreach (var u in OnlineUsers) u.InCall = (GetUserCall(u.ConnectionId) != null);
            Clients.All.updateUserList(OnlineUsers);
        }

        private UserCall GetUserCall(string connectionId) {
            var matchingCall =
                UserCalls.SingleOrDefault(uc => uc.Users.SingleOrDefault(u => u.ConnectionId == connectionId) != null);
            return matchingCall;
        }
        #endregion
    }
}