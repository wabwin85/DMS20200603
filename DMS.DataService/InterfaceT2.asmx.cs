using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using DMS.DataService.Core;
using DMS.Business.MasterData;
using DMS.Model;
using System.Web.Services.Protocols;
using DMS.DataService.Handler;
using System.Data;

namespace DMS.DataService
{
    /// <summary>
    /// InterfaceT2 的摘要说明
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // 若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消注释以下行。 
    // [System.Web.Script.Services.ScriptService]
    public class InterfaceT2 : System.Web.Services.WebService
    {
        public AuthHeader authHeader;

        private void Authenticate()
        {
            //测试账户
            //authHeader = new AuthHeader();
            //authHeader.User = "LP3";
            //authHeader.Password = "Sh123456";
            //end
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

        /// <summary>
        /// 获取平台发货单
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadLPDeliveryForT2()
        {
            Authenticate();

            IDownloadData downloader = new LPDeliveryForT2Downloader(authHeader.User);
            return downloader.Execute();
        }

        /// <summary>
        /// 收货确认接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadDeliveryConfirm(string xml)
        {
            Authenticate();

            IUploadData uploadloader = new T2DeliveryConfirmUploader(authHeader.User);
            return uploadloader.Execute(xml);
        }

        /// <summary>
        /// 收货确认接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadHospitalSalesForT2(string xml)
        {
            Authenticate();

            IUploadData uploadloader = new HospitalSalesForT2Uploader(authHeader.User);
            return uploadloader.Execute(xml);
        }

        /// <summary>
        /// 收货确认接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadInventoryTransferForT2(string xml)
        {
            Authenticate();

            IUploadData uploadloader = new InventoryTransferForT2Uploader(authHeader.User);
            return uploadloader.Execute(xml);
        }
    }
}
