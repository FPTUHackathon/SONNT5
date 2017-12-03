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
    [RoutePrefix("api/InPost")]
    public class InPostController : ApiController
    {
        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        public List<Comment> Get(int Post_id,string user_id)
        {
            string User_id = User.Identity.GetUserId();
            //TODO: Trả ra các comment và replies của comment thuộc về Question&Answer có id bằng QA_id được gửi đến 
            //Lấy comment và replie liên quan của QA có QA_id được gọi. 
            List<Comment> comments = new CommentContext().getAllCommentOfPost(User_id, Post_id);
            //Return
            return comments;
        }
        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        public Post Get(int Post_id)
        {
            //TODO: Lất Post theo postid
            Post post = new PostContext().getPostByID(Post_id);
            //Return
            return post;
        }
    }
}
