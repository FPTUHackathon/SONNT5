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
        public string Room(string sUserIds) {
            string[] userIds = sUserIds.Split(',');
            Array.Sort(userIds);
            string roomId = "";
            foreach (string userId in userIds) roomId += userId;
            ChatHub.Rooms.Add(new Room() {
                Name = "Room",
                UserIds = userIds.ToList(),
                RoomId = roomId
            });
            return roomId;
        }

        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        [Route("Upload")]
        [HttpPost]
        public IHttpActionResult Upload() {
            var httpRequest = HttpContext.Current.Request;
            var roomId = httpRequest.Form["roomId"];
            if (httpRequest.Files.Count < 1) {
                return Json(new {
                    error = "file not found",
                });
            }
            foreach (string file in httpRequest.Files) {
                var postedFile = httpRequest.Files[file];
                var filePath = HttpContext.Current.Server.MapPath("~/Upload/") + postedFile.FileName;
                postedFile.SaveAs(filePath);
                //
                var hubContext = GlobalHost.ConnectionManager.GetHubContext<ChatHub>();
                var userIds = ChatHub.Rooms.SingleOrDefault(r => r.RoomId == roomId).UserIds; // db
                                                                                              // db
                foreach (var userId in userIds) hubContext.Clients.Client(userId).ReceiveMessage("~/Upload/" + postedFile.FileName, 2, roomId);
            }
            return Json(new {
                messake = "ok",
            });
        }
    }
}
