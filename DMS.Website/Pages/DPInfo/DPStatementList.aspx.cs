using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using DMS.Model.Data;
using DMS.Business.DPInfo;
using System.Collections;
using System.Data;

namespace DMS.Website.Pages.DPInfo
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.None)]
    public partial class DPStatementList : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                //this.btnInsert.Visible = IsDealer;

                this.Bind_DealerList(this.DealerStore);

                if (IsDealer)
                {
                    this.cbDealer.Disabled = true;
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                }
                else
                {

                }

                //控制查询按钮
                //Permissions pers = this._context.User.GetPermissions();
                //this.btnSearch.Visible = pers.IsPermissible(Business.TransferBLL.Action_TransferRent, PermissionType.Read);
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {

        }

        protected void YearStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DpStatementBLL bll = new DpStatementBLL();
            Hashtable ht = new Hashtable();
            if (IsDealer)
            {
                ht.Add("DealerId", this._context.User.CorpId.Value);
            }
            this.YearStore.DataSource = bll.GetDealerFinanceStatementYearList(ht);
            this.YearStore.DataBind();
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DpStatementBLL bll = new DpStatementBLL();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbYear.SelectedItem.Value))
            {
                param.Add("Year", this.cbYear.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbMonth.SelectedItem.Value))
            {
                param.Add("Month", this.cbMonth.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbStatus.SelectedItem.Value);
            }

            DataSet ds = bll.QueryDealerFinanceStatement(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

    }
}
