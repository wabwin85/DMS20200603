using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Report
{
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

    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.None)]
    public partial class LPSalesForBscReport : BasePage
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
            serverReport.ReportPath = CommonVariable.ReportPath_LPSalesForBscReport;
            serverReport.ReportServerCredentials = new DmsReportCredentials();
            base.initReportView(this.ReportViewer1);

        }

        protected void initSearchCondition()
        {
            this.txtEndDate.Value = DateTime.Now;
            this.txtStartDate.Value = DateTime.Now.AddMonths(-1).AddDays(1);
        }

        protected void btnSearch_Click(object sender, AjaxEventArgs e)
        {
            bool Success = true;
            string ErrorMessage = string.Empty;

            string ProductLine = null;
            string StartDate = string.Empty;
            string EndDate = string.Empty;

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                ProductLine = this.cbProductLine.SelectedItem.Value;
            }
            StartDate = this.txtStartDate.SelectedDate.ToString(CommonVariable.DateFormat);
            EndDate = this.txtEndDate.SelectedDate.ToString(CommonVariable.DateFormat);


            ServerReport serverReport = this.ReportViewer1.ServerReport;

            //传递参数

            ReportParameter[] parametrts = new ReportParameter[5];
            parametrts[0] = new ReportParameter("StartDate", StartDate, false);
            parametrts[1] = new ReportParameter("EndDate", EndDate, false);
            parametrts[2] = new ReportParameter("ProductLine", ProductLine, false);
            parametrts[3] = new ReportParameter("CfnNumber", this.txtCfnCode.Text, false);
            parametrts[4] = new ReportParameter("LotNumber", this.txtLotNumber.Text, false);

            serverReport.SetParameters(parametrts);
            serverReport.Refresh();


        }



    }
}
