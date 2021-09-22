using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Report
{
    using DMS.Website.Common;
    using DMS.Model.Data;
    using Lafite.RoleModel.Security;
    using Coolite.Ext.Web;
    using Microsoft.Reporting.WebForms;

    public partial class OrderSalesSummaryInMonthReportForT1LP : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                this.initReportView();
                this.initSearchCondition();
            }

            if (IsDealer)
            {
                if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()))
                {
                    this.Bind_DealerList(this.DealerStore);
                    this.cbDealer.Disabled = true;
                    this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                }
                else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                {
                    this.Bind_DealerListByFilter(this.DealerStore, false);
                }
                else
                {
                    this.Bind_DealerList(this.DealerStore);
                }
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
            string DealerId = string.Empty;

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Text))
            {
                ProductLine = this.cbProductLine.SelectedItem.Value;
            }
            Year = this.cbCOP.SelectedItem.Value;

            DealerId = this.cbDealer.SelectedItem.Value;

            ServerReport serverReport = this.ReportViewer1.ServerReport;

            //传递参数

            ReportParameter[] parametrts = new ReportParameter[4];
            parametrts[0] = new ReportParameter("ProductLine", ProductLine, false);
            parametrts[1] = new ReportParameter("Year", Year, false);
            if (DealerId.Equals(string.Empty))
            {
                string dealerId = null;
                parametrts[2] = new ReportParameter("DealerId", dealerId, false);
            }
            else
            {
                parametrts[2] = new ReportParameter("DealerId", DealerId, false);
            }
            parametrts[3] = new ReportParameter("LpId", RoleModelContext.Current.User.CorpId.Value.ToString(), false);

            serverReport.SetParameters(parametrts);
            serverReport.Refresh();
        }
    }
}
