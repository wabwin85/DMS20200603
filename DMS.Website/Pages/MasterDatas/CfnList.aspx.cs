using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;


namespace DMS.Website.Pages.MasterDatas
{
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;

    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Common;
    public partial class CfnList : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private ICfns _cfns = Global.ApplicationContainer.Resolve<ICfns>();

        protected void Page_Load(object sender, EventArgs e)
        {



        }

        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //Suppliers 
            RefreshData(e.Start, e.Limit);
        }


        private void RefreshData(int start, int limit)
        {


            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (this.cbCatories.SelectedItem.Value != "" && this.cbCatories.SelectedItem.Text.Trim() != "")
            {
                param.Add("ProductLineBumId", new Guid(this.cbCatories.SelectedItem.Value));
            }
            if (this.cbContain.SelectedItem.Value != "" )
            {
                param.Add("IsContain", this.cbContain.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtCFN.Text.Trim()))
            {
                param.Add("CustomerFaceNbr", this.txtCFN.Text.Trim());
            }

            //param.CustomerFaceNbr = this.txtCFN.Value.ToString().Trim();

            IList<Cfn> query = _cfns.SelectByFilterIsContain(param, (start == -1 ? 0 : start), (limit == -1 ? this.PagingToolBar1.PageSize : limit), out totalCount);

            (this.Store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.Store1.DataSource = query;
            this.Store1.DataBind();

        }

        protected void Store1_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            //you can add own logic for save using one of above data representation and then set e.Cancel=true for canceling Store events

            string json = e.DataHandler.JsonData;
            StoreDataHandler dataHandler = new StoreDataHandler(json);


            ChangeRecords<Cfn> data = dataHandler.CustomObjectData<Cfn>();

            _cfns.SaveChanges(data);

            e.Cancel = true;

        }


        [AjaxMethod]
        public void SearchData()
        {
            if (this.cbCatories.SelectedItem.Value == "" || this.cbCatories.SelectedItem.Text.Trim() == "")
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = GetLocalResourceObject("SearchData.Title").ToString(),
                    Message = GetLocalResourceObject("SearchData.Message").ToString()
                });
                return;
            }

            this.PagingToolBar1.PageIndex = 1;
            RefreshData(0, PagingToolBar1.PageSize);
        }

        [AjaxMethod]
        public void CreateCFNs() //object sender, AjaxEventArgs e
        {
            this.CFNEditor1.CreateCFN();

        }

        ///// <summary>
        ///// 产品线

        ///// </summary>
        ///// <param name="sender">The source of the event.</param>
        ///// <param name="e">The <see cref="Coolite.Ext.Web.StoreRefreshDataEventArgs"/> instance containing the event data.</param>
        //public override void Store_RefreshProductLine(object sender, StoreRefreshDataEventArgs e)
        //{
        //    IList<Lafite.RoleModel.Domain.AttributeDomain> datasource = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine);

        //    if (sender is Store)
        //    {
        //        Store store1 = (sender as Store);
        //        store1.DataSource = datasource;
        //        store1.DataBind();
        //    }
        //}


        /// <summary>
        /// Called when [authenticate].
        /// </summary>
        protected override void OnAuthenticate()
        {
            Permissions pers = this._context.User.GetPermissions();

            //正式使用权限时请使用Visible = false, 更安全;

            this.btnDelete.Visible = pers.IsPermissible(Business.Cfns.Action_Cfns, PermissionType.Delete);
            this.btnInsert.Visible = pers.IsPermissible(Business.Cfns.Action_Cfns, PermissionType.Write);
            this.btnSave.Visible = this.btnInsert.Visible;
            this.btnSearch.Visible = pers.IsPermissible(Business.Cfns.Action_Cfns, PermissionType.Read);


        }
    }
}
