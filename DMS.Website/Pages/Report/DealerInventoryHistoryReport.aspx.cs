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
    public partial class DealerInventoryHistoryReport : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.Bind_DealerListByFilter(DealerStore, true);
            if (!Page.IsPostBack)
            {
                this.initReportView();
                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType != DealerType.HQ.ToString() && RoleModelContext.Current.User.CorpType != DealerType.LP.ToString() && RoleModelContext.Current.User.CorpType != DealerType.LS.ToString())
                    {
                        this.cboDealer.Enabled = false;
                    }
                    this.cboDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                }
            }
        }

        protected void initReportView()
        {
            ServerReport serverReport = this.ReportViewer1.ServerReport;

            serverReport.ReportServerUrl = new Uri(CommonVariable.ReportServerURL);
            serverReport.ReportPath = CommonVariable.ReportPath_DealerHistoryInvDetailReport;
            serverReport.ReportServerCredentials = new DmsReportCredentials();
            base.initReportView(this.ReportViewer1);


        }


        protected void btnSearch_Click(object sender, AjaxEventArgs e)
        {
            bool Success = true;
            string ErrorMessage = string.Empty;

            string Dealer = string.Empty;
            string InventDate = string.Empty;

            if (!string.IsNullOrEmpty(this.cboDealer.SelectedItem.Value))
            {
                Dealer = this.cboDealer.SelectedItem.Value;
            }

            if (!string.IsNullOrEmpty(this.dfInventDate.Value.ToString()))
            {
                InventDate = Convert.ToDateTime(this.dfInventDate.Value).ToString("yyyyMMdd");
            }

            ServerReport serverReport = this.ReportViewer1.ServerReport;

            //传递参数

            ReportParameter[] parametrts = new ReportParameter[5];
            parametrts[0] = new ReportParameter("Dealer", Dealer == "" ? null : Dealer, false);
            parametrts[1] = new ReportParameter("InventDate", InventDate == "" ? null : InventDate, false);
            
            //经销商
            if (IsDealer)
            {
                //平台
                if (RoleModelContext.Current.User.CorpType == DealerType.LP.ToString() || RoleModelContext.Current.User.CorpType == DealerType.LS.ToString())
                {
                    parametrts[2] = new ReportParameter("DealerType", "LP", false);
                    parametrts[3] = new ReportParameter("CorpId", RoleModelContext.Current.User.CorpId.Value.ToString(), false);
                }
                else//T1、T2、HQ
                {
                    parametrts[2] = new ReportParameter("DealerType", "DEALER", false);
                    parametrts[3] = new ReportParameter("CorpId", RoleModelContext.Current.User.CorpId.Value.ToString(), false);
                }
            }
            else//BSC User
            {
                parametrts[2] = new ReportParameter("DealerType", "USER", false);
                parametrts[3] = new ReportParameter("CorpId", Guid.Empty.ToString(), false);
            }
            
            parametrts[4] = new ReportParameter("UserId", RoleModelContext.Current.User.Id.ToString(), false);

            serverReport.SetParameters(parametrts);
            serverReport.Refresh();


        }
    }
}
