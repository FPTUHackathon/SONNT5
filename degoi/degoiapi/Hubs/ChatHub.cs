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
using degoiapi.Data;

namespace degoiapi.Hubs {
    [HubName("ChatHub")]
    [Authorize]
    public class ChatHub : Hub {
        public static readonly ObservableCollection<User> OnlineUsers = new ObservableCollection<User>();
        public static readonly List<UserCall> UserCalls = new List<UserCall>();
        public static readonly List<CallOffer> CallOffers = new List<CallOffer>();

        static ChatHub() {
            OnlineUsers.CollectionChanged += OnlineUsers_CollectionChanged;
        }

        private static void OnlineUsers_CollectionChanged(object sender, System.Collections.Specialized.NotifyCollectionChangedEventArgs e) {
            List<dynamic> users = DbContext.GetUsers();
            List<dynamic> userStates = new List<dynamic>();
            bool added = false;
            foreach (var user in users) {
                added = false;
                var userMiniDetails = DbContext.GetUserMiniDetails(user.UserId);
                foreach (var onlUser in OnlineUsers)
                    if (user.UserId == onlUser.UserId) {
                        userStates.Add(new {
                            UserId = user.UserId,
                            Name = user.Name,
                            Details = userMiniDetails,
                            Online = true
                        });
                        added = true;
                        break;
                    }
                if (!added) userStates.Add(new {
                    UserId = user.UserId,
                    Name = user.Name,
                    Details = userMiniDetails,
                    Online = false
                });
            }
            GlobalHost.ConnectionManager.GetHubContext<ChatHub>().Clients.All.UpdateUsers(userStates);
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
            HangUp();
            var UserId = Context.User.Identity.GetUserId();
            OnlineUsers.Remove(OnlineUsers.SingleOrDefault(u => u.UserId == UserId && u.ConnectionId == Context.ConnectionId));
            return base.OnDisconnected(stopCalled);
        }

        public void GetMessageHistory(string roomId, string datetime) {
            var user = OnlineUsers.SingleOrDefault(e => e.ConnectionId == Context.ConnectionId);
            DateTime dt = DateTime.Now;
            if (datetime != "" && datetime != null) dt = DateTime.Parse(datetime);
            Clients.Caller.History(DbContext.GetRoomById(roomId), DbContext.GetMessageHistory(user.UserId, roomId, dt, 9));
        }

        public void SendMessage(string message, string roomId) {
            var userIds = DbContext.GetUserIdsByRoomId(roomId);
            var user = OnlineUsers.SingleOrDefault(e => e.ConnectionId == Context.ConnectionId);
            var msg = DbContext.GetMessage(DbContext.PostMessage(roomId, user.UserId, message, 0));
            string sUserIds = "";
            foreach (var userId in userIds) sUserIds += userId.UserId + ",";
            sUserIds = sUserIds.Substring(0, sUserIds.Length - 1);
            foreach (var userId in userIds) {
                dynamic room = DbContext.GetRoomById(DbContext.GetRoomByUserIds(user.UserId, sUserIds, ""));
                var usr = OnlineUsers.SingleOrDefault(u => u.UserId == userId.UserId);
                if (usr == null) continue;
                Clients.Client(usr.ConnectionId).ReceiveMessage(user, message, msg.CreatedDate, msg.Status, room);
            }
        }

        public void CallUser(string UserId) {
            var callingUser = OnlineUsers.SingleOrDefault(u => u.ConnectionId == Context.ConnectionId);
            var targetUser = OnlineUsers.SingleOrDefault(u => u.UserId == UserId);
            if (callingUser == null) {
                return;
            }
            if (targetUser == null) {
                Clients.Caller.callDeclined(targetUser, "The user you called has left.");
                return;
            }
            if (callingUser.InCall) return;
            if (targetUser.InCall) return;
            if (GetUserCall(targetUser.ConnectionId) != null) {
                Clients.Caller.callDeclined(targetUser, $"{targetUser.UserId} is already in a call.");
                return;
            }
            Clients.Client(targetUser.ConnectionId).incomingCall(new {
                UserId = callingUser.UserId,
                Name = callingUser.Name,
                Details = DbContext.GetUserMiniDetails(callingUser.UserId),
                Online = true
            });
            CallOffers.Add(new CallOffer {
                Caller = callingUser,
                Callee = targetUser
            });
        }

        public void AnswerCall(bool acceptCall, string UserId) {
            var callingUser = OnlineUsers.SingleOrDefault(u => u.ConnectionId == Context.ConnectionId);
            var targetUser = OnlineUsers.SingleOrDefault(u => u.UserId == UserId);
            if (callingUser == null) {
                return;
            }
            if (targetUser == null) {
                Clients.Caller.callEnded(callingUser.ConnectionId, "The other user in your call has left.");
                return;
            }
            if (callingUser.InCall) return;
            if (targetUser.InCall) return;
            if (acceptCall == false) {
                Clients.Client(targetUser.ConnectionId).callDeclined(callingUser,
                    $"{callingUser.UserId} did not accept your call.");
                return;
            }
            var offerCount = CallOffers.RemoveAll(c => c.Callee.ConnectionId == callingUser.ConnectionId
                                                  && c.Caller.ConnectionId == targetUser.ConnectionId);
            if (offerCount < 1) {
                Clients.Caller.callEnded(targetUser.ConnectionId, $"{targetUser.UserId} has already hung up.");
                return;
            }
            if (GetUserCall(targetUser.UserId) != null) {
                Clients.Caller.callDeclined(targetUser.ConnectionId,
                    $"{targetUser.UserId} chose to accept someone elses call instead of yours :(");
                return;
            }
            CallOffers.RemoveAll(c => c.Caller.ConnectionId == targetUser.ConnectionId);
            UserCalls.Add(new UserCall {
                Users = new List<User> { callingUser, targetUser },
                TimeStart = DateTime.Now,
                TimeEnd = DateTime.Now,
            });
            Clients.Client(targetUser.ConnectionId).callAccepted(callingUser);
            SendUserListUpdate();
        }

        public void HangUp() {
            var callingUser = OnlineUsers.SingleOrDefault(u => u.ConnectionId == Context.ConnectionId);
            if (callingUser == null) {
                return;
            }
            var currentCall = GetUserCall(callingUser.UserId);
            if (currentCall != null) {
                currentCall.TimeEnd = DateTime.Now;
                var targetUser = currentCall.Users.SingleOrDefault(u => u.UserId != callingUser.UserId);
                DbContext.LogVideo(callingUser.UserId, targetUser.UserId, currentCall.TimeStart, currentCall.TimeEnd);
                foreach (var user in currentCall.Users.Where(u => u.ConnectionId != callingUser.ConnectionId)) {
                    Clients.Client(user.ConnectionId).callEnded(callingUser,
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
            var userCall = GetUserCall(callingUser.UserId);
            if (userCall != null && userCall.Users.Exists(u => u.ConnectionId == targetUser.ConnectionId)) {
                Clients.Client(targetUser.ConnectionId).receiveSignal(callingUser, signal);
            }
        }

        #region Private Helpers
        private void SendUserListUpdate() {
            foreach (var u in OnlineUsers) u.InCall = (GetUserCall(u.ConnectionId) != null);
            Clients.All.updateUserList(OnlineUsers);
        }

        private UserCall GetUserCall(string UserId) {
            var matchingCall =
                UserCalls.SingleOrDefault(uc => uc.Users.SingleOrDefault(u => u.UserId == UserId) != null);
            return matchingCall;
        }
        #endregion
    }
}