using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using DMS.TaskLib.Email.Configuration;
using System.Configuration;
using EmailSender;
using Common.Logging;
using DMS.Model;
using DMS.Business;
using System.IO;
using System.Net.Mail;

namespace DMS.TaskLib.Email
{
    public class MailSender
    {
        // private static ILog _log = LogManager.GetLogger(typeof(MailSender));

        private string _smtp;
        private int _port;
        private bool _ssl;
        private string _from;
        private string _username;
        private string _password;
        private MailMessageQueue _mail;
        private ManualResetEvent _doneEvent;
        private Object _threadContext;
        private List<MailMessageAttachment> _attachmentPath;

        public MailSender(string smtp, int port, bool ssl, string from, string username, string password, MailMessageQueue mail, List<MailMessageAttachment> attachmentPath, ManualResetEvent doneEvent)
        {
            _smtp = smtp;
            _port = port;
            _ssl = ssl;
            _from = from;
            _username = username;
            _password = password;
            _mail = mail;
            _attachmentPath = attachmentPath;
            _doneEvent = doneEvent;
        }

        public void ThreadPoolCallback(Object threadContext)
        {
            _threadContext = threadContext;
            //_log.Debug(string.Format("{0} started at thread[{1}]...", threadContext, Thread.CurrentThread.GetHashCode()));
            Send();
            //_log.Debug(string.Format("{0} finished at thread[{1}]...", threadContext, Thread.CurrentThread.GetHashCode()));
            _doneEvent.Set();
        }

        public void Send()
        {
            bool success = false;
            try
            {
                //SmtpSender sender = new SmtpSender(this._smtp);
                //sender.Port = this._port;
                //sender.UserName = this._username;
                //sender.Password = this._password;
                //sender.EnableSsl = this._ssl;


                //EmailSender.Message message = new EmailSender.Message();
                //message.From = this._from;
                //message.To = _mail.To;
                ////message.Encoding = Encoding.GetEncoding(936);
                //message.Encoding = Encoding.UTF8;
                //message.Format = Format.Html;
                //message.Subject = _mail.Subject;
                //message.Body = _mail.Body;
                //message.Cc = _mail.From;
                //for (int i = 0; i < this._attachmentPath.Count; i++)
                //{
                //    string p = this._attachmentPath[i];
                //    if (!Path.IsPathRooted(p))
                //    {
                //        message.Attachments.Add(new System.Net.Mail.Attachment(p));
                //    }
                //}

                //sender.Send(message);
                //success = true;

                SmtpClient client = new SmtpClient();
                MailMessage mailMsg = new MailMessage();
                //添加发件人地址
                if (!string.IsNullOrEmpty(this._from))
                {
                    mailMsg.From = new MailAddress(this._from, this._from);
                }
                //添加收件人地址
                if (!string.IsNullOrEmpty(_mail.To))
                {
                    mailMsg.To.Add(_mail.To);
                }
                //抄送
                mailMsg.CC.Add(mailMsg.From);

                //设置邮件级别
                mailMsg.Priority = MailPriority.Normal;

                //添加邮件主题
                mailMsg.SubjectEncoding = Encoding.UTF8;
                mailMsg.Subject = mailMsg.Subject;

                //添加邮件内容
                mailMsg.BodyEncoding = Encoding.UTF8;
                mailMsg.Body = mailMsg.Body;
                mailMsg.IsBodyHtml = true;

                //邮件的附件列表
                for (int i = 0; i < this._attachmentPath.Count; i++)
                {
                    string p = this._attachmentPath[i].FilePath;
                    if (!Path.IsPathRooted(p))
                    {
                        mailMsg.Attachments.Add(new System.Net.Mail.Attachment(p));
                    }
                }
                //发送邮件
                client.Send(mailMsg);
                success = true;

            }
            catch (Exception e)
            {
                //_log.Debug(string.Format("{0} at thread[{1}],error message : {2}", _threadContext == null ? "Send Mail Task" : _threadContext, Thread.CurrentThread.GetHashCode(), e.ToString()));
            }
            finally
            {
                try
                {
                    MessageBLL business = new MessageBLL();
                    business.UpdateMailMessageQueue(_mail, success);
                    //_log.Info(string.Format("{0} at thread[{1}], {2}", _threadContext == null ? "Send Mail Task" : _threadContext, Thread.CurrentThread.GetHashCode(), success ? "Success" : "Failure"));
                }
                catch
                {
                }
            }
        }
    }
}
