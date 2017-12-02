using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace JSHackathon_QA.Models
{
    public class Post
    {
        public int id { get; set; }
        public string  title { get; set; }
        public string content { get; set; }
        public string author { get; set; }
        public string crt_date { get; set; }
        public List<Tag> tags { get; set; }

    }
}