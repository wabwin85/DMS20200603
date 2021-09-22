using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using DMS.Model;
using Coolite.Ext.Web;
using Lafite.RoleModel.Security;
using DMS.Business;
using System.Collections;
using System.Data;
using DMS.Common;
using DMS.Model.Data;

namespace DMS.Website.Pages.WeChat
{
    public partial class ProductCodeReportList : BasePage
    {
        #region 公用

        private IRoleModelContext _context = RoleModelContext.Current;

        private ProductCodeReportBLL productCodeReportBLL = new ProductCodeReportBLL();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
            }
        }

        #region 举报查询

        protected void StoReportList_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.QryReportContact.Text))
            {
                param.Add("ReportContact", this.QryReportContact.Text);
            }
            if (!string.IsNullOrEmpty(this.QryReportContent.Text))
            {
                param.Add("ReportContent", this.QryReportContent.Text);
            }

            DataSet query = productCodeReportBLL.GetProductCodeReportList(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagReportList.PageSize : e.Limit), out totalCount);
            (this.StoReportList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.StoReportList.DataSource = query;
            this.StoReportList.DataBind();
        }

        #endregion

        #region 举报明细

        [AjaxMethod]
        public void ShowReportInfo(string reportId)
        {
            this.IptReportContent.Text = "";
            this.IptReportContact.Text = "";
            this.IptReportId.Value = reportId;
            this.IptScanResult.Text = "";
            this.IptProductImage.Text = "";
            this.IptAddressImage.Text = "";

            ProductCodeReport reportInfo = productCodeReportBLL.GetProductCodeReportById(this.IptReportId.Value.ToString());
            if (reportInfo != null)
            {
                this.IptReportContact.Text = reportInfo.ReportContact;
                this.IptReportContent.Text = reportInfo.ReportContent;
                this.IptReportTime.Text = reportInfo.ReportTime;
                if (!String.IsNullOrEmpty(reportInfo.ScanResultUrl))
                {
                    this.IptScanResult.Text = "点击查看";
                    this.IptScanResult.NavigateUrl = reportInfo.ScanResultUrl;
                }
                if (!String.IsNullOrEmpty(reportInfo.ProductImageUrl))
                {
                    this.IptProductImage.Text = "点击查看";
                    this.IptProductImage.NavigateUrl = reportInfo.ProductImageUrl;
                }
                if (!String.IsNullOrEmpty(reportInfo.AddressImageUrl))
                {
                    this.IptAddressImage.Text = "点击查看";
                    this.IptAddressImage.NavigateUrl = reportInfo.AddressImageUrl;
                }
            }
        }

        #endregion
    }
}
