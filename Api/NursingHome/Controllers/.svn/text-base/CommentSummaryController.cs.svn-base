using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using NursingHome.Domain;

namespace NursingHome.Controllers
{
    public class CommentSummaryController : ApiController
    {
		Repository<CommentSummary> repo = new Repository<CommentSummary>(false); // Disable lazy loading so xml/json formatter doesn't serialize navigation properties.
        
        // GET api/CommentSummary/5
        public CommentSummary Get(string id)
        {
            return repo.All.FirstOrDefault(e=>e.HomeID == id);
        }
    }
}
