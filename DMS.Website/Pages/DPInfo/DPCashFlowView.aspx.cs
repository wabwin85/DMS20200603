using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business.DPInfo;
using DMS.Model;
using System.Collections;

namespace DMS.Website.Pages.DPInfo
{
    public partial class DPCashFlowView : BasePage
    {
        public Guid DealerId
        {
            get
            {
                return new Guid(this.hidDealerId.Text);
            }
            set
            {
                this.hidDealerId.Text = value.ToString();
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (Request.QueryString["dealerid"] == null || string.IsNullOrEmpty(Request.QueryString["dealerid"].ToString()))
                {
                    Response.Write("请先在Statements表中选择会计期间");
                    Response.End();
                }
                this.DealerId = new Guid(Request.QueryString["dealerid"].ToString());

                if (Request["ym1"] != null && !string.IsNullOrEmpty(Request["ym1"].ToString()))
                {
                    this.tbYearMonth1.Text = Request["ym1"].ToString();
                    this.ym1_panel.Hidden = false;
                }

                if (Request["ym2"] != null && !string.IsNullOrEmpty(Request["ym2"].ToString()))
                {
                    this.tbYearMonth2.Text = Request["ym2"].ToString();
                    this.ym2_panel.Hidden = false;
                }

                if (Request["ym3"] != null && !string.IsNullOrEmpty(Request["ym3"].ToString()))
                {
                    this.tbYearMonth3.Text = Request["ym3"].ToString();
                    this.ym3_panel.Hidden = false;
                }

                if (Request["ym4"] != null && !string.IsNullOrEmpty(Request["ym4"].ToString()))
                {
                    this.tbYearMonth4.Text = Request["ym4"].ToString();
                    this.ym4_panel.Hidden = false;
                }

                if (Request["ym5"] != null && !string.IsNullOrEmpty(Request["ym5"].ToString()))
                {
                    this.tbYearMonth5.Text = Request["ym5"].ToString();
                    this.ym5_panel.Hidden = false;
                }

                BindData();
            }
        }

        private void BindData()
        {
            DpStatementBLL bll = new DpStatementBLL();

            if (!this.ym1_panel.Hidden)
            {
                BindDataByYearMonth("ym1", bll.SelectDealerFinanceStatementCashFlowByDealer(this.DealerId, this.tbYearMonth1.Text));
            }

            if (!this.ym2_panel.Hidden)
            {
                BindDataByYearMonth("ym2", bll.SelectDealerFinanceStatementCashFlowByDealer(this.DealerId, this.tbYearMonth2.Text));
            }

            if (!this.ym3_panel.Hidden)
            {
                BindDataByYearMonth("ym3", bll.SelectDealerFinanceStatementCashFlowByDealer(this.DealerId, this.tbYearMonth3.Text));
            }

            if (!this.ym4_panel.Hidden)
            {
                BindDataByYearMonth("ym4", bll.SelectDealerFinanceStatementCashFlowByDealer(this.DealerId, this.tbYearMonth4.Text));
            }

            if (!this.ym5_panel.Hidden)
            {
                BindDataByYearMonth("ym5", bll.SelectDealerFinanceStatementCashFlowByDealer(this.DealerId, this.tbYearMonth5.Text));
            }
        }

        private void BindDataByYearMonth(string prefix, IList<DpStatementCashflow> list)
        {
            if (list.Count > 0)
            {
                TextField ctrl = null;
                foreach (DpStatementCashflow detail in list)
                {
                    ctrl = this.Page.FindControl(prefix + "_" + detail.Key) as TextField;
                    if (ctrl != null)
                    {
                        ctrl.Text = detail.Value;
                    }
                }
            }
        }

        protected void ExportExcel(object sender, EventArgs e)
        {
            DpStatementBLL bll = new DpStatementBLL();
            DPCashflowExport export = new DPCashflowExport();
            Hashtable cashflowValues = new Hashtable();

            if (!this.ym1_panel.Hidden)
            {
                cashflowValues.Add("YearMonth_1", this.tbYearMonth1.Text);
                IList<DpStatementCashflow> list = bll.SelectDealerFinanceStatementCashFlowByDealer(this.DealerId, this.tbYearMonth1.Text);
                foreach (DpStatementCashflow detail in list)
                {
                    cashflowValues.Add(detail.Key + "_1", detail.Value);
                }
            }
            if (!this.ym2_panel.Hidden)
            {
                cashflowValues.Add("YearMonth_2", this.tbYearMonth2.Text);
                IList<DpStatementCashflow> list = bll.SelectDealerFinanceStatementCashFlowByDealer(this.DealerId, this.tbYearMonth2.Text);
                foreach (DpStatementCashflow detail in list)
                {
                    cashflowValues.Add(detail.Key + "_2", detail.Value);
                }
            }
            if (!this.ym3_panel.Hidden)
            {
                cashflowValues.Add("YearMonth_3", this.tbYearMonth3.Text);
                IList<DpStatementCashflow> list = bll.SelectDealerFinanceStatementCashFlowByDealer(this.DealerId, this.tbYearMonth3.Text);
                foreach (DpStatementCashflow detail in list)
                {
                    cashflowValues.Add(detail.Key + "_3", detail.Value);
                }
            }
            if (!this.ym4_panel.Hidden)
            {
                cashflowValues.Add("YearMonth_4", this.tbYearMonth4.Text);
                IList<DpStatementCashflow> list = bll.SelectDealerFinanceStatementCashFlowByDealer(this.DealerId, this.tbYearMonth4.Text);
                foreach (DpStatementCashflow detail in list)
                {
                    cashflowValues.Add(detail.Key + "_4", detail.Value);
                }
            }
            if (!this.ym5_panel.Hidden)
            {
                cashflowValues.Add("YearMonth_5", this.tbYearMonth5.Text);
                IList<DpStatementCashflow> list = bll.SelectDealerFinanceStatementCashFlowByDealer(this.DealerId, this.tbYearMonth5.Text);
                foreach (DpStatementCashflow detail in list)
                {
                    cashflowValues.Add(detail.Key + "_5", detail.Value);
                }
            }

            export.Export(cashflowValues);
        }
    }
}
