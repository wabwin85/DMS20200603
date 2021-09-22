using DMS.Business;
using DMS.Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace TimingTaskService
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

    public class MailHelper
    {
        /// <summary>
        /// 发送邮件
        /// </summary>
        /// <param name="mailMsg"></param>
        /// <returns></returns>
        public SmtpClient CreateSmtpClient()
        {
            SetSecurityProtocol();
            SmtpClient client = new SmtpClient();
            client.Host = ConfigurationManager.AppSettings["MailHost"];
            client.Port = 587;//587 465
            client.EnableSsl = true;//smtp服务器是否启用SSL加密
            client.DeliveryMethod = SmtpDeliveryMethod.Network; //将smtp的出站方式设为 Network
            client.UseDefaultCredentials = false;
            client.Credentials = new System.Net.NetworkCredential(ConfigurationManager.AppSettings["Mail_AddressFrom"], ConfigurationManager.AppSettings["Mail_AddressPWD"]);
            return client;
        }


        public static void SetSecurityProtocol()
        {
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 |
                                                   SecurityProtocolType.Tls | SecurityProtocolType.Ssl3;
            ServicePointManager.ServerCertificateValidationCallback = CheckServerCertificateValidationResult;
        }

        public static bool CheckServerCertificateValidationResult(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors errors)
        {
            return true;
        }

        private void AddMailAddress(MailAddressCollection listMail, string strMailAddress)
        {
            string[] arrAddress = strMailAddress.Split(';');

            foreach (string address in arrAddress)
            {
                listMail.Add(address);
            }
        }
        private void AddMailAttachment(AttachmentCollection lstAttachment, List<MailMessageAttachment> strFiles)
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
        public void SendMail(SmtpClient client, string strMailFrom,
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

        public void DoExecute()
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
                var mailClient = CreateSmtpClient();
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
                            SendMail(mailClient, strMailFrom,
                                strMailTo, strMailCC, strMailBCC, string.Empty,
                                strMailSubject, strMailBody, MailAttachment);
                            success = true;
                            //写文件日志
                            System.Diagnostics.Trace.TraceInformation("执行时间:{0} 执行成功", DateTime.Now);
                        }
                        catch (Exception ex)
                        {
                            ErrorLog(ex);
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
                        ErrorLog(ex);
                        System.Diagnostics.Trace.TraceError("执行时间:{0}, 邮件任务:{1},  错误信息:{2}", DateTime.Now, item.Id, ex);
                        continue; //一个发送不成功，跳过，发下一个
                    }
                }

            }
            catch (Exception ex)
            {
                ErrorLog(ex);
                System.Diagnostics.Trace.TraceError("执行时间:{0}, 错误信息:{1}", DateTime.Now, ex);
            }
        }

        /// <summary>
        /// 邮件异常任务异常日志
        /// </summary>
        /// <param name="strLog"></param>
        public static void ErrorLog(Exception ex)
        {
            string strLog = ex.Message + "," + ex.StackTrace;
            string path = Path.GetFullPath("../..") + "/Tasks/Log";
            path = path.Replace("/", "\\");
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            FileStream fs;
            StreamWriter sw;
            if (File.Exists(path + @"/log.txt"))
            {
                fs = new FileStream(path + @"/log.txt", FileMode.Append, FileAccess.Write);
            }
            else
            {
                fs = new FileStream(path + @"/log.txt", FileMode.Create, FileAccess.Write);
            }
            sw = new StreamWriter(fs);
            sw.WriteLine(strLog);
            sw.Close();
            fs.Close();
        }

    }
}
