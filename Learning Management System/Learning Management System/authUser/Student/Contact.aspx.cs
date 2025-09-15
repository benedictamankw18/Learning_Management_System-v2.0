using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Learning_Management_System.authUser.Student
{
    public partial class Contact : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [System.Web.Services.WebMethod]
        public static string SendContactEmail(string name, string email, string subject, string message)
        {
            try
            {
                var smtpServer = System.Configuration.ConfigurationManager.AppSettings["SmtpServer"];
                var smtpPort = int.Parse(System.Configuration.ConfigurationManager.AppSettings["SmtpPort"]);
                var smtpUser = System.Configuration.ConfigurationManager.AppSettings["SmtpUsername"];
                var smtpPass = System.Configuration.ConfigurationManager.AppSettings["SmtpPassword"];
                var enableSsl = bool.Parse(System.Configuration.ConfigurationManager.AppSettings["SmtpEnableSsl"]);
                var fromEmail = System.Configuration.ConfigurationManager.AppSettings["FromEmail"];
                var fromName = System.Configuration.ConfigurationManager.AppSettings["FromName"];
                var toEmail = "nethunterghana@gmail.com";

                var mail = new System.Net.Mail.MailMessage();
                mail.From = new System.Net.Mail.MailAddress(fromEmail, fromName);
                mail.To.Add(toEmail);
                mail.Subject = $"[Contact Form] {subject}";
                mail.Body = $"<b>Name:</b> {name}<br/><b>Email:</b> {email}<br/><b>Message:</b><br/>{message}";
                mail.IsBodyHtml = true;

                var smtp = new System.Net.Mail.SmtpClient(smtpServer, smtpPort);
                smtp.Credentials = new System.Net.NetworkCredential(smtpUser, smtpPass);
                smtp.EnableSsl = enableSsl;
                smtp.Send(mail);

                return "{\"success\":true}";
            }
            catch (System.Exception ex)
            {
                return $"{{\"success\":false,\"message\":\"{ex.Message.Replace("\"", "'") }\"}}";
            }
        }
    }
    }
