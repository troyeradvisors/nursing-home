using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using NursingHome.Domain;
namespace NursingHome.Controllers
{
    public class StateAverageController : ApiController
    {
        ReadRepository<StateAverage> repo = new ReadRepository<StateAverage>(false);
        // GET api/stateaverage
        public IEnumerable<StateAverage> Get()
        {
            return repo.All;
        }
        
        
        // GET api/stateaverage/5
        public StateAverage Get(string id)
        {
            return repo.All.Where(e=>e.StateCode.ToLower() == id.ToLower()).FirstOrDefault();
        }

		/*
        // POST api/stateaverage
        public void Post([FromBody]string value)
        {
        }

        // PUT api/stateaverage/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/stateaverage/5
        public void Delete(int id)
        {
        }
         */
    }
}
