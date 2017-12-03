using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Net.Http;
using degoiclient.Models.QAModels;
using System.Net;
using System.Net.Http.Headers;

namespace degoiclient.Controllers {
    [RequireHttps]
    public class HomeController : Controller {
        // GET: Homes
        public ActionResult Index() {
            return View();
        }

        public ActionResult Chat() {
            return View();
        }

        public ActionResult Test1() {
            return View();
        }

        public ActionResult Test2() {
            return View();
        }

        
        public ActionResult ChangeInfo() {
            return View();
        }
        public async System.Threading.Tasks.Task<ActionResult> Posts()
        {
            /*WebRequestHandler handler = new WebRequestHandler();
            X509Certificate2 certificate = GetMyX509Certificate();
            handler.ClientCertificates.Add(certificate);*/
            ServicePointManager.ServerCertificateValidationCallback = delegate { return true; };
            HttpClient client = new HttpClient();
            System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;
            client.BaseAddress = new Uri("https://localhost/");
            client.DefaultRequestHeaders.Add("Authorization", $"Bearer {Request.Cookies["token"].Value}");
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            var responseString = await client.GetStringAsync("degoiapi/api/Post/Get?tagID="+1001);
            var ac = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Post>>(responseString);
            return View(ac);
        }
        public async System.Threading.Tasks.Task<ActionResult> Post(int Post_id)
        {
            string user_id = "1459aaa0-4763-4f3e-99e2-1521e2e00bae";
            ServicePointManager.ServerCertificateValidationCallback = delegate { return true; };
            HttpClient client = new HttpClient();
            System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;
            client.BaseAddress = new Uri("https://localhost/");
            client.DefaultRequestHeaders.Add("Authorization", $"Bearer {Request.Cookies["token"].Value}");
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            var responseString = await client.GetStringAsync("degoiapi/api/InPost/Get?Post_id=" + Post_id + "&User_id=" + user_id);
            List<Comment> comments = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Comment>>(responseString);
            responseString = await client.GetStringAsync("degoiapi/api/InPost/Get?Post_id=" + Post_id);
            Post qa = Newtonsoft.Json.JsonConvert.DeserializeObject<Post>(responseString);
            ViewBag.qa = qa;
            return View(comments);
        }
        public async System.Threading.Tasks.Task<ActionResult> Create()
        {
            //TODO: Mở trang tạo mới 1 Post
            return View();
        }
    }
}