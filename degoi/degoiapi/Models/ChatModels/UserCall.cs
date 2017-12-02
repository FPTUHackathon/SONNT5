using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace degoiapi.Models.ChatModels {
    public class UserCall {
        public List<User> Users { get; set; }
        public DateTime TimeStart { get; set; }
        public DateTime TimeEnd { get; set; }
    }
}