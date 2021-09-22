using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.Model;
using DMS.Business;
using System.Data;

namespace DMS.Website.Service
{
    public class ShortMessageService : IHttpHandler
    {
        #region Service

        private IMessageBLL _messageBLL = new MessageBLL();

        #endregion

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ClearContent();
            context.Response.ContentType = "text/plain";
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

            string token = context.Request.Params["token"];

            string Massage = "";
          
            //参数判断
            if (string.IsNullOrEmpty(token) || !token.Equals("7A645BA9-B704-4D24-8938-3C9BD185E72E"))
            {
                Massage = "Error";
            }
            else
            {
                try
                {
                    string phone = context.Request.Params["phone"];
                    string content = context.Request.Params["content"];
                    SendMassage(phone, content);
                    Massage = "Success";
                }
                catch
                {
                    Massage = "Error";
                }
            }
            context.Response.Write(Massage);
            context.Response.End();
        }

        private void SendMassage(string massageTo,string content)
        {
            ShortMessageQueue massage = new ShortMessageQueue();
            massage.Id = Guid.NewGuid();
            massage.QueueNo = "sms";
            massage.To = massageTo;
            massage.Message = content;
            massage.Status = "Waiting";
            massage.CreateDate = DateTime.Now;
            _messageBLL.AddToShortMessageQueue(massage);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}
