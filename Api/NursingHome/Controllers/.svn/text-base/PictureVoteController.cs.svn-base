using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using NursingHome.Domain;

namespace NursingHome.Controllers
{
    public class PictureVoteController : ApiController
    {
        Repository<PictureVote> repo = new Repository<PictureVote>();

		public IEnumerable<PictureVote> Get(Guid userId)
		{
			return repo.All.Where(e => e.UserID == userId).ToList();
		}

        // POST api/PictureVote
        public void Post(PictureVote v)
        {
            if (v.UserID == Guid.Empty || v.PictureID == 0)
                return;
            repo.Update(v);
        }

		// DELETE api/CommentVote?user=xxx&commentID=yyy
		public void Delete(Guid? userID, int pictureID = 0)
		{
			if (userID == null || pictureID == 0) return;
			PictureVote  v = repo.All.Where(e => e.UserID == userID && e.PictureID == pictureID).FirstOrDefault();
			if (v != null)
			{
				repo.Delete(v);
			}
		}
    }
}
