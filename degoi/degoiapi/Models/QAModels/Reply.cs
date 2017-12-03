using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace degoiapi.Models.QAModels
{
    public class Reply
    {
        public int id { get; set; }
        public int comment_id { get; set; }
        public string content { get; set; }
        public string author { get; set; }
        public string authorName { get; set; }
        public string crt_date { get; set; }
    }
}