using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using DMS.Business;
using Coolite.Ext.Web;
using DMS.Common;
using DMS.Model;
using System.Collections;
using System.Data;
using DMS.Business.Cache;
using DMS.Model.Data;
using Microsoft.Practices.Unity;

namespace DMS.Website.Pages.Transfer
{
    public partial class TransferCommit : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();
        private ITransferBLL _business = null;
        [Dependency]
        public ITransferBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                //this.btnInsert.Disabled = !IsDealer;
                this.btnInsert.Visible = IsDealer;

                this.Bind_ProductLine(this.ProductLineStore);
                this.Bind_DealerListByFilter(this.DealerStore,false);
                this.Bind_DealerListByFilter(this.DealerToStore, false);
                this.Bind_TransferStatus(this.TransferStatusStore);

                if (IsDealer)
                {
                    //this.cbDealerFrom.Disabled = true;
                    //this.cbDealerFrom.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    this.hidInitDealerFromId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_TRANSFER);

                }
                else
                {
                    
                }

                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.TransferBLL.Action_TransferRentConsignment, PermissionType.Read);
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            this.TransferDialog1.GridStore = this.DetailStore;
        }

        protected void Store_DealerToList(object sender, StoreRefreshDataEventArgs e)
        {
            Guid DealerFromId = Guid.Empty;
            if (e.Parameters["DealerFromId"] != null && !string.IsNullOrEmpty(e.Parameters["DealerFromId"].ToString()))
            {
                DealerFromId = new Guid(e.Parameters["DealerFromId"].ToString());
            }

            DealerMasters business = new DealerMasters();

            IList<DealerMaster> dicts = business.QueryDealerMasterForTransferByDealerFromId(DealerFromId);

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dicts;
                store1.DataBind();
            }
        }


        protected void Store_DealerToWinList(object sender, StoreRefreshDataEventArgs e)
        {
            Guid DealerFromId = Guid.Empty;
            if (e.Parameters["DealerFromId"] != null && !string.IsNullOrEmpty(e.Parameters["DealerFromId"].ToString()))
            {
                DealerFromId = new Guid(e.Parameters["DealerFromId"].ToString());
            }

            DealerMasters business = new DealerMasters();

            IList<DealerMaster> dicts = business.SelectSameLevelDealer(DealerFromId);

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dicts;
                store1.DataBind();
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //ITransferBLL business = new TransferBLL();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLine", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealerFrom.SelectedItem.Value))
            {
                param.Add("FromDealerDmaId", this.cbDealerFrom.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealerTo.SelectedItem.Value))
            {
                param.Add("ToDealerDmaId", this.cbDealerTo.SelectedItem.Value);
            }
            if (!this.txtStartDate.IsNull)
            {
                param.Add("TransferDateStart", this.txtStartDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtEndDate.IsNull)
            {
                param.Add("TransferDateEnd", this.txtEndDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtTransferNumber.Text))
            {
                param.Add("TransferNumber", this.txtTransferNumber.Text);
            }
            if (!string.IsNullOrEmpty(this.cbTransferStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbTransferStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                param.Add("Cfn", this.txtCFN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                param.Add("Upn", this.txtUPN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            {
                param.Add("LotNumber", this.txtLotNumber.Text);
            }
            DataSet ds = business.QueryTransferRentConsignment(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this.hiddenTransferId.Text);

            //ITransferBLL business = new TransferBLL();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            param.Add("hid", tid);

            DataSet ds = business.QueryTransferLot(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.DetailStore.DataSource = ds;
            this.DetailStore.DataBind();

        }

        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this.hiddenTransferId.Text);
            int totalCount = 0;
            DataSet ds = _logbll.QueryPurchaseOrderLogByHeaderId(tid, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();
        }


        protected void WarehouseStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            this.Bind_WarehouseByDealerAndType(this.WarehouseStore, new Guid(hiddenDealerToId.Text), "Consignment");
        }

        protected void Bind_DealerToList(Store store)
        {
            Guid dealerId = new Guid(this.hiddenDealerFromId.Text);
            IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();
            DealerMaster dealer = DealerCacheHelper.GetDealerById(dealerId);

            var query = from d in dataSource where d.Id.Value != dealer.Id.Value && d.ParentDmaId.HasValue && d.ParentDmaId.Value == dealer.ParentDmaId.Value orderby d.ChineseName select d;

            store.DataSource = query.ToList<DealerMaster>();
            store.DataBind();

        }

        protected void Bind_TransferStatus(Store store)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_DealerTransfer_Status);

            var query = from t in dicts where t.Key != DealerTransferStatus.Cancelled.ToString() select t;
            query = from t in query where t.Key != DealerTransferStatus.OntheWay.ToString() select t;
            store.DataSource = query;
            store.DataBind();
        }



        protected void ShowDialog(object sender, AjaxEventArgs e)
        {
            //判断是否符合打开对话框的条件
            //1、经销商 2、产品线
            if (string.IsNullOrEmpty(this.cbDealerFromWin.SelectedItem.Value) || string.IsNullOrEmpty(this.hiddenDealerToId.Text) || string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
            {
                Ext.Msg.Alert(GetLocalResourceObject("ShowDialog.Alert.Title").ToString(), GetLocalResourceObject("ShowDialog.Alert.Body").ToString()).Show();
                return;
            }
            Guid id = new Guid(e.ExtraParams["TransferId"].ToString());
            System.Diagnostics.Debug.WriteLine("ShowDialog : " + id.ToString());
            if (string.IsNullOrEmpty(this.cbWarehouseWin.SelectedItem.Value))
            {
                Ext.Msg.Alert(GetLocalResourceObject("ToWarehouseIdEdit.Alert.Title").ToString(), GetLocalResourceObject("ToWarehouseIdEdit.Alert.Body").ToString()).Show();
                return;
            }
            else
            {
                this.TransferDialog1.Show(TransferType.RentConsignment, id, new Guid(this.cbDealerFromWin.SelectedItem.Value), new Guid(this.cbProductLineWin.SelectedItem.Value), new Guid(this.hiddenDealerToId.Text), new Guid(this.cbWarehouseWin.SelectedItem.Value));
            }
        }

        protected void ShowDetails(object sender, AjaxEventArgs e)
        {
            //初始化detail窗口,因为只有dealer才可以新增，因此打开页面默认选中session中的经销商

            this.hiddenTransferId.Text = string.Empty;
            this.hiddenDealerFromId.Text = string.Empty;
            this.hiddenDealerToId.Text = string.Empty;
            this.hiddenProductLineId.Text = string.Empty;
            this.hiddenDealerToDefaultWarehouseId.Text = string.Empty;

            //this.txtDealerToWin.Text = string.Empty;
            this.txtNumber.Text = string.Empty;
            this.txtDate.Text = string.Empty;
            this.txtStatus.Text = string.Empty;

            //added by bozhenfei on 20100607
            this.hiddenCurrentEdit.Text = string.Empty;
            this.hiddenIsEditting.Text = string.Empty;
            //end

            Guid id = new Guid(e.ExtraParams["TransferId"].ToString());

            //ITransferBLL business = new TransferBLL();
            DMS.Model.Transfer mainData = null;

            //若id为空，说明为新增，则生成新的id，并新增一条记录

            if (id == Guid.Empty)
            {
                id = Guid.NewGuid();
                this.hiddenTransferId.Text = id.ToString();
                mainData = new DMS.Model.Transfer();
                mainData.Id = id;
                mainData.Type = TransferType.RentConsignment.ToString();
                mainData.Status = DealerTransferStatus.Draft.ToString();
                //mainData.TransferNumber = DateTime.Now.ToString("yyyyMMddHHmmss");
                //mainData.TransferDate = DateTime.Now;
                //默认为session中的经销商

                mainData.FromDealerDmaId = RoleModelContext.Current.User.CorpId.Value;
                
                business.Insert(mainData);
            }
            //根据ID查询主表数据，并初始化页面

            //business = new TransferBLL();
            mainData = business.GetObject(id);
            this.hiddenTransferId.Text = mainData.Id.ToString();
            if (mainData.FromDealerDmaId != null)
            {
                this.hiddenDealerFromId.Text = mainData.FromDealerDmaId.Value.ToString();
            }
            if (mainData.ToDealerDmaId != null)
            {
                this.hiddenDealerToId.Text = mainData.ToDealerDmaId.Value.ToString();
                //this.txtDealerToWin.Text = DealerCacheHelper.GetDealerName(mainData.ToDealerDmaId.Value);
                //得到借入经销商默认分仓库ID
                //InvTrans invTrans = new InvTrans();
                //try
                //{
                //    this.hiddenDealerToDefaultWarehouseId.Text = invTrans.GetDefaultWarehouse(mainData.ToDealerDmaId.Value).ToString();
                //}
                //catch
                //{

                //}
                this.Bind_WarehouseByDealerAndType(this.WarehouseStore, mainData.ToDealerDmaId.Value, "Consignment");
            }
            if (mainData.ProductLineBumId != null)
            {
                this.hiddenProductLineId.Text = mainData.ProductLineBumId.Value.ToString();
            }
            this.txtNumber.Text = mainData.TransferNumber;
            if (mainData.TransferDate != null)
            {
                this.txtDate.Text = mainData.TransferDate.Value.ToString("yyyyMMdd");
            }
            this.txtStatus.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_DealerTransfer_Status, mainData.Status);

            //窗口状态控制

            //this.cbDealerFromWin.Disabled = true;
            this.cbProductLineWin.Disabled = true;
            //this.txtDealerToWin.Disabled = true;
            this.DraftButton.Disabled = true;
            this.SubmitButton.Disabled = true;
            //this.RevokeButton.Disabled = true;
            this.DeleteButton.Disabled = true;
            this.AddItemsButton.Disabled = true;
            this.GridPanel2.ColumnModel.SetHidden(7, true);
            this.GridPanel2.ColumnModel.SetHidden(8, true);
            this.GridPanel2.ColumnModel.SetHidden(10, true);
            this.cbWarehouseWin.Hidden = true;
            this.GridPanel2.ColumnModel.SetHidden(12, true);
            //this.GridPanel2.ColumnModel.SetEditable(11, false);
            this.GridPanel2.ColumnModel.SetEditable(9, false);
            //this.Bind_WarehouseByDealerAndType(this.WarehouseStore, mainData.FromDealerDmaId.Value,"Consignment");

            if (IsDealer)
            {
                if (mainData.Status == DealerTransferStatus.Draft.ToString())
                {
                    this.cbDealerFromWin.Disabled = false;
                    this.cbDealerToWin.Disabled = false;
                    this.cbProductLineWin.Disabled = false;
                    //this.txtDealerToWin.Disabled = false;
                    this.DraftButton.Disabled = false;
                    this.SubmitButton.Disabled = false;
                    this.DeleteButton.Disabled = false;
                    if (mainData.FromDealerDmaId != null && mainData.ToDealerDmaId != null && mainData.ProductLineBumId != null && this.hiddenDealerToDefaultWarehouseId.Text != string.Empty)
                    {
                        this.AddItemsButton.Disabled = false;
                    }
                    this.GridPanel2.ColumnModel.SetEditable(11, true);
                    this.GridPanel2.ColumnModel.SetHidden(11, false);
                    this.GridPanel2.ColumnModel.SetHidden(12, false);
                    this.GridPanel2.ColumnModel.SetHidden(7, false);
                    this.GridPanel2.ColumnModel.SetHidden(10, false);
                    Renderer r = new Renderer();
                    r.Fn = "SetCellCssEditable";
                    this.GridPanel2.ColumnModel.SetRenderer(7, r);
                    this.GridPanel2.ColumnModel.SetEditable(9, true);
                }
                else
                {
                    this.cbDealerFromWin.Disabled = true;
                    this.cbDealerToWin.Disabled = true;
                    this.GridPanel2.ColumnModel.SetHidden(8, false);
                    this.GridPanel2.ColumnModel.SetHidden(10, false);
                    this.GridPanel2.ColumnModel.SetEditable(10, false);
                    Renderer r = new Renderer();
                    r.Fn = "SetCellCssNonEditable";
                    this.GridPanel2.ColumnModel.SetEditable(9, false);
                    this.GridPanel2.ColumnModel.SetRenderer(7, r);
                    this.GridPanel2.ColumnModel.SetHidden(12, true);
                    this.GridPanel2.ColumnModel.SetHidden(11, true);
                }
            }
            else
            {
                this.GridPanel2.ColumnModel.SetHidden(8, false);
            }
            //显示窗口
            this.DetailWindow.Show();
        }

        [AjaxMethod]
        public void SaveDraft()
        {
            //ITransferBLL business = new TransferBLL();
            //更新字段
            DMS.Model.Transfer mainData = business.GetObject(new Guid(this.hiddenTransferId.Text));
            if (!string.IsNullOrEmpty(this.cbDealerFromWin.SelectedItem.Value))
            {
                mainData.FromDealerDmaId = new Guid(this.cbDealerFromWin.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
            {
                mainData.ProductLineBumId = new Guid(this.cbProductLineWin.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.hiddenDealerToId.Text))
            {
                mainData.ToDealerDmaId = new Guid(this.hiddenDealerToId.Text);
            }

            bool result = false;

            try
            {
                mainData.TransferUsrUserID = new Guid(this._context.User.Id);
                result = business.SaveDraft(mainData);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("SaveDraft.True.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.False.Alert.Title").ToString(), GetLocalResourceObject("SaveDraft.False.Alert.Body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void DeleteDraft()
        {
            //ITransferBLL business = new TransferBLL();

            bool result = false;

            try
            {
                result = business.DeleteDraft(new Guid(this.hiddenTransferId.Text));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                Ext.Msg.Alert(GetLocalResourceObject("DeleteDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DeleteDraft.True.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("DeleteDraft.False.Alert.Title").ToString(), GetLocalResourceObject("DeleteDraft.False.Alert.Body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void CheckDealer()
        {

            if (string.IsNullOrEmpty(this.cbDealerToWin.SelectedItem.Value))
            {
                this.hiddenDealerToId.Text = string.Empty;
                this.hiddenDealerToDefaultWarehouseId.Text = string.Empty;
            }
            else if (this.cbDealerToWin.SelectedItem.Text == this.cbDealerFromWin.SelectedItem.Text)
            {
                this.hiddenDealerToId.Text = string.Empty;
                this.hiddenDealerToDefaultWarehouseId.Text = string.Empty;
                this.AddItemsButton.Disabled = true;
                Ext.Msg.Alert(GetLocalResourceObject("ShowDialog.Alert.Title").ToString(), GetLocalResourceObject("ShowDialog.Alert.Title1").ToString()).Show();
            }
            else
            {

                //ITransferBLL business = new TransferBLL();

                DealerMaster dealer = business.GetDealerMasterByName(this.cbDealerToWin.SelectedItem.Text);

                if (dealer != null)
                {
                    if (dealer.ActiveFlag.Value)
                    {
                        this.hiddenDealerToId.Text = dealer.Id.Value.ToString();
                        //取得该经销商的默认仓库
                        InvTrans invTrans = new InvTrans();
                        try
                        {
                            this.hiddenDealerToDefaultWarehouseId.Text = invTrans.GetDefaultWarehouse(dealer.Id.Value).ToString();
                        }
                        catch
                        {
                            this.hiddenDealerToId.Text = string.Empty;
                            this.hiddenDealerToDefaultWarehouseId.Text = string.Empty;
                            Ext.Msg.Alert(GetLocalResourceObject("ShowDialog.Alert.Title").ToString(), GetLocalResourceObject("ShowDialog.Alert.Title2").ToString()).Show();
                        }
                    }
                    else
                    {
                        this.hiddenDealerToId.Text = string.Empty;
                        this.hiddenDealerToDefaultWarehouseId.Text = string.Empty;
                        Ext.Msg.Alert(GetLocalResourceObject("ShowDialog.Alert.Title").ToString(), GetLocalResourceObject("ShowDialog.Alert.Title3").ToString()).Show();
                    }
                }
                else
                {
                    this.hiddenDealerToId.Text = string.Empty;
                    this.hiddenDealerToDefaultWarehouseId.Text = string.Empty;
                    Ext.Msg.Alert(GetLocalResourceObject("ShowDialog.Alert.Title").ToString(), GetLocalResourceObject("ShowDialog.Alert.Title4").ToString()).Show();
                }
            }
        }

        [AjaxMethod]
        public void DeleteDetail()
        {
            //ITransferBLL business = new TransferBLL();
            try
            {
                business.DeleteDetail(new Guid(this.hiddenTransferId.Text));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        [AjaxMethod]
        public string DoSubmit()
        {
            //ITransferBLL business = new TransferBLL();
            //更新字段
            DMS.Model.Transfer mainData = business.GetObject(new Guid(this.hiddenTransferId.Text));
            if (!string.IsNullOrEmpty(this.cbDealerFromWin.SelectedItem.Value))
            {
                mainData.FromDealerDmaId = new Guid(this.cbDealerFromWin.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
            {
                mainData.ProductLineBumId = new Guid(this.cbProductLineWin.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.hiddenDealerToId.Text))
            {
                mainData.ToDealerDmaId = new Guid(this.hiddenDealerToId.Text);
            }

            bool result = false;
            string errMsg = string.Empty;

            //DealerMaster dealerfrom = DealerCacheHelper.GetDealerById(mainData.FromDealerDmaId.Value);
            //DealerMaster dealerto = DealerCacheHelper.GetDealerById(mainData.ToDealerDmaId.Value);

            try
            {
                mainData.TransferUsrUserID = new Guid(this._context.User.Id);
                result = business.TransferSubmit(mainData,out errMsg);
                
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoSubmit.True.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.True.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoSubmit.False.Alert.Title").ToString(), GetLocalResourceObject(errMsg).ToString()).Show();
            }
            return result.ToString();
        }

        [AjaxMethod]
        public void SaveItem(String LotId,String ToWarehouseId, String TransferQty, String QRCode, String EditQrCode, String LotNumber)
        {

            bool result = false;

            try
            {

                
                    string Number = string.Empty;
                    InventoryAdjustBLL bll = new InventoryAdjustBLL();
                    bool bl=true;
                        Guid? whid = null;
                        if (!string.IsNullOrEmpty(ToWarehouseId))
                        {
                            whid = new Guid(ToWarehouseId);
                        }
                        if (QRCode == "NoQR"&&EditQrCode!=string.Empty)
                        {
                            if (bll.QueryQrCodeIsExist(EditQrCode))
                            {
                            Number = LotNumber + "@@" + EditQrCode;
                            }
                            else{
                            bl=false;
                            }
                        }
                        result = business.SaveTransferItem(new Guid(LotId), whid, Convert.ToDouble(TransferQty), Number);
                        this.DetailStore.DataBind();
                        if (!result)
                        {
                            Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
                        }
                    if(!bl)
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), "该二维码不存在").Show();
                    }
                
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        [AjaxMethod]
        public void DeleteItem(String LotId)
        {
            //ITransferBLL business = new TransferBLL();

            bool result = false;

            try
            {
                result = business.DeleteItem(new Guid(LotId));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                this.DetailStore.DataBind();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("DeleteItem.Alert.Title").ToString(), GetLocalResourceObject("DeleteItem.Alert.Body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void DoRevoke()
        {
            //ITransferBLL business = new TransferBLL();

            bool result = false;

            try
            {
                result = business.Revoke(new Guid(this.hiddenTransferId.Text));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoSubmit.True.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.True.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoSubmit.False.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.False.Alert.Body").ToString()).Show();
            }
        }
    }
}
