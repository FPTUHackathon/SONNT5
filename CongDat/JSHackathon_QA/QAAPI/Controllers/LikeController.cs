using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using QAAPI.DAO;
namespace QAAPI.Controllers
{
    public class LikeController : ApiController
    {
        public bool Get(string user_id,int cmt_id, int status) {
            new CommentContext().changeLikeStatus(user_id,cmt_id,status);
            return true;
        }
    }
}
