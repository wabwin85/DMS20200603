using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using DMS.Website.Common;
using DMS.Business;
using DMS.Model;
using DMS.Common;
using System.Collections;
using System.Data;
using DMS.Business.Cache;
using DMS.Model.Data;
using Lafite.RoleModel.Security;
using System.Xml;
using System.Xml.Xsl;
using Microsoft.Reporting.WebForms;
namespace DMS.Website.Pages.Report
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.None)]
    public partial class OrderSalesSummaryInMonthReport : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                this.initReportView();
                this.initSearchCondition();
            }
        }

        protected void initReportView()
        {
            ServerReport serverReport = this.ReportViewer1.ServerReport;

            serverReport.ReportServerUrl = new Uri(CommonVariable.ReportServerURL);
            serverReport.ReportPath = CommonVariable.ReportPath_OrderSalesSummaryInMonthReport;
            serverReport.ReportServerCredentials = new DmsReportCredentials();
            base.initReportView(this.ReportViewer1);

        }

        protected void initSearchCondition()
        {
            
            this.cbCOP.SelectedItem.Value = DateTime.Now.Year.ToString();
        }

        protected void btnSearch_Click(object sender, AjaxEventArgs e)
        {

            bool Success = true;
            string ErrorMessage = string.Empty;

            string ProductLine = null;            
            string Year = string.Empty;
            string LpId = null;

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Text))
            {
                ProductLine = this.cbProductLine.SelectedItem.Value;
            }
            Year = this.cbCOP.SelectedItem.Value;


            ServerReport serverReport = this.ReportViewer1.ServerReport;

            //传递参数

            ReportParameter[] parametrts = new ReportParameter[4];
            parametrts[0] = new ReportParameter("ProductLine", ProductLine, false);
            parametrts[1] = new ReportParameter("Year", Year, false);
            parametrts[2] = new ReportParameter("DealerId", RoleModelContext.Current.User.CorpId.Value.ToString(), false);            
            parametrts[3] = new ReportParameter("LpId", LpId, false);

            serverReport.SetParameters(parametrts);
            serverReport.Refresh();
        }
    }
}
