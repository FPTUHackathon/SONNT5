using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using QAAPI.Models;
using Newtonsoft.Json;
using QAAPI.DAO;
namespace QAAPI.Controllers
{
    public class PostsController : ApiController
    {
        public List<Post> Get()
        {
            //TODO: Trả ra toàn bộ các Question&Answer 
            //Lấy QA từ database. *Ở đây chỉ là làm ví dụ:
            List<Post> qas = new List<Post>();
            qas.Add(new Post{ id = 1, title = "First sample QA", content = "This is the content of this QA", author = "User1" , crt_date = "01/01/2017" });
            //Return
            return qas;
        }
        
        public List<Post> Get(int tagID)
        {
            //TODO: Trả ra toàn bộ các Question&Answer theo tag            
            List<Post> posts = new PostContext().getAllPostByTag(tagID);
            return posts;
        }
        public int Get(string userID,string title,string content,string tags)
        {
            //TODO: add post
            int post_id = new PostContext().addPost(userID,title, content, tags, "12/3/2017");
            return post_id;
        }
    }
}
