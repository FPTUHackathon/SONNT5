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
    [RoutePrefix("api/Reply")]
    public class ReplyController : ApiController
    {
        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        public Int32 Get(int cmt_id, string ReplyContent, string user_id)
        {
            //TODO: add Reply
            int newReplyID = new ReplyContext().addReply(user_id, cmt_id, ReplyContent);
            return newReplyID;
        }
    }
}
