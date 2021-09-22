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
    public partial class ProductOperationLogReport : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (RoleModelContext.Current.User.CorpId.HasValue)
                {
                    this.initReportView();
                }
            }
        }

        protected void initReportView()
        {
            ServerReport serverReport = this.ReportViewer1.ServerReport;

            serverReport.ReportServerUrl = new Uri(CommonVariable.ReportServerURL);
            serverReport.ReportPath = CommonVariable.ReportPath_ProductOperationLogReport;
            serverReport.ReportServerCredentials = new DmsReportCredentials();
            base.initReportView(this.ReportViewer1);

        }

        protected void btnSearch_Click(object sender, AjaxEventArgs e)
        {
            bool Success = true;
            string ErrorMessage = string.Empty;

            string ProductLine = null;

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                ProductLine = this.cbProductLine.SelectedItem.Value;
            }
            ServerReport serverReport = this.ReportViewer1.ServerReport;

            //传递参数

            ReportParameter[] parametrts = new ReportParameter[4];
            parametrts[0] = new ReportParameter("DealerId", RoleModelContext.Current.User.CorpId.Value.ToString(), false);
            parametrts[1] = new ReportParameter("ProductLine", ProductLine, false);
            parametrts[2] = new ReportParameter("CfnNumber", this.txtCfnCode.Text, false);
            parametrts[3] = new ReportParameter("LotNumber", this.txtLotNumber.Text, false);

            serverReport.SetParameters(parametrts);
            serverReport.Refresh();


        }



    }
}
