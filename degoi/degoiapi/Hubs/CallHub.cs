using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using degoiapi.Models.CallModels;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;

namespace degoiapi {
    [HubName("CallHub")]
    [Authorize]
    public class CallHub : Hub {
        public static readonly List<User> OnlineUsers = new List<User>();
        public static readonly List<UserCall> UserCalls = new List<UserCall>();
        public static readonly List<CallOffer> CallOffers = new List<CallOffer>();

        public override Task OnConnected() {
            var userId = Context.User.Identity.GetUserId();
            var userName = Context.User.Identity.GetUserName();
            var user = OnlineUsers.SingleOrDefault(u => u.UserId == userId);
            if (user == null) OnlineUsers.Add(new User() {
                UserId = userId,
                Name = userName,
                ConnectionId = Context.ConnectionId,
            });
            else Clients.Caller.Duplicate();
            return base.OnConnected();
        }

        public override Task OnDisconnected(bool stopCalled) {
            HangUp();
            var userId = Context.User.Identity.GetUserId();
            OnlineUsers.RemoveAll(u => u.UserId == userId && u.ConnectionId == Context.ConnectionId);
            SendUserListUpdate();
            return base.OnDisconnected(stopCalled);
        }

        public void CallUser(string targetConnectionId) {
            var callingUser = OnlineUsers.SingleOrDefault(u => u.ConnectionId == Context.ConnectionId);
            var targetUser = OnlineUsers.SingleOrDefault(u => u.ConnectionId == targetConnectionId);
            if (targetUser == null) {
                Clients.Caller.callDeclined(targetConnectionId, "The user you called has left.");
                return;
            }
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
            OnlineUsers.ForEach(u => u.InCall = (GetUserCall(u.ConnectionId) != null));
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