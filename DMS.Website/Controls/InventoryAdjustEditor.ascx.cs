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
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "UCE")]
    public partial class InventoryAdjustEditor : BaseUserControl
    {
        public Store GridStore
        {
            get;
            set;
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void Show(Guid EditId, string Type)
        {
            this.txtWarehouseName.Clear();
            this.txtCFN.Clear();
            this.txtUPN.Clear();
            this.txtLotNumber.Clear();
            this.txtExpiredDate.Clear();
            this.txtUnitOfMeasure.Clear();
            this.txtTotalQty.Clear();
            this.txtCreatedDate.Clear();
            this.txtAdjustQty.Clear();

            this.hiddenEditId.Clear();
            this.hiddenEditType.Clear();

            IInventoryAdjustBLL business = new InventoryAdjustBLL();
            Hashtable param = new Hashtable();
            param.Add("LotId", EditId);
            DataSet ds = business.QueryInventoryAdjustLot(param);

            if (ds.Tables[0].Rows.Count > 0)
            {
                DataRow lot = ds.Tables[0].Rows[0];

                this.hiddenEditId.Text = EditId.ToString();
                this.hiddenEditType.Text = Type;
                this.txtWarehouseName.Text = lot["WarehouseName"].ToString();
                this.txtCFN.Text = lot["CFN"].ToString();
                this.txtUPN.Text = lot["UPN"].ToString();
                this.txtLotNumber.Text = lot["LotNumber"].ToString();
                if (lot["ExpiredDate"] != DBNull.Value)
                {
                    this.txtExpiredDate.SelectedDate = DateTime.ParseExact(lot["ExpiredDate"].ToString(), "yyyyMMdd", null);
                }
                this.txtUnitOfMeasure.Text = lot["UnitOfMeasure"].ToString();
                this.txtTotalQty.Text = lot["TotalQty"].ToString();
                if (lot["CreatedDate"] != DBNull.Value)
                {
                    this.txtCreatedDate.SelectedDate = DateTime.ParseExact(lot["CreatedDate"].ToString(), "yyyyMMdd", null);
                }
                this.txtAdjustQty.Text = lot["AdjustQty"].ToString();
            }

            if (Type == AdjustType.StockIn.ToString())
            {
                this.txtLotNumber.ReadOnly = false;
                this.txtLotNumber.Disabled = false;
                this.txtExpiredDate.ReadOnly = false;
                this.txtExpiredDate.Disabled = false;               
            }
            else
            {
                this.txtLotNumber.ReadOnly = true;
                this.txtLotNumber.Disabled = true;
                this.txtExpiredDate.ReadOnly = true;
                this.txtExpiredDate.Disabled = true;
            }

            this.EditorWindow.Show();
        }

        [AjaxMethod]
        public void CheckLotNumber()
        {
            this.txtExpiredDate.Clear();
            this.txtTotalQty.Clear();

            IInventoryAdjustBLL business = new InventoryAdjustBLL();
            DataSet ds = business.CheckLotNumber(new Guid(this.hiddenEditId.Text), this.txtLotNumber.Text);
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                this.txtTotalQty.Text = ds.Tables[0].Rows[0]["TotalQty"].ToString();
                if (ds.Tables[0].Rows[0]["ExpiredDate"] != DBNull.Value)
                {
                    this.txtExpiredDate.SelectedDate = DateTime.ParseExact(ds.Tables[0].Rows[0]["ExpiredDate"].ToString(), "yyyyMMdd", null);
                }
            }
        }

        [AjaxMethod]
        public void SaveItem()
        {
            IInventoryAdjustBLL business = new InventoryAdjustBLL();

            InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(this.hiddenEditId.Text));
            if (this.hiddenEditType.Text == AdjustType.StockIn.ToString())
            {
                lot.LotNumber = this.txtLotNumber.Text;

                if (this.txtExpiredDate.IsNull)
                {
                    lot.ExpiredDate = null;
                }
                else
                {
                    lot.ExpiredDate = this.txtExpiredDate.SelectedDate;
                }
            }
            else
            {
                //判断库存量是否足够
                if (Convert.ToDouble(this.txtTotalQty.Text) < this.txtAdjustQty.Number)
                {
                    Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.title").ToString(), GetLocalResourceObject("SaveItem.Alert.body").ToString()).Show();
                    return;
                }
            }
            lot.LotQty = this.txtAdjustQty.Number;

            bool result = business.SaveItem(lot);

            if (result)
            {
                this.GridStore.DataBind();
                this.EditorWindow.Hide();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Error.alert.title").ToString(), GetLocalResourceObject("SaveItem.Error.alert.body").ToString()).Show();
            }
        }
    }
}