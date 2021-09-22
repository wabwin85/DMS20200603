using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Collections;

namespace DMS.Website.Pages.WeChat
{
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using Microsoft.Practices.Unity;
    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Common;
    using DMS.Model.Data;



    public partial class RedeemGift : BasePage
    {
        #region 公共

        IRoleModelContext _context = RoleModelContext.Current;

        private IWeChatBaseBLL bll = new WeChatBaseBLL();


        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {

            }
        }

        #region Store
        public void ResultStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable table = new Hashtable();

            if (!string.IsNullOrEmpty(this.txtDealerName.Text.Trim()))
                table.Add("DealerName", this.txtDealerName.Text.Trim());

            if (!string.IsNullOrEmpty(this.txtUserName.Text.Trim()))
                table.Add("UserName", this.txtUserName.Text.Trim());
            if (!string.IsNullOrEmpty(this.cmbStatus.SelectedItem.Value))
            {
                table.Add("Status", this.cmbStatus.SelectedItem.Value);
            }
            DataSet data = bll.QuerySelectGiftsByFilter(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PageToolBar2.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            ResultStore.DataSource = data;
            ResultStore.DataBind();
        }


        #endregion

        #region AjaxMethod
        [AjaxMethod]
        public void Show(string id)
        {

            this.hdnDocumentnumber.Text = id;
        }
        #endregion






        protected void DetailStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            DataSet ds = bll.GetGiftByMainId(this.hdnDocumentnumber.Text, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            DetailStore.DataSource = ds;
            DetailStore.DataBind();
        }


        [AjaxMethod]
        public void Approve(string param)
        {
            param = param.Substring(0, param.Length - 1);


             bll.UpdateRedeemGiftStatus(param.Split(','));
             ResultStore.DataBind();
             //Ext.Msg.Alert("成功", "审批通过").Show();

        }


        [AjaxMethod]
        public void Reject(string param)
        {
            param = param.Substring(0, param.Length - 1);


            bll.UpdateRejectStatus(param.Split(','));
            ResultStore.DataBind();
           // Ext.Msg.Alert("拒绝", "已拒绝").Show();
        }
    }
}