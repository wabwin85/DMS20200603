using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business;
using System.Collections;
using System.Data;
using DMS.Model.Data;
using DMS.Model;
namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "InvenrotyQROperationCfnDailog")]
    public partial class InvenrotyQROperationCfnDailog : BaseUserControl
    {
        Warehouses whbusiness = new Warehouses();
        ITIWcDealerBarcodeqRcodeScanBLL Bll = new TIWcDealerBarcodeqRcodeScanBLL();
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        #region store
        protected void CfnStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable ht = new Hashtable();
            if(!string.IsNullOrEmpty(cbfWarehouse.SelectedItem.Value))
            {
                ht.Add("WarehouseId", cbfWarehouse.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(tfQrCode.Text))
            {
                ht.Add("NewQrCode", tfQrCode.Text);
            }
            if (!string.IsNullOrEmpty(hidCfnUpn.Text))
            {
                ht.Add("Upn", hidCfnUpn.Text);
            }
            if (!string.IsNullOrEmpty(hidCfnLot.Text))
            {
                ht.Add("LotNumber", hidCfnLot.Text);
            }
            if (!string.IsNullOrEmpty(hidQrCode.Text))
            {
                ht.Add("QrCode", hidQrCode.Text);
            }
            if (!string.IsNullOrEmpty(hidDelarId.Text))
            {
                ht.Add("DealerId", hidDelarId.Text);
            }
            DataSet ds=new DataSet();
            //if (hidType.Text == "Shipment")
            //{
                ds = Bll.QueryTIWShipmentCfnBY(ht, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            //}
            e.TotalCount = totalCount;
            CfnStore.DataSource = ds;
            CfnStore.DataBind();
        }
        #endregion
        #region
        [AjaxMethod]
        public void Show(string DealerId,string LotNumber,string Upn,string QrCode,string type)
        {
            hidCfnUpn.Clear();
            hidCfnLot.Clear();
            hidQrCode.Clear();
            hidDelarId.Clear();
            hidType.Clear();
            hidDelarId.Text=DealerId;
            hidQrCode.Text = QrCode;
            hidCfnUpn.Text = Upn;
            hidCfnLot.Text = LotNumber;
            hidType.Text = type;
            IList<Warehouse> list = whbusiness.GetAllWarehouseByDealer(new Guid(DealerId));
            List<Warehouse> Wlist = new List<Warehouse>(list);
            Wlist =new List<Warehouse>((from t in Wlist
                    where (t.Type == "Normal" || t.Type == "DefaultWH")
                    select t));
            this.CfnWarehouseStore.DataSource = Wlist;
            this.CfnWarehouseStore.DataBind();
            CfnWindow.Show();
        }
        #endregion
    }
}