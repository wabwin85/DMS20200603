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
    public partial class ConsignToSellingList : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();
        private IDealerMasters _dealers = Global.ApplicationContainer.Resolve<IDealerMasters>();
        private IInventoryAdjustBLL _business = null;
        [Dependency]
        public IInventoryAdjustBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        public bool IsPageNew
        {
            get
            {
                return (this.hidIsPageNew.Text == "True" ? true : false);
            }
            set
            {
                this.hidIsPageNew.Text = value.ToString();
            }
        }
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                //this.btnInsert.Disabled = !IsDealer;
                this.btnInsert.Visible = IsDealer;

                this.Bind_ProductLine(this.ProductLineStore);
                //this.Bind_DealerList(this.DealerStore);
                this.Bind_Status(this.AdjustStatusStore);

                //加载AdjustTypeStore
                List<object> list = new List<object>
                {
                    new {Value = "寄售转销售", Key = "CTOS"}                  
                };
                AdjustTypeStore.DataSource = list;
                AdjustTypeStore.DataBind();

                AdjustTypeWinStore.DataSource = list;
                AdjustTypeWinStore.DataBind();

                if (IsDealer)
                {
                    if (_context.User.CorpType == DealerType.HQ.ToString())
                    {
                        this.btnInsert.Visible = false;
                    }

                    //this.cbDealer.Disabled = true;
                    //this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_ADJUST);


                    //经销商选择
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        this.Bind_DealerList(this.DealerStore);
                        this.cbDealer.Disabled = true;
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        //this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();                       
                    }
                    else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                    {
                        this.Bind_DealerListByFilter(this.DealerStore, true);
                        this.cbDealer.Disabled = false;
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        //this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();

                    }
                    else
                    {
                        this.Bind_DealerList(this.DealerStore);
                        this.cbDealer.Disabled = false;
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                }
                else
                {
                    this.Bind_DealerList(this.DealerStore);
                    this.cbDealer.Disabled = false;
                }

                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryReturn, PermissionType.Read);
                //this.btnExport.Visible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryReturn, PermissionType.Read);
                //this.btnInsert.Visible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryReturn, PermissionType.Write);
                //this.btnInsertConsignment.Visible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryReturn, PermissionType.Write);
                //this.btnImport.Visible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryReturn, PermissionType.Write);
                //this.btnImportConsignment.Visible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryReturn, PermissionType.Write);

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

            store1.DataSource = dicts;
            store1.DataBind();

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

            param.Add("Type", "CTOS");


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
            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
            {
                param.Add("LPId", RoleModelContext.Current.User.CorpId);
            }

            DataSet ds = business.QueryInventoryAdjustHeaderCTOS(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

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

            DataSet ds = business.QueryInventoryAdjustLotCTOS(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.DetailStore.DataSource = ds;
            this.DetailStore.DataBind();
        }
        protected void RsmStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //add lijie 20160510
            if (!string.IsNullOrEmpty(hiddenAdjustId.Text))
            {
                InventoryAdjustHeader mainData = business.GetInventoryAdjustById(new Guid(hiddenAdjustId.Text));

                DealerMaster dmst = _dealers.SelectDealerMasterParentTypebyId(mainData.DmaId);
                //DealerMaster Partdms = new DealerMaster();

                //if (dmst != null)
                //{
                   

                //    Partdms = _dealers.GetDealerMaster(dmst.ParentDmaId.Value);
                  
                //}

                if (cbProductLineWin.SelectedItem.Value == "8f15d92a-47e4-462f-a603-f61983d61b7b" && dmst.DealerType.Equals(DealerType.T2.ToString()) && dmst.Taxpayer == "红海")
                {
                    //为true是RSm必填
                    hiddenIsRsm.Text = "true"; 
                    //但选择的产品线为Endo且经销商为T2品台为红海的时候获取RSM，并开放下拉框
                    cbRsm.Hidden = false;
                    Hashtable ht = new Hashtable();
                    DataSet ds = new DataSet();
                    ht.Add("ProductLineId", cbProductLineWin.SelectedItem.Value);
                    ht.Add("DealerCode", dmst.SapCode);
                    if (IsPageNew)
                    {
                        //如果是新添加的订单则在SelectT_I_QV_SalesRepDealer取RSM
                         ds = business.SelectT_I_QV_SalesRepDealerByProductLine(ht);
                    }
                    else {
                        //如果是历史订单则在interface.T_I_QV_SalesRep 取
                        ds = business.SelectT_I_QV_SalesRepByProductLine(ht);
                    
                    }
                    RsmStore.DataSource = ds;
                    RsmStore.DataBind();
                   
                }
                else
                {
                    hiddenIsRsm.Text = "false";
                    cbRsm.Hidden = true;
                }
            }
            // lijie end

        }
        protected void ShowDialog(object sender, AjaxEventArgs e)
        {
            //判断是否符合打开对话框的条件
            //1、产品线 2、调整类型

            if (string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
            {
                Ext.Msg.Alert(GetLocalResourceObject("ShowDialog.Alert.Title").ToString(), GetLocalResourceObject("ShowDialog.Alert.Body").ToString()).Show();
                return;
            }
            //显示全部仓库
            this.InventoryAdjustDialog1.ShowConsignment(new Guid(this.hiddenAdjustId.Text), new Guid(this.hiddenDealerId.Text), new Guid(this.hiddenProductLineId.Text), this.cbAdjustTypeWin.SelectedItem.Value, "Consignment");
        }

        protected void ShowDetails(object sender, AjaxEventArgs e)
        {
            //初始化detail窗口,因为只有dealer才可以新增，因此打开页面默认选中session中的经销商
            this.hidSalesAccount.Clear();
            this.hiddenAdjustId.Text = string.Empty;
            this.hiddenDealerId.Text = string.Empty;
            this.hiddenProductLineId.Text = string.Empty;
            this.hiddenAdjustTypeId.Text = string.Empty;

            this.txtAdjustNumberWin.Text = string.Empty;
            this.txtAdjustDateWin.Text = string.Empty;
            this.txtAdjustStatusWin.Text = string.Empty;
            this.txtAdjustReasonWin.Text = string.Empty;
            this.txtAduitNoteWin.Text = string.Empty;

            //added by bozhenfei on 20100607 Begin
            this.hiddenCurrentEdit.Text = string.Empty;
            this.hiddenIsEditting.Text = string.Empty;
            //end

            //Added By Song Yuqi On 20140320 Begin
            this.TabPanel1.ActiveTabIndex = 0;
            this.TabHeader.Disabled = false;
            //Added By Song Yuqi On 20140320 Begin


            //add liji 2016-0520 隐藏rsm
            this.cbRsm.Hidden = true;
            hiddenIsRsm.Clear();
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

                //Edited By Song Yuqi On 20140319 Begin
                //由用户新增的类型（点击普通OR寄售新增按钮）判断是普通退货单还是寄售退货单
                mainData.WarehouseType = this.hiddenAdjustTypeId.Text;//AdjustWarehouseType.Normal.ToString();
                this.hiddenDealerType.Text = _context.User.CorpType; // Added By Song Yuqi On 20140317
                //Edited By Song Yuqi On 20140319 End

                mainData.Reason = AdjustType.CTOS.ToString();

                business.InsertInventoryAdjustHeader(mainData);

                IsPageNew = true;

            }
            else {
                IsPageNew = false;
            }

            //根据ID查询主表数据，并初始化页面
            mainData = business.GetInventoryAdjustById(id);
            this.hiddenAdjustId.Text = mainData.Id.ToString();
            this.hiddenDealerId.Text = mainData.DmaId.ToString();

            //Added By Song Yuqi On 20140319 Begin
            //获得明细单中经销商的类型
            DealerMaster dma = new DealerMasters().GetDealerMaster(new Guid(this.hiddenDealerId.Text));
            this.hiddenDealerType.Text = dma.DealerType;
            //Added By Song Yuqi On 20140319 End

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
            if (!string.IsNullOrEmpty(mainData.Rsm))
            {
                this.hidSalesAccount.Text = mainData.Rsm;
            }
            this.txtAdjustStatusWin.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_AdjustQty_Status, mainData.Status);
            this.txtAdjustReasonWin.Text = mainData.UserDescription;
            this.txtAduitNoteWin.Text = mainData.AuditorNotes;
            //窗口状态控制

            this.cbDealerWin.Disabled = true;

            this.cbProductLineWin.Disabled = true;
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

            this.cbAdjustTypeWin.Disabled = true;
            this.GridPanel2.ColumnModel.SetHidden(13, true);
            #region 暂时不用
            //if (mainData.ProductLineBumId == new Guid("8f15d92a-47e4-462f-a603-f61983d61b7b") || cbProductLineWin.SelectedItem.Text =="内窥镜介入")
            //{
            //    DealerMaster dmst = _dealers.GetDealerMaster(mainData.DmaId);
            //    if (dmst.DealerType == "T2" && dmst.Taxpayer == "红海")
            //    {
            //        //订产品线为Endo且平台类型为红海的T2经销商才能查看RSM
            //        this.cbRsm.Hidden = false;
            //    }

            //}
            #endregion
            if (IsDealer)
            {
                if (mainData.Status == AdjustStatus.Draft.ToString())
                {
                    this.cbProductLineWin.Disabled = false;
                    //this.txtAdjustReasonWin.Disabled = false;
                    this.txtAdjustReasonWin.ReadOnly = false;
                    this.DraftButton.Disabled = false;
                    this.DeleteButton.Disabled = false;
                    this.SubmitButton.Disabled = false;

                    this.GridPanel2.ColumnModel.SetEditable(11, true);
                    this.GridPanel2.ColumnModel.SetEditable(12, true);
                    this.GridPanel2.ColumnModel.SetHidden(13, false);
                    this.AddItemsButton.Disabled = false;
                    Renderer r = new Renderer();
                    r.Fn = "SetCellCssEditable";
                    this.GridPanel2.ColumnModel.SetRenderer(11, r);
                    this.GridPanel2.ColumnModel.SetRenderer(12, r);
                    this.cbAdjustTypeWin.Disabled = false;
                    this.cbAdjustTypeWin.SetValue("CTOS");
                    this.cbRsm.Disabled = false;

                }
                else
                {

                    this.GridPanel2.ColumnModel.SetEditable(11, false);
                    this.GridPanel2.ColumnModel.SetEditable(12, false);
                    this.GridPanel2.ColumnModel.SetHidden(13, true);
                    Renderer r = new Renderer();
                    r.Fn = "SetCellCssNonEditable";
                    this.GridPanel2.ColumnModel.SetRenderer(11, r);
                    this.GridPanel2.ColumnModel.SetRenderer(12, r);


                    //Added By Song Yuqi On 20140320 End
                    this.cbAdjustTypeWin.SetValue(mainData.Reason);
                    //add lijie 20160520
                    this.cbRsm.Disabled = true;
                }


            }
            else
            {
                // this.cbRsm.Disabled = true;
                this.GridPanel2.ColumnModel.SetEditable(12, false);
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

            if (!string.IsNullOrEmpty(this.txtAdjustReasonWin.Text))
            {
                mainData.UserDescription = this.txtAdjustReasonWin.Text;
            }
            if (!string.IsNullOrEmpty(this.cbAdjustTypeWin.SelectedItem.Value))
            {
                mainData.Reason = this.cbAdjustTypeWin.SelectedItem.Value;
            }
            if (!string.IsNullOrEmpty(this.cbRsm.SelectedItem.Value))
            {
                mainData.Rsm = this.cbRsm.SelectedItem.Value;
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
                //Edited By Song Yuqi On 20140320 Begin
                //二级经销商、退货、寄售
                business.DeleteDetail(new Guid(this.hiddenAdjustId.Text));


                //Edited By Song Yuqi On 20140320 End
              

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
        [AjaxMethod]
        public void IsHiddenRsm()
        {
            //控制rsm是否隐藏
            InventoryAdjustHeader mainData = business.GetInventoryAdjustById(new Guid(hiddenAdjustId.Text));
            if (cbProductLineWin.SelectedItem.Value == "8f15d92a-47e4-462f-a603-f61983d61b7b")
            {
                DealerMaster dmst = _dealers.GetDealerMaster(mainData.DmaId);
                DealerMaster Partdms = new DealerMaster();
                if (dmst != null)
                {
                    Partdms = _dealers.GetDealerMaster(dmst.ParentDmaId.Value);
                }
                if (dmst.DealerType == "T2" && Partdms.Taxpayer == "红海")
                {
                    //订产品线为Endo且平台类型为红海的T2经销商才能查看RSM
                    this.cbRsm.Hidden = false;
                    //Hashtable ht = new Hashtable();
                    //ht.Add("ProductLineId", cbProductLineWin.SelectedItem.Value);
                    //DataSet ds = business.SelectT_I_QV_SalesRepDealerByProductLine(ht);
                    //RsmStore.DataSource = ds;
                    hiddenIsRsm.Text = "true";
                    RsmStore.DataBind();
                }
                else {
                    hiddenIsRsm.Text = "false";
                    this.cbRsm.Hidden = true;
                }

            }
            else {
                hiddenIsRsm.Text = "false";
                this.cbRsm.Hidden = true;
            }
        }
        protected void SaveInvAdjDetailLine(object sender, AjaxEventArgs e)
        {

            string json = e.ExtraParams["Values"];
            Dictionary<string, string>[] fieldPair = JSON.Deserialize<Dictionary<string, string>[]>(json);
            string value = "";

            //IInventoryAdjustBLL business = new InventoryAdjustBLL();

            InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(this.hiddenCurrentEdit.Text));

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

        //Edited By Song Yuqi On 20140320 Begin
        [AjaxMethod]
        public void SaveItem(String adjustQty, String QrCode, String EditQrCode, String lotNumber)
        {
            if (string.IsNullOrEmpty(EditQrCode))
            {
                InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(this.hiddenCurrentEdit.Text));

                lot.LotQty = Convert.ToDouble(adjustQty);


                bool result = business.SaveItem(lot);

                if (!result)
                {
                    Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
                }
            }
            else if (QrCode == "NoQR" && !string.IsNullOrEmpty(EditQrCode))
            {
                //校验二维码库中是否存在这个二维码
                if (business.QueryQrCodeIsExist(EditQrCode))
                {

                    InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(this.hiddenCurrentEdit.Text));

                    lot.QrLotNumber = lotNumber + "@@" + EditQrCode;
                    lot.LotQty = Convert.ToDouble(adjustQty);

                    bool result = business.SaveItem(lot);

                    if (!result)
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
                    }
                }
                else
                {
                    Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), "不存在此二维码").Show();
                }
            }
            this.DetailStore.DataBind();
        }
        //Edited By Song Yuqi On 20140320 End

        [AjaxMethod]
        public void DoSubmit()
        {
            //IInventoryAdjustBLL business = new InventoryAdjustBLL();
            //更新字段
            InventoryAdjustHeader mainData = business.GetInventoryAdjustById(new Guid(this.hiddenAdjustId.Text));

            if (!string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
            {
                mainData.ProductLineBumId = new Guid(this.cbProductLineWin.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtAdjustReasonWin.Text))
            {
                mainData.UserDescription = this.txtAdjustReasonWin.Text;
            }
            if (!string.IsNullOrEmpty(this.cbAdjustTypeWin.SelectedItem.Value))
            {
                mainData.Reason = this.cbAdjustTypeWin.SelectedItem.Value;
            }
            if (!string.IsNullOrEmpty(this.cbRsm.SelectedItem.Value))
            {
                mainData.Rsm = this.cbRsm.SelectedItem.Value;
            }
            bool result = false;

            try
            {
                result = business.Submit(mainData);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                if (this._context.User.CorpType == DealerType.T1.ToString() || this._context.User.CorpType == DealerType.LP.ToString())
                {
                    Ext.Msg.Alert(GetLocalResourceObject("DoSubmit.True.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.True.Alert.Body").ToString()).Show();
                }
                else
                {
                    Ext.Msg.Alert(GetLocalResourceObject("DoSubmit.True.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.True.Alert.Body").ToString()).Show();
                }
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoSubmit.False.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.False.Alert.Body").ToString()).Show();
            }
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
    }
}
