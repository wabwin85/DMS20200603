using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Lafite.RoleModel.Security;
using DMS.Business;
using Microsoft.Practices.Unity;
using DMS.Website.Common;
using System.Data;
using DMS.Business.Cache;
using DMS.Common;
using System.Collections;
using DMS.Model;

namespace DMS.Website.Pages.POReceipt
{
    public partial class POReceiptPrint : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPOReceipt _business = null;
        private IDealerMasters _master = null;
        private static Guid id = Guid.Empty;
        const string DIBProductLineID = "5cff995d-8ffc-44f6-a0aa-ff750cc36312";

        [Dependency]
        public IPOReceipt business
        {
            get { return _business; }
            set { _business = value; }
        }
        [Dependency]
        public IDealerMasters master
        {
            get { return _master; }
            set { _master = value; }
        }


        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] == null)
                    Response.Redirect("POReceiptList.aspx");
                else
                {
                    id = new Guid(Request.QueryString["id"].ToString());
                    BindMain(id);

                    DetailRefershData(id);
                }
            }
        }


        private void BindMain(Guid id)
        {
            DealerMasters dm = new DealerMasters();
            Guid pid = Guid.Empty;
            Guid hid = Guid.Empty;
            PoReceiptHeader mainData = business.GetObjectAddWarehouse(id);
            lbDealer.Text = DealerCacheHelper.GetDealerName(mainData.DealerDmaId);


            if (mainData.ProductLineBumId != null)
                pid = mainData.ProductLineBumId.Value;

            //this.lbTotalAmount.Text = business.GetReceiptTotalAmount(id).ToString();
            this.lbTotalQty.Text = business.GetReceiptTotalQty(id).ToString();

            this.lbDealer.Text = DealerCacheHelper.GetDealerName(mainData.DealerDmaId);
            this.lbVendor.Text = DealerCacheHelper.GetDealerName(mainData.VendorDmaId);
            this.lbWarehouse.Text = mainData.WHMName;
            this.lbSapNumber.Text = mainData.SapShipmentid;
            this.lbPONumber.Text = mainData.PoNumber;
            this.lbDate.Text = (mainData.ReceiptDate == null) ? "" : mainData.ReceiptDate.Value.ToString("yyyyMMdd");
            //added by bozhenfei on 20100612
            this.lbCarrier.Text = mainData.Carrier;
            this.lbTrackingNo.Text = mainData.TrackingNo;
            this.lbShipType.Text = mainData.ShipType;

        }

        protected void DetailRefershData(Guid id)
        {
            
            Hashtable param = new Hashtable();

            param.Add("hid", id);
            DataSet ds = business.QueryPoReceiptLot(param);

            this.GridView1.DataSource = ds;

            this.GridView1.DataBind();
        }

        protected void result_RowCreated(object sender, GridViewRowEventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("result_RowCreated");

        }
    }
}
