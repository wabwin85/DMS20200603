using DMS.Website.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Controls
{
    using DMS.Common;
    using DMS.Website.Common;
    using DMS.Model;
    using DMS.Business;
    using Coolite.Ext.Web;
    using System.Collections;
    using System.Data;

    public partial class CFNSearchForComplainDialog : BaseUserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Store_RefreshProductLineByDealer(object sender, StoreRefreshDataEventArgs e)
        {
            if (this.hiddenIsCrm.Value.ToString() == "1")
            {
                IList<Lafite.RoleModel.Domain.AttributeDomain> plList = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine);

                ProductCatoriesStore.DataSource = plList.Where<Lafite.RoleModel.Domain.AttributeDomain>(p => new Guid(p.Id) == new Guid("97a4e135-74c7-4802-af23-9d6d00fcb2cc")).ToList<Lafite.RoleModel.Domain.AttributeDomain>();
                ProductCatoriesStore.DataBind();
            }
            else
            {
                IDealerContracts dealers = new DealerContracts();

                DealerAuthorization da = new DealerAuthorization();
                da.DmaId = new Guid(this.hiddenDealerId.Value.ToString());

                IList<DealerAuthorization> auths = dealers.GetAuthorizationListByDealer(da);

                IList<Lafite.RoleModel.Domain.AttributeDomain> dataSet = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine);

                var lines = from p in dataSet
                            where auths.FirstOrDefault<DealerAuthorization>(c => c.ProductLineBumId.Value == new Guid(p.Id)) != null
                            select p;

                ProductCatoriesStore.DataSource = lines.ToList<Lafite.RoleModel.Domain.AttributeDomain>();
                ProductCatoriesStore.DataBind();
            }
        }

        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            RefreshCfnData(e.Start, e.Limit);
        }

        protected void Store2_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            RefreshQrCodeData(e.Start, e.Limit);
        }

        private void RefreshCfnData(int start, int limit)
        {
            IDealerComplainBLL bll = new DealerComplainBLL();

            int totalCount = 0;

            Hashtable param = new Hashtable();
            
            if (this.cbCatories.SelectedItem.Value != "" && this.cbCatories.SelectedItem.Text.Trim() != "")
            {
                param.Add("BumId", new Guid(this.cbCatories.SelectedItem.Value));
            }
            if (!string.IsNullOrEmpty(this.txtCFN.Text.Trim()))
            {
                param.Add("Sku", this.txtCFN.Text.Trim());
            }
            if (!string.IsNullOrEmpty(this.txtLot.Text.Trim()))
            {
                param.Add("LotNumber", this.txtLot.Text.Trim());
            }
            param.Add("IsCrm", this.hiddenIsCrm.Value);
            param.Add("DealerId", this.hiddenDealerId.Value);

            DataSet ds = bll.SelectInventoryForComplainsDataSet(param, start, limit, out totalCount);

            (this.Store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.Store1.DataSource = ds;
            this.Store1.DataBind();

        }

        private void RefreshQrCodeData(int start, int limit)
        {
            IDealerComplainBLL bll = new DealerComplainBLL();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.txtQrCodeForSearch.Text.Trim()))
            {
                param.Add("QrCode", this.txtQrCodeForSearch.Text.Trim());
            }

            if (!string.IsNullOrEmpty(this.txtUpnForSearch.Text.Trim()))
            {
                param.Add("UPN", this.txtUpnForSearch.Text.Trim());
            }
            if (!string.IsNullOrEmpty(this.txtLotForSearch.Text.Trim()))
            {
                param.Add("LotNumber", this.txtLotForSearch.Text.Trim());
            }
            param.Add("DealerId", this.hiddenDealerId.Value);

            DataSet ds = bll.SelectInventoryWarehouseForComplainsDataSet(param, start, limit, out totalCount);

            (this.Store2.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.Store2.DataSource = ds;
            this.Store2.DataBind();

        }
        
        protected void SubmitSelectionForCfn(object sender, AjaxEventArgs e)
        {
            string json = e.ExtraParams["Values"];

            if (string.IsNullOrEmpty(json))
            {
                return;
            }

            if (AfterSelectedCfnHandler != null)
            {
                AfterSelectedCfnHandler(new SelectedEventArgs(json));
            }

            e.Success = true;
        }

        protected void SubmitSelectionForQrCode(object sender, AjaxEventArgs e)
        {
            string json = e.ExtraParams["Values"];

            if (string.IsNullOrEmpty(json))
            {
                return;
            }

            if (AfterSelectedQrCodeHandler != null)
            {
                AfterSelectedQrCodeHandler(new SelectedEventArgs(json));
            }

            e.Success = true;
        }

        public AfterSelectedRow AfterSelectedCfnHandler;
        public AfterSelectedRow AfterSelectedQrCodeHandler;
    }
}