using degoiapi.Data;
using degoiapi.Hubs;
using degoiapi.Models.ChatModels;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;

namespace degoiapi.Controllers {
    [System.Web.Http.Authorize]
    [RoutePrefix("api/Chat")]
    public class ChatController : ApiController {
        [Route("Room")]
        [HttpPost]
        public dynamic Room() {
            var httpRequest = HttpContext.Current.Request;
            var sUserIds = httpRequest.Form["sUserIds"];
            return DbContext.GetRoomById(DbContext.GetRoomByUserIds(User.Identity.GetUserId(), sUserIds));
            //return DbContext.GetRoom(User.Identity.GetUserId(), sUserIds);
        }

        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        [Route("Upload")]
        [HttpPost]
        public IHttpActionResult Upload() {
            var httpRequest = HttpContext.Current.Request;
            var roomId = httpRequest.Form["roomId"];
            if (httpRequest.Files.Count < 1) return BadRequest();
            foreach (string file in httpRequest.Files) {
                var postedFile = httpRequest.Files[file];
                var filePath = HttpContext.Current.Server.MapPath("~/Upload/") + postedFile.FileName;
                postedFile.SaveAs(filePath);
                //
                var hubContext = GlobalHost.ConnectionManager.GetHubContext<ChatHub>();
                var user = ChatHub.OnlineUsers.SingleOrDefault(e => e.UserId == User.Identity.GetUserId());
                dynamic room = DbContext.GetRoomById(roomId);
                var users = DbContext.GetUserIdsByRoomId(roomId);
                var message = $"{HttpRuntime.AppDomainAppVirtualPath}/Upload/{postedFile.FileName}";
                var msg = DbContext.GetMessage(DbContext.PostMessage(roomId, user.UserId, message, 2));
                foreach (var userr in users) {
                    var to = ChatHub.OnlineUsers.SingleOrDefault(e => e.UserId == userr.UserId);
                    if (to != null) hubContext.Clients.Client(to.ConnectionId).ReceiveMessage(user, message, msg.CreatedDate, msg.Status, room);
                }
            }
            return Ok();
        }
    }
}
