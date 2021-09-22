﻿using System;
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
    public partial class DealerPriceForSynthesReport : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                this.initReportView();

                if (IsDealer)
                {
                    this.cbDealer.Disabled = true;
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();

                }
                else
                {

                }
            }

        }

        protected void initReportView()
        {
            ServerReport serverReport = this.ReportViewer1.ServerReport;

            serverReport.ReportServerUrl = new Uri(CommonVariable.ReportServerURL);
            serverReport.ReportPath = CommonVariable.ReportPath_DealerPriceForSynthesReport;
            serverReport.ReportServerCredentials = new DmsReportCredentials();
            base.initReportView(this.ReportViewer1);


        }


        protected void btnSearch_Click(object sender, AjaxEventArgs e)
        {
            string DealerName = string.Empty;
            string Cfn = string.Empty;

            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Text))
            {
                DealerName = this.cbDealer.SelectedItem.Text;
            }
            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                Cfn = this.txtCFN.Text;
            }
            ServerReport serverReport = this.ReportViewer1.ServerReport;

            //传递参数

            ReportParameter[] parametrts = new ReportParameter[3];
            parametrts[0] = new ReportParameter("UserId", RoleModelContext.Current.User.Id, false);
            parametrts[1] = new ReportParameter("DealerName", DealerName, false);
            parametrts[2] = new ReportParameter("Cfn", Cfn, false);

            serverReport.SetParameters(parametrts);
            serverReport.Refresh();
        }
    }
}
