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
    public partial class CfnnotorderInfo : BasePage
    {
        private IPurchaseOrderBLL _business = new PurchaseOrderBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["UPN"]))
                {
                    this.txtUpn.Text = Request.QueryString["UPN"];
                }
                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                    {
                        this.Bind_DealerList(this.DealerStore);
                        this.cbDealer.Disabled = true;
                        //this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        //DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_ORDERNEW);
                    }
                    else
                    {
                        this.Bind_DealerListByFilter(this.DealerStore, false);
                    }

                }
                {
                    this.Bind_DealerList(this.DealerStore);
                }
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {


            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(cbDealer.SelectedItem.Value))
            {
                param.Add("DealerId", cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(txtUpn.Text))
            {
                param.Add("Upn", txtUpn.Text.Split(',')[0]);
            }
            DataSet ds = _business.GetCfnIsorderByUpn(param);
            ResultStore.DataSource = ds;
            ResultStore.DataBind();
        }
    }
}
