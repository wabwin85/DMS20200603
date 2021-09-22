using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.Common;
using System.Data;
using System.Collections;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using System.IO;
using Common.Logging;

namespace DMS.Business
{
    public class MessageBLL : IMessageBLL
    {
        //private static ILog _log = LogManager.GetLogger(typeof(MessageBLL));
        private IRoleModelContext _context = RoleModelContext.Current;
        public static string EmailFrom = System.Configuration.ConfigurationManager.AppSettings["EmailFrom"];


        /// <summary>
        /// 根据代码得到短消息模板
        /// </summary>
        /// <param name="code"></param>
        /// <returns></returns>
        public ShortMessageTemplate GetShortMessageTemplate(string code)
        {
            using (ShortMessageTemplateDao dao = new ShortMessageTemplateDao())
            {
                return dao.GetObjectByCode(code);
            }
        }

        /// <summary>
        /// 根据代码得到邮件模板
        /// </summary>
        /// <param name="code"></param>
        /// <returns></returns>
        public MailMessageTemplate GetMailMessageTemplate(string code)
        {
            using (MailMessageTemplateDao dao = new MailMessageTemplateDao())
            {
                return dao.GetObjectByCode(code);
            }
        }

        /// <summary>
        /// 将邮件放入队列中
        /// </summary>
        /// <param name="msg"></param>
        public void AddToMailMessageQueue(MailMessageQueue msg)
        {
            using (MailMessageQueueDao dao = new MailMessageQueueDao())
            {
                dao.Insert(msg);
            }
        }

        /// <summary>
        /// 将短消息放入队列中
        /// </summary>
        /// <param name="msg"></param>
        public void AddToShortMessageQueue(ShortMessageQueue msg)
        {
            using (ShortMessageQueueDao dao = new ShortMessageQueueDao())
            {
                dao.Insert(msg);
            }
        }
        public void AddToShortMessagTask(MessageTaskSend msg)
        {
            using (ShortMessageQueueDao dao = new ShortMessageQueueDao())
            {
                dao.InsertTask(msg);
            }
        }

        /// <summary>
        /// 发送邮件至队列
        /// </summary>
        /// <param name="code"></param>
        /// <param name="header"></param>
        public void AddToMailMessageQueue(MailMessageTemplateCode code, Dictionary<String, String> dictMsgSubject, Dictionary<String, String> dictMsgBody, String mailAddress)
        {
            if (!string.IsNullOrEmpty(mailAddress))
            {

                MailMessageTemplate template = this.GetMailMessageTemplate(code.ToString());
                if (template != null)
                {

                    string subject = template.Subject;
                    string body = template.Body;
                    //替换标题内容
                    foreach (var item in dictMsgSubject.Keys)
                    {
                        String args = "{#" + item.ToString() + "}";
                        subject = subject.Replace(args, dictMsgSubject[item.ToString()].ToString());
                    }

                    //替换正文内容
                    foreach (var item in dictMsgBody.Keys)
                    {
                        String args = "{#" + item.ToString() + "}";
                        body = body.Replace(args, dictMsgBody[item.ToString()].ToString());
                    }

                    MailMessageQueue queue = new MailMessageQueue();
                    queue.Id = Guid.NewGuid();
                    queue.QueueNo = "email";
                    queue.From = "";
                    //queue.From = EmailFrom;
                    queue.To = mailAddress;
                    queue.Subject = subject;
                    queue.Body = body;
                    queue.Status = MailMessageQueueStatus.Waiting.ToString();
                    queue.CreateDate = DateTime.Now;
                    queue.SendDate = null;

                    this.AddToMailMessageQueue(queue);
                }
            }
        }

        /// <summary>
        /// 发送至短信队列
        /// </summary>
        /// <param name="code"></param>
        /// <param name="header"></param>
        public void AddToShortMessageQueue(ShortMessageTemplateCode code, Dictionary<String, String> dict, String ContactMobile)
        {
            if (!string.IsNullOrEmpty(ContactMobile))
            {

                ShortMessageTemplate template = this.GetShortMessageTemplate(code.ToString());
                if (template != null)
                {

                    string message = template.Template;

                    //替换正文内容
                    foreach (var item in dict.Keys)
                    {
                        String args = "{#" + item.ToString() + "}";
                        message = message.Replace(args, dict[item.ToString()].ToString());
                    }

                    ShortMessageQueue queue = new ShortMessageQueue();
                    queue.Id = Guid.NewGuid();
                    queue.QueueNo = "sms";
                    queue.To = ContactMobile;
                    queue.Message = message;
                    queue.Status = ShortMessageQueueStatus.Waiting.ToString();
                    queue.CreateDate = DateTime.Now;
                    queue.SendDate = null;

                    this.AddToShortMessageQueue(queue);
                }
            }
        }

