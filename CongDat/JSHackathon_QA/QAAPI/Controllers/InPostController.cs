using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using QAAPI.Models;
using QAAPI.DAO;
using Newtonsoft.Json;
namespace QAAPI.Controllers
{
    public class InPostController : ApiController
    {
        public List<Comment> Get(int Post_id,string User_id)
        {
            //TODO: Trả ra các comment và replies của comment thuộc về Question&Answer có id bằng QA_id được gửi đến 
            //Lấy comment và replie liên quan của QA có QA_id được gọi. 
            List<Comment> comments = new CommentContext().getAllCommentOfPost(User_id,Post_id);                       
            //Return
            return comments;
        }
        public Post Get(int Post_id)
        {
            //TODO: Lất Post theo postid
            Post post = new PostContext().getPostByID(Post_id);
            //Return
            return post;
        }
    }
}
