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
    public partial class DealerNews : BasePage
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
            DataTable dt = _WhatBase.GetComplaintType(1,"0").Tables[0];
            this.ComplaintTypeStore.DataSource = dt;
            this.ComplaintTypeStore.DataBind();
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
            DataSet ds = _WhatBase.GetDealerNews(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        private Hashtable bindResult()
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
        public void DetailItem(string detailId)
        {
            InitAnswerWindow(true);

            if (!string.IsNullOrEmpty(detailId))
            {
                LoadComplaintWindow(new Guid(detailId));

                //Set Value
                this.texthdId.Value = detailId;

                //Show Window
                this.InputWindow.Show();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }

        }

        private void InitAnswerWindow(bool canSubmit)
        {
            this.texthdId.Clear();
            this.textUserName.Text = "";
            this.textDealerName.Text = "";
            this.taTextComplaintType.Value = "";
            this.taProductLine.Value = "";
            this.taTextBody.Clear();
            this.textImage.ImageUrl="";
        }

        private void LoadComplaintWindow(Guid detailId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("Id", detailId.ToString());
            DataTable dt = _WhatBase.GetDealerNews(obj).Tables[0];
            if (dt.Rows.Count > 0)
            {
                this.taTextComplaintType.SelectedItem.Value = dt.Rows[0]["Tital"].ToString();
                this.taProductLine.SelectedItem.Value = dt.Rows[0]["ProductLineId"].ToString();
                this.taTextBody.Value = dt.Rows[0]["Body"].ToString();
                this.textImage.ImageUrl = "http://115.28.172.91/wechat/Upload/" + dt.Rows[0]["Url"].ToString();
                this.textDealerName.Text = dt.Rows[0]["DealerName"].ToString();
                this.textUserName.Text = dt.Rows[0]["UserName"].ToString();
            }
        }
    }
}
