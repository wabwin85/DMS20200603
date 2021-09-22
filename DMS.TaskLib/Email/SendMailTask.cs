using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EmailSender;
using DMS.TaskLib.Email.Configuration;
using System.Configuration;
using System.Threading;
using Common.Logging;
using Fulper.TaskManager.TaskPlugin;
using Microsoft.Practices.EnterpriseLibrary.Common.Configuration;
using DMS.Model;
using DMS.Business;

namespace DMS.TaskLib.Email
{
    public class SendMailTask : ITask
    {
        //private static ILog _log = LogManager.GetLogger(typeof(SendMailTask));
        private IDictionary<string, string> _config = null;
        public SendMailTask()
        {

        }
        #region ITask 成员

        public void Execute()
        {
            IConfigurationSource source = ConfigurationSourceFactory.Create("grapecityLibrary");
            var emailSettings = (EmailSettings)source.GetSection("grapecityGroup/emailSettings");
            var server = emailSettings.Servers[emailSettings.Default];

            MessageBLL business = new MessageBLL();
            IList<MailMessageQueue> msgList = null;
            //初始化邮件并得到邮件发送队列
            try
            {
                //_log.Info("Initializing messages!");
                business.MailMessageProcessToQueue();
                msgList = business.GetMailMessageQueue();
                //_log.Info("Initialize messages success.");
            }
            catch (Exception ex)
            {
                //_log.Info(string.Format("Initialize messages failed, error Message:{0}", ex.ToString()));
                return;
            }

            //判断是否有待发送的邮件
            if (msgList == null || msgList.Count == 0)
            {
                // _log.Info("No message can be sent!");
                return;
            }

            //发送邮件
            try
            {
                if (server.EnableConcurrency)
                {
                    //设置线程池大小
                    ThreadPool.SetMinThreads(server.MinThreadCount, server.MinThreadCount);
                    ThreadPool.SetMaxThreads(server.MaxThreadCount, server.MaxThreadCount);
                    //邮件队列大小
                    int size = msgList.Count > server.Total ? server.Total : msgList.Count;
                    //添加信号量
                    ManualResetEvent[] doneEvents = new ManualResetEvent[size];
                    //邮件发送对象
                    MailSender[] emailSenders = new MailSender[size];
                    //丢入线程池发送邮件
                    //_log.Debug(string.Format("Start sending email, total {0} ...", size));

                    for (int i = 0; i < size; i++)
                    {
                        MailMessageQueue mail = msgList[i];
                        doneEvents[i] = new ManualResetEvent(false);
                        List<MailMessageAttachment> attachmentPath = business.GetMailMessageAttachments(mail.Id).ToList();
                        MailSender emailSender = new MailSender(server.Smtp, server.Port, server.EnableSSL, server.From, server.UserName, server.Password, mail, attachmentPath, doneEvents[i]);
                        emailSenders[i] = emailSender;
                        ThreadPool.QueueUserWorkItem(emailSender.ThreadPoolCallback, "Send Mail Task-" + i.ToString());
                    }

                    WaitHandle.WaitAll(doneEvents);
                    //_log.Debug("All emails have been sent.");
                }
                else
                {
                    //邮件队列大小
                    int size = msgList.Count > server.Total ? server.Total : msgList.Count;
                    for (int i = 0; i < size; i++)
                    {
                        MailMessageQueue mail = msgList[i];
                        List<MailMessageAttachment> attachmentPath = business.GetMailMessageAttachments(mail.Id).ToList();
                        MailSender emailSender = new MailSender(server.Smtp, server.Port, server.EnableSSL, server.From, server.UserName, server.Password, mail, attachmentPath, null);
                        //_log.Debug(string.Format("{0} started at thread[{1}]...", "Send Mail Task-" + i.ToString(), Thread.CurrentThread.GetHashCode()));
                        emailSender.Send();
                        //_log.Debug(string.Format("{0} finished at thread[{1}]...", "Send Mail Task-" + i.ToString(), Thread.CurrentThread.GetHashCode()));
                        Thread.Sleep(server.Interval);
                    }
                }
            }
            catch (Exception ex)
            {
                //_log.Error(string.Format("Send message failure ,error Message:{0}", ex.ToString()), ex);
            }
        }


        #endregion

        #region ITask 成员

        public Dictionary<string, string> Config
        {
            set
            {
                this._config = value;
                //_log.Info("SendMailTask Config : Count = " + this._config.Count);
            }
        }

        #endregion
    }
}
