using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace degoiapi.Models.CallModels {
    public class CallOffer {
        public User Caller { get; set; }
        public User Callee { get; set; }
    }
}