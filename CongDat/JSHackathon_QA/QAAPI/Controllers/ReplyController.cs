using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace QAAPI.Controllers
{
    public class ReplyController : ApiController
    {
        public bool Post (int cmt_id,string ReplyContent, string user_id){
            return true;
        }
    }
}
