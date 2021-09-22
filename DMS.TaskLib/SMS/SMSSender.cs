using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Configuration;
using Common.Logging;
using DMS.Model;
using DMS.Business;

namespace DMS.TaskLib.SMS
{
    public class SMSSender
    {
        //private static ILog _log = LogManager.GetLogger(typeof(SMSSender));
        private DMS.TaskLib.SMSService.Sender client = null;

        public SMSSender()
        {
            client = new DMS.TaskLib.SMSService.Sender();
        }

        public void Dispose()
        {
            try
            {
                client.Dispose();
            }
            catch
            {
                client.Abort();
            }
        }

        public void Send(ShortMessageQueue sms)
        {
            bool success = false;
            try
            {
                int rtn = client.Send(12960, sms.To, sms.Message);
                success = true;
            }
            catch (Exception e)
            {

            }
            finally
            {
                try
                {
                    MessageBLL business = new MessageBLL();
                    business.UpdateShortMessageQueue(sms, success);
                }
                catch
                {
                }
            }
        }
    }
}
