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
    public partial class ShipmentEditor : BaseUserControl
    {
        public Store GridStore
        {
            get;
            set;
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void Show(Guid EditId)
        {
            this.txtWarehouseName.Clear();
            this.txtCFN.Clear();
            this.txtUPN.Clear();
            this.txtLotNumber.Clear();
            this.txtExpiredDate.Clear();
            this.txtUnitOfMeasure.Clear();
            this.txtTotalQty.Clear();
            this.txtShipmentQty.Clear();

            this.hiddenEditId.Clear();

            IShipmentBLL business = new ShipmentBLL();
            Hashtable param = new Hashtable();
            param.Add("LotId", EditId);
            DataSet ds = business.QueryShipmentLot(param);

            if (ds.Tables[0].Rows.Count > 0)
            {
                DataRow lot = ds.Tables[0].Rows[0];

                this.hiddenEditId.Text = EditId.ToString();
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
                this.txtShipmentQty.Text = lot["ShipmentQty"].ToString();
            }           

            this.EditorWindow.Show();
        }

        [AjaxMethod]
        public void SaveItem()
        {
            if (Convert.ToDouble(this.txtTotalQty.Text) < this.txtShipmentQty.Number)
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.title").ToString(), GetLocalResourceObject("SaveItem.Alert.body").ToString()).Show();
                return;
            }

            IShipmentBLL business = new ShipmentBLL();

            ShipmentLot lot = business.GetShipmentLotById(new Guid(this.hiddenEditId.Text));
            lot.LotShippedQty = this.txtShipmentQty.Number;

            bool result = business.SaveItem(lot, 0);//added by bozhenfei on 20100608 @此控件不使用，故填写了个0

            if (result)
            {
                this.GridStore.DataBind();
                this.EditorWindow.Hide();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.title1").ToString(), GetLocalResourceObject("SaveItem.Alert.body1").ToString()).Show();
            }
        }
    }
}