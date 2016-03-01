using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using NursingHome.Domain;

namespace NursingHome.Controllers
{
    public class CommentVoteController : ApiController
    {
        Repository<CommentVote> repo = new Repository<CommentVote>();

		public IEnumerable<CommentVote> Get(Guid userId)
		{
			return repo.All.Where(e => e.UserID == userId).ToList();
		}

        // POST api/CommentVote
        public void Post(CommentVote v)
        {
            if (v.UserID == Guid.Empty || v.CommentID == 0)
                return;
            repo.Update(v);
        }

		// DELETE api/CommentVote?user=xxx&commentID=yyy
		public void Delete(Guid? userID, int commentID=0)
		{
			if (userID == null || commentID == 0) return;
			CommentVote v = repo.All.Where(e => e.UserID == userID && e.CommentID == commentID).FirstOrDefault();
			if (v != null)
			{
				repo.Delete(v);
			}
		}
    }
}