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
    public partial class DealerBuyInForSynthesReport : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                this.initReportView();

                this.initSearchCondition();
            }

            this.DealerStore.DataSource = DealerCacheHelper.GetDealers();
            this.DealerStore.DataBind();

        }

        protected void initReportView()
        {
            ServerReport serverReport = this.ReportViewer1.ServerReport;

            serverReport.ReportServerUrl = new Uri(CommonVariable.ReportServerURL);
            serverReport.ReportPath = CommonVariable.ReportPath_DealerBuyInForBscReport;
            serverReport.ReportServerCredentials = new DmsReportCredentials();
            base.initReportView(this.ReportViewer1);

        }

        protected void initSearchCondition()
        {
            this.txtEndDate.Value = DateTime.Now;
            this.txtStartDate.Value = DateTime.Now.AddMonths(-1).AddDays(1);

            this.txtOrderEndDate.Value = DateTime.Now;
            this.txtOrderStartDate.Value = DateTime.Now.AddMonths(-1).AddDays(1);
        }

        protected void btnSearch_Click(object sender, AjaxEventArgs e)
        {
            bool Success = true;
            string ErrorMessage = string.Empty;

            string DealerId = null;
            string ProductLine = string.Empty;
            string StartDate = string.Empty;
            string EndDate = string.Empty;
            string OrderStartDate = string.Empty;
            string OrderEndDate = string.Empty;

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Text))
            {
                ProductLine = this.cbProductLine.SelectedItem.Text;
            }

            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                DealerId = this.cbDealer.SelectedItem.Value;
            }

            StartDate = this.txtStartDate.SelectedDate.ToString(CommonVariable.DateFormat);
            EndDate = this.txtEndDate.SelectedDate.ToString(CommonVariable.DateFormat);

            if (!this.txtOrderStartDate.IsNull)
            {
                OrderStartDate = this.txtOrderStartDate.SelectedDate.ToString(CommonVariable.DateFormat);
            }

            if (!this.txtOrderEndDate.IsNull)
            {
                OrderEndDate = this.txtOrderEndDate.SelectedDate.ToString(CommonVariable.DateFormat);
            }
            
            ServerReport serverReport = this.ReportViewer1.ServerReport;

            //传递参数

            ReportParameter[] parametrts = new ReportParameter[8];
            //parametrts[0] = new ReportParameter("UserId", RoleModelContext.Current.User.Id, false);
            parametrts[0] = new ReportParameter("DealerId", DealerId, false);
            parametrts[1] = new ReportParameter("StartDate", StartDate, false);
            parametrts[2] = new ReportParameter("EndDate", EndDate, false);
            parametrts[3] = new ReportParameter("ProductLine", ProductLine, false);
            parametrts[4] = new ReportParameter("OrderStartDate", OrderStartDate, false);
            parametrts[5] = new ReportParameter("OrderEndDate", OrderEndDate, false);
            parametrts[6] = new ReportParameter("CfnNumber", this.txtCfnCode.Text, false);
            parametrts[7] = new ReportParameter("LotNumber", this.txtLotNumber.Text, false);

            serverReport.SetParameters(parametrts);
            serverReport.Refresh();


        }

    }
}