        /// <summary>
        /// 更新邮件发送状态
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="success"></param>
        public void UpdateMailMessageQueue(MailMessageQueue msg, bool success)
        {
            using (MailMessageQueueDao dao = new MailMessageQueueDao())
            {
                msg.Status = success ? MailMessageQueueStatus.Success.ToString() : MailMessageQueueStatus.Failure.ToString();
                msg.SendDate = DateTime.Now;
                dao.Update(msg);
            }
        }

        /// <summary>
        /// 更新短信发送状态
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="success"></param>
        public void UpdateShortMessageQueue(ShortMessageQueue msg, bool success)
        {
            using (ShortMessageQueueDao dao = new ShortMessageQueueDao())
            {
                msg.Status = success ? ShortMessageQueueStatus.Success.ToString() : ShortMessageQueueStatus.Failure.ToString();
                msg.SendDate = DateTime.Now;
                dao.Update(msg);
            }
        }

        /// <summary>
        /// 更新邮件处理状态
        /// </summary>
        /// <param name="process"></param>
        /// <param name="success"></param>
        public void UpdateMailMessageProcess(MailMessageProcess process, bool success)
        {
            using (MailMessageProcessDao dao = new MailMessageProcessDao())
            {
                process.Status = success ? MailMessageProcessStatus.Success.ToString() : MailMessageProcessStatus.Failure.ToString();
                process.UpdateDate = DateTime.Now;
                dao.Update(process);
            }
        }

        /// <summary>
        /// 更新短信处理状态
        /// </summary>
        /// <param name="process"></param>
        /// <param name="success"></param>
        public void UpdateShortMessageProcess(ShortMessageProcess process, bool success)
        {
            using (ShortMessageProcessDao dao = new ShortMessageProcessDao())
            {
                process.Status = success ? ShortMessageProcessStatus.Success.ToString() : ShortMessageProcessStatus.Failure.ToString();
                process.UpdateDate = DateTime.Now;
                dao.Update(process);
            }
        }

        /// <summary>
        /// 得到待发送邮件列表
        /// </summary>
        /// <returns></returns>
        public IList<MailMessageQueue> GetMailMessageQueue()
        {
            using (MailMessageQueueDao dao = new MailMessageQueueDao())
            {
                return dao.GetMailMessageQueue();
            }
        }
        /// <summary>
        /// 得到待发送邮件列表对应附件列表
        /// </summary>
        /// <returns></returns>
        public IList<MailMessageAttachment> GetMailMessageAttachments(Guid MmqId)
        {
            MailMessageAttachment m = new MailMessageAttachment();
            m.MmqId = MmqId;
            using (MailMessageAttachmentDao dao = new MailMessageAttachmentDao())
            {
                return dao.SelectByFilter(m);
            }
        }

        /// <summary>
        /// 得到待发送短信列表
        /// </summary>
        /// <returns></returns>
        public IList<ShortMessageQueue> GetShortMessageQueue()
        {
            using (ShortMessageQueueDao dao = new ShortMessageQueueDao())
            {
                return dao.GetShortMessageQueue();
            }
        }

        /// <summary>
        /// 得到待处理邮件列表
        /// </summary>
        /// <returns></returns>
        public IList<MailMessageProcess> GetMailMessageProcess()
        {
            using (MailMessageProcessDao dao = new MailMessageProcessDao())
            {
                return dao.GetMailMessageProcess();
            }
        }

        /// <summary>
        /// 得到待处理短信列表
        /// </summary>
        /// <returns></returns>
        public IList<ShortMessageProcess> GetShortMessageProcess()
        {
            using (ShortMessageProcessDao dao = new ShortMessageProcessDao())
            {
                return dao.GetShortMessageProcess();
            }
        }

        /// <summary>
        /// 处理邮件至待发送列表
        /// </summary>
        public void MailMessageProcessToQueue()
        {
            using (TransactionScope trans = new TransactionScope())
            {
                IList<MailMessageProcess> processList = this.GetMailMessageProcess();
                foreach (MailMessageProcess process in processList)
                {
                    bool success = false;
                    try
                    {
                        MailMessageQueue msg = GetMailMessageQueue(process);
                        if (msg != null)
                        {
                            this.AddToMailMessageQueue(msg);
                        }

                        success = true;
                    }
                    catch (Exception e)
                    {
                        //_log.Info(e.ToString());
                    }
                    finally
                    {
                        this.UpdateMailMessageProcess(process, success);
                    }
                }
                trans.Complete();
            }
        }

