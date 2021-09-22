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
using DMS.Business.Cache;
using Lafite.RoleModel.Domain;
using System.IO;

namespace DMS.Business
{
    public class PurchaseOrderUtil
    {
        public static string FilePath = System.Configuration.ConfigurationManager.AppSettings["OrderExportPath"];
        public static string FileExtension = ".txt";
        public static string FileSeparator = "|";
        public static string EmailFrom = System.Configuration.ConfigurationManager.AppSettings["EmailFrom"];
        public static string ServerUrl = System.Configuration.ConfigurationManager.AppSettings["ServerUrl"];

        public static int GetAuditWaitHour(Guid id)
        {
            int hour = 0;
            IList<AttributeDomain> list = OrganizationCacheHelper.GetDictionary(SR.Organization_ProductLine).Where<AttributeDomain>(p => p.Id == id.ToString()).ToList<AttributeDomain>();
            if (list != null && list.Count > 0)
            {
                AttributeDomain attr = list[0];
                hour = string.IsNullOrEmpty(attr.AttributeField3) ? 0 : Convert.ToInt32(attr.AttributeField3);
            }
            return hour;
        }

        public static string GetInvoiceComment(PurchaseOrderHeader header, IList<PurchaseOrderDetail> list)
        {
            //CN3 Power Tool 若订单为PT产品线，则为动力工具
            if (OrganizationCacheHelper.GetDictionaryNameById(SR.Organization_ProductLine, header.ProductLineBumId.Value.ToString()).StartsWith("PT"))
            {
                return "CN3";
            }

            CfnDao cfnDao = new CfnDao();
            IList<Cfn> cfnList = new List<Cfn>();
            
            foreach (PurchaseOrderDetail detail in list)
            {
                cfnList.Add(cfnDao.GetCfn(detail.CfnId));
            }
          
            bool hasImplant = cfnList.Where<Cfn>(item => item.Implant.HasValue && item.Implant.Value).Count() > 0;
            bool hasInstrument = cfnList.Where<Cfn>(item => item.Tool.HasValue && item.Tool.Value).Count() > 0;

            //CN4 Implant & Instrument 既包含内植物,又包含工具 
            if (hasImplant && hasInstrument) return "CN4";

            //CN1 Orthopaedics Implant 若订单订购产品为植入物，则为骨科植入物
            if (hasImplant) return "CN1";

            //CN2 Medical Instrument 若订单订购产品为工具，则为骨科器械
            if (hasInstrument) return "CN2";

            return null;
        }

        public static string GetExportFileName(string fileName)
        {
            return Path.Combine(FilePath, fileName + FileExtension);
        }

        public static string FormatString(string str)
        {
            StringBuilder sb = new StringBuilder();
            char[] charArray = str.ToCharArray();
            foreach (char c in charArray)
            {
                System.Diagnostics.Debug.WriteLine("FormatString char = " + c.ToString() + " ASCII = " + ((short)c).ToString());
                switch ((short)c)
                {
                    case 10: sb.Append(" "); break;
                    case 13: sb.Append(" "); break;
                    case 124: sb.Append("/"); break;
                    default: sb.Append(c); break;
                }
            }
            return sb.ToString();
        }

        //public static string GetExportLineString(InterfaceOrder line)
        //{
        //    StringBuilder sb = new StringBuilder();
        //    sb.Append(line.DealerSapCode);
        //    sb.Append(FileSeparator);
        //    sb.Append(line.OrderNo);
        //    sb.Append(FileSeparator);
        //    sb.Append(line.TerritoryCode);
        //    sb.Append(FileSeparator);
        //    sb.Append(FormatString(line.Remark));
        //    sb.Append(FileSeparator);
        //    sb.Append(line.InvoiceComment);
        //    sb.Append(FileSeparator);
        //    sb.Append(line.Rdd.Value.ToString("yyyy-M-d"));
        //    sb.Append(FileSeparator);
        //    sb.Append(line.ArticleNumber);
        //    sb.Append(FileSeparator);
        //    sb.Append(Convert.ToInt32(line.OrderNum));
        //    return sb.ToString();
        //}

        public static MailMessageQueue GetMailMessageQueue(MailMessageTemplate template, PurchaseOrderHeader header, string to)
        {
            string subject = template.Subject;
            string body = template.Body;
            //替换内容
            subject = subject.Replace("{#OrderNo}", header.OrderNo);
            body = body.Replace("{#OrderNo}", header.OrderNo);
            body = body.Replace("{#OrderDate}", header.SubmitDate.Value.GetDateTimeFormats('D')[3].ToString());
            body = body.Replace("{#Url}", ServerUrl);

            MailMessageQueue queue = new MailMessageQueue();
            queue.Id = Guid.NewGuid();
            queue.QueueNo = "email";
            queue.From = EmailFrom;
            queue.To = to;
            queue.Subject = subject;
            queue.Body = body;
            queue.Status = MailMessageQueueStatus.Waiting.ToString();
            queue.CreateDate = DateTime.Now;
            queue.SendDate = null;

            return queue;
        }

        public static ShortMessageQueue GetShortMessageQueue(ShortMessageTemplate template, PurchaseOrderHeader header, string to)
        {
            string message = template.Template;
            //替换内容
            message = message.Replace("{#OrderNo}", header.OrderNo);
            message = message.Replace("{#OrderDate}", header.SubmitDate.Value.GetDateTimeFormats('D')[3].ToString());

            ShortMessageQueue queue = new ShortMessageQueue();
            queue.Id = Guid.NewGuid();
            queue.QueueNo = "sms";
            queue.To = to;
            queue.Message = message;
            queue.Status = ShortMessageQueueStatus.Waiting.ToString();
            queue.CreateDate = DateTime.Now;
            queue.SendDate = null;

            return queue;
        }
    }
}
