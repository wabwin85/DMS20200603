using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Collections;
using System.Data;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.MasterDatas
{
    using DMS.Website.Common;
    using Coolite.Ext.Web;
    using DMS.Business;
    using DMS.Business.Cache;
    using DMS.Model;
    using DMS.Model.Data;
    using Lafite.RoleModel.Security;
    using DMS.Common;


    public partial class DealerList : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IDealerMasters _dealers = Global.ApplicationContainer.Resolve<IDealerMasters>();


        protected void Page_Load(object sender, EventArgs e)
        {
            //IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_Dealer_Type);
            //Store DealerTypeStore = new Store { ID = "DealerTypeStore" };
            //this.Page.Form.Controls.Add(DealerTypeStore);
            //DealerTypeStore.Reader.Add(new JsonReader());

            //((Coolite.Ext.Web.JsonReader)DealerTypeStore.Reader[0]).ReaderID = "Key";
            //DealerTypeStore.Reader[0].Fields.Add(new Coolite.Ext.Web.RecordField("Key"));
            //DealerTypeStore.Reader[0].Fields.Add(new Coolite.Ext.Web.RecordField("Value"));
            //DealerTypeStore.DataSource = dictsCompanyType;
            //DealerTypeStore.DataBind();
            //cmbEditGrade.StoreID = DealerTypeStore.ID;

            //Add By SongWeiming on 2015-09-14 For Dealer License Application and Approval

            if (IsDealer)
            {
                this.hidCorpType.Text = RoleModelContext.Current.User.CorpType;

            }

            if (!IsPostBack && !Ext.IsAjaxRequest)
            {

                //如果是经销商，则页面上的“刷新经销商缓存”、“新建”、“保存”、“删除选中记录”按钮不可见
                this.btnRefreshDealerCache.Visible = !IsDealer;
                //this.btnInsert.Visible = !IsDealer;
                //this.btnSave.Visible = !IsDealer;
                //this.btnDelete.Visible = !IsDealer;
                this.btnInsert.Visible = false;
                this.btnSave.Visible = false;
                this.btnDelete.Visible = false;

                if (IsDealer)
                {
                    //如果是经销商用户，则不可以选择经销商，只能查看自己
                    //this.Bind_DealerList(this.DealerStore);
                    this.cbDealer.Disabled = true;
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();

                    this.cboFilterDealterType.Disabled = true;
                    this.cboFilterDealterType.SelectedItem.Value = RoleModelContext.Current.User.CorpType.ToString();
                }
                else
                {
                    //this.Bind_DealerList(this.DealerStore);
                    this.cbDealer.Disabled = false;
                    this.cboFilterDealterType.Disabled = false;
                }
            }

            //End Add By SongWeiming


        }

        protected void DealerTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_Dealer_Type);
            if (sender is Store)
            {
                Store DealerTypeStore = (sender as Store);

                DealerTypeStore.DataSource = dictsCompanyType;
                DealerTypeStore.DataBind();
            }

        }

        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //Suppliers 
            RefreshData(e.Start, e.Limit);
        }

        private void RefreshData(int start, int limit)
        {


            int totalCount = 0;

            //DealerMaster param = new DealerMaster();
            Hashtable param = new Hashtable();


            //Hospital param = new Hospital();
            //原来使用的文本框作模糊查询

            //param.ChineseName = (this.txtFilterChineseName.Text.Trim() == string.Empty) ? null : this.txtFilterChineseName.Text.Trim();
            //现在使用可以编辑和检索的下拉列表框

            if (!string.IsNullOrEmpty(cbDealer.SelectedItem.Value))
            {
                //param.Id = new Guid(cbDealer.SelectedItem.Value);
                param.Add("DealerId", new Guid(cbDealer.SelectedItem.Value));
            }
            //param.SapCode = this.txtFilterSAPCode.Text.Trim() == string.Empty ? null : this.txtFilterSAPCode.Text.Trim();
            //param.DealerType = this.cboFilterDealterType.SelectedItem.Value == string.Empty ? null : this.cboFilterDealterType.SelectedItem.Value;
            //param.Address = this.txtFilterAddress.Text.Trim() == string.Empty ? null : this.txtFilterAddress.Text.Trim();

            param.Add("SapCode", this.txtFilterSAPCode.Text.Trim() == string.Empty ? null : this.txtFilterSAPCode.Text.Trim());
            param.Add("DealerType", this.cboFilterDealterType.SelectedItem.Value == string.Empty ? null : this.cboFilterDealterType.SelectedItem.Value);
            param.Add("Address", this.txtFilterAddress.Text.Trim() == string.Empty ? null : this.txtFilterAddress.Text.Trim());

            //IList<DealerMaster> query = bll.QueryForHospital(param, start, limit, out totalCount);
            DataSet ds = _dealers.QueryForDealerMaster(param, (start == -1 ? 0 : start), (limit == -1 ? this.PagingToolBar1.PageSize : limit), out totalCount);

            (this.Store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.Store1.DataSource = ds;
            this.Store1.DataBind();

        }

        protected void Store1_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            //you can add own logic for save using one of above data representation and then set e.Cancel=true for canceling Store events

            string json = e.DataHandler.JsonData;
            StoreDataHandler dataHandler = new StoreDataHandler(json);


            ChangeRecords<DealerMaster> data = dataHandler.CustomObjectData<DealerMaster>();

            DealerMasters bll = new DealerMasters();
            bll.SaveChanges(data);

            //Clears the dealer's cache
            DMS.Business.Cache.DealerCacheHelper.FlushCache();

            e.Cancel = true;
        }

        protected void ExportLicenseToExcel(object sender, EventArgs e)
        {
            DataTable dt = this.GetDealerLicense().Tables[0];//dt是从后台生成的要导出的datatable
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=result.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }

        protected DataSet GetDealerLicense()
        {
            Hashtable param = new Hashtable();
            param.Add("SapCode", this.txtFilterSAPCode.Text.Trim() == string.Empty ? null : this.txtFilterSAPCode.Text.Trim());
            param.Add("DealerType", this.cboFilterDealterType.SelectedItem.Value == string.Empty ? null : this.cboFilterDealterType.SelectedItem.Value);
            param.Add("Address", this.txtFilterAddress.Text.Trim() == string.Empty ? null : this.txtFilterAddress.Text.Trim());


            //BSC用户可以看所有经销商信息，T1、T2经销商用户只能看自己的发货单,LP可以看自己的以及下属经销商信息
            if (IsDealer  )
            {
                if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                {
                    param.Add("LPId", RoleModelContext.Current.User.CorpId);
                }
                else
                {
                    param.Add("DealerId", RoleModelContext.Current.User.CorpId);
                }                
            }
            DataSet ds = _dealers.QueryDealerLicenseForExport(param);

            return ds;
        }

        //lijie add 2016-04-13
        protected void ExportLicenseCfnToExcel(object sender, EventArgs e)
        {
            DataTable dt = this.GetDealerLicenseCfn().Tables[0];//dt是从后台生成的要导出的datatable
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=result.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }
        protected DataSet GetDealerLicenseCfn()
        {

            Hashtable param = new Hashtable();
            if(!string.IsNullOrEmpty(cbDealer.SelectedItem.Value))
            {
                param.Add("DmaId", cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(txtFilterAddress.Text))
            {
                param.Add("Address", txtFilterAddress.Text);
            }
            if (!string.IsNullOrEmpty(txtFilterSAPCode.Text))
            {
                param.Add("Code", txtFilterSAPCode.Text);
            }
            
            if (!string.IsNullOrEmpty(cboFilterDealterType.SelectedItem.Value))
            {
                param.Add("DmaType", cboFilterDealterType.SelectedItem.Value);
            }
            
            DataSet ds = _dealers.QueryDealerLicenseCfnForExport(param);
            ds.Tables[0].Columns.Remove("DmaId");
            ds.Tables[0].Columns.Remove("Address");
            return ds;
        }

        [AjaxMethod]
        public void SearchData()
        {
            this.PagingToolBar1.PageIndex = 1;
            RefreshData(0, PagingToolBar1.PageSize);
        }

        [AjaxMethod]
        public void CreateDealerMasters() //object sender, AjaxEventArgs e
        {
            this.DealerMasterEditor1.CreateDealerMaster();
        }

        [AjaxMethod]
        public void RefreshDealerCache()
        {
            string rtnVal = string.Empty;
            DealerCacheHelper.ReloadDealers();
            this.hidRtnVal.Text = "Success";
        }

        //public void SaveChanged(BeforeStoreChangedEventArgs e)
        //{

        //    HttpContext ct = HttpContext.Current;

        //    IRoleModelContext _context = RoleModelContext.Current;

        //    Lafite.RoleModel.Security.LoginUser user = _context.User;

        //    string userid = user.Id;

        //    if (_context.UserName == userid)
        //    {
        //        WebTools.alert("hello");
        //    }
        //}



        /// <summary>
        /// Called when [authenticate].
        /// </summary>
        protected override void OnAuthenticate()
        {
            Permissions pers = this._context.User.GetPermissions();

            //正式使用权限时请使用Visible = false, 更安全;

            this.btnDelete.Visible = pers.IsPermissible(Business.DealerMasters.Action_DealerMasters, PermissionType.Delete);
            this.btnInsert.Visible = pers.IsPermissible(Business.DealerMasters.Action_DealerMasters, PermissionType.Write);
            this.btnSave.Visible = this.btnInsert.Visible;
            this.btnSearch.Visible = pers.IsPermissible(Business.DealerMasters.Action_DealerMasters, PermissionType.Read);

        }

        /// <summary>
        /// the StoreRefershData method for Dealer form cache
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="Coolite.Ext.Web.StoreRefreshDataEventArgs"/> instance containing the event data.</param>
        public override void Store_DealerList(object sender, StoreRefreshDataEventArgs e)
        {
            //Clears the dealer's cache
            DMS.Business.Cache.DealerCacheHelper.FlushCache();

            //Gets all dealers
            IList<DealerMaster> dataSource = DMS.Business.Cache.DealerCacheHelper.GetDealers();
            var query = from p in dataSource
                        where p.HostCompanyFlag != true
                        select p;

            dataSource = query.ToList<DealerMaster>();
            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dataSource;
                store1.DataBind();
            }
        }

        [AjaxMethod]
        public void Show(string dealerId)
        {
            Guid id = new Guid(dealerId);
            this.DealerLicenseEditor1.Show(id);

        }
    }
}
