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
using Microsoft.Practices.Unity;

namespace DMS.Website.Pages.Order
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "DealerPriceInit")]
    public partial class DealerPriceInit : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IDealerPriceBLL _business = null;

        [Dependency]
        public IDealerPriceBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            this.hidCorpType.Text = "";

            if (IsDealer)
            {
                this.hidCorpType.Text = RoleModelContext.Current.User.CorpType;

            }

            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.btnImport.Visible = IsDealer;

                if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                {
                    this.btnImport.Visible = true;
                }
                else
                {
                    this.btnImport.Visible = false;
                }

                //控制查询按钮
                //Permissions pers = this._context.User.GetPermissions();
                //this.btnSearch.Visible = pers.IsPermissible(Business.PurchaseOrderBLL.Action_OrderApply, PermissionType.Read);
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!this.txtSubmitDateStart.IsNull)
            {
                param.Add("UploadDateStart", this.txtSubmitDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtSubmitDateEnd.IsNull)
            {
                param.Add("UploadDateEnd", this.txtSubmitDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!String.IsNullOrEmpty(this.txtUploadNbr.Text)) 
            { 
                param.Add("UploadNbr", this.txtUploadNbr.Text); 
            }
            if (!String.IsNullOrEmpty(this.txtCfn.Text))
            {
                param.Add("Cfn", this.txtCfn.Text);
            }

            
            param.Add("LPId", RoleModelContext.Current.User.CorpId);

            DataSet ds = business.QueryDealerPriceHead(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }
    }
}
