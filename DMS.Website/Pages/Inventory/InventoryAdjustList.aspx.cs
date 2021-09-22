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


namespace DMS.Website.Pages.Inventory
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.None)]
    public partial class InventoryAdjustList : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();
        private IInventoryAdjustBLL _business = null;
        [Dependency]
        public IInventoryAdjustBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        public IShipmentBLL spbusiness = new ShipmentBLL();
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                //this.btnInsert.Disabled = !IsDealer;
                this.btnInsert.Visible = IsDealer;
                this.btnImport.Visible = spbusiness.IsAdminRole();

                this.Bind_ProductLine(this.ProductLineStore);
                this.Bind_DealerList(this.DealerStore);
                this.Bind_Status(this.AdjustStatusStore);
                this.Bind_Type(this.AdjustTypeStore, this.AdjustTypeWinStore);

                if (IsDealer)
                {
                    if (_context.User.CorpType == DealerType.HQ.ToString())
                    {
                        this.btnInsert.Visible = false;
                    }
                    this.cbDealer.Disabled = true;
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_ADJUST);
                }
                else
                {

                }

                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryAdjust, PermissionType.Read);
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            this.InventoryAdjustDialog1.GridStore = this.DetailStore;
            //this.InventoryAdjustEditor1.GridStore = this.DetailStore;
        }

        protected void Bind_Status(Store store1)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_AdjustQty_Status);
            IList list = dicts.ToList().FindAll(item => item.Key != AdjustStatus.Reject.ToString() && item.Key != AdjustStatus.Submitted.ToString() && item.Key != AdjustStatus.Accept.ToString());

            store1.DataSource = list;
            store1.DataBind();

        }

        protected void Bind_Type(Store ListStore, Store WinStore)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_AdjustQty_Type);

            //判断如果用户账号不是99账号，且不在开放期限内
            String strUserId = RoleModelContext.Current.User.Id;

            new Guid(RoleModelContext.Current.User.Id);
            int isAvailable = _business.IsOtherStockInAvailable(new Guid(strUserId));

            if (isAvailable == 0)
            {
                var winList = from d in dicts where d.Key.Equals(AdjustType.StockOut.ToString()) select d;
                WinStore.DataSource = winList;
            }
            else
            {
                var winList = from d in dicts where d.Key.Equals(AdjustType.StockIn.ToString()) || d.Key.Equals(AdjustType.StockOut.ToString()) select d;
                WinStore.DataSource = winList;
            }
            WinStore.DataBind();

            //绑定
            var list = from d in dicts where d.Key.Equals(AdjustType.StockIn.ToString()) || d.Key.Equals(AdjustType.StockOut.ToString()) select d;
            ListStore.DataSource = list;
            ListStore.DataBind();


        }

        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this.hiddenAdjustId.Text);
            int totalCount = 0;
            DataSet ds = _logbll.QueryPurchaseOrderLogByHeaderId(tid, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //IInventoryAdjustBLL business = new InventoryAdjustBLL();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLine", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbAdjustType.SelectedItem.Value))
            {
                param.Add("Type", this.cbAdjustType.SelectedItem.Value);
            }
            if (!this.txtStartDate.IsNull)
            {
                param.Add("CreateDateStart", this.txtStartDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtEndDate.IsNull)
            {
                param.Add("CreateDateEnd", this.txtEndDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtAdjustNumber.Text))
            {
                param.Add("AdjustNumber", this.txtAdjustNumber.Text);
            }
            if (!string.IsNullOrEmpty(this.cbAdjustStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbAdjustStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                param.Add("Cfn", this.txtCFN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                param.Add("Upn", this.txtUPN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtLotNumber2.Text))
            {
                param.Add("LotNumber", this.txtLotNumber2.Text);
            }
            DataSet ds = business.QueryInventoryAdjustHeader(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this.hiddenAdjustId.Text);

            //IInventoryAdjustBLL business = new InventoryAdjustBLL();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            param.Add("AdjustId", tid);

            DataSet ds = business.QueryInventoryAdjustLot(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.DetailStore.DataSource = ds;
            this.DetailStore.DataBind();
        }

        protected void ShowDialog(object sender, AjaxEventArgs e)
        {
            //判断是否符合打开对话框的条件
            //1、产品线 2、调整类型

            if (string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value) || string.IsNullOrEmpty(this.cbAdjustTypeWin.SelectedItem.Value))
            {
                Ext.Msg.Alert(GetLocalResourceObject("ShowDialog.Alert.Title").ToString(), GetLocalResourceObject("ShowDialog.Alert.Body").ToString()).Show();
                return;
            }
            this.InventoryAdjustDialog1.Show(new Guid(this.hiddenAdjustId.Text), new Guid(this.hiddenDealerId.Text), new Guid(this.hiddenProductLineId.Text), this.hiddenAdjustTypeId.Text, "Normal","");
        }

        protected void ShowDetails(object sender, AjaxEventArgs e)
        {
            //初始化detail窗口,因为只有dealer才可以新增，因此打开页面默认选中session中的经销商
            this.gpLog.Reload();
            this.GridPanel2.ColumnModel.SetHidden(10, true);

            this.hiddenAdjustId.Text = string.Empty;
            this.hiddenDealerId.Text = string.Empty;
            this.hiddenProductLineId.Text = string.Empty;
            this.hiddenAdjustTypeId.Text = string.Empty;
            this.hiddenIsRtnValue.Text = string.Empty;
            this.txtAdjustNumberWin.Text = string.Empty;
            this.txtAdjustDateWin.Text = string.Empty;
            this.txtAdjustStatusWin.Text = string.Empty;
            this.txtAdjustReasonWin.Text = string.Empty;
            this.txtAduitNoteWin.Text = string.Empty;

            //added by bozhenfei on 20100607
            this.hiddenCurrentEdit.Text = string.Empty;
            this.hiddenIsEditting.Text = string.Empty;
            //end

            Guid id = new Guid(e.ExtraParams["AdjustId"].ToString());

            //IInventoryAdjustBLL business = new InventoryAdjustBLL();
            InventoryAdjustHeader mainData = null;

            //若id为空，说明为新增，则生成新的id，并新增一条记录

            if (id == Guid.Empty)
            {
                id = Guid.NewGuid();
                this.hiddenAdjustId.Text = id.ToString();
                mainData = new InventoryAdjustHeader();
                mainData.Id = id;
                mainData.CreateDate = DateTime.Now;
                mainData.CreateUser = new Guid(RoleModelContext.Current.User.Id);
                mainData.DmaId = RoleModelContext.Current.User.CorpId.Value;
                mainData.Status = AdjustStatus.Draft.ToString();
                mainData.WarehouseType = AdjustWarehouseType.Normal.ToString();

                business.InsertInventoryAdjustHeader(mainData);
            }

            //根据ID查询主表数据，并初始化页面

            mainData = business.GetInventoryAdjustById(id);
            this.hiddenAdjustId.Text = mainData.Id.ToString();
            this.hiddenDealerId.Text = mainData.DmaId.ToString();

            if (!string.IsNullOrEmpty(mainData.Reason))
            {
                this.hiddenAdjustTypeId.Text = mainData.Reason;
            }
            if (mainData.ProductLineBumId != null)
            {
                this.hiddenProductLineId.Text = mainData.ProductLineBumId.Value.ToString();
            }
            this.txtAdjustNumberWin.Text = mainData.InvAdjNbr;
            if (mainData.CreateDate != null)
            {
                this.txtAdjustDateWin.Text = mainData.CreateDate.Value.ToString("yyyyMMdd");
            }
            this.txtAdjustStatusWin.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_AdjustQty_Status, mainData.Status);
            this.txtAdjustReasonWin.Text = mainData.UserDescription;
            this.txtAduitNoteWin.Text = mainData.AuditorNotes;
            //窗口状态控制

            this.cbDealerWin.Disabled = true;
            this.GridPanel2.ColumnModel.SetHidden(7, true);
            this.GridPanel2.ColumnModel.SetHidden(14, true);
            this.GridPanel2.ColumnModel.SetEditable(6, false);
            this.GridPanel2.ColumnModel.SetEditable(7, false);
            this.GridPanel2.ColumnModel.SetEditable(11, false);
            this.GridPanel2.ColumnModel.SetEditable(13, false);
            this.GridPanel2.ColumnModel.SetEditable(5, false);
            //this.GridPanel2.ColumnModel.SetHidden(13, true);
            this.cbProductLineWin.Disabled = true;
            this.cbAdjustTypeWin.Disabled = true;
            //this.txtAdjustReasonWin.Disabled = true;
            this.txtAdjustReasonWin.ReadOnly = true;
            //this.txtAduitNoteWin.Disabled = true;
            this.txtAduitNoteWin.ReadOnly = true;
            this.txtAduitNoteWin.Hidden = true;
            this.DraftButton.Disabled = true;
            this.DeleteButton.Disabled = true;
            this.SubmitButton.Disabled = true;
            this.RevokeButton.Disabled = true;
            this.AddItemsButton.Disabled = true;

            if (IsDealer)
            {
                if (mainData.Status == AdjustStatus.Draft.ToString())
                {
                    this.cbProductLineWin.Disabled = false;
                    this.cbAdjustTypeWin.Disabled = false;
                    //this.txtAdjustReasonWin.Disabled = false;
                    this.txtAdjustReasonWin.ReadOnly = false;
                    this.DraftButton.Disabled = false;
                    this.DeleteButton.Disabled = false;
                    this.SubmitButton.Disabled = false;
                    this.GridPanel2.ColumnModel.SetHidden(14, false);
                    this.GridPanel2.ColumnModel.SetHidden(13, false);
                    if (this.cbAdjustTypeWin.SelectedItem.Value == AdjustType.StockOut.ToString())
                    {
                        this.GridPanel2.ColumnModel.SetEditable(13, false);
                    }
                    else {
                        this.GridPanel2.ColumnModel.SetEditable(13, true);
                    }
                   
                    //如果是其他入库，则序列号、有效期可以做修改

                    if (mainData.Reason == AdjustType.StockIn.ToString())
                    {
                        //this.GridPanel2.ColumnModel.SetHidden(6, true);
                        this.GridPanel2.ColumnModel.SetHidden(6, false);
                        this.GridPanel2.ColumnModel.SetHidden(13, false);
                        this.GridPanel2.ColumnModel.SetEditable(5, true);
                        this.GridPanel2.ColumnModel.SetEditable(7, true);
                    }
                    if (mainData.Reason == AdjustType.StockOut.ToString())
                    {
                        this.GridPanel2.ColumnModel.SetHidden(6, false);
                        this.GridPanel2.ColumnModel.SetHidden(13, false);
                    }
                    this.GridPanel2.ColumnModel.SetEditable(5, true);                  
                    this.GridPanel2.ColumnModel.SetEditable(11, true);
                    if (mainData.ProductLineBumId != null && mainData.Reason != null)
                    {
                        this.AddItemsButton.Disabled = false;
                    }

                    Renderer r = new Renderer();
                    r.Fn = "SetCellCssEditable";
                    this.GridPanel2.ColumnModel.SetRenderer(5, r);
                    //this.GridPanel2.ColumnModel.SetRenderer(4, r);
                    this.GridPanel2.ColumnModel.SetRenderer(11, r);
                }
                else
                {
                    this.GridPanel2.ColumnModel.SetEditable(5, false);
                    if (mainData.Reason == AdjustType.StockIn.ToString())
                    {
                       // this.GridPanel2.ColumnModel.SetHidden(6, true);
                        this.GridPanel2.ColumnModel.SetHidden(6, false);
                        this.GridPanel2.ColumnModel.SetHidden(13, false);
                    }
                    if (mainData.Reason == AdjustType.StockOut.ToString())
                    {
                        this.GridPanel2.ColumnModel.SetHidden(6, false);
                        this.GridPanel2.ColumnModel.SetHidden(13, false);
                    }
                    this.GridPanel2.ColumnModel.SetEditable(13, false);
                    this.GridPanel2.ColumnModel.SetHidden(7, false);
                    Renderer r = new Renderer();
                    r.Fn = "SetCellCssNonEditable";
                    this.GridPanel2.ColumnModel.SetRenderer(5, r);
                    //this.GridPanel2.ColumnModel.SetRenderer(4, r);
                    this.GridPanel2.ColumnModel.SetRenderer(11, r);
                }
                if (mainData.Reason == AdjustType.StockIn.ToString() || mainData.Reason == AdjustType.StockOut.ToString())
                {
                    if (mainData.Status == AdjustStatus.Submit.ToString())
                    {
                        this.RevokeButton.Disabled = false;
                    }
                }
                else
                {
                    if (mainData.Status == AdjustStatus.Submitted.ToString())
                    {
                        this.RevokeButton.Disabled = false;
                    }
                }
            }
            else {
                if (mainData.Reason == AdjustType.StockIn.ToString())
                {
                    //this.GridPanel2.ColumnModel.SetHidden(6, true);
                    this.GridPanel2.ColumnModel.SetHidden(6, false);
                }
                else if (mainData.Reason == AdjustType.StockOut.ToString())
                {
                    this.GridPanel2.ColumnModel.SetHidden(6, false);
                    this.GridPanel2.ColumnModel.SetHidden(13, false);
                }
            }

            if (mainData.Status == AdjustStatus.Reject.ToString() || mainData.Status == AdjustStatus.Accept.ToString())
            {
                this.txtAduitNoteWin.Hidden = false;
            }
            //显示窗口
            this.DetailWindow.Show();
        }

        [AjaxMethod]
        public void SaveDraft()
        {
            //IInventoryAdjustBLL business = new InventoryAdjustBLL();
            //更新字段
            InventoryAdjustHeader mainData = business.GetInventoryAdjustById(new Guid(this.hiddenAdjustId.Text));

            if (!string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
            {
                mainData.ProductLineBumId = new Guid(this.cbProductLineWin.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbAdjustTypeWin.SelectedItem.Value))
            {
                mainData.Reason = this.cbAdjustTypeWin.SelectedItem.Value;
            }
            if (!string.IsNullOrEmpty(this.txtAdjustReasonWin.Text))
            {
                mainData.UserDescription = this.txtAdjustReasonWin.Text;
            }

            bool result = false;

            try
            {
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
            //IInventoryAdjustBLL business = new InventoryAdjustBLL();

            bool result = false;

            try
            {
                result = business.DeleteDraft(new Guid(this.hiddenAdjustId.Text));
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
        public void OnProductLineChange()
        {
            //IInventoryAdjustBLL business = new InventoryAdjustBLL();
            try
            {
                business.DeleteDetail(new Guid(this.hiddenAdjustId.Text));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        [AjaxMethod]
        public void OnAdjustTypeChange()
        {
            //IInventoryAdjustBLL business = new InventoryAdjustBLL();
            //如果是样品，则序列号、有效期可以做修改

            //Boolean bEditable;
            //bEditable = this.cbAdjustTypeWin.SelectedItem.Value == AdjustType.Sample.ToString();
            //this.GridPanel2.ColumnModel.SetEditable(3, bEditable);
            //this.GridPanel2.ColumnModel.SetEditable(4, bEditable);

            try
            {
                business.DeleteDetail(new Guid(this.hiddenAdjustId.Text));
                Renderer r = new Renderer();

                if (this.cbAdjustTypeWin.SelectedItem.Value == AdjustType.StockOut.ToString())
                {
                    r.Fn = "SetCellCssNonEditable";
                    this.GridPanel2.ColumnModel.SetRenderer(5, r);
                    //this.GridPanel2.ColumnModel.SetHidden(13, true);
                    //this.GridPanel2.ColumnModel.SetRenderer(4, r);
                }
                else
                {
                    r.Fn = "SetCellCssEditable";
                    //this.GridPanel2.ColumnModel.SetHidden(13, false);
                    this.GridPanel2.ColumnModel.SetRenderer(5, r);
                    //this.GridPanel2.ColumnModel.SetRenderer(4, r);
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
            //IInventoryAdjustBLL business = new InventoryAdjustBLL();

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

        protected void SaveInvAdjDetailLine(object sender, AjaxEventArgs e)
        {

            string json = e.ExtraParams["Values"];
            Dictionary<string, string>[] fieldPair = JSON.Deserialize<Dictionary<string, string>[]>(json);
            string value = "";

            //IInventoryAdjustBLL business = new InventoryAdjustBLL();

            InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(this.hiddenCurrentEdit.Text));
            if (this.cbAdjustTypeWin.SelectedItem.Value == AdjustType.StockIn.ToString())
            {
                fieldPair[0].TryGetValue("LotNumber", out value);
                lot.LotNumber = value;
                fieldPair[0].TryGetValue("ExpiredDate", out value);
                if (value == "")
                {
                    lot.ExpiredDate = null;
                }
                else
                {
                    lot.ExpiredDate = Convert.ToDateTime(value);
                }
            }
            else
            {
                ////判断库存量是否足够

                //if (Convert.ToDouble(this.txtTotalQty.Text) < this.txtAdjustQty.Number)
                //{
                //    Ext.Msg.Alert("Error", "调整数量不能大于库存量！").Show();
                //    return;
                //}
            }
            fieldPair[0].TryGetValue("AdjustQty", out value);
            if (value == "")
            {
                lot.LotQty = 0;
            }
            else
            {
                lot.LotQty = Convert.ToDouble(value);
            }

            bool result = business.SaveItem(lot);

            if (result)
            {
                this.DetailStore.DataBind();
                //this.EditorWindow.Hide();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveInvAdjDetailLine.Alert.Title").ToString(), GetLocalResourceObject("SaveInvAdjDetailLine.Alert.Body").ToString()).Show();
            }
        }


        [AjaxMethod]
        public void EditItem(String LotId, String Type)
        {
            //this.InventoryAdjustEditor1.Show(new Guid(LotId), Type);
        }

        [AjaxMethod]
        public void SaveItem(String CFN, String lotNumber, String expiredDate, String adjustQty,String EditQrCode)
        {
             bool isCode = false;
            bool isLotNbr = false;
            string Messinge = string.Empty;
            LotMasters lms = new LotMasters();

            if (hiddenAdjustTypeId.Text == AdjustType.StockOut.ToString())
            {
                InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(this.hiddenCurrentEdit.Text));
                if (!string.IsNullOrEmpty(adjustQty))
                {
                    lot.LotQty = Convert.ToDouble(adjustQty); ;

                }
                if (!string.IsNullOrEmpty(EditQrCode))
                {

                    if (business.QueryQrCodeIsExist(EditQrCode))
                    {
                        lot.QrLotNumber = lotNumber + "@@" + EditQrCode;

                    }
                    else
                    {

                        Messinge = Messinge + "该二维码不存在<BR/>";

                    }

                }
                if (string.IsNullOrEmpty(Messinge))
                {
                    bool result = business.SaveItem(lot);

                }
                else
                {
                    Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), Messinge).Show();
                }
                this.DetailStore.DataBind();
            }
            if (hiddenAdjustTypeId.Text == AdjustType.StockIn.ToString())
            {
                InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(this.hiddenCurrentEdit.Text));
                if (!string.IsNullOrEmpty(lotNumber) && !string.IsNullOrEmpty(EditQrCode))
                {
                    LotMaster lm = new LotMaster();
                    if (!string.IsNullOrEmpty(lotNumber))
                    {
                        lm = lms.SelectLotMasterByLotNumberCFNQrCode(lotNumber, CFN);
                        if (lm == null)
                        {
                            Messinge = Messinge + "产品批号" + lotNumber + "不存在<BR/>";
                        }
                        else
                        {
                            lot.ExpiredDate = lm.ExpiredDate;
                        }
                    }
                    if (!string.IsNullOrEmpty(EditQrCode))
                    {
                        if (!business.QueryQrCodeIsExist(EditQrCode))
                        {
                            Messinge = Messinge + "二维码" + EditQrCode + "不存在<BR/>";
                        }

                    }


                    // lot.LotNumber = lotNumber + "@@" + EditQrCode;
                    lot.LotQRCode = EditQrCode;
                    lot.LtmLot=lotNumber;
                    lot.QrLotNumber = lotNumber + "@@" + EditQrCode;

                    lot.LotQty = Convert.ToDouble(adjustQty);
                    bool result = business.SaveItem(lot);
                    if (result)
                    {
                        this.DetailStore.DataBind();
                        //this.EditorWindow.Hide();
                    }
                    else
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
                    }
                    if (Messinge != string.Empty)
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), Messinge).Show();


                    }
                }
                else if (!string.IsNullOrEmpty(adjustQty))
                {
                    //InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(this.hiddenCurrentEdit.Text));
                    lot.LotQty = Convert.ToDouble(adjustQty);

                    bool result = business.SaveItem(lot);
                    if (!result)
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
                        //this.DetailStore.DataBind();
                        //this.EditorWindow.Hide();
                    }

                }
            }
            #region
            //if (!string.IsNullOrEmpty(lotNumber) || !string.IsNullOrEmpty(EditQrCode))
            //{
            //    LotMaster lm = new LotMaster();
            //    if (!string.IsNullOrEmpty(lotNumber))
            //    {
            //         lm = lms.SelectLotMasterByLotNumberCFNQrCode(lotNumber, CFN);
            //        if (lm != null)
            //        {
                      
            //            isLotNbr = true;
            //        }
            //        else
            //        {
                     
            //            isLotNbr = false;
                   
            //            Messinge = Messinge + "产品批号不存在<BR/>";
            //            Ext.Msg.Alert(GetLocalResourceObject("LotNumber.Alert.Title").ToString(), GetLocalResourceObject("LotNumber.Alert.Body").ToString()).Show();
            //        }
            //    }
            //     if (!string.IsNullOrEmpty(EditQrCode))
            //    {
            //        if (business.QueryQrCodeIsExist(EditQrCode))
            //        {
            //            isCode = true;
                    
            //        }
            //        else {
            //            isCode = false;
                     
            //            Messinge = Messinge + "该二维码不存在<BR/>";
                   
                       
            //        }
            //    }
              
            //     InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(this.hiddenCurrentEdit.Text));
            //     if (isLotNbr && !isCode)
            //     {
            //         if (!string.IsNullOrEmpty(lot.QrLotNumber))
            //         {
            //             string[] str = lot.QrLotNumber.Split(new char[2] { '@', '@' });
            //             if (str.Length > 1)
            //             {
            //                 lot.LotNumber = lotNumber + "@@" + str[2];
            //                 lot.QrLotNumber = lotNumber + "@@" + str[2];
            //             }

            //         }
            //         else {
            //             lot.QrLotNumber = lotNumber + "@@";
            //             lot.LotNumber = lotNumber + "@@";
            //         }
            //     }
            //     if (!isLotNbr && isCode)
            //     {
            //         if (!string.IsNullOrEmpty(lot.QrLotNumber))
            //         {
            //             string[] str = lot.QrLotNumber.Split(new char[2] { '@', '@' });
            //             if (str.Length > 1)
            //             {
            //                 lot.LotNumber = str[0] + "@@" + EditQrCode;
            //                 lot.QrLotNumber = str[0] + "@@" + EditQrCode;
            //             }

            //         }
            //         else
            //         {
            //             lot.QrLotNumber = "@@" + EditQrCode;
            //             lot.LotNumber = "@@" + EditQrCode;
            //         }
            //     }
            //    if (isLotNbr&&isCode)
            //    {
                    
            //        if (this.cbAdjustTypeWin.SelectedItem.Value == AdjustType.StockIn.ToString())
            //        {
            //            lot.LotNumber = lotNumber + "@@" + EditQrCode;
                       

            //            lot.ExpiredDate = lm.ExpiredDate;
            //        }
            //        lot.QrLotNumber = lotNumber + "@@" + EditQrCode;
            //        lot.LotQty = Convert.ToDouble(adjustQty);

                   
            //    }
            //    bool result = business.SaveItem(lot);

            //    if (result)
            //    {
            //        this.DetailStore.DataBind();
            //        //this.EditorWindow.Hide();
            //    }
            //    else
            //    {
            //        Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
            //    }
            //        if (Messinge != string.Empty)
            //      {
            //            Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), Messinge).Show();
            //        }

            //}
            #endregion
            //#region
            //IInventoryAdjustBLL business = new InventoryAdjustBLL();
            //bool isCode = false;
            //bool isLotNbr = false;
            //string Messinge = string.Empty;
            //LotMasters lms = new LotMasters();
            //if (!string.IsNullOrEmpty(lotNumber) || !string.IsNullOrEmpty(EditQrCode))
            //{

            //    if (!string.IsNullOrEmpty(lotNumber))
            //    {
            //        LotMaster lm = lms.SelectLotMasterByLotNumberCFNQrCode(lotNumber, CFN);
            //        if (lm != null)
            //        {

            //            isLotNbr = true;
            //        }
            //        else
            //        {
            //            isLotNbr = false;

            //            Messinge = Messinge + "产品批号不存在<BR/>";
            //            Ext.Msg.Alert(GetLocalResourceObject("LotNumber.Alert.Title").ToString(), GetLocalResourceObject("LotNumber.Alert.Body").ToString()).Show();
            //        }
            //    }
            //    if (!string.IsNullOrEmpty(EditQrCode))
            //    {
            //        if (business.QueryQrCodeIsExist(EditQrCode))
            //        {
            //            isCode = true;

            //        }
            //        else
            //        {
            //            isCode = false;
            //            Messinge = Messinge + "该二维码不存在<BR/>";


            //        }
            //    }
            //    if (isLotNbr && isCode)
            //    {
            //        LotMaster lm = lms.SelectLotMasterByLotNumberCFNQrCode(lotNumber, CFN);
            //        InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(this.hiddenCurrentEdit.Text));
            //        if (this.cbAdjustTypeWin.SelectedItem.Value == AdjustType.StockIn.ToString())
            //        {
            //            lot.LotNumber = lotNumber + "@@";
            //            lot.QrLotNumber = lotNumber + "@@" + EditQrCode;

            //            lot.ExpiredDate = lm.ExpiredDate;
            //        }
            //        if (this.cbAdjustTypeWin.SelectedItem.Value == AdjustType.StockOut.ToString())
            //        {
            //            lot.QrLotNumber = lotNumber + "@@" + EditQrCode;
            //            lot.ExpiredDate = lm.ExpiredDate;
            //        }
            //        lot.LotQty = Convert.ToDouble(adjustQty);

            //        bool result = business.SaveItem(lot);

            //        if (result)
            //        {
            //            this.DetailStore.DataBind();
            //            this.EditorWindow.Hide();
            //        }
            //        else
            //        {
            //            Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
            //        }
            //    }
            //    else
            //    {
            //        if (Messinge != string.Empty)
            //        {
            //            Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), Messinge).Show();
            //        }
            //    }
            //}
            //#endregion
        }


        [AjaxMethod]
        public void DoSubmit()
        {
            hiddenIsRtnValue.Text = string.Empty;
            //bool isQrcode = true;
            //string Messing = string.Empty;
            //DataSet ds = business.SelectInventoryAdjustLotChecked(this.hiddenAdjustId.Text);
            //if (ds.Tables[0].Rows.Count > 0)
            //{
            //    foreach (DataRow row in ds.Tables[0].Rows)
            //    {
            //        if (!string.IsNullOrEmpty(row["LotNumber"].ToString()))
            //        {
            //            if (row["QrCode"].ToString() == "NoQR" && string.IsNullOrEmpty(row["EditQrCode"].ToString()))
            //            {
            //                Messing = Messing + "批次号" + row["LotNumber"].ToString() + "二维码填写错误<br/>";
            //                isQrcode = false;
            //            }
            //        }
            //        else
            //        {
            //            Messing = Messing + "请填写批次号<br/>";
            //            isQrcode = false;
            //        }
            //    }
            //}
            //else {
            //    Messing = "请填写正确的批次号和二维码";
            //    isQrcode = false;
            //}
            //if (isQrcode)
            //{
                if (this.cbAdjustTypeWin.SelectedItem.Value == "StockIn" && _business.IsOtherStockInAvailable(new Guid(RoleModelContext.Current.User.Id)) == 0)
                {
                    throw new Exception("其他入库功能未开放，不能提交其他入库单");
                }
                else
                {

                    //IInventoryAdjustBLL business = new InventoryAdjustBLL();
                    //更新字段
                    InventoryAdjustHeader mainData = business.GetInventoryAdjustById(new Guid(this.hiddenAdjustId.Text));

                    if (!string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
                    {
                        mainData.ProductLineBumId = new Guid(this.cbProductLineWin.SelectedItem.Value);
                    }
                    if (!string.IsNullOrEmpty(this.cbAdjustTypeWin.SelectedItem.Value))
                    {
                        mainData.Reason = this.cbAdjustTypeWin.SelectedItem.Value;
                    }
                    if (!string.IsNullOrEmpty(this.txtAdjustReasonWin.Text))
                    {
                        mainData.UserDescription = this.txtAdjustReasonWin.Text;
                    }
                    bool result = false;

                    try
                    {

                        hiddenIsRtnValue.Text = "true";
                        hiddenReturnMessing.Text = string.Empty;
                        bool bl = true;
                        string Messing = string.Empty;
                        string RtnRegMsg = "";
                        string QrCode = string.Empty;
                        string IsValid = string.Empty;
                        //LotMaster lm = new LotMaster();
                        //LotMasters lms = new LotMasters();
                        //DataSet ds = _business.SelectInventoryAdjustLot(hiddenAdjustId.Text);
                        _business.InventoryAdjust_CheckSubmit(hiddenAdjustId.Text, hiddenAdjustTypeId.Text, out RtnRegMsg, out IsValid);
                        #region

                        //foreach (DataRow row in ds.Tables[0].Rows)
                        //{
                        //    //入库要校验批次号和二维码
                        //    if (hiddenAdjustTypeId.Text == AdjustType.StockIn.ToString())
                        //    {
                        //        if (row["LotNumber"] != DBNull.Value)
                        //        {
                        //            lm = lms.SelectLotMasterByLotNumberCFNQrCode(row["LotNumber"].ToString(), row["CFN"].ToString());
                        //            if (lm == null)
                        //            {
                                       
                        //                Messing = Messing + "批次号" + row["LotNumber"].ToString() + "填写错误<br/>";
                        //            }
                        //        }
                        //        else
                        //        {
                                    
                        //            Messing = Messing + "批次号错误，请重新填写<br/>";
                        //        }
                        //        if (row["QRCodeEdit"] != DBNull.Value)
                        //        {
                        //            if (!business.QueryQrCodeIsExist(row["QRCodeEdit"].ToString()))
                        //            {
                                       
                        //                Messing = Messing + "二维码" + row["QRCodeEdit"].ToString() + "不存在<br/>";
                        //            }
                        //        }
                        //        else
                        //        {
                        //            Messing = Messing + "二维码填写错误<br/>";
                        //        }
                        //    }
                        //    if (row["QRCodeEdit"] != DBNull.Value)
                        //    {
                        //        if (!string.IsNullOrEmpty(row["QRCodeEdit"].ToString()))
                        //        {
                        //            QrCode = row["QRCodeEdit"].ToString();
                        //        }
                        //        else
                        //        {
                        //            QrCode = row["QRCode"].ToString();
                        //        }
                        //    }
                        //    else
                        //    {
                                
                        //        QrCode = row["QRCode"].ToString();
                        //    }
                        //   if (!CheckdeQrCode(QrCode))
                        //    {
                        //        Messing = Messing + "二维码" + QrCode + "重复<br/>";

                        //        hiddenIsRtnValue.Text = "false";
                        //    }
                        //}
                        #endregion
                        if (RtnRegMsg != string.Empty)
                        {
                            hiddenIsRtnValue.Text = "false";
                            bl = false;
                        }
                        if (IsValid == "Error" && !string.IsNullOrEmpty(RtnRegMsg))
                        {
                            RtnRegMsg = RtnRegMsg.Replace(",", "</br>");
                            Ext.Msg.Alert(GetLocalResourceObject("DoSubmit.True.Alert.Title").ToString(), RtnRegMsg).Show();
                            return;
                        }
                        else if (IsValid == "Success")
                        {
                            result = business.Submit(mainData);
                        }
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
            //}
            //else
            //{
            //    hiddenIsRtnValue.Text = "Error";
            //    Ext.Msg.Alert(GetLocalResourceObject("DoSubmit.False.Alert.Title").ToString(), Messing).Show();
            //}
        }
        public bool CheckdeQrCode(string QrCode)
        {
            bool bl = true;
          
            DataSet ds = _business.SelectInventoryAdjustLotQrCode(this.hiddenAdjustId.Text, QrCode);
            if (ds.Tables[0].Rows[0]["Cnt"] != DBNull.Value)
            {
                if (Double.Parse(ds.Tables[0].Rows[0]["Cnt"].ToString()) > 1)
                {
                    bl = false;
                }
            }
            return bl;
        }
        [AjaxMethod]
        public void DoRevoke()
        {
            //IInventoryAdjustBLL business = new InventoryAdjustBLL();

            bool result = false;

            try
            {
                result = business.Revoke(new Guid(this.hiddenAdjustId.Text));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoRevoke.True.Alert.Title").ToString(), GetLocalResourceObject("DoRevoke.True.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoRevoke.False.Alert.Title").ToString(), GetLocalResourceObject("DoRevoke.False.Alert.Body").ToString()).Show();
            }
        }

        //[AjaxMethod]
        //public string CheckProductMinQty(string cfn, string qty)
        //{
        //    ICfns cfns = new Cfns();

        //    decimal qty1 = string.IsNullOrEmpty(qty) ? 0 : Convert.ToDecimal(qty);

        //    return cfns.CheckProductMinQty(cfn, qty1);
        //}
    }
}
