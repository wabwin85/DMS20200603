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
    public partial class DealerOperationDaysReport : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                this.initReportView();

                this.initSearchCondition();

                this.QueryData();
                
            }

        }

        protected void initReportView()
        {
            ServerReport serverReport = this.ReportViewer1.ServerReport;

            serverReport.ReportServerUrl = new Uri(CommonVariable.ReportServerURL);
            serverReport.ReportPath = CommonVariable.ReportPath_DealerOperationDays;
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
            this.QueryData();
        }
        private int getWorkDays()
        {
            string StartDate = string.Empty;
            string EndDate = string.Empty;

            StartDate = this.txtStartDate.SelectedDate.ToString(CommonVariable.DateFormat);
            EndDate = this.txtEndDate.SelectedDate.ToString(CommonVariable.DateFormat);

            TimeSpan ts = DateTime.Parse(EndDate) - DateTime.Parse(StartDate);
            int days = ts.Days;
            int workdays = 0;//工作日
            //循环用来扣除总天数中的双休日
            for (int i = 0; i < days; i++)
            {
                DateTime tempdt = DateTime.Parse(StartDate).Date.AddDays(i);
                if (tempdt.DayOfWeek != System.DayOfWeek.Saturday && tempdt.DayOfWeek != System.DayOfWeek.Sunday)
                {
                    workdays++;
                }
            }
            return workdays;
        }

        private void QueryData()
        {
            ServerReport serverReport = this.ReportViewer1.ServerReport;
            ReportParameter[] parametrts = new ReportParameter[4];
            parametrts[0] = new ReportParameter("StartDate", this.txtStartDate.SelectedDate.ToString(CommonVariable.DateFormat), false);
            parametrts[1] = new ReportParameter("EndDate", this.txtEndDate.SelectedDate.ToString(CommonVariable.DateFormat), false);
            parametrts[2] = new ReportParameter("WorkDays", this.getWorkDays().ToString(), false);
            parametrts[3] = new ReportParameter("UserId", RoleModelContext.Current.User.Id, false);
            serverReport.SetParameters(parametrts);
            serverReport.Refresh();
        }
       
    }
}
