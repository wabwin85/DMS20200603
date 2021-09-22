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
using DMS.Common;
using DMS.Business;

namespace DMS.Website.Pages.DPInfo
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.None)]
    public partial class DPScoreCardList : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
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

        protected void DealerTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_Dealer_Type);
            var list = from t in dictsCompanyType where t.Key != "HQ" select t;
            if (sender is Store)
            {
                Store DealerTypeStore = (sender as Store);

                DealerTypeStore.DataSource = list;
                DealerTypeStore.DataBind();
            }

        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DpScoreCardBLL bll = new DpScoreCardBLL();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.tbSapCode.Text))
            {
                param.Add("SapCode", this.tbSapCode.Text);
            }
            if (!string.IsNullOrEmpty(this.cbDealerType.SelectedItem.Value))
            {
                param.Add("DealerType", this.cbDealerType.SelectedItem.Value);
            }
            DataSet ds = bll.QueryDealerFinanceScoreCard(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

    }
}
