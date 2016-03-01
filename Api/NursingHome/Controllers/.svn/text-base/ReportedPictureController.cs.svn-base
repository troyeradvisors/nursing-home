using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NursingHome.Domain;
using NursingHome.Models;
namespace NursingHome.Controllers
{
    [Authorize]
    public class ReportedPictureController : Controller
    {
        Repository<Picture> repo = new Repository<Picture>();


        public ActionResult Index()
        {
            List<ReportModel> p = repo.FilterBy(e => e.IsReported).Select(e => new ReportModel() { ID = e.ID }).ToList();
            return View(p);
        }

        [HttpPost]
        public ActionResult Index(List<ReportModel> pictures, string SubmitButton)
        {
            foreach (ReportModel p in pictures)
            {
                if (!p.IsChecked) 
                    continue;
                if (SubmitButton == null)
                {
                    Picture delete = repo.FindBy(p.ID);
                    delete.DeletePictures();
                    repo.Delete(delete, false);

                }
                else if (SubmitButton == "Ignore")
                {
                    repo.FindBy(p.ID).IsReported = false;
                }
            }
            repo.Save();
            return RedirectToAction("Index");
        }
        public FileContentResult LoadImage(int id)
        {
            Picture p = repo.FindBy(id);
            p.LoadPicture(PictureFormFactor.Thumbnail);
            return File(p.Content, p.Content.FindMime());
        }
    }
}
