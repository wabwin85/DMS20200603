using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Inventory
{
    using DMS.Website.Common;
    using Coolite.Ext.Web;
    using DMS.Business;
    using DMS.Model;
    using Lafite.RoleModel.Security;
    using DMS.Common;
    using Lafite.RoleModel.Security.Authorization;
    using Microsoft.Practices.Unity;
    using System.Data;

    public partial class WarehouseMaint : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IWarehouses _business = null;
        [Dependency]
        public IWarehouses business
        {
            get { return _business; }
            set { _business = value; }
        }
        #endregion

        private string _guidDealerID;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                //非经销商用户不得修改，所以隐藏修改数据的三个按钮。


                bool isDealer = (_context.User.IdentityType == SR.Consts_System_Dealer_User);

                Permissions pers = this._context.User.GetPermissions();
                this.btnSave.Visible = pers.IsPermissible(Business.Warehouses.Action_DealerWarehouseMaint, PermissionType.Write);
                this.btnInsert.Visible = pers.IsPermissible(Business.Warehouses.Action_DealerWarehouseMaint, PermissionType.Write);
                this.btnDelete.Visible = pers.IsPermissible(Business.Warehouses.Action_DealerWarehouseMaint, PermissionType.Write);
                this.btnSearch.Visible = pers.IsPermissible(Business.Warehouses.Action_DealerWarehouseMaint, PermissionType.Read);

                //btnSave.Visible = isDealer;
                //btnInsert.Visible = isDealer;
                //btnDelete.Visible = isDealer;

                _guidDealerID = _context.User.CorpId.ToString();

                if (IsDealer)
                {
                    //Warehouses bll = new Warehouses();
                    Hashtable ht = new Hashtable();
                    IList<Warehouse> query;

                    ht.Add("DmaId", RoleModelContext.Current.User.CorpId);
                    ht.Add("Type", "DefaultWH");
                    query = this.business.GetWarehousesByHashtable(ht);
                    if (query.Count >= 1)
                    {
                        this.hiddenHasDefaultWarehouse.Value = "True";
                    }
                    else
                    {
                        this.hiddenHasDefaultWarehouse.Value = "False";
                    }
                    this.cbDealer.Disabled = true;
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();

                }
                else
                {
                    //this.
                }
            }
        }


        protected void Store1_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            //Suppliers 
            RefreshData(e.Start, e.Limit);
        }


        private void RefreshData(int start, int limit)
        {

            //Warehouses bll = new Warehouses();
            Hashtable hashtable = new Hashtable();
            hashtable.Clear();

            int totalCount = 0;

            IList<Warehouse> query;
            /*
             * 经销商用户和美敦力用户作不同处理。美敦力用户根据其管辖的医院，可以看到相关经销商的仓库（或其他数据）。

             * 规则是：经销商得到授权的产品线和医院与美敦力用户的产品线与医院有交集。

             */
            //if (IsDealer)
            //{
            //    //经销商用户

            //    hashtable.Add("DmaId", RoleModelContext.Current.User.CorpId);
            //    hashtable.Add("Name", (this.txtFilterWarehouseName.Text.Trim() == string.Empty) ? null : this.txtFilterWarehouseName.Text.Trim());
            //    hashtable.Add("Address", this.txtFilterAddress.Text.Trim() == string.Empty ? null : this.txtFilterAddress.Text.Trim());
            //}
            //else
            //{
            //    //美敦力用户

            //    hashtable.Add("MedtronicUserID", RoleModelContext.Current.User.Id);
            //    if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            //    {
            //        hashtable.Add("DmaId", this.cbDealer.SelectedItem.Value);
            //    }
            //    hashtable.Add("Name", (this.txtFilterWarehouseName.Text.Trim() == string.Empty) ? null : this.txtFilterWarehouseName.Text.Trim());
            //    hashtable.Add("Address", this.txtFilterAddress.Text.Trim() == string.Empty ? null : this.txtFilterAddress.Text.Trim());
            //}

            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                hashtable.Add("DmaId", this.cbDealer.SelectedItem.Value);
            }

            if (!string.IsNullOrEmpty(this.txtFilterWarehouseName.Text))
            {
                hashtable.Add("Name", this.txtFilterWarehouseName.Text);
            }

            if (!string.IsNullOrEmpty(this.txtFilterAddress.Text))
            {
                hashtable.Add("Address", this.txtFilterAddress.Text);
            }

            try
            {
                query = business.GetWarehousesByHashtable(hashtable, (start == -1 ? 0 : start), (limit == -1 ? this.PagingToolBar1.PageSize : limit), out totalCount);

                (this.Store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

                this.Store1.DataSource = query;
                this.Store1.DataBind();
                CheckShowDefaultWarehouse(query);
            }
            catch (Exception ex)
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Title = GetLocalResourceObject("RefreshData.Msg.Show.Title").ToString(),
                    Message = GetLocalResourceObject("RefreshData.Msg.Show.Message").ToString() + ex.Message + " <br /> Source:" + ex.Source + " <br /> Stack Trace:" + ex.StackTrace,
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR
                });
            }
        }

        private void CheckShowDefaultWarehouse(IList<Warehouse> lw)
        {
            Boolean hasDefaultWH = false;
            foreach (Warehouse w in lw)
            {
                if (w.Type != null)
                {
                    if (w.Type.ToLower() == "defaultwh")
                    {
                        hasDefaultWH = true;
                        break;
                    }
                }
            }
            if (hasDefaultWH)
            {
                this.hiddenShowDefaultWarehouse.Value = "True";
            }
            else
            {
                this.hiddenShowDefaultWarehouse.Value = "False";
            }
        }

        protected void Store1_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            //you can add own logic for save using one of above data representation and then set e.Cancel=true for canceling Store events

            string json = e.DataHandler.JsonData;

            StoreDataHandler dataHandler = new StoreDataHandler(json);


            ChangeRecords<Warehouse> data = dataHandler.CustomObjectData<Warehouse>();

            //Warehouses bll = new Warehouses();
            business.SaveChanges(data);

            e.Cancel = true;
        }


        [AjaxMethod]
        public void SearchData()
        {
            this.PagingToolBar1.PageIndex = 1;
            RefreshData(0, PagingToolBar1.PageSize);
        }

        /// <summary>
        /// 到Editor界面上设置新建仓库的记录ID和经销商的记录ID
        /// </summary>
        /// <param></param>
        /// <returns></returns>
        [AjaxMethod]
        public void createNewObjects()
        {
            this.WarehouseEditor1.CreateWarehouse();
        }

        [AjaxMethod]
        public void sethospitalname()
        {
            this.WarehouseEditor1.SetHospitalName();
        }

        /// <summary>
        /// 导出仓库信息
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ExportExcel(object sender, EventArgs e)
        {
            DataTable dt = this.GetWarehouse().Tables[0];//dt是从后台生成的要导出的datatable
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

        protected DataSet GetWarehouse()
        {
            Hashtable hashtable = new Hashtable();
            hashtable.Clear();

            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                hashtable.Add("DmaId", this.cbDealer.SelectedItem.Value);
            }

            if (!string.IsNullOrEmpty(this.txtFilterWarehouseName.Text))
            {
                hashtable.Add("Name", this.txtFilterWarehouseName.Text);
            }

            if (!string.IsNullOrEmpty(this.txtFilterAddress.Text))
            {
                hashtable.Add("Address", this.txtFilterAddress.Text);
            }

            DataSet ds = business.GetWarehousesForExport(hashtable);
            return ds;

        }
    }
}
