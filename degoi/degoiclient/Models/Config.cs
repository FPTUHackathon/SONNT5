using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace degoiclient.Models {
    public class Config {
        public static string _api;
        public static string Api {
            get {
                if (_api == null) _api = ConfigurationManager.AppSettings["api"];
                return _api;
            }
        }
    }
}