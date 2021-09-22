using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using DMS.DataService.Core;
using DMS.DataService.Handler;
using DMS.Business.MasterData;
using DMS.Model;
using System.Web.Services.Protocols;

namespace DMS.DataService
{
    /// <summary>
    /// Hospital 的摘要说明
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // 若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消对下行的注释。
    // [System.Web.Script.Services.ScriptService]
    public class Hospital : System.Web.Services.WebService
    {
        public AuthHeader authHeader;

        private void Authenticate()
        {
            //测试账户
            authHeader = new AuthHeader();
            authHeader.User = "LP3";
            authHeader.Password = "Sh123456";
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
        /// 获取经销商库存信息
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadDealerInventoryWithQR(string qrcode, string dealercode)
        {
            Authenticate();
            IDownloadData downloader = new DealerInventoryDownloader(qrcode, dealercode, authHeader.User);
            return downloader.Execute();
        }

        /// <summary>
        /// 获取渠道物流信息
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadChannelLogisticInfoWithQR(string qrcode)
        {
            Authenticate();
            IDownloadData downloader = new ChannelLogisticInfoWithQRDownloader(qrcode, authHeader.User);
            return downloader.Execute();
        }

        /// <summary>
        /// 上传301医院交易记录 
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadHospitalTransactionWithQR(string xml)
        {
            Authenticate();

            IUploadData uploader = new HospitalTransactionWithQRUploader(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 获取经销商库存信息-For红会医院
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadDealerInventoryWithQRForRedCross(string qrcode, string upn, string merchandisename, string supplyid, string supplyname)
        {
            Authenticate();
            IDownloadData downloader = new DealerInventoryWithQRForRedCrossDownloader(qrcode, upn, merchandisename, supplyid, supplyname, authHeader.User);
            return downloader.Execute();
        }

        /// <summary>
        /// 上传红会医院交易记录 
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadRedCrossHospitalTransactionWithQR(string xml)
        {
            Authenticate();

            IUploadData uploader = new RedCrossHospitalTransactionWithQRUploader(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 获取301医院渠道物流信息
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadRedCrossHospitalChannelLogisticInfoWithQR(string qrcode)
        {
            Authenticate();
            IDownloadData downloader = new ChannelLogisticInfoWithQR301Downloader(qrcode, authHeader.User);
            return downloader.Execute();
        }

    }
}
