using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using DMS.Model;
using DMS.Website.Common;
using DMS.Business.Cache;
using DMS.Business;
using DMS.Common;
using System.Collections;
using System.Data;

namespace DMS.Website.Controls
{
    public partial class POReceiptListDetail : BaseUserControl
    {
        public Guid HeaderId
        {
            set
            {
                ViewState["HeaderId"] = value;
            }
            get
            {
                if (ViewState["HeaderId"] == null)
                {
                    return Guid.Empty;
                }
                return new Guid(ViewState["HeaderId"].ToString());
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            BindData(e.Start, e.Limit);
        }

        public void Show(Guid id)
        {
            BindHeader();
            BindData(0, 15);
            this.DetailWindow.Show();
        }

        private void BindHeader()
        {
            IPOReceipt business = new DMS.Business.POReceipt();
            PoReceiptHeader header = business.GetObject(HeaderId);

            this.txtDealer.Text = DealerCacheHelper.GetDealerName(header.DealerDmaId);
            this.txtVendor.Text = DealerCacheHelper.GetDealerName(header.VendorDmaId);
            this.txtSapNumber.Text = header.SapShipmentid;
            this.txtPoNumber.Text = header.PoNumber;
            this.txtDate.Text = (header.SapShipmentDate == null) ? "" : header.SapShipmentDate.Value.ToString("yyyyMMdd");
            this.txtStatus.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_Receipt_Status, header.Status);
        }

        private void BindData(int start, int limit)
        {
            IPOReceipt business = new DMS.Business.POReceipt();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            param.Add("hid", HeaderId.ToString());

            DataSet ds = business.QueryPoReceiptLot(param, start, limit, out totalCount);

            (this.DetailStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.DetailStore.DataSource = ds;
            this.DetailStore.DataBind();
        }

    }
}