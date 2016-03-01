using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using NursingHome.Domain;
using NursingHome.Models;
using System.Configuration;
namespace NursingHome.Controllers
{
    public class SummaryController : ApiController
    {
        ReadRepository<Summary> repo = new ReadRepository<Summary>();
        // api/summary?
        public IEnumerable<Summary> Get(string homeid) 
        {
            var ids = homeid.ToUpper().Split(new char[]{','}, StringSplitOptions.RemoveEmptyEntries).ToArray();
            List<Summary> summaries = repo.All.Where(e => ids.Contains(e.HomeID)).ToList();
			summaries.LoadPictures(PictureFormFactor.Thumbnail, LoadOptions.OnlyURL);  // Client downloads actual thumbnails based on URL and on demand.  
			return summaries;
        }

        public IEnumerable<Summary> Get([FromUri]Filter f)
        {
			List<Summary> s = repo.All.Where(f.Query).ToList();
			s.LoadPictures(PictureFormFactor.Thumbnail, LoadOptions.OnlyURL);  // Client downloads actual thumbnails based on URL and on demand.  
			return s;
        }
    }
}
