using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using NursingHome.Domain;
namespace NursingHome.Controllers
{
    public class PictureController : ApiController
    {
        Repository<Picture> repo = new Repository<Picture>(false);
		Repository<PictureVote> votes = new Repository<PictureVote>(false); // Disable lazy loading so xml/json formatter doesn't serialize navigation properties.


        // GET api/Picture/5
        public Picture Get(int id)
        {
            Picture p = repo.FindBy(id);
            p.LoadPicture(PictureFormFactor.iPhone, LoadOptions.OnlyURL); // Load high quality image when loading one at a time.

            return p;
        }

		public Picture GetByUser(string homeID, string userID)
		{
			Guid lower = new Guid(userID);
			Picture pic = repo.All.Where(e => e.HomeID == homeID && e.UserID == lower).FirstOrDefault();
			if (pic != null) 
				pic.LoadPicture(PictureFormFactor.Thumbnail);
			return pic;
		}

        public IEnumerable<Picture> GetByHome(string homeID, Guid? includeMyVotes = null, int skip = 0, int take = int.MaxValue)
        {

            var pics = repo.All.Where(e => e.HomeID == homeID && !e.IsReported).OrderByDescending(e=>e.PositiveVotes - e.NegativeVotes).ThenBy(e=>e.NegativeVotes).Skip(skip).Take(take).ToList();
			pics.LoadPictures(PictureFormFactor.Thumbnail);

			if (includeMyVotes != null)  //685A24DD-7F1B-4507-9F05-094979381CB3
			{
				//List<CommentVote> v = votes.All.Where(e => e.UserID == includeMyVotes).ToList();
				foreach (Picture c in pics)
				{
					var vote = votes.All.Where(vv => vv.UserID == includeMyVotes && vv.PictureID == c.ID).FirstOrDefault();
					if (vote != null) c.MyVote = vote.Vote;
				}
			}

			return pics;
        }

        // POST api/Picture
        public void Post(Picture c)
        {
            c.EditDate = DateTime.UtcNow;
            // A user is only allowed a maximum of 1 comment/picture per home
            Picture c2 = repo.All.Where(e => e.HomeID == c.HomeID && e.UserID == c.UserID).FirstOrDefault();
            bool created = false;
            if (c2 == null)
                c2 = repo.Update(c, out created, false);
            else
            {
                //c2.FileName = c.FileName;
                c2.Caption = c.Caption;
                c2.EditDate = c.EditDate;
            }
			string name;
            if (created)
                c2.FileName = PictureHandler.Create(c.Content, c2.HomeID);
			else if (PictureHandler.Save(c.Content, c2.FileName, c2.HomeID, out name))
			{
				c2.FileName = name; // extension might have changed based on the content
				c2.PositiveVotes = c2.NegativeVotes = 0;
			}
            repo.Save();
        }

        [HttpGet]
        public void Report(int id, string report)
        {
            Picture p = repo.FindBy(id);
            p.IsReported = true;
            repo.Save();
            Mailer.SendPictureReport();
        }
    }
}
