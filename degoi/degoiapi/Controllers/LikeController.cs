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
    [RoutePrefix("api/Like")]
    public class LikeController : ApiController
    {
        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        public bool Get(string user_id, int cmt_id, int status)
        {
            user_id = User.Identity.GetUserId();
            new CommentContext().changeLikeStatus(user_id, cmt_id, status);
            return true;
        }
    }
}
