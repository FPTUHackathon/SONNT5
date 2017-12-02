using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using JSHackathon_QA.Models;
using System.Net.Http;
using System.Threading.Tasks;

namespace JSHackathon_QA.Controllers
{
    public class PostController : Controller
    {
        // GET: QAs
        public async Task<ActionResult> Index()
        {
            //TODO: Kết nối vào API, vào controller: api/Post/Get , để lấy tất cả các Question&Answer
            //      Hiện thị các Question&Answer đó dưới dạng các thẻ trong View/Post/Index.cshtml
            HttpClient client = new HttpClient();
            var responseString = await client.GetStringAsync("http://localhost:51922/api/Posts/Get?tagID="+1000);
            var ac = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Post>>(responseString);
            return View(ac);
        }
        public async Task<ActionResult> Post(int Post_id)
        {
            //TODO: Kết nối vào API, vào controller: api/QA/Get , để lấy tất cả các comment và reply của Question&Answer
            //      Hiện thị lại nội dung QA và các comment, các replie đó dưới dạng các thẻ trong View/QAs/QA.cshtml
            string user_id = "user1";
            HttpClient client = new HttpClient();
            var responseString = await client.GetStringAsync("http://localhost:51922/api/InPost/Get?Post_id=" + Post_id+"&User_id="+user_id);            
            List<Comment> comments = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Comment>>(responseString);
            //Lấy thông tin của QA : *Ở đây demo nên gán luôn:
            Post qa = new Post { id = 1, title = "First sample QA", content = "This is the content of this QA", author = "User1", crt_date = "01/01/2017" };
            //Truyền QA và comments vào datacolection -> share với view
            ViewBag.qa = qa;
            return View(comments);
        }
        public async Task<ActionResult> Create()
        {
            //TODO: Mở trang tạo mới 1 Post
            return View();
        }
    }
}