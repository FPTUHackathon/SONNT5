using degoiapi.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace degoiapi.Controllers {
    [Authorize]
    [RoutePrefix("api/User")]
    public class UserController : ApiController {
        [Route("Search")]
        [HttpGet]
        public List<dynamic> Search(string name) {
            return DbContext.SearchUserByName(name);
        }
    }
}