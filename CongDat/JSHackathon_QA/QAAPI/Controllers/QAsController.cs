using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Newtonsoft.Json;
using QAAPI.Models;
namespace QAAPI.Controllers
{
    public class QAsController : ApiController
    {
        public string Get()
        {
            List<QA> qas = new List<QA>();
            qas.Add(new QA() { id = 1, title = "First QA", content = "Please help me answer this: ....?" });
            return JsonConvert.SerializeObject(qas);
        }
    }
}
