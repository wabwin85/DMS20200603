using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using DMS.Model;
using Coolite.Ext.Web;
using Lafite.RoleModel.Security;
using DMS.Business;
using System.Collections;
using System.Data;
using DMS.Common;
using DMS.Model.Data;

namespace DMS.Website.Pages.WeChat
{
    public partial class ComplaintReply : BasePage
    {
        private IWeChatBaseBLL _WhatBase = new WeChatBaseBLL();
        IRoleModelContext _context = RoleModelContext.Current;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (RoleModelContext.Current.User.CorpType != null && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString())))
                {
                    this.cbDealerType.Visible = false;
                }
            }
        }
        protected void Store_ProductLine(object sender, StoreRefreshDataEventArgs e)
        {
            IList<Lafite.RoleModel.Domain.AttributeDomain> dataSet = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine);
            this.ProductLineStore.DataSource = dataSet;
            this.ProductLineStore.DataBind();
        }

        protected void ComplaintTypeStore_RefershData(object sender, StoreRefreshDataEventArgs e) 
        {
            DataTable dt= _WhatBase.GetComplaintType(0,"0").Tables[0];
            this.ComplaintTypeStore.DataSource = dt;
            this.ComplaintTypeStore.DataBind();
        }
        protected void AnswerStateStore_RefershData(object sender, StoreRefreshDataEventArgs e) 
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Id");
            dt.Columns.Add("Value");
            dt.Rows.Add("0", "未回复");
            dt.Rows.Add("1", "已回复");
            this.AnswerStateStore.DataSource = dt;
            this.AnswerStateStore.DataBind();
        }

        protected void DealerTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_Dealer_Type);
            if (sender is Store)
            {
                Store DealerTypeStore = (sender as Store);

                DealerTypeStore.DataSource = dictsCompanyType;
                DealerTypeStore.DataBind();
            }

        }
     
        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = bindResult();
            DataSet ds = _WhatBase.GetComplaintQuery(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        private Hashtable  bindResult()
        {
            Hashtable obj = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbComplaintType.SelectedItem.Value))
            {
                obj.Add("ComplaintType", cbComplaintType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                obj.Add("ProductLineId", cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbAnswerStatus.SelectedItem.Value))
            {
                obj.Add("AnswerStatus", cbAnswerStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealerType.SelectedItem.Value))
            {
                obj.Add("DealerType", cbDealerType.SelectedItem.Value);
            }
            if (RoleModelContext.Current.User.CorpType != null && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))) 
            {
                obj.Add("ParentDealerId", RoleModelContext.Current.User.CorpId.Value.ToString());
            }
            return obj;
        }

        [AjaxMethod]
        public void EditQuestionItem(string detailId)
        {
            if (!string.IsNullOrEmpty(detailId))
            {
                LoadComplaintWindow(detailId);
                this.QuestionWindow.Show();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        private void InitQuestionWindow()
        {
            this.questionIdDetail.Clear();
            this.taTextComplaintType.SelectedItem.Value = string.Empty;
            this.taProductLine.SelectedItem.Value = string.Empty;
            this.tfSubUserDetail.Clear();
            this.tfSubTimeDetail.Clear();
            this.tfDealerNameDetail.Clear();
            this.taQtDetail.Clear();
            this.tfStatusDetail.Clear();
            this.taTextAnswer.Clear();
            this.tfAnswerUserNameDetail.Clear();
            this.tfAnswerDateDetail.Clear();
        }

        private void LoadComplaintWindow(string detailId)
        {
            InitQuestionWindow();
            Hashtable obj = new Hashtable();
            obj.Add("Id", detailId);
            DataTable dt = _WhatBase.GetComplaintQuery(obj).Tables[0];
            if (dt.Rows.Count > 0)
            {
                this.taTextComplaintType.SelectedItem.Value = dt.Rows[0]["WdtId"].ToString();
                this.taProductLine.SelectedItem.Value = dt.Rows[0]["WupId"].ToString();
                this.taQtDetail.Value = dt.Rows[0]["QuestionBody"].ToString();
                this.taTextAnswer.Value = dt.Rows[0]["Answer"].ToString();
                this.tfDealerNameDetail.Text = dt.Rows[0]["DealerName"].ToString();
                this.tfSubUserDetail.Value = dt.Rows[0]["UserName"].ToString();
                this.tfSubTimeDetail.Text = dt.Rows[0]["CreateDate"] == null ? "" : (Convert.ToDateTime(dt.Rows[0]["CreateDate"]).ToShortDateString());
                this.tfStatusDetail.Value = dt.Rows[0]["Status"] == null ? "未答复" : (Convert.ToBoolean(dt.Rows[0]["Status"]) ? "已答复" : "未答复");
                this.tfAnswerUserNameDetail.Value = dt.Rows[0]["AnswerUserName"].ToString();
                this.tfAnswerDateDetail.Value = dt.Rows[0]["AnswerDate"] == null ? "" : (Convert.ToDateTime(dt.Rows[0]["AnswerDate"]).ToShortDateString());

            }
        }

    }
}
