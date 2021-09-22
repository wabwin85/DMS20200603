using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;

namespace DMS.Website.Pages.DCM
{
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;

    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Common;
    using System.Data;
    using Model.ApiModel;

    public partial class DealerProductSearch : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private ICfns _cfns = Global.ApplicationContainer.Resolve<ICfns>();

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //Suppliers 

            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (this.cbCatories.SelectedItem.Value != "" && this.cbCatories.SelectedItem.Text.Trim() != "")
            {
                param.Add("ProductLineBumId", this.cbCatories.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtCFN.Text.Trim()))
            {
                param.Add("CustomerFaceNbr", this.txtCFN.Text.Trim());
            }
            if (_context.User.CorpId != null)
            {
                param.Add("DMA_ID", _context.User.CorpId.Value.ToString());
            }

            DataSet query = null;

            if (this.cbIsShare.Checked)
                query = _cfns.SelectCFNForDealerShare(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            else
                query = _cfns.SelectCFNForDealerNotShare(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.Store1.DataSource = query;
            this.Store1.DataBind();

        }
        protected void StoreRegistration_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!this.hidCfnId.Value.ToString().Equals(""))
            {
                Hashtable param = new Hashtable();

                param.Add("CustomerFaceNbr", this.hidCfnId.Value.ToString());
                int totalCount = 0;
                DataSet ds = _cfns.SelectCFNRegistration(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);

                e.TotalCount = totalCount;

                this.StoreRegistration.DataSource = ds;
                this.StoreRegistration.DataBind();
            }
        }

        protected void StoreRegistrationBylot_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!this.hidCfnId.Value.ToString().Equals(""))
            {
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(this.ProductLot.Text.Trim()))
                {
                    param.Add("ProductLot", this.ProductLot.Text.Trim());
                }
                param.Add("CustomerFaceNbr", this.hidCfnId.Value.ToString());
                int totalCount = 0;
                DataSet ds = _cfns.SelectCFNRegistrationBylot(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount);
                e.TotalCount = totalCount;
                if (ds.Tables[0].Rows.Count > 0)
                {
                    this.StoreRegistrationBylot.DataSource = ds;
                    this.StoreRegistrationBylot.DataBind();
                }
            }
        }

        protected void StoreRegistrationNew_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!this.hidCfnId.Value.ToString().Equals(""))
            {
                Hashtable param = new Hashtable();

                param.Add("CustomerFaceNbr", this.hidCfnId.Value.ToString());
                //DataSet ds = _cfns.SelectCFNRegistration(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);

                List<UPNDocumentItem> ds = _cfns.SelectCFNRegistrationBylotAPI(this.hidCfnId.Value.ToString(), "注册证", "");
                this.StoreRegistrationNew.DataSource = ds;
                this.StoreRegistrationNew.DataBind();
            }
        }
        protected void StoreRegistrationBylotNew_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!this.hidCfnId.Value.ToString().Equals(""))
            {
                List<UPNDocumentItem> ds = _cfns.SelectCFNRegistrationBylotAPI(this.hidCfnId.Value.ToString(), "报关单,检疫检验报告,COA", this.windTfLotNew.Text.Trim());
                this.StoreRegistrationBylotNew.DataSource = ds;
                this.StoreRegistrationBylotNew.DataBind();
            }
        }

        [AjaxMethod]
        public void ShowRegistration(string customerFaceNbr)
        {
            this.ProductLot.Value = string.Empty;
            this.hidCfnId.Clear();
            this.hidCfnId.Value = customerFaceNbr;
            this.TabPanel1.ActiveTabIndex = 0;
            this.windowRegistration.Show();

        }

    }
}
