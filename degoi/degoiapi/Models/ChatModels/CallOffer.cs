using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace degoiapi.Models.ChatModels {
    public class CallOffer {
        public User Caller { get; set; }
        public User Callee { get; set; }
    }
}