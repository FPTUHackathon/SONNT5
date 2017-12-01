using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace degoiapi.Models.ChatModels {
    public class Room {
        public string RoomId { get; set; }
        public string Name { get; set; }
        public List<string> UserIds { get; set; }
    }
}