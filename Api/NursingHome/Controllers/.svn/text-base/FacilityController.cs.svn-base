using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using NursingHome.Domain;
namespace NursingHome.Controllers
{
    public class FacilityController : ApiController
    {
        ReadRepository<Home> repo = new ReadRepository<Home>(false);
        // GET api/facility
        public Home Get(string id)
        {
            return repo.FindBy(id);
        }

        /*
        // GET api/facility/5
        public string Get(int id)
        {
            return "value";
        }

        // POST api/facility
        public void Post([FromBody]string value)
        {
        }

        // PUT api/facility/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/facility/5
        public void Delete(int id)
        {
        }
         */
    }
}
