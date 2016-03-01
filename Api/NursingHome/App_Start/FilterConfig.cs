using System.Web;
using System.Web.Mvc;
using NursingHome.Infrastructure;
namespace NursingHome
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new LocalLoginAttribute("abrubaker@troyeradvisors.com"));
            filters.Add(new HandleErrorAttribute());
        }
    }
}