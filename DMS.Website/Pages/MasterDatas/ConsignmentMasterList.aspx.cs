using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using Coolite.Ext.Web;
using DMS.Business;
using DMS.Common;
using DMS.Model.Data;
using System.Data;
using System.Collections;


namespace DMS.Website.Pages.MasterDatas
{
    public partial class ConsignmentMasterList : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();

        private IConsignmentMasterBLL business = new ConsignmentMasterBLL();
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                
                this.Bind_ProductLine(this.ProductLineStore);

                this.Bind_DealerList(this.DealerStore);
                this.Bind_Status(this.OrderStatusStore);
                this.Bind_EffectiveType(this.OrderTypeStore);
                this.cbDealer.Disabled = false;

                this.btnSearch.Enabled = _context.IsInRole("Administrators") || _context.IsInRole("经销商短期寄售管理员");
                this.btnInsert.Enabled = _context.IsInRole("Administrators") || _context.IsInRole("经销商短期寄售管理员");
                this.PagingToolBar1.Enabled = _context.IsInRole("Administrators") || _context.IsInRole("经销商短期寄售管理员");
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            //this.InventoryAdjustDialog1.GridStore = this.DetailStore;
            //this.InventoryAdjustDialog1.GridConsignmentStore = this.ConsignmentDetailStore;
            
        }

        protected void Bind_Status(Store store1)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Const_Consignment_Type);

            store1.DataSource = dicts;
            store1.DataBind();

        }

        protected void Bind_EffectiveType(Store store1)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Const_Consignment_Rule);

            store1.DataSource = dicts;
            store1.DataBind();

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
            //IInventoryAdjustBLL business = new InventoryAdjustBLL();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLineId", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cbDealer.SelectedItem.Value);
            }

            if (!string.IsNullOrEmpty(this.cbOrderType.SelectedItem.Value))
            {
                param.Add("OrderType", this.cbOrderType.SelectedItem.Value);
            }

            if (!this.txtStartDate.IsNull)
            {
                param.Add("StartDate", this.txtStartDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtEndDate.IsNull)
            {
                param.Add("EndDate", this.txtEndDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtOrderNo.Text))
            {
                param.Add("OrderNo", this.txtOrderNo.Text);
            }
            if (!string.IsNullOrEmpty(this.cbOrderStatus.SelectedItem.Value))
            {
                param.Add("OrderStatus", this.cbOrderStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                param.Add("Cfn", this.txtCFN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtConsignmentName.Text))
            {
                param.Add("ConsignmentName", this.txtConsignmentName.Text);
            }


            DataSet ds = business.SelectConsignmentMasterByFilter(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }


        

       
    }
}
