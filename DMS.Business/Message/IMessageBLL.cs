using System;
using DMS.Model;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using DMS.Model.Data;
namespace DMS.Business
{
    public interface IMessageBLL
    {
        //得到短信与邮件模板对象
        ShortMessageTemplate GetShortMessageTemplate(string code);
        MailMessageTemplate GetMailMessageTemplate(string code);

        //新增短信与邮件对象
        void AddToMailMessageQueue(MailMessageQueue msg);
        void AddToShortMessageQueue(ShortMessageQueue msg);
        void AddToShortMessagTask(MessageTaskSend msg);
        void AddToMailMessageQueue(MailMessageTemplateCode code, Dictionary<String, String> dictMsgSubject, Dictionary<String, String> dictMsgBody, String mailAddress);
        void AddToShortMessageQueue(ShortMessageTemplateCode code, Dictionary<String, String> dict, String ContactMobile);

        //更新短信与邮件对象
        void UpdateMailMessageQueue(MailMessageQueue msg, bool success);
        void UpdateShortMessageQueue(ShortMessageQueue msg, bool success);
        void UpdateMailMessageProcess(MailMessageProcess process, bool success);
        void UpdateShortMessageProcess(ShortMessageProcess process, bool success);

        //得到短信与邮件对象
        IList<MailMessageQueue> GetMailMessageQueue();
        IList<ShortMessageQueue> GetShortMessageQueue();
        IList<MailMessageProcess> GetMailMessageProcess();
        IList<ShortMessageProcess> GetShortMessageProcess();

        //处理短信与邮件至发送列表
        void MailMessageProcessToQueue();
        void ShortMessageProcessToQueue();

        void AddToMailMessageAttach(MailMessageAttachment attachment);
    }
}
