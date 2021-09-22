using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business.Cache;
using Lafite.RoleModel.Security;
using DMS.Business.DPInfo;
using System.Data;
using DMS.Model;
using System.Collections;
using Fulper.ExpressionParser;
using System.Globalization;

namespace DMS.Website.Pages.DPInfo
{
    public partial class DPStatementInfo : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;

        public bool IsPageNew
        {
            get
            {
                return (this.hidIsPageNew.Text == "True" ? true : false);
            }
            set
            {
                this.hidIsPageNew.Text = value.ToString();
            }
        }

        public Guid InstanceId
        {
            get
            {
                return new Guid(this.hidInstanceId.Text);
            }
            set
            {
                this.hidInstanceId.Text = value.ToString();
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.btnSave.Visible = false;
                this.btnSubmit.Visible = false;

                if (Request.QueryString["id"] == null || string.IsNullOrEmpty(Request.QueryString["id"].ToString()))
                    throw new Exception("传递参数错误");
                this.IsPageNew = Request.QueryString["id"].ToString() == Guid.Empty.ToString();
                this.InstanceId = (Request.QueryString["id"].ToString() == Guid.Empty.ToString() ? Guid.NewGuid() : (new Guid(Request.QueryString["id"].ToString())));

                this.Bind_DealerList(this.DealerStore);
                if (IsPageNew)
                {
                    if (IsDealer)
                    {
                        this.tbDealer.SelectedItem.Value = this._context.User.CorpId.Value.ToString();
                        this.tbDealer.Disabled = true;
                    }
                    this.cbCurrency.SelectedItem.Value = "人民币";
                    this.btnSubmit.Visible = true;
                    BindYear();
                }
                else
                {
                    if (!IsDealer)
                    {
                        this.btnSave.Visible = false;
                    }
                    tbDealer.Disabled = true;
                    BindData();
                }
            }
        }

        [AjaxMethod]
        public void Calculation()
        {
            GetFormValues();
        }

        [AjaxMethod]
        public void Submit()
        {
            DpStatementHeader header = new DpStatementHeader();
            header.Id = this.InstanceId;
            header.DmaId = new Guid(this.tbDealer.SelectedItem.Value);
            header.Year = this.cbYear.SelectedItem.Value;
            header.Month = this.cbMonth.SelectedItem.Value;
            header.Status = "已提交";
            header.Currency = this.cbCurrency.SelectedItem.Value;
            header.CreateUser = new Guid(this._context.User.Id);
            header.CreateDate = DateTime.Now;

            DpStatementBLL bll = new DpStatementBLL();
            bll.Submit(header, GetFormValues());
        }

        [AjaxMethod]
        public void Save()
        {
            DpStatementBLL bll = new DpStatementBLL();
            bll.Save(this.InstanceId, GetFormValues());
        }

        [AjaxMethod]
        public void GetDays()
        {
            if (!string.IsNullOrEmpty(this.cbYear.SelectedItem.Value) && !string.IsNullOrEmpty(this.cbMonth.SelectedItem.Value))
            {
                DateTime dt;
                if (!DateTime.TryParseExact(this.cbYear.SelectedItem.Value + "-" + this.cbMonth.SelectedItem.Value + "-01", "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                    throw new Exception("日期格式不正确");

                int days = dt.AddMonths(1).AddDays(-1).DayOfYear;
                this.tbC09.Text = days.ToString();
            }
        }

        private void BindYear()
        {
            //最近5年
            int year = DateTime.Now.Year;
            for (int i = 4; i >= 0; i--)
            {
                string curYear = (year - i).ToString();
                this.cbYear.Items.Add(new Coolite.Ext.Web.ListItem(curYear, curYear));
            }
        }

        protected void MonthStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            string year = string.Empty;
            if (e.Parameters["Year"] != null && !string.IsNullOrEmpty(e.Parameters["Year"].ToString())
                && e.Parameters["DealerId"] != null && !string.IsNullOrEmpty(e.Parameters["DealerId"].ToString()))
            {
                year = e.Parameters["Year"].ToString();
                DpStatementBLL bll = new DpStatementBLL();
                Hashtable ht = new Hashtable();
                ht.Add("DealerId", new Guid(e.Parameters["DealerId"].ToString()));
                ht.Add("Year", year);
                this.MonthStore.DataSource = bll.GetDealerFinanceStatementMonthByYear(ht);
                this.MonthStore.DataBind();
            }
        }

        private void BindData()
        {
            DpStatementBLL bll = new DpStatementBLL();
            DpStatementHeader header = bll.GetDealerFinanceStatementHeaderById(this.InstanceId);
            this.tbDealer.SelectedItem.Value = header.DmaId.ToString();
            this.cbCurrency.SelectedItem.Value = header.Currency;
            this.cbCurrency.Disabled = true;
            this.cbYear.SelectedItem.Value = header.Year;
            this.cbYear.Disabled = true;
            this.cbMonth.SelectedItem.Value = header.Month;
            this.cbMonth.Disabled = true;

            bool isFinanceUser = true;

            //控制是否可以修改
            DataSet ds = bll.SelectDealerFinanceStatementFieldByType("资产负债表&利润表");
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                TextField ctrl = null;
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    ctrl = this.Page.FindControl("tb" + dr["Key"].ToString()) as TextField;
                    if (ctrl != null)
                    {
                        if (dr["Formula"] == DBNull.Value)
                        {
                            ctrl.Disabled = IsDealer || !isFinanceUser;
                        }
                    }
                }
            }

