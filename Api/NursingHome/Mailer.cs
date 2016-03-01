using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Mail;
using System.Web.Configuration;
using System.IO;

namespace NursingHome
{
    public class Mailer
    {
        public static void SendPictureReport()
        {
            double days;
			if (!double.TryParse(WebConfigurationManager.AppSettings["ReportFrequencyDays"], out days))
				days = 7.0;
            if (DateTime.Now.Subtract(LastReportDate).TotalDays < days) 
                return;
 
            SmtpClient client = new SmtpClient();
            using (MailMessage message = new MailMessage())
            {
				string emails = WebConfigurationManager.AppSettings["ReportPictureEmails"];
                if (string.IsNullOrWhiteSpace(emails)) return;
                emails.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).ToList().ForEach(e => message.To.Add(new MailAddress(e)));
                message.Subject = WebConfigurationManager.AppSettings["ReportEmailSubject"] ?? "Inappropriate pictures";
                message.Body = "<html><body>New images have been flagged as inappropriate within the last " + days + " days. <a href=\"" +WebConfigurationManager.AppSettings["ReportEmailLink"]+ "\">Click to manage images.</a></body></html>";
                message.IsBodyHtml = true;
                client.Send(message);
                LastReportDate = DateTime.Now;
                SaveLastReportDate();
            }
        }
        private static string SettingsPath { get { return Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "LastReportDate.txt"); }}
        private static DateTime _LastReportDate = DateTime.MinValue;
        public static DateTime LastReportDate
        {
            get
            {
                if (_LastReportDate == DateTime.MinValue && File.Exists(SettingsPath))
                {
                    using (StreamReader s = new StreamReader(SettingsPath))
                    {
                        DateTime.TryParse(s.ReadToEnd(), out _LastReportDate);
                    }
                }
                return _LastReportDate;
            }
            set
            {
                _LastReportDate = value;
            }
        }

        private static void SaveLastReportDate()
        {
            using (StreamWriter w = new StreamWriter(SettingsPath, false))
            {
                w.WriteLine(_LastReportDate);
            }
        }


    }
}