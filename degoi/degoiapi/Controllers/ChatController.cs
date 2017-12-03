using degoiapi.Data;
using degoiapi.Hubs;
using degoiapi.Models.ChatModels;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.SignalR;
using System;
using System.Collections.Generic;
using System.IO;
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
            var roomName = httpRequest.Form["roomName"];
            return DbContext.GetRoomById(DbContext.GetRoomByUserIds(User.Identity.GetUserId(), sUserIds, roomName));
        }

        [Route("Rooms")]
        [HttpGet]
        public List<dynamic> Rooms() {
            var httpRequest = HttpContext.Current.Request;
            var userId = User.Identity.GetUserId();
            var roomIds = DbContext.GetRoomByUserId(userId);
            List<dynamic> rooms = new List<dynamic>();
            foreach (var roomId in roomIds) {
                var troom = DbContext.GetRoomById(roomId);
                if (troom.Total <= 2) continue;
                rooms.Add(troom);
            }
            return rooms;
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
                var folderName = $"{postedFile.FileName}{DateTime.Now.Ticks}";
                var dirPath = $"{HttpContext.Current.Server.MapPath("~/Upload/")}/{folderName}";
                Directory.CreateDirectory(dirPath);
                var filePath = $"{dirPath}/{postedFile.FileName}";
                postedFile.SaveAs(filePath);
                //
                var hubContext = GlobalHost.ConnectionManager.GetHubContext<ChatHub>();
                var user = ChatHub.OnlineUsers.SingleOrDefault(e => e.UserId == User.Identity.GetUserId());
                dynamic room = DbContext.GetRoomById(roomId);
                var users = DbContext.GetUserIdsByRoomId(roomId);
                var message = $"{HttpRuntime.AppDomainAppVirtualPath}/Upload/{folderName}/{postedFile.FileName}";
                var type = 1;
                List<string> imageExts = new List<string>() { ".jpg", ".jpeg", ".bmp", ".png", ".ico", ".gif" };
                foreach (string imageExt in imageExts)
                    if (postedFile.FileName.EndsWith(imageExt)) {
                        type = 2;
                        break;
                    }
                var msg = DbContext.GetMessage(DbContext.PostMessage(roomId, user.UserId, message, type));
                foreach (var userr in users) {
                    var to = ChatHub.OnlineUsers.SingleOrDefault(e => e.UserId == userr.UserId);
                    if (to != null) hubContext.Clients.Client(to.ConnectionId).ReceiveMessage(user, message, msg.CreatedDate, msg.Status, room);
                }
            }
            return Ok();
        }
    }
}
