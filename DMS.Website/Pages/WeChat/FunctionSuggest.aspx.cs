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
using Microsoft.Practices.Unity;

namespace DMS.Website.Pages.WeChat
{
    public partial class FunctionSuggest : BasePage
    {
        private IWeChatBaseBLL _WhatBase = new WeChatBaseBLL();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable table = new Hashtable();

            if (!this.dfBeginDate.IsNull)
            {
                table.Add("BeginDate", this.dfBeginDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.dfEndDate.IsNull)
            {
                table.Add("EndDate", this.dfEndDate.SelectedDate.ToString("yyyyMMdd"));
            }

            DataSet ds = _WhatBase.GetFunctionSuggest(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        [AjaxMethod]
        public void EditSuggestItem(string detailId)
        {
            this.txtUserName.Text = "";
            this.txtDealerName.Text = "";
            this.txtDealerType.Text = "";
            this.txtBody.Text = "";
            this.txtDate.Text = "";

            if (!string.IsNullOrEmpty(detailId))
            {
                Hashtable table = new Hashtable();
                table.Add("Id", detailId);
                DataTable dt = _WhatBase.GetFunctionSuggest(table).Tables[0];
                if (dt.Rows.Count > 0) 
                {
                    this.txtUserName.Text = dt.Rows[0]["UserName"].ToString();
                    this.txtDealerName.Text = dt.Rows[0]["DealerName"].ToString();
                    this.txtDealerType.Text = dt.Rows[0]["DealerType"].ToString();
                    this.txtBody.Text = dt.Rows[0]["Body"].ToString();
                    this.txtDate.Text = dt.Rows[0]["CreateDate"].ToString();
                }
                //Show Window
                this.InputWindow.Show();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

    }
}
