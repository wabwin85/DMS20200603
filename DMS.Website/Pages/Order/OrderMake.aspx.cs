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
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.None)]
    public partial class OrderMake : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _business = null;

        [Dependency]
        public IPurchaseOrderBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (IsDealer)
                {
                    this.cbDealer.Disabled = true;
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    //DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_ORDERNEW);
                }
                //else
                //{
                //}
                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.PurchaseOrderBLL.Action_OrderMake, PermissionType.Read);
                bool writable = pers.IsPermissible(Business.PurchaseOrderBLL.Action_OrderMake, PermissionType.Write);
                this.btnLock.Visible = writable;
                this.btnUnlock.Visible = writable;
                this.btnMake.Visible = writable;
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLineBumId", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DmaId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbOrderStatus.SelectedItem.Value))
            {
                param.Add("OrderStatus", this.cbOrderStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbIsLocked.SelectedItem.Value))
            {
                param.Add("IsLocked", this.cbIsLocked.SelectedItem.Value);
            }
            if (!this.txtSubmitDateStart.IsNull)
            {
                param.Add("SubmitDateStart", this.txtSubmitDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtSubmitDateEnd.IsNull)
            {
                param.Add("SubmitDateEnd", this.txtSubmitDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtOrderNo.Text))
            {
                param.Add("OrderNo", this.txtOrderNo.Text);
            }
            if (!string.IsNullOrEmpty(this.txtCfn.Text))
            {
                param.Add("Cfn", this.txtCfn.Text);
            }

            DataSet ds = business.QueryPurchaseOrderHeaderForMake(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        protected override internal void Store_RefreshDictionary(object sender, StoreRefreshDataEventArgs e)
        {
            Store store = (Store)sender;
            string type = e.Parameters["Type"].ToString();

            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);
            IList list = dicts.ToList().FindAll(item => item.Key != PurchaseOrderStatus.Draft.ToString() && item.Key != PurchaseOrderStatus.Rejected.ToString());
            store.DataSource = list;
            store.DataBind();
        }
        #region Ajax Method
        [AjaxMethod]
        public void Lock(string listString)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            string message = string.Empty;
            bool result = business.Lock(listString.Substring(0, listString.Length - 1), out rtnVal, out rtnMsg);
            if (result)
            {
                switch (rtnVal)
                {
                    case "Success": message = GetLocalResourceObject("Lock.Success.message").ToString(); break;
                    case "Error": message = rtnMsg; break;
                    case "Failure": message = GetLocalResourceObject("Lock.Failure.message").ToString(); break;
                    default: message = GetLocalResourceObject("Lock.default.message").ToString(); break;
                }
                Ext.MessageBox.Alert("Message", message).Show();
            }
            else
            {
                Ext.MessageBox.Alert("Error", GetLocalResourceObject("Lock.Failure.message").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void Unlock(string listString)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            string message = string.Empty;
            bool result = business.Unlock(listString.Substring(0, listString.Length - 1), out rtnVal, out rtnMsg);
            if (result)
            {
                switch (rtnVal)
                {
                    case "Success": message = GetLocalResourceObject("Unlock.Success.message").ToString(); break;
                    case "Error": message = rtnMsg; break;
                    case "Failure": message = GetLocalResourceObject("Unlock.Failure.message").ToString(); break;
                    default: message = GetLocalResourceObject("Unlock.default.message").ToString(); break;
                }
                Ext.MessageBox.Alert("Message", message).Show();
            }
            else
            {
                Ext.MessageBox.Alert("Error", GetLocalResourceObject("Unlock.Failure.message").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void MakeManual(string listString)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            string batchNbr = string.Empty;

            bool result = business.MakeManual(listString.Substring(0, listString.Length - 1), out rtnVal, out rtnMsg, out batchNbr);
            if (result)
            {
                if (rtnVal == "Success")
                {
                    Ext.MessageBox.Alert("Message", string.Format(GetLocalResourceObject("MakeManual.Success.message").ToString(), batchNbr)).Show();
                }
                else if (rtnVal == "Error")
                {
                    if (string.IsNullOrEmpty(batchNbr))
                    {
                        Ext.MessageBox.Alert("Message", string.Format(GetLocalResourceObject("MakeManual.Error.message1").ToString(), rtnMsg)).Show();
                    }
                    else
                    {
                        Ext.MessageBox.Alert("Message", string.Format(GetLocalResourceObject("MakeManual.Error.message2").ToString(), rtnMsg, batchNbr)).Show();
                    }
                }
            }
            else
            {
                Ext.MessageBox.Alert("Error", GetLocalResourceObject("MakeManual.Failure.message").ToString()).Show();
            }
        }
        #endregion
    }
}