        /// <summary>
        /// 处理短信至待发送列表
        /// </summary>
        public void ShortMessageProcessToQueue()
        {
            using (TransactionScope trans = new TransactionScope())
            {
                IList<ShortMessageProcess> processList = this.GetShortMessageProcess();
                foreach (ShortMessageProcess process in processList)
                {
                    bool success = false;
                    try
                    {
                        ShortMessageQueue msg = GetShortMessageQueue(process);
                        if (msg != null)
                        {
                            this.AddToShortMessageQueue(msg);
                        }

                        success = true;
                    }
                    catch (Exception e)
                    {
                        //_log.Info(e.ToString());
                    }
                    finally
                    {
                        this.UpdateShortMessageProcess(process, success);
                    }
                }
                trans.Complete();
            }
        }

        /// <summary>
        /// 处理邮件得到待发送邮件对象
        /// </summary>
        /// <param name="process"></param>
        /// <returns></returns>
        private MailMessageQueue GetMailMessageQueue(MailMessageProcess process)
        {
            MailMessageQueue msg = null;
            MailMessageTemplateCode code = (MailMessageTemplateCode)Enum.Parse(typeof(MailMessageTemplateCode), process.Code, true);
            switch (code)
            {
                //case MailMessageTemplateCode.EMAIL_ORDER_CONFIRMED: msg = GetMailMessageQueueForOrder(process); break;
                //case MailMessageTemplateCode.EMAIL_ORDER_COMPLETED: msg = GetMailMessageQueueForOrder(process); break;
                //case MailMessageTemplateCode.EMAIL_RECEIVE: msg = GetMailMessageQueueForReceipt(process); break;
                //case MailMessageTemplateCode.EMAIL_SEND_INVOICE: msg = GetMailMessageQueueForSendInvoice(process); break;
                //case MailMessageTemplateCode.EMAIL_ACCOUNT_STATEMENT: msg = GetMailMessageQueueForRemind(process); break;
                //case MailMessageTemplateCode.EMAIL_EXPIRATION_REMIND: msg = GetMailMessageQueueForRemind(process); break;
                case MailMessageTemplateCode.EMAIL_ORDER_AUTOGENERATE: msg = GetMailMessageQueueForOrderAutoGenerate(process); break;
                case MailMessageTemplateCode.EMAIL_ORDER_CONFIRM: msg = GetMailMessageQueueForOrderConfirmation(process); break;
            }
            return msg;
        }

        /// <summary>
        /// 处理短信得到待发送短信对象
        /// </summary>
        /// <param name="process"></param>
        /// <returns></returns>
        private ShortMessageQueue GetShortMessageQueue(ShortMessageProcess process)
        {
            ShortMessageQueue msg = null;
            ShortMessageTemplateCode code = (ShortMessageTemplateCode)Enum.Parse(typeof(ShortMessageTemplateCode), process.Code, true);
            switch (code)
            {
                //case ShortMessageTemplateCode.SMS_ORDER_CONFIRMED: msg = GetShortMessageQueueForOrder(process); break;
                //case ShortMessageTemplateCode.SMS_ORDER_COMPLETED: msg = GetShortMessageQueueForOrder(process); break;
                //case ShortMessageTemplateCode.SMS_RECEIVE: msg = GetShortMessageQueueForReceipt(process); break;
                //case ShortMessageTemplateCode.SMS_SEND_INVOICE: msg = GetShortMessageQueueForSendInvoice(process); break;
            }
            return msg;
        }

