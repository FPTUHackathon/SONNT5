using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using QAAPI.Models;
using Newtonsoft.Json;
namespace QAAPI.Controllers
{
    public class InPostController : ApiController
    {
        public List<Comment> Get(int Post_id,string User_id)
        {
            //TODO: Trả ra các comment và replies của comment thuộc về Question&Answer có id bằng QA_id được gửi đến 
            //if QA_id ==1:
            //Lấy comment và replie liên quan của QA có QA_id được gọi. *Ở đây chỉ là làm ví dụ, khi lấy thật lấy từ database
            List<Comment> comments = new List<Comment>();
            comments.Add(new Comment() { id = 1, QA_id=Post_id, content = "Oh shit! This is too hard, I cant solve it", author = "User2",like_count=10,dislike_count=0,crt_date="01/01/2017" ,likeStatusOfCurrentUser=true});
            List<Reply> replies = new List<Reply>();
            replies.Add(new Reply() { id = 1, comment_id = 1, content = "Yeah, same here", author = "User3" , crt_date = "01/01/2017" });
            comments[0].replies = replies;
            //Return
            return comments;
        }

    }
}
