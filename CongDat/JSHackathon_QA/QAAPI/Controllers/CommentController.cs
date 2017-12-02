using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using QAAPI.DAO;
namespace QAAPI.Controllers
{
    public class CommentController : ApiController
    {
        public Int32 Get(int post_id,string cmtContent, string user_id) {
            //TODO: add Comment           
            int newCommentID = new CommentContext().addComment(user_id, cmtContent, post_id);            
            return newCommentID;
        }
    }
}
