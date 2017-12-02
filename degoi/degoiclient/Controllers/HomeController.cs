using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace degoiclient.Controllers {
    [RequireHttps]
    public class HomeController : Controller {
        // GET: Homes
        public ActionResult Index() {
            return View();
        }

        public ActionResult Chat() {
            return View();
        }

        public ActionResult Test1() {
            return View();
        }

        public ActionResult Test2() {
            return View();
        }

        // GET: Account/ChangeInfo
        public ActionResult ChangeInfo() {
            return View();
        }
    }
}