        /// <summary>
        /// 处理邮件得到待发送的自动补货邮件提醒对象
        /// </summary>
        /// <param name="process"></param>
        /// <returns></returns>
        private MailMessageQueue GetMailMessageQueueForOrderAutoGenerate(MailMessageProcess process)
        {
            MailMessageQueue msg = null;
            //获取经销商负责人的邮件地址
            DealerShipToDao dealerShiptoDao = new DealerShipToDao();
            DealerShipTo dst = new DealerShipTo();
            if (process.ProcessId != null)
            {
                dst = dealerShiptoDao.GetDealerEmailAddressByDmaId(process.ProcessId);
            }

            if (dst != null && !string.IsNullOrEmpty(dst.Email))
            {
                MailMessageTemplate template = this.GetMailMessageTemplate(MailMessageTemplateCode.EMAIL_ORDER_AUTOGENERATE.ToString());

                if (template != null)
                {
                    Dictionary<String, String> dictMailBody = new Dictionary<String, String>();
                    dictMailBody.Add("OrderDate", process.CreateDate.Value.GetDateTimeFormats('D')[3].ToString());

                    string subject = template.Subject;
                    string body = template.Body;

                    //替换正文内容
                    foreach (var item in dictMailBody.Keys)
                    {
                        String args = "{#" + item.ToString() + "}";
                        body = body.Replace(args, dictMailBody[item.ToString()].ToString());
                    }
                    msg = new MailMessageQueue();
                    msg.Id = Guid.NewGuid();
                    msg.QueueNo = "email";
                    msg.From = "";
                    msg.To = dst.Email;
                    msg.Subject = subject;
                    msg.Body = body;
                    msg.Status = MailMessageQueueStatus.Waiting.ToString();
                    msg.CreateDate = DateTime.Now;
                    msg.SendDate = null;
                }
            }
            return msg;
        }


        /// <summary>
        /// 处理邮件得到待发送的订单确认提醒对象
        /// </summary>
        /// <param name="process"></param>
        /// <returns></returns>
        private MailMessageQueue GetMailMessageQueueForOrderConfirmation(MailMessageProcess process)
        {
            MailMessageQueue msg = null;
            //获取经销商负责人的邮件地址
            PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
            PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();

            DealerShipToDao dealerShiptoDao = new DealerShipToDao();
            DealerShipTo dst = new DealerShipTo();

            PurchaseOrderHeader header = headerDao.GetObject(process.ProcessId);

            if (header.DmaId != null)
            {
                dst = dealerShiptoDao.GetDealerEmailAddressByDmaId(header.DmaId.Value);
            }

            if (dst != null && !string.IsNullOrEmpty(dst.Email))
            {
                MailMessageTemplate template = this.GetMailMessageTemplate(MailMessageTemplateCode.EMAIL_ORDER_CONFIRM.ToString());

                if (template != null)
                {

                    IList<PurchaseOrderDetail> orderDetailList = detailDao.SelectByHeaderId(header.Id);
                    //获取订单包括的产品数及总金额
                    Decimal productNumber = 0;
                    Decimal orderPrice = 0;

                    foreach (PurchaseOrderDetail detail in orderDetailList)
                    {
                        productNumber += detail.RequiredQty.Value;
                        orderPrice += detail.Amount.Value;
                    }


                    Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                    Dictionary<String, String> dictMailBody = new Dictionary<String, String>();

                    dictMailSubject.Add("Approver", "物流平台");
                    dictMailSubject.Add("OrderNo", header.OrderNo);


                    dictMailBody.Add("Approver", "物流平台");
                    dictMailBody.Add("OrderDate", header.SubmitDate.Value.ToShortDateString().ToString());
                    dictMailBody.Add("OrderNo", header.OrderNo);
                    dictMailBody.Add("OrderAmount", orderPrice.ToString("f2"));
                    dictMailBody.Add("ProductNumber", ((int)productNumber).ToString());

                    string subject = template.Subject;
                    string body = template.Body;
                    //替换标题内容
                    foreach (var item in dictMailSubject.Keys)
                    {
                        String args = "{#" + item.ToString() + "}";
                        subject = subject.Replace(args, dictMailSubject[item.ToString()].ToString());
                    }

                    //替换正文内容
                    foreach (var item in dictMailBody.Keys)
                    {
                        String args = "{#" + item.ToString() + "}";
                        body = body.Replace(args, dictMailBody[item.ToString()].ToString());
                    }
                    msg = new MailMessageQueue();
                    msg.Id = Guid.NewGuid();
                    msg.QueueNo = "email";
                    msg.From = "";
                    msg.To = dst.Email;
                    msg.Subject = subject;
                    msg.Body = body;
                    msg.Status = MailMessageQueueStatus.Waiting.ToString();
                    msg.CreateDate = DateTime.Now;
                    msg.SendDate = null;
                }
            }
            return msg;
        }

        public void AddToMailMessageAttach(MailMessageAttachment attachment)
        {
            using (MailMessageAttachmentDao dao = new MailMessageAttachmentDao())
            {
                dao.Insert(attachment);
            }
        }
    }

}