            //C09天数始终不可填写
            this.tbC09.Disabled = true;

            //赋值
            IList<DpStatementDetail> list = bll.SelectDealerFinanceStatementDetailById(this.InstanceId);
            if (list.Count > 0)
            {
                TextField ctrl = null;
                foreach (DpStatementDetail detail in list)
                {
                    ctrl = this.Page.FindControl("tb" + detail.Key) as TextField;
                    if (ctrl != null)
                    {
                        ctrl.Text = detail.Value;
                    }
                }
            }

            //控制是否显示历史
            IList<DpStatementDetail> changeList = bll.SelectChangedDealerFinanceStatementDetailById(this.InstanceId);
            if (list.Count > 0)
            {
                ToolbarButton ctrl = null;
                foreach (DpStatementDetail detail in changeList)
                {
                    ctrl = this.Page.FindControl("btn" + detail.Key) as ToolbarButton;
                    if (ctrl != null)
                    {
                        ctrl.Visible = true;
                    }
                }
            }

            //财务可以修改
            this.btnSave.Visible = !IsDealer && isFinanceUser;
        }

        private Hashtable GetFormValues()
        {
            Hashtable ht = new Hashtable();
            RPNParser parser = new RPNParser();
            DpStatementBLL bll = new DpStatementBLL();

            DataSet ds = bll.SelectDealerFinanceStatementFieldByType("资产负债表&利润表");
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                TextField ctrl = null;
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    ctrl = this.Page.FindControl("tb" + dr["Key"].ToString()) as TextField;
                    if (ctrl != null)
                    {
                        if (dr["Formula"] == DBNull.Value)
                        {
                            ctrl.Text = ctrl.Text.Replace(",", "");
                            ht.Add(dr["Key"].ToString(), string.IsNullOrEmpty(ctrl.Text) ? "0" : ctrl.Text);
                        }
                        else
                        {
                            //计算
                            object val = parser.EvaluateExpression(dr["Formula"].ToString(), ht);
                            ht.Add(dr["Key"].ToString(), val.ToString());
                            ctrl.Text = val.ToString();
                        }
                    }
                    else
                    {
                        if (dr["Formula"] == DBNull.Value)
                        {
                            ht.Add(dr["Key"].ToString(), "0");
                        }
                        else
                        {
                            //计算
                            object val = parser.EvaluateExpression(dr["Formula"].ToString(), ht);
                            ht.Add(dr["Key"].ToString(), val.ToString());
                        }
                    }
                }
            }

            return ht;
        }

        protected void HistoryStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {

            if (e.Parameters["Key"] != null && !string.IsNullOrEmpty(e.Parameters["Key"].ToString()))
            {
                DpStatementBLL bll = new DpStatementBLL();

                int totalCount = 0;

                Hashtable param = new Hashtable();

                param.Add("HeaderId", this.InstanceId);
                param.Add("Key", e.Parameters["Key"].ToString());

                DataSet ds = bll.SelectDealerFinanceStatementDetailChangeLogByKey(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarHistory.PageSize : e.Limit), out totalCount);

                e.TotalCount = totalCount;

                this.HistoryStore.DataSource = ds;
                this.HistoryStore.DataBind();
            }
        }

        [AjaxMethod]
        public void ShowHistory(string key)
        {
            this.hidShowHistoryKey.Text = key;
            this.HistoryWindow.Show();
        }

    }
}
