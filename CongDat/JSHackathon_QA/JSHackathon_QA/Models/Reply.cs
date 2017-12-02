using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace JSHackathon_QA.Models
{
    public class Reply
    {
        public int id { get; set; }
        public int comment_id { get; set; }
        public string content { get; set; }
        public string author { get; set; }
        public string crt_date { get; set; }
    }
}