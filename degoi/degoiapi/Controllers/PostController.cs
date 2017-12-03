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
    [RoutePrefix("api/Post")]
    public class PostController : ApiController    {
        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        public List<Post> Get(string titleWord)
        {
            //TODO: Trả ra toàn bộ các Question&Answer theo tag
            if (titleWord == null)
                titleWord = "";            
            List<Post> posts = new PostContext().getAllPostByTitle(titleWord);
            return posts;
        }

        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        public List<Post> Get(int tagID)
        {
            //TODO: Trả ra toàn bộ các Question&Answer theo tag            
            List<Post> posts = new PostContext().getAllPostByTag(tagID);
            return posts;
        }
        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        public int Get(string userID, string title, string content, string tags)
        {
            //TODO: add post
            int post_id = new PostContext().addPost(userID, title, content, tags, "12/3/2017");
            return post_id;
        }
    }
}
