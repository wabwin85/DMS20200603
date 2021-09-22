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

namespace DMS.Website.Pages.Inventory
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.None)]
    public partial class InventorySafetyList : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IInventorySafetyBLL _business = null;

        [Dependency]
        public IInventorySafetyBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        #endregion

        #region Ajax Method
        [AjaxMethod]
        public void DetailWindowShow()
        {
            this.DetailWindow.Show();
        }

        [AjaxMethod]
        public void Cancel()
        {
        }

        [AjaxMethod]
        public void SaveData(string param)
        {
            //System.Diagnostics.Debug.WriteLine("AddItems : Param = " + param);

            param = param.Substring(0, param.Length - 1);

            bool result = business.AddItemsCfn(new Guid(this.cbDealer.SelectedItem.Value), param.Split(','));

            if (result)
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveData.True.Alert.Title").ToString(), GetLocalResourceObject("SaveData.True.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveData.False.Alert.Title").ToString(), GetLocalResourceObject("SaveData.False.Alert.Body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void SaveItem(String txtSaftyQty)
        {
            int iRe = business.UpdateInventoryQty(new Guid(this.hiddenCurrentEditID.Text), Convert.ToDouble(txtSaftyQty));

            if (iRe == 1)
            {
                this.ResultStore.DataBind();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void UpdateSafetyQty()
        {

            bool result = business.UpdateSafetyQtyWithAcutalQty(new Guid(this.cbDealer.SelectedItem.Value));

            if (result)
            {
                Ext.Msg.Alert(GetLocalResourceObject("UpdateSafetyQty.True.Alert.Title").ToString(), GetLocalResourceObject("UpdateSafetyQty.True.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("UpdateSafetyQty.False.Alert.Title").ToString(), GetLocalResourceObject("UpdateSafetyQty.False.Alert.Body").ToString()).Show();
            }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.btnImport.Visible = IsDealer;
                this.Bind_DealerListByFilter(DealerStore, true);
               
                if (IsDealer)
                {
                    
                    //this.AddItemsButton.Disabled = true;
                    //this.btnCopy.Disabled = true;
                    this.btnCopy.Visible = false;
                    this.AddItemsButton.Visible = false;
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    this.GridPanel1.ColumnModel.SetHidden(4, true);
                    this.GridPanel1.ColumnModel.SetHidden(5, false);

                    if (RoleModelContext.Current.User.CorpType == DealerType.T1.ToString() ||
                        RoleModelContext.Current.User.CorpType == DealerType.T2.ToString())
                    {
                        this.cbDealer.Disabled = true;
                        this.btnImport.Visible = false;
                    }
                

                }
                else
                {
                    this.cbDealer.Disabled = false;
                    this.btnCopy.Visible = false;
                    this.AddItemsButton.Visible = false;
                    this.GridPanel1.ColumnModel.SetHidden(4, false);
                    this.GridPanel1.ColumnModel.SetHidden(5, true);
                    this.btnImport.Visible = false;
                }
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable param = new Hashtable();

            //经销商ID
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DMA_ID", this.cbDealer.SelectedItem.Value);
            }
            //ArticleNumber
            if (!string.IsNullOrEmpty(this.txtCfnAN.Text))
            {
                param.Add("Article_Number", this.txtCfnAN.Text);
            }

            DataSet ds = business.GetInventoryByDMACFN(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        protected void ActualQtyStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {

            int totalCount = 0;

            Hashtable param = new Hashtable();

            //经销商ID
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DMA_ID", this.cbDealer.SelectedItem.Value);
            }
            //ArticleNumber
            if (!string.IsNullOrEmpty(this.txtCfnANWin.Text))
            {
                param.Add("Article_Number", this.txtCfnANWin.Text);
            }
            DataSet ds = new DataSet();
            if (this.chkIsShareCFN.Checked)
            {
                ds = business.GetActualInvQtyOfShareCFN(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            }
            else
            {
                ds = business.GetActualInvQtyByCFN(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            }
            e.TotalCount = totalCount;

            this.ActualQtyStore.DataSource = ds;
            this.ActualQtyStore.DataBind();
        }
    }

}
