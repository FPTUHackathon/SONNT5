using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using degoiapi.Models.QAModels;
using degoiapi.Data.PostContext;
using Microsoft.AspNet.Identity;
namespace degoiapi.Controllers
{
    [Authorize]
    [RoutePrefix("api/Comment")]
    public class CommentController : ApiController
    {
        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        public Int32 Get(int post_id, string cmtContent, string user_id)
        {
            //TODO: add Comment           
            int newCommentID = new CommentContext().addComment(user_id, cmtContent, post_id);
            return newCommentID;
        }
    }
}
