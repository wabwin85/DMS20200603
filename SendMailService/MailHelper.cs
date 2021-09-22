using DMS.Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace SendMailService
{
    public enum SendStatus
    {
        //新邮件
        New,

        Sending, //发送中

        //已发送
        Sent,

        //发送失败
        Failure,

        //过期
        Expired,

        //重试
        Retry
    }

    public static class MailUtil
    {
        /// <summary>
        /// 发送邮件
        /// </summary>
        /// <param name="mailMsg"></param>
        /// <returns></returns>
        public static SmtpClient CreateSmtpClient()
        {
            SmtpClient client = new SmtpClient();
            client.Host = ConfigurationManager.AppSettings["MailHost"];
            client.Port = 587;//465
            client.Credentials = new System.Net.NetworkCredential(ConfigurationManager.AppSettings["Mail_AddressFrom"], ConfigurationManager.AppSettings["Mail_AddressPWD"]);
            client.DeliveryMethod = SmtpDeliveryMethod.Network; //将smtp的出站方式设为 Network
            client.EnableSsl = true;//smtp服务器是否启用SSL加密
            return client;
        }

        private static void AddMailAddress(MailAddressCollection listMail, string strMailAddress)
        {
            string[] arrAddress = strMailAddress.Split(';');

            foreach (string address in arrAddress)
            {
                listMail.Add(address);
            }
        }
        private static void AddMailAttachment(AttachmentCollection lstAttachment, List<MailMessageAttachment> strFiles)
        {
            string defaultPath = ConfigurationManager.AppSettings["MailTask.AttachDefautPath"];
            if (!Path.IsPathRooted(defaultPath))
            {
                defaultPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, defaultPath);
            }
            foreach (MailMessageAttachment path in strFiles)
            {
                string p = path.FilePath;
                if (!Path.IsPathRooted(p))
                {
                    p = Path.Combine(defaultPath, p);
                }
                lstAttachment.Add(new System.Net.Mail.Attachment(p));
            }
        }
        /// <summary>
        /// 邮件 信息
        /// </summary>
        /// <param name="strTo">收件人地址 列表</param>
        /// <param name="strSubjet">邮件主题</param>
        /// <param name="strBody">邮件内容</param>
        /// <returns></returns>
        public static void SendMail(SmtpClient client, string strMailFrom,
            string strTo, string strMailCC, string strMailBCC, string strNoticeTo, string strSubjet, string strBody, List<MailMessageAttachment> strFiles)
        {
            MailMessage mailMsg = new MailMessage();
            try
            {
                //添加发件人地址
                if (!string.IsNullOrEmpty(strMailFrom))
                {
                    mailMsg.From = new MailAddress(strMailFrom, strMailFrom);
                }
                //添加收件人地址
                if (!string.IsNullOrEmpty(strTo))
                {
                    AddMailAddress(mailMsg.To, strTo);
                }

                //抄送
                if (!string.IsNullOrEmpty(strMailCC))
                {
                    AddMailAddress(mailMsg.CC, strMailCC);
                    //mailMsg.CC.Add(strMailCC);
                }
                //密送
                if (!string.IsNullOrEmpty(strMailBCC))
                {
                    AddMailAddress(mailMsg.Bcc, strMailBCC);
                    //mailMsg.Bcc.Add(strMailBCC);
                }

                //回执
                if (!string.IsNullOrEmpty(strNoticeTo))
                {
                    mailMsg.Headers.Add("Disposition-Notification-To", strNoticeTo);
                }

                //设置邮件级别
                mailMsg.Priority = MailPriority.Normal;

                //添加邮件主题
                mailMsg.SubjectEncoding = Encoding.UTF8;
                mailMsg.Subject = strSubjet;

                //添加邮件内容
                mailMsg.BodyEncoding = Encoding.UTF8;
                mailMsg.Body = strBody;
                mailMsg.IsBodyHtml = true;

                //邮件的附件列表
                if (strFiles.Count > 0)
                {
                    AddMailAttachment(mailMsg.Attachments, strFiles);
                }
                //发送邮件
                client.Send(mailMsg);
            }
            catch (System.Exception ex)
            {
                throw ex;
            }
        }

    }
}
