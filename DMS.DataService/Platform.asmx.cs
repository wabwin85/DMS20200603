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
    public class Platform : System.Web.Services.WebService
    {
        public AuthHeader authHeader;

        private void Authenticate()
        {
            //测试账户
            //authHeader = new AuthHeader();
            //authHeader.User = "LP1";
            //authHeader.Password = "Td6dnGFT";
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
        /// 获取平台订单
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadLpOrder()
        {
            Authenticate();

            IDownloadData downloader = new LpOrderDownloader(authHeader.User);
            return downloader.Execute();
        }

        /// <summary>
        /// 获取二级经销商订单
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadDealerOrder()
        {
            Authenticate();

            IDownloadData downloader = new T2OrderDownloader(authHeader.User);
            return downloader.Execute();
        }

        /// <summary>
        /// 获取波科发货数据
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadLpShipment()
        {
            Authenticate();

            IDownloadData downloader = new SapDeliveryDownloader(authHeader.User);
            return downloader.Execute();
        }

        /// <summary>
        /// 平台销售数据（经销商）接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadDealerShipment(string xml)
        {
            Authenticate();

            IUploadData uploader = new LpDeliveryUploader(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 上传平台确认收货数据
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadLpShipmentConfirm(string xml)
        {
            Authenticate();

            IUploadData uploader = new SapDeliveryConfirmationUploader(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 平台销售数据（医院）接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadLpSales(string xml)
        {
            Authenticate();

            IUploadData uploader = new LpSalesUploader(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 平台退货确认数据接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadLpReturnConfirm(string xml)
        {
            Authenticate();

            IUploadData uploader = new LpReturnConfirmationUploader(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 平台借货数据接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadLpBorrow(string xml)
        {
            Authenticate();

            IUploadData uploader = new LpBorrowUploader(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 平台其他出入库数据接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadLpAdjust(string xml)
        {
            Authenticate();

            IUploadData uploader = new LpAdjustUploader(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 平台寄售数据（经销商）接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadDealerConsignment(string xml)
        {
            Authenticate();

            IUploadData uploader = new LpConsignmentUploader(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 二级经销商订单确认数据接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadDealerOrderConfirmation(string xml)
        {
            Authenticate();

            IUploadData uploader = new T2OrderConfirmationUploader(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 获取经销商寄售产品
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadDealerSales()
        {
            Authenticate();

            IDownloadData downloader = new T2ConsignmentSalesDownloader(authHeader.User);
            return downloader.Execute();
        }

        /// <summary>
        /// 获取医院信息
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadLpHospital()
        {
            Authenticate();

            IDownloadData downloader = new HospitalInfoDownloader(authHeader.User);
            return downloader.Execute();
        }

        /// <summary>
        /// 获取经销商信息
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadLpDistributor()
        {
            Authenticate();

            IDownloadData downloader = new DealerInfoDownloader(authHeader.User);
            return downloader.Execute();
        }

        ///<summary>
        /// LP退货数据下载
        ///</summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadLpReturn()
        {
            Authenticate();

            IDownloadData downloader = new LpReturnDownloader(authHeader.User);
            return downloader.Execute();
        }

        ///<summary>
        /// 二级经销商退货数据下载
        ///</summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadDealerReturn()
        {
            Authenticate();

            IDownloadData downloader = new T2ReturnDownloader(authHeader.User);
            return downloader.Execute();
        }

        /// <summary>
        /// 上传二级经销商平台寄售库仓库信息
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadConsignmentWarehouse(string xml)
        {
            Authenticate();

            IUploadData uploader = new ConsignmentWarehouseUploader(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 波科发票信息接口下载
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadBSCInvoiceData()
        {
            Authenticate();

            IDownloadData downloader = new BSCInvoiceDownloader(authHeader.User);
            return downloader.Execute();
        }

        /// <summary>
        /// 产品信息接口下载
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadProductData()
        {
            Authenticate();

            IDownloadData downloader = new ProductDownloader(authHeader.User);
            return downloader.Execute();
        }

        /// <summary>
        /// 二级经销商寄售销售冲红接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadDealerSalesWritebackData(string xml)
        {
            Authenticate();

            IUploadData uploader = new DealerSalesWritebackUploader(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 二级经销商退货平台确认接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadDealerReturnConfirmData(string xml)
        {
            Authenticate();

            IUploadData uploader = new DealerReturnConfirmUploader(authHeader.User);
            return uploader.Execute(xml);
        }


        /// <summary>
        /// 二级经销商寄售销售出库单销售价格接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadDealerConsignmentSalesPrice(string xml)
        {
            Authenticate();

            IUploadData uploader = new DealerConsignmentSalesPriceUploader(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 上传文件接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadDMSFiles(string FileType, string uid, string pwd, byte[] fileBt, string XML)
        {
            authHeader = new AuthHeader();
            authHeader.User = uid;
            authHeader.Password = pwd;
            Authenticate();

            string[] data = XML.Split('|');

            string result = "";
            IUploadData uploader = new DMSFilesUploader(fileBt, data[0].ToString(), FileType, data[1].ToString(), data[2].ToString(), data[3].ToString(), data[4].ToString(), Convert.ToDateTime(data[5].ToString()), out result);
            //return uploader.Execute(xml);
            return result;
        }

        /// <summary>
        /// 分批上传文件接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadFiles(string FileType, string uid, string pwd, byte[] fileBt, string XML, int index)
        {
            authHeader = new AuthHeader();
            authHeader.User = uid;
            authHeader.Password = pwd;
            Authenticate();

            string[] data = XML.Split('|');

            string result = "";
            IUploadData uploader = new FileUploader(fileBt, data[0].ToString(), FileType, data[1].ToString(), data[2].ToString(), data[3].ToString(), data[4].ToString(), Convert.ToDateTime(data[5].ToString()), index, out result);
            //return uploader.Execute(xml);
            return result;
        }
        /// <summary>
        ///  平台ERP投诉数据接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownLoadLPComplain()
        {
            Authenticate();

            IDownloadData downloader = new LpComplainDownloader(authHeader.User);
            return downloader.Execute();
        }

        /// <summary>
        ///  二级经销商寄售转销售数据接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadT2DealerConsignmentToSelling()
        {
            Authenticate();

            IDownloadData downloader = new T2ConsignToSellingDownloader(authHeader.User);
            return downloader.Execute();
        }


        /// <summary>
        /// 波科发货数据接口（畅联WMS发货数据接口-带二维码）
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadBSCDelivery(string xml)
        {
            Authenticate();

            IUploadData uploader = new BSCDeliveryUploader(authHeader.User);
            return uploader.Execute(xml);
        }


        /// <summary>
        /// 二维码主数据接口（JY二维码平台上传二维码主信息）
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadJYQRCode(string xml)
        {
            Authenticate();

            IUploadData uploader = new QRCodeMasterUploader(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        /// 二维码操作记录上传接口（JY二维码APP上传二维码操作相关信息）
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadDealerTransaction(string xml)
        {
            Authenticate();

            IUploadData uploader = new DealerTransactionUploader(authHeader.User);
            return uploader.Execute(xml);
        }

        /// <summary>
        ///  平台下载借货入库数据
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string DownloadLPRent()
        {
            Authenticate();

            IDownloadData downloader = new LpRentDownloader(authHeader.User);
            return downloader.Execute();
        }
        /// <summary>
        /// 经销商积分调整（购买积分）信息上传接口
        /// </summary>
        /// <param name="Xml"></param>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public String UploadT2PointsAdjustment(String Xml)
        {
             Authenticate();

            IUploadData uploader = new T2PointsAdjustmentUpload(authHeader.User);
            //IUploadData uploader = new T2PointsAdjustmentUpload("LP1");
            return uploader.Execute(Xml);
        }
        /// <summary>
        /// 经销商红票额度信息上传接口
        /// </summary>
        /// <param name="Xml"></param>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public String UploadT2CreditMemo(String Xml)
        {
            Authenticate();
            IUploadData uploader = new T2CreditMemoUpload(authHeader.User);
            //UploadData uploader = new T2CreditMemoUpload("LP1");
            return uploader.Execute(Xml);
        }
        /// <summary>
        /// DMS计算生成积分信息下载数据接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public String DownloadDMSCalculatedPoints()
        {
            Authenticate();
            IDownloadData downloader = new DMSCalculatedPointsDownloader(authHeader.User);
           // IDownloadData downloader = new DMSCalculatedPointsDownloader("LP1");
            return downloader.Execute();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public String DownloadT2Authorization(string code)
        {
            Authenticate();
            IDownloadData downloader = new T2AuthorizationDownloader(code,authHeader.User);
            return downloader.Execute();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public String DownloadT2CommercialIndex(string code)
        {
            Authenticate();
            IDownloadData downloader = new T2CommercialIndexDownloader(code, authHeader.User);
            return downloader.Execute();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="Xml"></param>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public String UploadT2ContactInfo(String Xml)
        {
            Authenticate();
            IUploadData uploader = new T2ContactInfoUploader(authHeader.User);
            return uploader.Execute(Xml);
        }


        /// <summary>
        /// LS移库数据接口
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        [SoapHeader("authHeader")]
        public string UploadLpTransfer(string xml)
        {
            Authenticate();

            IUploadData uploader = new LpTransferUploader(authHeader.User);
            return uploader.Execute(xml);
        }

    }
}
