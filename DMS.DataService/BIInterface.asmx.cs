using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using DMS.DataService.Core;
using DMS.DataService.Handler;
using DMS.DataService.Util;
using DMS.Business.MasterData;
using DMS.Model;
using System.Data;
using DMS.Business;

namespace DMS.DataService
{
    /// <summary>
    /// Service 的摘要说明
    /// SAP使用 EAI接口
    /// </summary>
    [WebService(Namespace = "https://testdms.bscwin.com/services")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // 若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消对下行的注释。
    // [System.Web.Script.Services.ScriptService]
    public class BIInterface : System.Web.Services.WebService
    {
        public AuthHeader authHeader;
        private const string SAP_CLIENT_ID = "EAI";

        private void Authenticate()
        {
            IClientBLL business = new ClientBLL();
            Client client = business.GetClientById(authHeader.User);
            if (client == null)
                throw new SoapException("ClientID不存在", SoapException.ClientFaultCode);

            if (!client.ActiveFlag)
                throw new SoapException("ClientID已失效", SoapException.ClientFaultCode);

            if (client.DeletedFlag)
                throw new SoapException("ClientID已失效", SoapException.ClientFaultCode);

            if (!client.Password.Equals(authHeader.Password))
                throw new SoapException("密码错误", SoapException.ClientFaultCode);
        }

        private void AuthenticateNew()
        {
            IClientBLL business = new ClientBLL();
            if (authHeader == null)
                throw new Exception("非法调用");
            Client client = business.GetClientById(authHeader.User);
            if (client == null)
                //ret = "ClientID不存在";
                throw new Exception("ClientID不存在");

            if (!client.ActiveFlag)
                //ret = "ClientID已失效";
                throw new Exception("ClientID已失效");

            if (client.DeletedFlag)
                //ret = "ClientID已删除";
                throw new Exception("ClientID已失效");

            if (!client.Password.Equals(authHeader.Password))
                //ret = "密码错误";
                throw new Exception("密码错误");
            //return ret;
        }
        /// <summary>
        /// SAP读取订单数据
        /// </summary>
        /// <param name="MsgType"></param>
        /// <param name="Password"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public string ReadData(int MsgType, string Password)
        {
            authHeader = new AuthHeader();
            authHeader.User = SAP_CLIENT_ID;
            authHeader.Password = Password;

            Authenticate();

            IDownloadData downloader = new SapOrderDownloader(authHeader.User);
            return downloader.Execute();
        }

        /// <summary>
        /// SAP写入发货数据
        /// </summary>
        /// <param name="MsgType"></param>
        /// <param name="Password"></param>
        /// <param name="Value"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public int WriteData(int MsgType, string Password, string Value)
        {
            authHeader = new AuthHeader();
            authHeader.User = SAP_CLIENT_ID;
            authHeader.Password = Password;

            Authenticate();

            try
            {
                IUploadData uploader = new SapDeliveryUploader(authHeader.User);
                uploader.Execute(Value);
                return 0;
            }
            catch
            {
                return -1;
            }
        }
        /// <summary>
        /// 金蝶ERP写入发货信息
        /// </summary>
        /// <param name="Xml"></param>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadDealerShipment(String Xml)
        {
            try
            {
                AuthenticateNew();
                IUploadData uploader = new SapDeliveryUploaderNew(authHeader.User);  //authHeader.User             
                string ret = uploader.Execute(Xml);
                return ret;
            }
            catch(Exception ex)
            {
                return string.Format("<result><rtnVal>0</rtnVal><rtnMsg>{0}</rtnMsg></result>",ex.Message);
            }
        }
        /// <summary>
        /// 金蝶ERP更新订单状态
        /// </summary>
        /// <param name="Xml"></param>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadOrderStatus(String Xml)
        {
            try
            {
                AuthenticateNew();
                IUploadData uploader = new OrderStatusUploader(authHeader.User);  //authHeader.User             
                string ret = uploader.Execute(Xml);
                return ret;
            }
            catch (Exception ex)
            {
                return string.Format("<result><rtnVal>0</rtnVal><rtnMsg>{0}</rtnMsg></result>", ex.Message);
            }
        }
        /// <summary>
        /// 金蝶ERP退货确认接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadReturnConfirm(string xml)
        {
            try
            {
                Authenticate();

                IUploadData uploader = new BSCDeliveryUploader(authHeader.User);
                return uploader.Execute(xml);
            }
            catch (Exception ex)
            {
                return string.Format("<result><rtnVal>0</rtnVal><rtnMsg>{0}</rtnMsg></result>", ex.Message);
            }
        }
    }
}
