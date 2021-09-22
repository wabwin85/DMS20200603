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
    public partial class DealerSalesReport : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                this.initReportView();

                this.initSearchCondition();
            }

            this.Bind_Status(ShipmentStatus, SR.Consts_ShipmentOrder_Status);
        }

        private void Bind_Status(Store store, string type)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);

            dicts.Remove("Draft");  //草稿
            dicts.Remove("Submitted");  //冲红待审批
            dicts.Remove("Cancelled");  //冲红审批拒绝

            store.DataSource = dicts;
            store.DataBind();
        }

        protected void initReportView()
        {
            ServerReport serverReport = this.ReportViewer1.ServerReport;

            serverReport.ReportServerUrl = new Uri(CommonVariable.ReportServerURL);
            serverReport.ReportPath = CommonVariable.ReportPath_DealerSales;
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

            string ProductLine = string.Empty;
            string StartDate = string.Empty;
            string EndDate = string.Empty;
            string Status = string.Empty;

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Text))
            {
                ProductLine = this.cbProductLine.SelectedItem.Text;
            }
            StartDate = this.txtStartDate.SelectedDate.ToString(CommonVariable.DateFormat);
            EndDate = this.txtEndDate.SelectedDate.ToString(CommonVariable.DateFormat);

            if (!string.IsNullOrEmpty(this.cbStatus.SelectedItem.Value))
            {
                Status = this.cbStatus.SelectedItem.Value;
            }
            ServerReport serverReport = this.ReportViewer1.ServerReport;

            //传递参数

            ReportParameter[] parametrts = new ReportParameter[7];
            parametrts[0] = new ReportParameter("UserId", RoleModelContext.Current.User.Id, false);
            parametrts[1] = new ReportParameter("StartDate", StartDate, false);
            parametrts[2] = new ReportParameter("EndDate", EndDate, false);
            parametrts[3] = new ReportParameter("ProductLine", ProductLine, false);
            parametrts[4] = new ReportParameter("Status", Status, false);
            parametrts[5] = new ReportParameter("CfnNumber", this.txtCfnCode.Text, false);
            parametrts[6] = new ReportParameter("LotNumber", this.txtLotNumber.Text, false);

            serverReport.SetParameters(parametrts);
            serverReport.Refresh();


        }



    }
}
