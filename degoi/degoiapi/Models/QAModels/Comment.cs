﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace degoiapi.Models.QAModels
{
    public class Comment
    {
        public int id { get; set; }
        public int QA_id { get; set; }
        public string content { get; set; }
        public string author { get; set; }
        public string author_name { get; set; }
        public int like_count { get; set; }
        public int dislike_count { get; set; }
        public string crt_date { get; set; }
        public List<Reply> replies { get; set; }
        public Boolean likeStatusOfCurrentUser { get; set; }
        public List<Tag> tags { get; set; }
    }
}