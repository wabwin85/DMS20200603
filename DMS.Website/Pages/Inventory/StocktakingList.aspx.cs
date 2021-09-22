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
using Microsoft.Practices.Unity;
using System.Web.Script.Serialization;


namespace DMS.Website.Pages.Inventory
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.None)]
    public partial class StocktakingList : BasePage
    {
        #region Properties
        IRoleModelContext _context = RoleModelContext.Current;
        private IStocktakingBLL _business = null;

        [Dependency]
        public IStocktakingBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        #endregion

        #region Page Control
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                //this.btnAdd.Visible = IsDealer;
                this.txtStatus.Disabled = true;
                this.BtnAddProduct.Disabled = true;
                this.BtnAdjustDif.Disabled = true;
                this.BtnPrintDif.Disabled = true;
                this.BtnPrintInv.Disabled = true;
                if (IsDealer)
                {
                    this.cbDealer.Disabled = true;
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    //DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_ADJUST);
                    this.GridPanelList.ColumnModel.SetEditable(7, true);

                }
                else
                {
                    //控制查询按钮
                    //Permissions pers = this._context.User.GetPermissions();
                    //this.btnSearch.Visible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_DealerAdj, PermissionType.Read);
                    this.GridPanelList.ColumnModel.SetEditable(7, false);

                }

                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.StocktakingBLL.Action_Stocktaking, PermissionType.Read);
                //this.btnAdd.Visible = pers.IsPermissible(Business.StocktakingBLL.Action_Stocktaking, PermissionType.Write);
            }
        }

        protected void OnAfterSelectedRow(SelectedEventArgs e)
        {
            IDictionary<string, string>[] selectedRows = e.ToDictionarys();

            //添加已选择的数据

            foreach (IDictionary<string, string> row in selectedRows)
            {
                IDictionary<string, string> newRow = new Dictionary<string, string>();

                //PmaId 
                newRow.Add("PmaId", row["PmaId"]);
                //CustomerFaceNbr
                newRow.Add("CustomerFaceNbr", row["CustomerFaceNbr"]);
                //ChineseName
                newRow.Add("ChineseName", row["ChineseName"]);
                //LotID
                newRow.Add("LotID", Guid.NewGuid().ToString());
                //LotNumber
                newRow.Add("LotNumber", null);
                //ExpiredDate
                newRow.Add("ExpiredDate", null);
                //CheckQuantity
                newRow.Add("CheckQuantity", "0");
                this.GridPanel2.AddRecord(newRow);
            }
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            this.StocktakingDialog1.AfterSelectedHandler += OnAfterSelectedRow;
        }


        #endregion

        #region Store Control

        //仓库Store刷新（根据经销商进行联动）
        //protected void WarehouseStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        //{
        //    Warehouses business = new Warehouses();
        //    //System.Diagnostics.Debug.WriteLine("Warehouse's DealerId = " + e.Parameters["DealerId"]);

        //    Guid DealerId = Guid.Empty;
        //    if (e.Parameters["DealerId"] != null || !string.IsNullOrEmpty(e.Parameters["DealerId"].ToString()))
        //    {
        //        DealerId = new Guid(e.Parameters["DealerId"].ToString());
        //    }
        //    IList<Warehouse> list = business.GetAllWarehouseByDealer(DealerId);

        //    if (sender is Store)
        //    {
        //        Store storeWH = (sender as Store);

        //        storeWH.DataSource = list;
        //        storeWH.DataBind();
        //    }
        //}

        //盘点单号Store刷新（根据经销商、仓库进行联动）
        protected void StocktakingNoStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //System.Diagnostics.Debug.WriteLine("Warehouse's DealerId = " + e.Parameters["DealerId"]);

            Hashtable param = new Hashtable();
            Guid DealerId = Guid.Empty;
            Guid WarehouseId = Guid.Empty;
            if (e.Parameters["DealerId"] != null || !string.IsNullOrEmpty(e.Parameters["DealerId"].ToString()))
            {
                param.Add("DMA_ID", e.Parameters["DealerId"].ToString());
            }
            if (e.Parameters["WarehouseId"] != null || !string.IsNullOrEmpty(e.Parameters["WarehouseId"].ToString()))
            {
                param.Add("WHM_ID", e.Parameters["WarehouseId"].ToString());
            }
            DataSet ds = business.GetAllStocktakingNoByCondition(param);

            if (sender is Store)
            {
                Store storeSKHNo = (sender as Store);

                storeSKHNo.DataSource = ds;
                storeSKHNo.DataBind();
            }
        }

        //List页面查询
        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable param = new Hashtable();
            this.txtStatus.Text = "";
            this.BtnAddProduct.Disabled = true;
            this.BtnAdjustDif.Disabled = true;
            this.BtnPrintInv.Disabled = true;
            this.BtnPrintDif.Disabled = true;
            this.GridPanelList.ColumnModel.SetHidden(9, true);
            this.GridPanelList.ColumnModel.SetEditable(7, false);

            if (!string.IsNullOrEmpty(this.cbStocktakingNo.SelectedItem.Value))
            {
                param.Add("StocktakingNo", this.cbStocktakingNo.SelectedItem.Text);

                //设定控件状态
                this.hiddenStocktakingSthID.Value = this.cbStocktakingNo.SelectedItem.Value;
                this.BtnPrintInv.Disabled = false;
                this.BtnPrintDif.Disabled = false;
                //获取单据状态
                Guid header_id = Guid.Empty;
                header_id = new Guid(this.cbStocktakingNo.SelectedItem.Value);
                StocktakingHeader dsSH = business.GetStocktakingHeaderByID(header_id);
                this.txtStatus.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_Stocktaking_Type, dsSH.Status);

                //未调整状态的单据允许编辑修改 @modified by bozhenfei on 20100707
                if (dsSH.Status == "NotAdjust" && IsDealer)
                {
                    this.BtnAddProduct.Disabled = false;
                    this.BtnAdjustDif.Disabled = false;
                    this.GridPanelList.ColumnModel.SetHidden(9, false);//显示删除列
                    this.GridPanelList.ColumnModel.SetEditable(7, true);//允许编辑盘点库存数
                }
            }
            if (!string.IsNullOrEmpty(this.txtArticleNumber.Text))
            {
                param.Add("ArticleNumber", this.txtArticleNumber.Text);
            }

            DataSet ds = business.GetStocktakingListByCondition(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();

        }

        //新增产品页面Store
        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
        }

        protected void DetailStore_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            try
            {
                //获取DetailStore明细数据
                JavaScriptSerializer jss = new JavaScriptSerializer();

                string json = e.DataHandler.JsonData;
                IDictionary<String, List<Dictionary<String, String>>> data = jss.Deserialize<Dictionary<String, List<Dictionary<String, String>>>>(json);
                List<Dictionary<String, String>> created = data["Created"];
                String sth_Id = this.hiddenSTHIDWin.Text;

                business.InsertNewProductLotInfo(created, sth_Id);

                Ext.Msg.Alert(GetLocalResourceObject("ListSearch.Alert.Title").ToString(), GetLocalResourceObject("DetailStore_BeforeStoreChanged.Alert.Body").ToString()).Show();
                this.DetailWindow.Hide();
                this.GridPanelList.Reload();
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert(GetLocalResourceObject("ListSearch.Alert.Title").ToString(), GetLocalResourceObject("DetailStore_BeforeStoreChanged.Exception.Alert.Body").ToString()).Show();
                throw new Exception(ex.Message);
            }

            e.Cancel = true;
        }

        #endregion

        #region Ajax Method

        [AjaxMethod]
        public void AddStocktaking()
        {
            StocktakingHeader mainData = new StocktakingHeader();
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value) && !string.IsNullOrEmpty(this.cbWarehouse.SelectedItem.Value))
            {
                //准备Header表信息
                mainData.Id = Guid.NewGuid();
                DateTime nowTime = DateTime.Now;  
                mainData.DealerDmaId = new Guid(this.cbDealer.SelectedItem.Value);
                mainData.WarehouseWhmId = new Guid(this.cbWarehouse.SelectedItem.Value);
                mainData.Status = StocktakingStatus.NotAdjust.ToString();
                mainData.StocktakingNo = (new AutoNumberBLL()).GetNextAutoNumberForST(mainData.DealerDmaId, OrderType.Next_StocktakingNbr);                
                //准备必要的数据
                Hashtable param = new Hashtable();
                param.Add("DMA_ID", this.cbDealer.SelectedItem.Value);
                param.Add("WHM_ID", this.cbWarehouse.SelectedItem.Value);
                param.Add("STH_ID", mainData.Id.ToString());
                param.Add("StocktakingNO", mainData.StocktakingNo);

                //新增盘点单
                business.AddStocktaking(mainData, param);
            }
        }

        [AjaxMethod]
        public void SaveItem(String txtStockTakingQty)
        {
            //准备必要的数据            
            int dif = Convert.ToInt32(txtStockTakingQty) - Convert.ToInt32(this.hiddenCurrentEditActualQty.Text);
            Hashtable param = new Hashtable();
            param.Add("SLT_ID", this.hiddenCurrentEditID.Text);
            param.Add("CheckQty", dif.ToString());

            if (business.UpdateCheckQuantity(param))
            {
                this.ResultStore.DataBind();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("ListSearch.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void DeleteDetailItem()
        {
            this.GridPanel2.DeleteSelected();
        }

        [AjaxMethod]
        public void DeleteListItem(String LotId)
        {
            bool result = false;

            try
            {
                result = business.DeleteListItem(new Guid(LotId));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                this.ResultStore.DataBind();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("ListSearch.Alert.Title").ToString(), GetLocalResourceObject("DeleteListItem.Alert.Body").ToString()).Show();
            }
        }
        [AjaxMethod]
        public void Cancel()
        {

        }

        [AjaxMethod]
        public void DoDifAdjust(String SthId)
        {
            bool result = false;
            String sthId = this.hiddenStocktakingSthID.Value.ToString();
            try
            {
                result = business.DoDifAdjust(SthId);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

        }
        [AjaxMethod]
        public void ShowDetails()
        {
            //初始化detail窗口,因为只有dealer才可以新增。
            if (IsDealer)
            {
                if (!string.IsNullOrEmpty(this.cbStocktakingNo.SelectedItem.Value))
                {
                    this.hiddenDealerIDWin.Value = this.cbDealer.SelectedItem.Value;
                    this.txtDealerWin.Text = this.cbDealer.SelectedItem.Text;
                    this.hiddenWarehouseIDWin.Value = this.cbWarehouse.SelectedItem.Value;
                    this.txtWarehouseWin.Text = this.cbWarehouse.SelectedItem.Text;
                    this.hiddenSTHIDWin.Value = this.cbStocktakingNo.SelectedItem.Value;
                    this.txtStocktakingNoWin.Value = this.cbStocktakingNo.SelectedItem.Text;

                    this.DetailWindow.Show();
                }
                else
                {
                    Ext.Msg.Alert(GetLocalResourceObject("ListSearch.Alert.Title").ToString(), GetLocalResourceObject("ShowDetails.Alert.Body").ToString()).Show();
                }
            }
        }

        [AjaxMethod]
        public void PrintInvReport(String SthId)
        {

        }

        [AjaxMethod]
        public void PrintDifReport(String SthId)
        {

        }

        [AjaxMethod]
        public void GetStocktakingDate(string SthId)
        {
            if (SthId == string.Empty)
            {
                Ext.Msg.Alert(GetLocalResourceObject("AddStocktaking.Confirm.Title").ToString(), GetLocalResourceObject("GetStocktakingDate.Alert.Body").ToString()).Show();
            }
            else
            {
                StocktakingHeader header = business.GetStocktakingHeaderByID(new Guid(SthId));
                if (header.CreateDate.HasValue)
                    this.txtStocktakingDate.Text = header.CreateDate.Value.ToString();
            }
        }

        #endregion


    }
}
