using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace degoiapi.Models.ChatModels {
    public class User {
        public string Name { get; set; }
        public string UserId { get; set; }
        public string ConnectionId { get; set; }
        public bool InCall { get; set; }
    }
}