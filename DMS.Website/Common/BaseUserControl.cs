using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DMS.Website.Common
{
    using Coolite.Ext.Web;

    using DMS.Common.WebControls;
    using DMS.Common;

    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;

    public class BaseUserControl : System.Web.UI.UserControl
    {
        protected void Store_WarehouseByDealer(object sender, StoreRefreshDataEventArgs e)
        {
            this.PageBase.Store_WarehouseByDealer(sender, e);
        }

        protected void Store_WarehouseByDealerAndType(object sender, StoreRefreshDataEventArgs e)
        {
            this.PageBase.Store_WarehouseByDealerAndType(sender, e);
        }

        protected void Store_SAPWarehouseAddress(object sender, StoreRefreshDataEventArgs e)
        {
            this.PageBase.Store_SAPWarehouseAddress(sender, e);
        }

        protected void Store_ReceiptStatus(object sender, StoreRefreshDataEventArgs e)
        {
            this.PageBase.Store_ReceiptStatus(sender, e);
        }

        protected void Store_ReceiptType(object sender, StoreRefreshDataEventArgs e)
        {
            this.PageBase.Store_ReceiptType(sender, e);
        }

        protected void Store_HospitalGrade(object sender, StoreRefreshDataEventArgs e)
        {
            this.PageBase.Store_HospitalGrade(sender, e);
        }

        protected void Store_RefreshProvinces(object sender, StoreRefreshDataEventArgs e)
        {
            this.PageBase.Store_RefreshProvinces(sender, e);
        }

        protected void Store_RefreshTerritorys(object sender, StoreRefreshDataEventArgs e)
        {
            this.PageBase.Store_RefreshTerritorys(sender, e);
        }


        protected void Store_RefreshProductLine(object sender, StoreRefreshDataEventArgs e)
        {
            this.PageBase.Store_RefreshProductLine(sender, e);
        }

        protected void Store_RefreshProductLine_PO(object sender, StoreRefreshDataEventArgs e)
        {
            this.PageBase.Store_RefreshProductLine_PO(sender, e);
        }

        protected void Store_RefreshProductLine_PT(object sender, StoreRefreshDataEventArgs e)
        {
            this.PageBase.Store_RefreshProductLine_PT(sender, e);
        }

        protected void Store_DealerList(object sender, StoreRefreshDataEventArgs e)
        {
            this.PageBase.Store_DealerList(sender, e);
        }

        protected void Store_DealerListByFilter(object sender, StoreRefreshDataEventArgs e)
        {
            this.PageBase.Store_DealerListByFilter(sender, e);
        }

        //added by bozhenfei on 20100401
        protected void Store_RefreshDictionary(object sender, StoreRefreshDataEventArgs e)
        {
            this.PageBase.Store_RefreshDictionary(sender, e);
        }
        //end

        protected void Store_WarehouseByDealerAndTypeWithoutDWH(object sender, StoreRefreshDataEventArgs e)
        {
            this.PageBase.Store_WarehouseByDealerAndTypeWithoutDWH(sender, e);
        }

        protected BasePage PageBase
        {
            get {

                if (this.Page is BasePage)
                    return (BasePage)this.Page;
                else
                {
                    throw new DMSException("页面没有继承BasePage.");
                }
            }
        }

        protected Guid GetGuid()
        {
            return this.PageBase.GetGuid();
        }

        protected string NewGuid()
        {
            return this.PageBase.NewGuid();
        }

        //added by bozhenfei on 20100326
        protected bool IsDealer
        {
            get
            {
                return this.PageBase.IsDealer;
            }
        }
        //end

        protected void Bind_DealerList(Store store)
        {
            this.PageBase.Bind_DealerList(store);
        }

        protected void Bind_DealerListByFilter(Store store, bool showParent)
        {
            this.PageBase.Bind_DealerListByFilter(store, showParent);
        }

        protected void Bind_Dictionary(Store store, string type)
        {
            this.PageBase.Bind_Dictionary(store, type);
        }

        protected void Bind_ProductLine(Store store)
        {
            this.PageBase.Bind_ProductLine(store);
        }

        protected void Bind_DealerList(Store store, Guid dealerId, string dealerWarehouseType)
        {
            this.PageBase.Bind_WarehouseByDealer(store, dealerId, dealerWarehouseType);
        }

        protected void Bind_WarehouseByDealerAndType(Store store, Guid dealerId, string dealerWarehouseType)
        {
            this.PageBase.Bind_WarehouseByDealerAndType(store, dealerId, dealerWarehouseType);
        }

        protected void Bind_TransferWarehouseByDealerAndType(Store store, Guid dealerId, string dealerWarehouseType)
        {
            this.PageBase.Bind_TransferWarehouseByDealerAndType(store, dealerId, dealerWarehouseType);
        }

        protected void Bind_TransferWarehouseByDealerAndTypeWithoutDWH(Store store, Guid dealerId, Guid productlineId, string dealerWarehouseType)
        {
            this.PageBase.Bind_WarehouseByDealerAndTypeWithoutDWH(store, dealerId, productlineId,dealerWarehouseType);
        }

        public virtual void Bind_SAPWarehouseAddress(Store store, Guid dealerId)
        {
            this.PageBase.Bind_SAPWarehouseAddress(store, dealerId);
        }

        protected void Bind_NormalWarehousType(Store store, Guid dealerId, Guid productlineId, string dealerWarehouseType)
        {
            this.PageBase.Bind_NormalWarehousType(store, dealerId, productlineId,dealerWarehouseType);
        }
    }
}
