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
    /// Platform 的摘要说明
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // 若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消对下行的注释。
    // [System.Web.Script.Services.ScriptService]
    public class SampleManageService : System.Web.Services.WebService
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
        /// 创建样品申请单接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string CreateSampleApply(string xml)
        {
            try { 
                Authenticate();

                IUploadData uploader = new CreateSampleApplyHandler(authHeader.User);
                //IUploadData uploader = new CreateSampleApplyHandler("");
                return uploader.Execute(xml);
            }
            catch(Exception ex)
            {
                return ex.ToString();
            }
        }

        /// <summary>
        /// 创建样品退货单接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string CreateSampleReturn(string xml)
        {
            Authenticate();

            IUploadData uploader = new CreateSampleReturnHandler(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 样品收货接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string ReceiveSample(string xml)
        {
            Authenticate();

            IUploadData uploader = new ReceiveSampleHandler(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 上传评估单接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string CreateSampleEval(string xml)
        {
            Authenticate();

            IUploadData uploader = new CreateSampleEvalHandler(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 申请关闭订单接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string SampleCloseApply(string xml)
        {
            Authenticate();

            string result = "";
            IUploadData uploader = new SampleCloseApplyHandler(xml, out result);
            return result;
            
        }

    }
}
