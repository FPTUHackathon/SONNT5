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

        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        [Route("MessageRoomSearch")]
        [HttpGet]
        public List<dynamic> MessageRoomSearch()
        {
            var httpRequest = HttpContext.Current.Request;
            var UserId = httpRequest.Params["UserId"];
            var RoomId = httpRequest.Params["RoomId"];
            var Text = httpRequest.Params["Text"];
            return DbContext.MessageRoomSearch(UserId, RoomId, Text);
        }

        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        [Route("MessageRoomSearchUp")]
        [HttpGet]
        public List<dynamic> MessageRoomSearchUp()
        {
            var httpRequest = HttpContext.Current.Request;
            var UserId = httpRequest.Params["UserId"];
            var RoomId = httpRequest.Params["RoomId"];
            var MessId = httpRequest.Params["MessId"];
            return DbContext.MessageRoomSearchUp(UserId, RoomId, MessId);
        }

        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        [Route("MessageRoomSearchDown")]
        [HttpGet]
        public List<dynamic> MessageRoomSearchDown()
        {
            var httpRequest = HttpContext.Current.Request;
            var UserId = httpRequest.Params["UserId"];
            var RoomId = httpRequest.Params["RoomId"];
            var MessId = httpRequest.Params["MessId"];
            return DbContext.MessageRoomSearchDown(UserId, RoomId, MessId);
        }

        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        [Route("MessageRoomSearchMid")]
        [HttpGet]
        public List<dynamic> MessageRoomSearchMid()
        {
            var httpRequest = HttpContext.Current.Request;
            var UserId = httpRequest.Params["UserId"];
            var RoomId = httpRequest.Params["RoomId"];
            var MessId = httpRequest.Params["MessId"];
            return DbContext.MessageRoomSearchMid(UserId, RoomId, MessId);
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
