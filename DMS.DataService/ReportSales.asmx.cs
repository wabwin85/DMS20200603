using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using DMS.Business;
using System.Data;
using System.Collections;
using DMS.Model;

namespace DMS.DataService
{
    /// <summary>
    /// ReportSales 的摘要说明
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // 若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消对下行的注释。
    // [System.Web.Script.Services.ScriptService]
    public class ReportSales : System.Web.Services.WebService
    {
        [WebMethod]
        public DataSet GetCfnLevel1ByProductLine(Guid productLineID)
        {
            IReportSalesBLL bll = new ReportSalesBLL();

            return bll.GetCfnLevel1ByProductLine(productLineID);
        }

        [WebMethod]
        public DataSet GetCfnLevel2ByProductLine(Guid productLineID)
        {
            IReportSalesBLL bll = new ReportSalesBLL();

            return bll.GetCfnLevel2ByProductLine(productLineID);
        }

        [WebMethod]
        public DataSet GetCfnLevel2ByFilter(Guid productLineID, string level1Code)
        {
            IReportSalesBLL bll = new ReportSalesBLL();

            Hashtable table = new Hashtable();
            table.Add("ProductLineBumId", productLineID);
            table.Add("Level1TypeCode", level1Code);

            return bll.GetCfnLevel2ByFilter(table);
        }

        [WebMethod]
        public bool HashBindingWeChat(string weChat)
        {
            IReportSalesBLL bll = new ReportSalesBLL();

            return bll.HashBindingWeChat(weChat);
        }

        [WebMethod]
        public HospitalReportUser GetReportUserInfoByWeChat(string weChat)
        {
            IReportSalesBLL bll = new ReportSalesBLL();

            return bll.GetReportUserInfoByWeChat(weChat);
        }

        [WebMethod]
        public string BindingWeChatByMobile(string mobile, string weChat)
        {
            IReportSalesBLL bll = new ReportSalesBLL();

            return bll.BindingWeChatByMobile(mobile, weChat);
        }

        [WebMethod]
        public int CheckProductInfo(string upn, string lotNumber, string weChatNumber)
        {
            IReportSalesBLL bll = new ReportSalesBLL();

            return bll.CheckCfn(upn, lotNumber, weChatNumber);
        }

        [WebMethod]
        public int CheckCfnWeChatBySpec(string level2Code, string spec, string expiredDate, string weChatNumber, string reportType)
        {
            IReportSalesBLL bll = new ReportSalesBLL();

            return bll.CheckCfnWeChatBySpec(level2Code, spec, expiredDate, weChatNumber, reportType);
        }

        [WebMethod]
        public DataSet GetCountByFilter(string weChatNumber)
        {
            IReportSalesBLL bll = new ReportSalesBLL();

            return bll.GetCountByFilter(weChatNumber);
        }
    }
}
