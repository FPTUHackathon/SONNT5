using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace QAAPI.Models
{
    public class Comment
    {
        public int id { get; set; }
        public int QA_id { get; set; }
        public string content { get; set; }
        public int count_like { get; set; }
        public int count_dislike { get; set; }
        public string author { get; set; }
    }
}