using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using NursingHome.Domain;

namespace NursingHome.Controllers
{
    public class CommentController : ApiController
    {
		Repository<Comment> repo = new Repository<Comment>(false); // Disable lazy loading so xml/json formatter doesn't serialize navigation properties.
		Repository<CommentVote> votes = new Repository<CommentVote>(false); // Disable lazy loading so xml/json formatter doesn't serialize navigation properties.
        
        // GET api/comment
        public IEnumerable<Comment> Get()
        {
            return repo.All;
        }

        // GET api/comment/5
        public Comment Get(int id)
        {
            return repo.FindBy(id);
        }

		public Comment GetByUser(string homeID, string userID)
		{
			Guid lower = new Guid(userID);
			return repo.All.Where(e => e.HomeID == homeID && e.UserID == lower).FirstOrDefault();
		}

		public IEnumerable<Comment> GetByHome(string homeID, Guid? includeMyVotes = null,int skip=0, int take=int.MaxValue)
        {
			var comments =  repo.All.Where(e => e.HomeID == homeID).OrderByDescending(e=>e.PositiveVotes-e.NegativeVotes).ThenBy(e=>e.NegativeVotes).Skip(skip).Take(take).ToList();

			if (includeMyVotes != null)  //685A24DD-7F1B-4507-9F05-094979381CB3
			{
				//List<CommentVote> v = votes.All.Where(e => e.UserID == includeMyVotes).ToList();
				foreach (Comment c in comments)
				{
					var vote = votes.All.Where(vv => vv.UserID == includeMyVotes && vv.CommentID == c.ID).FirstOrDefault();
					if (vote != null) c.MyVote = vote.Vote;
				}
			}
			return comments;
        }

        // POST api/comment
        public void Post(Comment c)
        {
            c.EditDate = DateTime.UtcNow;
            // A user is only allowed a maximum of 1 comment/picture per home
            Comment c2 = repo.All.Where(e => e.HomeID == c.HomeID && e.UserID == c.UserID).FirstOrDefault();
            if (c2 == null)
                repo.Update(c); // add or update
            else
            {
                //c2.Rating = c.Rating; // it's a computed column in the database.
				c2.FriendlyRating = c.FriendlyRating;
				c2.ResponsiveRating = c.ResponsiveRating;
				c2.RehabilitationRating = c.RehabilitationRating;
				c2.PhysicalAppealSafetyRating = c.PhysicalAppealSafetyRating;
				c2.MealExperienceRating = c.MealExperienceRating;
				c2.OdorRating = c.OdorRating;
                c2.Title = c.Title;
                c2.Content = c.Content;
                c2.EditDate = c.EditDate;
                repo.Save();
            }
        }

    }
}
