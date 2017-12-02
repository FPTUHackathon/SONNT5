using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using QAAPI.DAO;
namespace QAAPI.Controllers
{
    public class ReplyController : ApiController
    {
        public Int32 Get (int cmt_id,string ReplyContent, string user_id){
            //TODO: add Reply
            int newReplyID = new ReplyContext().addReply(user_id, cmt_id, ReplyContent);
            return newReplyID;
        }
    }
}
