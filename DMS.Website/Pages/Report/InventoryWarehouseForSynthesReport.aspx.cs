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
    public partial class InventoryWarehouseForSynthesReport : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                this.initReportView();

            }

        }

        protected void initReportView()
        {
            ServerReport serverReport = this.ReportViewer1.ServerReport;

            serverReport.ReportServerUrl = new Uri(CommonVariable.ReportServerURL);
            serverReport.ReportPath = CommonVariable.ReportPath_InventoryWarehouseForSynthesReport;
            serverReport.ReportServerCredentials = new DmsReportCredentials();
            base.initReportView(this.ReportViewer1);

        }



        protected void btnSearch_Click(object sender, AjaxEventArgs e)
        {
            bool Success = true;
            string ErrorMessage = string.Empty;

            string DealerId = Guid.Empty.ToString();
            string ProductLine = string.Empty;
            string WHMName = string.Empty;

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Text))
            {
                ProductLine = this.cbProductLine.SelectedItem.Text;
            }
            if (!string.IsNullOrEmpty(this.tfWHMName.Text.Trim()))
            {
                WHMName = this.tfWHMName.Text.Trim();
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                DealerId = this.cbDealer.SelectedItem.Value;
            }
            ServerReport serverReport = this.ReportViewer1.ServerReport;

            //传递参数

            ReportParameter[] parametrts = new ReportParameter[4];
            parametrts[0] = new ReportParameter("UserId", RoleModelContext.Current.User.Id, false);
            parametrts[1] = new ReportParameter("ProductLine", ProductLine, false);
            parametrts[2] = new ReportParameter("WHMName", WHMName, false);
            parametrts[3] = new ReportParameter("DealerId", DealerId, false);

            serverReport.SetParameters(parametrts);
            serverReport.Refresh();


        }
    }
}
