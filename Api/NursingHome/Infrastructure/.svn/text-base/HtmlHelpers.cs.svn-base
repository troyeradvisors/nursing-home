using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc.Html;
using System.Web.Mvc;

namespace NursingHome.Infrastructure
{
	public static class HtmlHelpers
	{
		public static MvcHtmlString MenuLink(this HtmlHelper htmlHelper, string linkText, string actionName, string controllerName, int? id=null)
		{
			string currentAction = htmlHelper.ViewContext.RouteData.GetRequiredString("action");
			string currentController = htmlHelper.ViewContext.RouteData.GetRequiredString("controller");
            var routeValues = id == null ? null : new { id = id.Value};
			if (actionName.ToLower()==currentAction.ToLower() && controllerName.ToLower()==currentController.ToLower())
			{
				return htmlHelper.ActionLink(
					linkText,
					actionName,
					controllerName,
					routeValues,
					new
					{
						@class = "current"
					});
			}
			return htmlHelper.ActionLink(linkText, actionName, controllerName, routeValues, null);
		}

	}
}