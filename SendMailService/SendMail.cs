using DMS.Business;
using DMS.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace SendMailService
{
    public partial class SendMail : ServiceBase
    {
        static readonly Object syncRoot = new Object();

        readonly System.Timers.Timer timer;

        protected override void OnStart(string[] args)
        {
            timer.Enabled = true;
            System.Diagnostics.Trace.TraceInformation("执行时间:{0} 服务开始执行", DateTime.Now);
        }

        protected override void OnStop()
        {
            timer.Enabled = false;
            System.Diagnostics.Trace.TraceInformation("执行时间:{0} 服务停止执行", DateTime.Now);
        }

        public SendMail()
        {
            timer = new System.Timers.Timer();
            string second = ConfigurationManager.AppSettings["MailTask.Interval"];
            timer.Interval = int.Parse(second) * 1000;
            // timer.Interval = 30000;
            timer.Elapsed += new System.Timers.ElapsedEventHandler(timer_Elapsed);
            InitializeComponent();
        }

        public SendMail(bool enabled)
            : this()
        {
            timer.Enabled = enabled;
            DoExecute();
        }

        void timer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            lock (SendMail.syncRoot)
            {
                DoExecute();
            }
        }

        /// <summary>
        /// 处理邮件任务
        /// </summary>
        private void DoExecute()
        {
            try
            {
                MessageBLL business = new MessageBLL();
                IList<MailMessageQueue> msgList = null;
                //初始化邮件并得到邮件发送队列
                business.MailMessageProcessToQueue();
                msgList = business.GetMailMessageQueue();

                //判断是否有待发送的邮件
                if (msgList == null || msgList.Count == 0)
                {
                    // _log.Info("No message can be sent!");
                    return;
                }
                var mailClient = MailUtil.CreateSmtpClient();
                foreach (MailMessageQueue item in msgList)
                {
                    try
                    {
                        string strMailSubject = item.Subject;
                        string strMailBody = item.Body;
                        string strMailFrom = ConfigurationManager.AppSettings["Mail_AddressFrom"];
                        string strMailTo = item.To;
                        string strMailCC = string.Empty;
                        string strMailBCC = string.Empty;
                        List<MailMessageAttachment> MailAttachment = business.GetMailMessageAttachments(item.Id).ToList();
                        #region 发送邮件
                        bool success = false;
                        try
                        {
                            //根据开关决定是否真的发送邮件 
                            MailUtil.SendMail(mailClient, strMailFrom,
                                strMailTo, strMailCC, strMailBCC, string.Empty,
                                strMailSubject, strMailBody, MailAttachment);
                            success = true;
                            //写文件日志
                            System.Diagnostics.Trace.TraceInformation("执行时间:{0} 执行成功", DateTime.Now);
                        }
                        catch (Exception ex)
                        {
                            //写文件日志
                            System.Diagnostics.Trace.TraceError("执行时间:{0}, 邮件任务:{1},  错误信息:{2}", DateTime.Now, item.Id, ex);
                        }
                        finally
                        {
                            //更新邮件状态
                            business.UpdateMailMessageQueue(item, success);
                        }

                        #endregion 发送邮件
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Trace.TraceError("执行时间:{0}, 邮件任务:{1},  错误信息:{2}", DateTime.Now, item.Id, ex);
                        continue; //一个发送不成功，跳过，发下一个
                    }
                }

            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("执行时间:{0}, 错误信息:{1}", DateTime.Now, ex);
            }
        }


        private static string ReplaceK2(string str)
        {
            if (str.IndexOf("K2SQL:") >= 0)
                return str.Substring(6);
            else
                return str;
        }


        private static List<string> StringUserToList(string sMailUser)
        {
            List<string> list = new List<string>();
            string[] userArr = sMailUser.Split(',', ';');
            foreach (string item in userArr)
            {
                if (item != string.Empty)
                {
                    list.Add(ReplaceK2(item));
                }
            }
            return list;
        }

        /// <summary>
        /// 验证邮件地址格式是否正确
        /// </summary>
        /// <param name="strIn"></param>
        /// <returns></returns>
        private static bool IsValidEmail(string strIn)
        {
            return Regex.IsMatch(strIn, @"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$");
        }

    }
}
