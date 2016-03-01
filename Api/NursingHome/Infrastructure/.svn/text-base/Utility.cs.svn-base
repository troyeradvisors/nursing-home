using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.IO;
using System.Web.UI;

namespace NursingHome.Infrastructure
{
	public static class Utility
	{

        public static string RenderPartialToString(string controlName, object viewData)
        {
            ViewDataDictionary vd = new ViewDataDictionary(viewData);
            ViewPage vp = new ViewPage { ViewData = vd };
            System.Web.UI.Control control = vp.LoadControl(controlName);

            vp.Controls.Add(control);

            StringBuilder sb = new StringBuilder();
            using (StringWriter sw = new StringWriter(sb))
            {
                using (HtmlTextWriter tw = new HtmlTextWriter(sw))
                {
                    vp.RenderControl(tw);
                }
            }

            return sb.ToString();
        }

		public static string HumanizeCamel(string camelCasedString)
		{
			if (camelCasedString == null)
				return "";

			StringBuilder sb = new StringBuilder();

			char last = char.MinValue;
			foreach (char c in camelCasedString)
			{
				if (char.IsLower(last) && char.IsUpper(c))
				{
					sb.Append(' ');
				}
				sb.Append(c);
				last = c;
			}
			return sb.ToString();
		}

		public static string GetWatermark(ViewDataDictionary<dynamic> data)
		{
			string watermark = data.ModelMetadata.Watermark;
			if (watermark == "")
				watermark = Utility.HumanizeCamel(data.TemplateInfo.HtmlFieldPrefix);
			return watermark;
		}

	}
}
