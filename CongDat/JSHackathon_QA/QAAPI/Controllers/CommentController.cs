﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace QAAPI.Controllers
{
    public class CommentController : ApiController
    {
        public bool Get(int post_id,string cmtContent, string user_id) {
            return true;
        }
    }
}
