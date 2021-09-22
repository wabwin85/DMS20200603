using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Common.Logging;
using Fulper.TaskManager.TaskPlugin;
using Microsoft.Practices.EnterpriseLibrary.Common.Configuration;
using DMS.Business;
using DMS.Model;
using System.Threading;

namespace DMS.TaskLib.SMS
{
    public class SendSMSTask : ITask
    {
        //private static ILog _log = LogManager.GetLogger(typeof(SendSMSTask));
        private IDictionary<string, string> _config = null;

        #region 短信发送属性
        private int Total = 3;
        #endregion

        public SendSMSTask()
        {

        }
        #region ITask 成员

        public void Execute()
        {
            MessageBLL business = new MessageBLL();
            IList<ShortMessageQueue> msgList = null;
            //初始化短信并得到短信发送队列
            try
            {
                //_log.Info("Initializing messages!");
                business.ShortMessageProcessToQueue();
                msgList = business.GetShortMessageQueue();
                //_log.Info("Initialize messages success.");
            }
            catch (Exception ex)
            {
                //_log.Info(string.Format("Initialize messages failed, error Message:{0}", ex.ToString()));
                return;
            }

            //判断是否有待发送的短信
            if (msgList == null || msgList.Count == 0)
            {
                //_log.Info("No message can be sent!");
                return;
            }

            //发送短信
            //短信队列大小
            int size = msgList.Count > Total ? Total : msgList.Count;
            SMSSender sender = new SMSSender();
            try
            {
                for (int i = 0; i < size; i++)
                {
                    sender.Send(msgList[i]);
                }
            }
            catch (Exception ex)
            {
                //_log.Error(string.Format("Send message failure ,error Message:{0}", ex.ToString()), ex);
            }
            finally
            {
                sender.Dispose();
            }
        }


        #endregion

        #region ITask 成员

        public Dictionary<string, string> Config
        {
            set 
            { 
                this._config = value;
                if (this._config.ContainsKey("total"))
                {
                    this.Total = Convert.ToInt32(this._config["total"]);
                }
                //_log.Info("SendSMSTask Config : Total = " + this.Total);
            }
        }

        #endregion
    }
}
