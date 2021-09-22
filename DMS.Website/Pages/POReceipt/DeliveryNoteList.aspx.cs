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
using System.Xml;
using System.Xml.Xsl;

namespace DMS.Website.Pages.POReceipt
{
    public partial class DeliveryNoteList : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (IsDealer)
                {
                    this.cbDealer.Disabled = true;
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                }
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            IDeliveryNotes business = new DeliveryNotes();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbType.SelectedItem.Value))
            {
                param.Add("Type", this.cbType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtSapCode.Text))
            {
                param.Add("SapCode", this.txtSapCode.Text);
            }
            if (!string.IsNullOrEmpty(this.txtDeliveryNoteNbr.Text))
            {
                param.Add("DeliveryNoteNbr", this.txtDeliveryNoteNbr.Text);
            }
            if (!string.IsNullOrEmpty(this.txtPONbr.Text))
            {
                param.Add("PoNbr", this.txtPONbr.Text);
            }
            if (!this.txtStartDate.IsNull)
            {
                param.Add("ShipmentDateStart", this.txtStartDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtEndDate.IsNull)
            {
                param.Add("ShipmentDateEnd", this.txtEndDate.SelectedDate.ToString("yyyyMMdd"));
            }

            DataSet ds = business.QueryDeliveryNote(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }
    }
}
