using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using DMS.Business;
using Coolite.Ext.Web;

namespace DMS.Website.Pages.Contract
{
    public partial class ContractIAFOperation : System.Web.UI.Page
    {
        private IPurchaseOrderBLL _business = new PurchaseOrderBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (Request.QueryString["ContId"] != null)
                {
                    this.hdContractID.Value = Request.QueryString["ContId"];
                }
            }
        }

        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = _business.QueryPurchaseOrderLogByHeaderId(new Guid(this.hdContractID.Value.ToString()),(e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();
        }
    }
}
