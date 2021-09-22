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
using System.IO;
using System.Text.RegularExpressions;

namespace DMS.Website.Pages.Inventory
{
    public partial class InventoryReturn : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();
        private IInventoryAdjustBLL _business = null;
        private IDealerMasters _dealers = Global.ApplicationContainer.Resolve<IDealerMasters>();
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

        private IAttachmentBLL _attachBll;
        [Dependency]
        public IAttachmentBLL attachBll
        {
            get { return _attachBll; }
            set { _attachBll = value; }
        }
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                //this.btnInsert.Disabled = !IsDealer;
                this.btnInsert.Visible = IsDealer;
                this.btnInsertConsignment.Visible = IsDealer;//Added By Song Yuqi On 20140321

                this.Bind_ProductLine(this.ProductLineStore);
                //this.Bind_DealerList(this.DealerStore);
                this.Bind_Status(this.AdjustStatusStore);

                //加载AdjustTypeStore
                List<object> list = new List<object>
                {
                    new {Value = "退款(寄售产品仅退货)", Key = "Return"},
                    new {Value = "换货", Key = "Exchange"}

                };
                if (_context.User.CorpType == DealerType.LP.ToString() || _context.User.CorpType == DealerType.LS.ToString() || _context.User.CorpType == DealerType.T1.ToString())
                {
                    list.Add(new { Value = "转移给其他经销商", Key = "Transfer" });
                }
                //AdjustTypeStore.DataSource = list;
                //AdjustTypeStore.DataBind();

                AdjustTypeForMainStore.DataSource = list;
                AdjustTypeForMainStore.DataBind();


                if (IsDealer)
                {
                    if (_context.User.CorpType == DealerType.HQ.ToString())
                    {
                        this.btnInsert.Visible = false;
                    }
                    //Added By Song Yuqi On 20140321 Begin
                    //只有二级经销商可以显示寄售退货按钮
                    this.btnInsertConsignment.Visible = true;
                    //this.btnImportConsignment.Visible = true;
                    this.btnInsertBorrow.Visible = false;
                    if (_context.User.CorpType != DealerType.T2.ToString())
                    {
                        this.btnInsertConsignment.Visible = false;
                        //this.btnImportConsignment.Visible = false;
                        //T1和LP显示短期寄售退货按钮
                        this.btnInsertBorrow.Visible = true;
                    }
                    //Added By Song Yuqi On 20140321 End
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
                    else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
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
                    if (_context.User.IdentityType == IdentityType.User.ToString())
                    {
                        this.btnInsert.Visible = true;
                        this.btnInsertBorrow.Visible = true;
                        this.btnInsertConsignment.Visible = true;
                    }
                    this.Bind_DealerList(this.DealerStore);
                    this.cbDealer.Disabled = false;
                }

                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryReturn, PermissionType.Read);
                this.btnExport.Visible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryReturn, PermissionType.Read);
                //this.btnInsert.Visible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryReturn, PermissionType.Write);
                //this.btnInsertConsignment.Visible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryReturn, PermissionType.Write);
                //this.btnImport.Visible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryReturn, PermissionType.Write);
                //this.btnImportConsignment.Visible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryReturn, PermissionType.Write);

            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            this.InventoryAdjustDialog1.GridStore = this.DetailStore;
            this.InventoryAdjustDialog1.GridConsignmentStore = this.ConsignmentDetailStore;
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

            if (!string.IsNullOrEmpty(this.cbReturnType.SelectedItem.Value))
            {
                param.Add("Type", this.cbReturnType.SelectedItem.Value);
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
            if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString())))
            {
                param.Add("LPId", RoleModelContext.Current.User.CorpId);
            }

            DataSet ds = business.QueryInventoryAdjustHeaderReturn(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this.hiddenAdjustId.Text);

            //IInventoryAdjustBLL business = new InventoryAdjustBLL();

            int totalCount = 0;
            DataSet ds = new DataSet();
            Hashtable param = new Hashtable();

            param.Add("AdjustId", tid);
            if (this.hiddenReturnType.Text == AdjustWarehouseType.Borrow.ToString())
            {
                // ds = business.QueryInventoryAdjustLot(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
                ds = business.SelectByFilterInventoryAdjustLotTransfer(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            }
            else
            {
                ds = business.QueryInventoryAdjustLot(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            }

            e.TotalCount = totalCount;

            this.DetailStore.DataSource = ds;
            this.DetailStore.DataBind();
            DisplayRetrunPrcie(hiddenAdjustId.Text);
        }
        protected void RetrunReasonStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable ht = new Hashtable();
            ht.Add("TypeName", "CONST_AdjustRenturn_Reason");
            ht.Add("Value2", this.hiddApplyType.Value);
            if (!string.IsNullOrEmpty(this.hiddApplyType.Value.ToString()))
            {
                DataSet ds = _business.SelectAdjustRenturn_Reason(ht);
                RetrunReasonStore.DataSource = ds;
                RetrunReasonStore.DataBind();
            }

        }

        protected void RsmStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //add lijie 20160510
            if (!string.IsNullOrEmpty(hiddenAdjustId.Text))
            {
                InventoryAdjustHeader mainData = business.GetInventoryAdjustById(new Guid(hiddenAdjustId.Text));
                DealerMaster dmst = _dealers.SelectDealerMasterParentTypebyId(mainData.DmaId);

                if (dmst.DealerType == "T1" || dmst.DealerType == "LP" || dmst.DealerType == "LS")
                {
                    DataSet ds = new DataSet();
                    Hashtable ht = new Hashtable();
                    ht.Add("ProductLineId", hiddenProductLineId.Text);
                    ht.Add("DealerCode", dmst.SapCode);

                    //Added By Song Yuqi On 2017-08-24 For 普通退换货对接EKP Begin
                    if (IsPageNew)
                    {
                        //如果是新添加的订单则在SelectT_I_QV_SalesRepDealer取RSM
                        ds = business.SelectT_I_QV_SalesRepDealerByProductLine(ht);
                    }
                    else
                    {
                        //如果是历史订单则在interface.T_I_QV_SalesRep 取
                        ds = business.SelectT_I_QV_SalesRepByProductLine(ht);

                    }
                    RsmStore.DataSource = ds;
                    RsmStore.DataBind();
                    hiddenIsRsm.Text = "true";
                    cbRsm.Hidden = false;
                }
                else
                {
                    hiddenIsRsm.Text = "false";
                    cbRsm.Hidden = true;
                }


                //Added By Song Yuqi On 2017-08-24 For 普通退换货对接EKP End

                //if (hiddenReturnType.Text == "Normal")
                //{
                //lijie add 2016_05_24 如果为普通订单，判断经销商类型和产品线
                //Hashtable ht = new Hashtable();
                //DataSet ds = new DataSet();
                //ht.Add("ProductLineId", hiddenProductLineId.Text);
                //ht.Add("DealerCode", dmst.SapCode);
                //if ((cbProductLineWin.SelectedItem.Value == "8f15d92a-47e4-462f-a603-f61983d61b7b" && dmst.DealerType.Equals(DealerType.T1.ToString()))
                //    || cbProductLineWin.SelectedItem.Value == "97a4e135-74c7-4802-af23-9d6d00fcb2cc" || cbProductLineWin.SelectedItem.Value == "8de26929-588b-4e24-9dcd-a26200a9d56b"
                //    || cbProductLineWin.SelectedItem.Value == "e2964379-9323-4009-9cf9-a33800b55a2b" || cbProductLineWin.SelectedItem.Value == "0f71530b-66d5-44af-9cab-ad65d5449c51")
                //{
                //    // lijie add 2016-05-24如果产品线是Endo，用户类型为T1的普通订单或者大心脏都需要选择rsm
                //    hiddenIsRsm.Text = "true";
                //    cbRsm.Hidden = false;
                //    if (IsPageNew)
                //    {
                //        //如果是新添加的订单则在SelectT_I_QV_SalesRepDealer取RSM
                //        ds = business.SelectT_I_QV_SalesRepDealerByProductLine(ht);
                //    }
                //    else
                //    {
                //        //如果是历史订单则在interface.T_I_QV_SalesRep 取
                //        ds = business.SelectT_I_QV_SalesRepByProductLine(ht);

                //    }
                //    RsmStore.DataSource = ds;
                //    RsmStore.DataBind();

                //}
                //else if ((cbProductLineWin.SelectedItem.Value == "8f15d92a-47e4-462f-a603-f61983d61b7b" && dmst.DealerType.Equals(DealerType.T2.ToString()) && dmst.Taxpayer == "红海")
                //   || cbProductLineWin.SelectedItem.Value == "97a4e135-74c7-4802-af23-9d6d00fcb2cc" || cbProductLineWin.SelectedItem.Value == "8de26929-588b-4e24-9dcd-a26200a9d56b"
                //   || cbProductLineWin.SelectedItem.Value == "e2964379-9323-4009-9cf9-a33800b55a2b" || cbProductLineWin.SelectedItem.Value == "0f71530b-66d5-44af-9cab-ad65d5449c51")
                //{
                //    //lijie add 2016_05_24如果产品线是Endo，用户类型为T2所属品台为红海
                //    if (IsPageNew)
                //    {
                //        //如果是新添加的订单则在SelectT_I_QV_SalesRepDealer取RSM
                //        ds = business.SelectT_I_QV_SalesRepDealerByProductLine(ht);
                //    }
                //    else
                //    {
                //        //如果是历史订单则在interface.T_I_QV_SalesRep 取
                //        ds = business.SelectT_I_QV_SalesRepByProductLine(ht);

                //    }
                //    RsmStore.DataSource = ds;
                //    RsmStore.DataBind();
                //    hiddenIsRsm.Text = "true";
                //    cbRsm.Hidden = false;
                //}
                //else
                //{
                //    hiddenIsRsm.Text = "false";
                //    cbRsm.Hidden = true;
                //}
                //}
                //else
                //{
                //    hiddenIsRsm.Text = "false";
                //    cbRsm.Hidden = true;
                //}
            }
        }

        protected void ConsignmentDetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this.hiddenAdjustId.Text);

            int totalCount = 0;

            Hashtable param = new Hashtable();

            param.Add("AdjustId", tid);

            //二级经销商、寄售、退货
            if ((this.hiddenAdjustTypeId.Text == AdjustType.Return.ToString() || this.hiddenAdjustTypeId.Text == AdjustType.Exchange.ToString())
                && this.hiddenDealerType.Text == DealerType.T2.ToString()
                && this.hiddenReturnType.Text == AdjustWarehouseType.Consignment.ToString())
            {
                param.Add("DealerId", this.cbDealerWin.SelectedItem.Value);
                param.Add("WarehouseTypes", string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(','));

                DataSet ds = business.QueryInventoryAdjustConsignment(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarConsignment.PageSize : e.Limit), out totalCount);

                e.TotalCount = totalCount;
                this.ConsignmentDetailStore.DataSource = ds;
                this.ConsignmentDetailStore.DataBind();
            }
            //转移给其他经销商
            else if ((this.hiddenDealerType.Text == DealerType.T1.ToString() || this.hiddenDealerType.Text == DealerType.LP.ToString() || this.hiddenDealerType.Text == DealerType.LS.ToString())
                && this.hiddenReturnType.Text == AdjustWarehouseType.Borrow.ToString())
            {
                param.Add("DealerId", this.cbDealerWin.SelectedItem.Value);
                param.Add("WarehouseTypes", string.Format("{0},{1}", WarehouseType.Borrow.ToString(), WarehouseType.LP_Borrow.ToString()).Split(','));

                DataSet ds = business.GetInventoryAdjustBorrowById(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarConsignment.PageSize : e.Limit), out totalCount);

                e.TotalCount = totalCount;
                this.ConsignmentDetailStore.DataSource = ds;
                this.ConsignmentDetailStore.DataBind();
            }
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
            if (string.IsNullOrEmpty(this.cbReturnTypeWin.SelectedItem.Value))
            {
                Ext.Msg.Alert(GetLocalResourceObject("ShowDialog.Alert.Title").ToString(), "请选择退换货要求").Show();
                return;
            }
            if (string.IsNullOrEmpty(this.cbApplyType.SelectedItem.Value))
            {
                Ext.Msg.Alert(GetLocalResourceObject("ShowDialog.Alert.Title").ToString(), "请选择退换货类型").Show();
                return;
            }
            //显示全部仓库
            this.InventoryAdjustDialog1.Show(new Guid(this.hiddenAdjustId.Text), new Guid(this.hiddenDealerId.Text), new Guid(this.hiddenProductLineId.Text), this.cbReturnTypeWin.SelectedItem.Value, this.hiddenReturnType.Text, this.hiddApplyType.Text);
        }

        protected void ShowDetails(object sender, AjaxEventArgs e)
        {
            //初始化detail窗口,因为只有dealer才可以新增，因此打开页面默认选中session中的经销商

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
            this.TabConsignment.Disabled = true;
            //Added By Song Yuqi On 20140320 Begin
            cbRsm.Hidden = true;
            this.hidSalesAccount.Clear();
            hiddApplyType.Clear();
            cbReturnTypeWin.SelectedItem.Value = "";
            cbReturnTypeWin.SelectedItem.Text = "";
            lblInvSum.Text = string.Empty;
            hiddenWhmType.Clear();
            this.hiddenReason.Clear();

            //end


            //窗口状态控制

            this.cbDealerWin.Disabled = true;
            this.GridPanel2.ColumnModel.SetHidden(12, false);
            this.GridPanel2.ColumnModel.SetHidden(13, true);
            this.GridPanel2.ColumnModel.SetHidden(15, true);
            this.GridPanel2.ColumnModel.SetEditable(5, false);
            this.GridPanel2.ColumnModel.SetEditable(7, false);
            this.GridPanel2.ColumnModel.SetEditable(11, false);
            this.GridPanel2.ColumnModel.SetEditable(12, false);
            this.GridPanel2.ColumnModel.SetEditable(13, false);
            this.GridPanel2.ColumnModel.SetEditable(14, false);
            this.GridPanel2.ColumnModel.SetHidden(14, false);
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
            cbReturnReason.Disabled = true;
            this.cbReturnTypeWin.Disabled = true;
            this.cbApplyType.Disabled = true;
            GridPanel2.ColumnModel.SetHidden(15, false);
            GridPanel2.ColumnModel.SetHidden(16, true);
            RetrunReasonStore.RemoveAll();
            Guid id = new Guid(e.ExtraParams["AdjustId"].ToString());
            // hiddenReturnType.Text = e.ExtraParams["AdjustType"].ToString();
            if (hiddenReturnType.Text == "Normal")
            {
                GridPanel2.ColumnModel.SetHidden(12, true);
            }

            //IInventoryAdjustBLL business = new InventoryAdjustBLL();
            InventoryAdjustHeader mainData = null;

            //若id为空，说明为新增，则生成新的id，并新增一条记录
            if (_context.User.IdentityType == IdentityType.User.ToString())
            {
                this.cbDealerWin.Disabled = false;
                this.BindDealerWin(this.DealerStore);


            }
            else
            {
                this.Bind_ProductLine(this.ProductLineStoreWin);
            }
            //隐藏RSM下拉框
            if (id == Guid.Empty)
            {
                id = Guid.NewGuid();
                this.hiddenAdjustId.Text = id.ToString();
                mainData = new InventoryAdjustHeader();
                mainData.Id = id;
                mainData.CreateDate = DateTime.Now;
                mainData.CreateUser = new Guid(RoleModelContext.Current.User.Id);
                if (_context.User.IdentityType == IdentityType.User.ToString())
                {
                    mainData.DmaId = new Guid(hiddenDealerId.Text);
                    this.hiddenDealerType.Text = hiddenDealerType.Text;
                }
                else
                {
                    mainData.DmaId = RoleModelContext.Current.User.CorpId.Value;
                    this.hiddenDealerType.Text = _context.User.CorpType; // Added By Song Yuqi On 20140317
                }
                mainData.Status = AdjustStatus.Draft.ToString();

                //Edited By Song Yuqi On 20140319 Begin
                //由用户新增的类型（点击普通OR寄售新增按钮）判断是普通退货单还是寄售退货单
                mainData.WarehouseType = this.hiddenReturnType.Text;//AdjustWarehouseType.Normal.ToString();
                this.hiddenDealerType.Text = _context.User.CorpType; // Added By Song Yuqi On 20140317
                //Edited By Song Yuqi On 20140319 End

                // mainData.Reason = AdjustType.Return.ToString();
                //lijie edit 2016-06-21 判断是寄售转移还是退货
                mainData.Reason = e.ExtraParams["AdjustType"].ToString();
                //新增的单据
                //IsPageNew = true;
                business.InsertInventoryAdjustHeader(mainData);
            }
            //else
            //{
            //    //历史的单据
            //    IsPageNew = false;
            //}
            //根据ID查询主表数据，并初始化页面
            mainData = business.GetInventoryAdjustById(id);
            this.hiddenDealerId.Text = mainData.DmaId.ToString();
            this.hiddenAdjustId.Text = mainData.Id.ToString();
            if (_context.User.IdentityType == IdentityType.User.ToString())
            {
                this.ProductLineStoreWin.DataSource = GetProductLineStoreDataSourceWin(new Guid(hiddenDealerId.Text));
                this.ProductLineStoreWin.DataBind();
            }

            if (!string.IsNullOrEmpty(mainData.ApplyType))
            {
                this.hiddApplyType.Text = mainData.ApplyType;
            }
            //Added By Song Yuqi On 20140319 Begin
            //获得明细单中经销商的类型
            DealerMaster dma = new DealerMasters().GetDealerMaster(new Guid(this.hiddenDealerId.Text));
            this.hiddenDealerType.Text = dma.DealerType;
            //Added By Song Yuqi On 20140319 End

            if (!string.IsNullOrEmpty(mainData.Reason))
            {
                this.hiddenAdjustTypeId.Text = String.IsNullOrEmpty(e.ExtraParams["AdjustType"].ToString()) ? mainData.Reason : e.ExtraParams["AdjustType"].ToString();
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
            if (mainData.ProductLineBumId.HasValue)
            {
                hiddenProductLineId.Text = mainData.ProductLineBumId.ToString();
            }
            this.txtAdjustStatusWin.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_AdjustQty_Status, mainData.Status);
            this.txtAdjustReasonWin.Text = mainData.UserDescription;
            this.txtAduitNoteWin.Text = mainData.AuditorNotes;
            //窗口状态控制

            //Added By Song Yuqi On 20140319 Begin
            if (mainData.WarehouseType != null)
            {
                this.hiddenReturnType.Text = mainData.WarehouseType;
            }
            if (!string.IsNullOrEmpty(mainData.RetrunReason))
            {
                this.hiddenReason.Text = mainData.RetrunReason;
            }
            this.GridPanel3.ColumnModel.SetEditable(9, false);
            this.GridPanel3.ColumnModel.SetEditable(10, false);
            this.GridPanel3.ColumnModel.SetEditable(11, false);
            this.GridPanel3.ColumnModel.SetHidden(11, true);
            this.GridPanel3.ColumnModel.SetHidden(12, true);
            //如果是用户类型为User lijie add 2016-07-19
            if (_context.User.IdentityType == IdentityType.User.ToString())
            {
                this.cbProductLineWin.Disabled = false;
            }

            //this.btnAddConsignment.Disabled = true;
            //二级经销商寄售退货单
            if (this.hiddenDealerType.Text == DealerType.T2.ToString()
                && mainData.WarehouseType == AdjustWarehouseType.Consignment.ToString()
                && (this.hiddenAdjustTypeId.Text == AdjustType.Return.ToString() ||
                this.hiddenAdjustTypeId.Text == AdjustType.Exchange.ToString()))
            {

                this.TabPanel1.ActiveTabIndex = 0;
                this.TabConsignment.Disabled = true;
                this.TabHeader.Disabled = false;

            }
            else if ((this.hiddenDealerType.Text == DealerType.T1.ToString() || this.hiddenDealerType.Text == DealerType.LP.ToString() || this.hiddenDealerType.Text == DealerType.LS.ToString())
                && mainData.WarehouseType == AdjustWarehouseType.Borrow.ToString())
            {

                this.TabPanel1.ActiveTabIndex = 0;
                this.TabConsignment.Disabled = true;
                this.TabHeader.Disabled = false;
                this.GridPanel2.ColumnModel.SetHidden(13, false);
                this.GridPanel2.ColumnModel.SetHidden(14, true);
                if (mainData.Status == AdjustStatus.Draft.ToString())
                {
                    Renderer f = new Renderer();
                    f.Fn = "SetCellCssEditable";
                    this.GridPanel2.ColumnModel.SetRenderer(13, f);
                }
                //if (mainData.Status == AdjustStatus.Draft.ToString())
                //{
                //    this.TabPanel1.ActiveTabIndex = 1;
                //    this.TabConsignment.Disabled = false;
                //    this.TabHeader.Disabled = true;
                //}
                //else
                //{
                //    this.TabPanel1.ActiveTabIndex = 0;
                //    this.TabConsignment.Disabled = false;
                //    this.TabHeader.Disabled = false;
                //}
            }
            if (mainData.WarehouseType == "Normal")
            {
                //如果LP或T1的普通退货申请单，隐藏关联订单，显示价格
                //GridPanel2.ColumnModel.SetHidden(12, true);
                GridPanel2.ColumnModel.SetHidden(15, false);

            }
            else if (mainData.WarehouseType == "Borrow" || mainData.WarehouseType == "Consignment")
            {
                //如果LP或T1的寄售转移申请单，显示关联订单，隐藏价格
                //GridPanel2.ColumnModel.SetHidden(12, false);
                GridPanel2.ColumnModel.SetHidden(15, true);

            }
            //Added By Song Yuqi On 20140319 End
            cbRsm.Disabled = true;
            //退货要求与原因联动
            #region 退货类型与退货要求的联动
            Hashtable ht = new Hashtable();
            ht.Add("TypeName", "CONST_AdjustRenturn_Type");
            DataSet ds = new DataSet();
            if ((this.hiddenDealerType.Text == DealerType.T1.ToString() || this.hiddenDealerType.Text == DealerType.LP.ToString() || this.hiddenDealerType.Text == DealerType.LS.ToString()) && this.hiddenReturnType.Text == AdjustWarehouseType.Borrow.ToString() && this.hiddenAdjustTypeId.Text == AdjustType.Transfer.ToString())
            {
                cbReturnReason.Hidden = true;
                //如果是寄售转移
                ht.Add("DmaType", "LTC");
                ds = _business.SelectAdjustRenturn_Reason(ht);
                List<object> list = new List<object>
                       {
                            new { Value = "转移给其他经销商", Key = "Transfer" }
                       };

                AdjustTypeStore.DataSource = list;
                AdjustTypeStore.DataBind();
                AdjustReturnTypeStore.DataSource = ds;
                AdjustReturnTypeStore.DataBind();
                this.cbApplyType.SetValue(ds.Tables[0].Rows[0]["Key"].ToString());
                this.cbReturnTypeWin.SetValue("Transfer");
                hiddApplyType.Text = ds.Tables[0].Rows[0]["Key"].ToString();
                hiddenWhmType.Text = "Consignment";
            }
            else if (this.hiddenDealerType.Text == DealerType.T1.ToString() || this.hiddenDealerType.Text == DealerType.LP.ToString() || this.hiddenDealerType.Text == DealerType.LS.ToString())
            {
                cbReturnReason.Hidden = false;
                //如果是T1或品台平台普通退货
                ht.Add("DmaType", "LT");
                ds = _business.SelectAdjustRenturn_Reason(ht);
                AdjustReturnTypeStore.DataSource = ds;
                AdjustReturnTypeStore.DataBind();
                if (!string.IsNullOrEmpty(mainData.ApplyType))
                {
                    this.cbApplyType.SetValue(mainData.ApplyType);
                    ht.Add("Key", mainData.ApplyType);
                    DataSet Dds = _business.SelectAdjustRenturn_Reason(ht);
                    if (Dds.Tables[0].Rows[0]["VALUE2"].ToString() == "1")
                    {

                        if (mainData.RetrunReason == "5")
                        {
                            //1代表可选退货和换货
                            List<object> list = new List<object>
                        {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"}

                        };
                            AdjustTypeStore.DataSource = list;
                            AdjustTypeStore.DataBind();
                        }
                        else
                        {

                            //1代表可选退货和换货
                            List<object> list = new List<object>
                        {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"},
                            new {Value = "换货", Key = "Exchange"}

                        };
                            AdjustTypeStore.DataSource = list;
                            AdjustTypeStore.DataBind();
                        }

                        this.cbReturnTypeWin.SetValue(mainData.Reason);

                    }
                    else if (Dds.Tables[0].Rows[0]["VALUE2"].ToString() == "2")
                    {
                        //2代表只可选退货
                        List<object> list = new List<object>
                        {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"},
                        };
                        AdjustTypeStore.DataSource = list;
                        AdjustTypeStore.DataBind();
                        this.cbReturnTypeWin.SetValue(mainData.Reason);
                    }

                    if (Dds.Tables[0].Rows[0]["REV3"].ToString() == "Consignment")
                    {
                        //如果限制的仓库为寄售
                        // GridPanel2.ColumnModel.SetHidden(12, false);
                        GridPanel2.ColumnModel.SetHidden(15, true);
                    }
                    hiddenWhmType.Text = Dds.Tables[0].Rows[0]["REV3"].ToString();
                }
                else
                {
                    //清空退换货要求sotre
                    AdjustTypeStore.RemoveAll();
                    AdjustTypeStore.DataBind();
                }
            }
            else if (this.hiddenDealerType.Text == DealerType.T2.ToString())
            {
                cbReturnReason.Hidden = true;
                ht.Add("DmaType", "T2");
                ht.Add("Rev3", this.hiddenReturnType.Text);
                ds = _business.SelectAdjustRenturn_Reason(ht);
                if (hiddenReturnType.Text == AdjustWarehouseType.Consignment.ToString())
                {
                    List<object> list = new List<object>
                        {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"},

                        };
                    AdjustTypeStore.DataSource = list;
                }
                else
                {
                    List<object> list = new List<object>
                        {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"},
                            new {Value = "换货", Key = "Exchange"}

                        };
                    AdjustTypeStore.DataSource = list;
                }
                AdjustReturnTypeStore.DataSource = ds;
                AdjustReturnTypeStore.DataBind();

                AdjustTypeStore.DataBind();
                cbApplyType.SetValue(ds.Tables[0].Rows[0]["Key"].ToString());
                hiddApplyType.Text = ds.Tables[0].Rows[0]["Key"].ToString();
                hiddenWhmType.Text = ds.Tables[0].Rows[0]["REV3"].ToString();
                this.cbReturnTypeWin.SetValue(mainData.Reason);
                //this.cbReturnTypeWin.SetValue("Return");
            }
            //cbApplyType.SelectedItem.Value = hiddApplyType.Text;


            #endregion
            DisplayRetrunPrcie(mainData.Id.ToString());
            if (IsDealer || _context.User.IdentityType == IdentityType.User.ToString())
            {
                if (mainData.Status == AdjustStatus.Draft.ToString())
                {
                    IsPageNew = true;
                    this.cbProductLineWin.Disabled = false;
                    //this.txtAdjustReasonWin.Disabled = false;
                    this.txtAdjustReasonWin.ReadOnly = false;
                    this.DraftButton.Disabled = false;
                    this.DeleteButton.Disabled = false;
                    this.SubmitButton.Disabled = false;
                    this.cbApplyType.Disabled = false;
                    // this.GridPanel2.ColumnModel.SetHidden(12, false);
                    this.GridPanel2.ColumnModel.SetHidden(16, false);

                    this.GridPanel2.ColumnModel.SetEditable(11, true);
                    this.GridPanel2.ColumnModel.SetEditable(12, true);
                    this.GridPanel2.ColumnModel.SetEditable(13, true);
                    this.GridPanel2.ColumnModel.SetEditable(14, true);
                    this.GridPanel2.ColumnModel.SetEditable(15, true);
                    GridPanel2.ColumnModel.SetHidden(16, false);
                    this.AddItemsButton.Disabled = false;
                    Renderer r = new Renderer();
                    r.Fn = "SetCellCssEditable";
                    this.GridPanel2.ColumnModel.SetRenderer(11, r);
                    this.GridPanel2.ColumnModel.SetRenderer(14, r);

                    //Added By Song Yuqi On 20140320 Begin
                    this.GridPanel2.ColumnModel.SetRenderer(12, r); //订单号


                    this.GridPanel3.ColumnModel.SetHidden(12, false);
                    this.GridPanel3.ColumnModel.SetRenderer(9, r);
                    this.GridPanel3.ColumnModel.SetRenderer(10, r);
                    this.GridPanel3.ColumnModel.SetRenderer(11, r);
                    this.GridPanel3.ColumnModel.SetEditable(9, true);
                    this.GridPanel3.ColumnModel.SetEditable(10, true);
                    this.GridPanel3.ColumnModel.SetEditable(11, true);
                    cbRsm.Disabled = false;
                    cbReturnReason.Disabled = false;
                    if (this.hiddenDealerType.Text == DealerType.T1.ToString() || this.hiddenDealerType.Text == DealerType.LP.ToString() || this.hiddenDealerType.Text == DealerType.LS.ToString())
                    {
                        this.GridPanel3.ColumnModel.SetHidden(11, false);
                    }
                    //Added By Song Yuqi On 20140320 End
                    this.cbReturnTypeWin.Disabled = false;

                    //if ((this.hiddenDealerType.Text == DealerType.T1.ToString() || this.hiddenDealerType.Text == DealerType.LP.ToString()) && this.hiddenReturnType.Text == AdjustWarehouseType.Borrow.ToString() && this.hiddenAdjustTypeId.Text == AdjustType.Transfer.ToString())
                    //{
                    //    List<object> list = new List<object>
                    //   {
                    //        new { Value = "转移给其他经销商", Key = "Transfer" }
                    //   };

                    //    AdjustTypeStore.DataSource = list;
                    //    AdjustTypeStore.DataBind();

                    //    this.cbReturnTypeWin.SetValue("Transfer");
                    //}
                    //else
                    //{
                    //    List<object> list = new List<object>
                    //    {
                    //        new {Value = "退货", Key = "Return"},
                    //        new {Value = "换货", Key = "Exchange"}

                    //    };
                    //    AdjustTypeStore.DataSource = list;
                    //    AdjustTypeStore.DataBind();
                    //    //this.cbReturnTypeWin.SetValue("Return");
                    //}


                }
                else
                {
                    IsPageNew = false;
                    Renderer r = new Renderer();
                    r.Fn = "SetCellCssNonEditable";
                    //this.GridPanel2.ColumnModel.SetRenderer(10, r);
                    //Added By Song Yuqi On 20140320 Begin
                    this.GridPanel2.ColumnModel.SetRenderer(11, r);
                    this.GridPanel2.ColumnModel.SetRenderer(12, r); //订单号
                    this.GridPanel2.ColumnModel.SetHidden(12, false);
                    this.GridPanel2.ColumnModel.SetRenderer(13, r); //订单号
                    this.GridPanel3.ColumnModel.SetRenderer(9, r);
                    this.GridPanel3.ColumnModel.SetRenderer(10, r);
                    if (mainData.WarehouseType == "Normal")
                    {
                        //如果LP或T1的普通退货申请单，隐藏关联订单，显示价格
                        GridPanel2.ColumnModel.SetHidden(12, true);


                    }
                    else if (mainData.WarehouseType == "Borrow" || mainData.WarehouseType == "Consignment")
                    {
                        //如果LP或T1的寄售转移申请单，显示关联订单，隐藏价格
                        // GridPanel2.ColumnModel.SetHidden(12, false);


                    }
                    if ((this.hiddenDealerType.Text == DealerType.T1.ToString() || this.hiddenDealerType.Text == DealerType.LP.ToString() || this.hiddenDealerType.Text == DealerType.LS.ToString()) && this.hiddenReturnType.Text == AdjustWarehouseType.Borrow.ToString())
                    {
                        this.GridPanel2.ColumnModel.SetHidden(13, false);
                        this.GridPanel2.ColumnModel.SetEditable(13, false);
                        this.GridPanel3.ColumnModel.SetRenderer(11, r);
                        this.GridPanel3.ColumnModel.SetHidden(11, false);
                    }
                    //Added By Song Yuqi On 20140320 End
                    this.cbReturnTypeWin.SetValue(mainData.Reason);
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
                    //如果是退货，已提交时不能撤销，如果e-workflow已确认，则也不能修改
                    if (mainData.Status == AdjustStatus.Submitted.ToString() && business.QueryLPGoodsReturnApprove(id.ToString()).Tables[0].Rows.Count == 0)
                    {
                        this.RevokeButton.Disabled = false;
                    }

                    //如果是二级经销商，且状态是已提交，则也不能修改
                    if (_context.User.IdentityType != IdentityType.User.ToString())
                    {
                        if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()) && mainData.Status == AdjustStatus.Submitted.ToString())
                        {
                            this.RevokeButton.Disabled = true;
                        }
                        //如果是平台，且单据经销商不是平台，则也不能修改
                        if ((RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString())) && mainData.Status == AdjustStatus.Submitted.ToString() && !mainData.DmaId.ToString().Equals(RoleModelContext.Current.User.CorpId.Value.ToString()))
                        {
                            this.RevokeButton.Disabled = true;
                        }
                    }



                    //如果是平台或者T1不可撤销 ljie add 2016-06-28
                    if (this.hiddenDealerType.Text.Equals(DealerType.T1.ToString()) || this.hiddenDealerType.Text.Equals(DealerType.LP.ToString()) || this.hiddenDealerType.Text.Equals(DealerType.LS.ToString()))
                    {
                        this.RevokeButton.Disabled = true;
                    }

                    if (mainData.WarehouseType == "Normal" && mainData.ProductLineBumId.ToString() == "8f15d92a-47e4-462f-a603-f61983d61b7b" && mainData.Reason == "Return" && mainData.Status.ToString() != AdjustStatus.Draft.ToString())
                    {
                        //如果为普通退货单，产品线为Endo,经销商类型为T1或T2，为红海所属的不能修改
                        //DealerMaster dmst = _dealers.GetDealerMaster(mainData.DmaId);
                        //if (((dmst.DealerType == "T2" && dmst.Taxpayer == "红海") || dmst.DealerType == "T1") &&  mainData.State.ToString() != AdjustStatus.Draft.ToString())
                        //{
                        this.RevokeButton.Disabled = true;
                        //}
                    }
                }
            }

            if (mainData.Status == AdjustStatus.Reject.ToString() || mainData.Status == AdjustStatus.Accept.ToString())
            {
                this.txtAduitNoteWin.Hidden = false;
            }
            //显示窗口
            this.DetailWindow.Show();
        }
        public void DisplayRetrunPrcie(string IahId)
        {
            //获取产品总数量和总价格
            DataSet Pds = _business.SelectReturnProductQtyorPrice(IahId);

            if (Pds.Tables[0].Rows.Count > 0)
            {
                decimal SumQty = 0;
                decimal SumPrice = 0;
                decimal SumPriceTax = 0;
                if (Pds.Tables[0].Rows[0]["SumQty"] != DBNull.Value)
                {
                    SumQty = decimal.Parse(Pds.Tables[0].Rows[0]["SumQty"].ToString());
                }
                if (Pds.Tables[0].Rows[0]["SumPrice"] != DBNull.Value)
                {
                    SumPrice = decimal.Parse(Pds.Tables[0].Rows[0]["SumPrice"].ToString());
                }
                if (Pds.Tables[0].Rows[0]["SumQtyTax"] != DBNull.Value)
                {
                    SumPriceTax = decimal.Parse(Pds.Tables[0].Rows[0]["SumQtyTax"].ToString());
                }
                if (hiddenWhmType.Text == "Normal")
                {
                    lblInvSum.Text = "退货总数量:" + SumQty + ";不含税总金额(CNY):" + SumPriceTax + ";含税总金额(CNY):" + SumPrice;
                }
                else
                {
                    lblInvSum.Text = "退货总数量:" + SumQty;
                }
            }
        }
        [AjaxMethod]
        public void OnChangcbReturnReason(string ReturnReason)
        {

            if ((this.hiddenDealerType.Text == DealerType.T1.ToString() || this.hiddenDealerType.Text == DealerType.LP.ToString() || this.hiddenDealerType.Text == DealerType.LS.ToString()) && this.hiddenReturnType.Text == AdjustWarehouseType.Normal.ToString())
            {
                cbReturnTypeWin.SelectedItem.Value = "";
                cbReturnTypeWin.SelectedItem.Text = "";
                cbReturnReason.Hidden = false;

                DataSet ds = new DataSet();
                //如果是T1或品台平台普通退货
                Hashtable ht = new Hashtable();
                ht.Add("TypeName", "CONST_AdjustRenturn_Type");
                ht.Add("DmaType", "LT");
                //ds = _business.SelectAdjustRenturn_Reason(ht);
                //AdjustReturnTypeStore.DataSource = ds;
                //AdjustReturnTypeStore.DataBind();
                if (!string.IsNullOrEmpty(cbApplyType.SelectedItem.Value))
                {

                    ht.Add("Key", cbApplyType.SelectedItem.Value);
                    DataSet Dds = _business.SelectAdjustRenturn_Reason(ht);
                    if (Dds.Tables[0].Rows[0]["VALUE2"].ToString() == "1")
                    {
                        //1代表可选退货和换货

                        if (ReturnReason == "5")
                        {
                            List<object> list = new List<object>
                          {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"}

                          };
                            AdjustTypeStore.DataSource = list;
                            AdjustTypeStore.DataBind();
                        }
                        else
                        {
                            List<object> list = new List<object>
                          {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"},
                            new {Value = "换货", Key = "Exchange"}

                          };
                            AdjustTypeStore.DataSource = list;
                            AdjustTypeStore.DataBind();
                        }



                    }
                    else if (Dds.Tables[0].Rows[0]["VALUE2"].ToString() == "2")
                    {
                        //2代表只可选退货
                        List<object> list = new List<object>
                        {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"},
                        };
                        AdjustTypeStore.DataSource = list;
                        AdjustTypeStore.DataBind();

                    }

                    if (Dds.Tables[0].Rows[0]["REV3"].ToString() == "Consignment")
                    {
                        //如果限制的仓库为寄售
                        // GridPanel2.ColumnModel.SetHidden(12, false);
                        GridPanel2.ColumnModel.SetHidden(15, true);
                    }
                    hiddenWhmType.Text = Dds.Tables[0].Rows[0]["REV3"].ToString();
                }
                else
                {
                    //清空退换货要求sotre
                    AdjustTypeStore.RemoveAll();
                    AdjustTypeStore.DataBind();
                }
            }

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
            if (!string.IsNullOrEmpty(this.cbReturnTypeWin.SelectedItem.Value))
            {
                mainData.Reason = this.cbReturnTypeWin.SelectedItem.Value;
            }

            if (!string.IsNullOrEmpty(this.cbRsm.SelectedItem.Value))
            {
                mainData.Rsm = this.cbRsm.SelectedItem.Value;
            }
            if (!string.IsNullOrEmpty(cbApplyType.SelectedItem.Value))
            {
                mainData.ApplyType = cbApplyType.SelectedItem.Value;
            }
            if (!string.IsNullOrEmpty(this.hiddenDealerId.Text))
            {
                mainData.DmaId = new Guid(this.hiddenDealerId.Text);
            }
            if (!string.IsNullOrEmpty(this.cbReturnReason.SelectedItem.Value))
            {
                mainData.RetrunReason = this.cbReturnReason.SelectedItem.Value;
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
                if (this.hiddenDealerType.Text == DealerType.T2.ToString()
                    && (this.hiddenAdjustTypeId.Text == AdjustType.Return.ToString() || this.hiddenAdjustTypeId.Text == AdjustType.Exchange.ToString())
                    && this.hiddenReturnType.Text == AdjustWarehouseType.Consignment.ToString())
                {
                    business.DeleteConsignmentItemByHeaderId(new Guid(this.hiddenAdjustId.Text));
                }
                //一级经销商及物流平台短期寄售产品退货
                else if ((this.hiddenDealerType.Text == DealerType.T1.ToString() || this.hiddenDealerType.Text == DealerType.LP.ToString() || this.hiddenDealerType.Text == DealerType.LS.ToString())
                && this.hiddenAdjustTypeId.Text == AdjustType.Transfer.ToString()
                && this.hiddenReturnType.Text == AdjustWarehouseType.Consignment.ToString())
                {
                    business.DeleteConsignmentItemByHeaderId(new Guid(this.hiddenAdjustId.Text));
                }
                else
                {
                    business.DeleteDetail(new Guid(this.hiddenAdjustId.Text));
                }

                //Edited By Song Yuqi On 20140320 End
                // RsmStore.DataBind();

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        [AjaxMethod]
        public void OnCbApplyChange()
        {
            try
            {

                Hashtable ht = new Hashtable();
                ht.Add("TypeName", "CONST_AdjustRenturn_Type");
                DataSet ds = new DataSet();
                hiddApplyType.Text = cbApplyType.SelectedItem.Value;
                cbReturnTypeWin.SelectedItem.Value = "";
                cbReturnTypeWin.SelectedItem.Text = "";
                if (this.hiddenDealerType.Text == DealerType.T1.ToString() || this.hiddenDealerType.Text == DealerType.LP.ToString() || this.hiddenDealerType.Text == DealerType.LS.ToString())
                {

                    if (!string.IsNullOrEmpty(cbApplyType.SelectedItem.Value))
                    {

                        ht.Add("Key", cbApplyType.SelectedItem.Value);
                        DataSet Dds = _business.SelectAdjustRenturn_Reason(ht);
                        if (Dds.Tables[0].Rows[0]["VALUE2"].ToString() == "1")
                        {
                            //1代表可选退货和换货
                            List<object> list = new List<object>
                        {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"},
                            new {Value = "换货", Key = "Exchange"}

                        };
                            AdjustTypeStore.DataSource = list;
                            AdjustTypeStore.DataBind();

                        }
                        else if (Dds.Tables[0].Rows[0]["VALUE2"].ToString() == "2")
                        {
                            //2代表只可选退货
                            List<object> list = new List<object>
                        {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"},
                        };
                            AdjustTypeStore.DataSource = list;
                            AdjustTypeStore.DataBind();

                        }
                        if (Dds.Tables[0].Rows[0]["REV3"].ToString() == "Consignment")
                        {
                            //如果限制仓库类型为寄售，隐藏价格，显示关联订单
                            //GridPanel2.ColumnModel.SetHidden(12, false);
                            GridPanel2.ColumnModel.SetHidden(15, true);
                        }
                        else
                        {
                            //移除关联订单，显示价格
                            //GridPanel2.ColumnModel.SetHidden(12, true);
                            GridPanel2.ColumnModel.SetHidden(15, false);
                        }
                        hiddenWhmType.Text = Dds.Tables[0].Rows[0]["REV3"].ToString();
                    }
                }
                //business.DeleteDetail(new Guid(this.hiddenAdjustId.Text));
            }
            catch (Exception ex)
            {

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
        public void SaveItem(String lotNumber, String expiredDate, String adjustQty, String PurchaseOrderId, String QRCode, String QRCodeEdit, String ToDealer, String Upn)
        {
            if (this.hiddenReturnType.Text == AdjustWarehouseType.Borrow.ToString())
            {
                //如果是寄售转销售
                InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(this.hiddenCurrentEdit.Text));
                lot.LotQty = Convert.ToDouble(adjustQty);

                if (IsGuid(PurchaseOrderId))
                {
                    Hashtable param = new Hashtable();

                    param.Add("PrhId", PurchaseOrderId);
                    param.Add("Upn", Upn);
                    DataSet ds = new DataSet();
                    if (this.cbReturnTypeWin.SelectedItem.Value == AdjustType.Transfer.ToString())
                    {
                        //转移给其他经销商,选择短期寄售申请单号
                        ds = business.ExistsConsignmentIsUpn(param);
                    }
                    else
                    {
                        ds = business.ExistsPOReceiptHeaderIsUpn(param);
                    }
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        lot.PrhId = new Guid(PurchaseOrderId);
                    }
                }
                if (IsGuid(ToDealer))
                {
                    lot.DmaId = new Guid(ToDealer);

                }

                bool result = business.SaveItem(lot);

                if (result)
                {
                    this.DetailStore.DataBind();
                }
                else
                {
                    Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
                }
            }
            else
            {
                if (string.IsNullOrEmpty(QRCodeEdit))
                {
                    InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(this.hiddenCurrentEdit.Text));
                    lot.LotQty = Convert.ToDouble(adjustQty);
                    if (IsGuid(PurchaseOrderId))
                    {
                        lot.PrhId = new Guid(PurchaseOrderId);
                    }
                    bool result = business.SaveItem(lot);

                    if (result)
                    {
                        this.DetailStore.DataBind();
                    }
                    else
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
                    }
                }
                else if (QRCode == "NoQR" && !string.IsNullOrEmpty(QRCodeEdit))
                {
                    //校验二维码库中是否存在这个二维码
                    if (business.QueryQrCodeIsExist(QRCodeEdit))
                    {
                        //校验二维码库中是否填写重复
                        if (business.QueryQrCodeIsDouble(new Guid(this.hiddenAdjustId.Text), QRCodeEdit, new Guid(this.hiddenCurrentEdit.Text)))
                        {
                            this.DetailStore.DataBind();
                            Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), "此二维码已填写过").Show();
                        }
                        else
                        {
                            InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(this.hiddenCurrentEdit.Text));

                            lot.QrLotNumber = lotNumber + "@@" + QRCodeEdit;
                            lot.LotQty = Convert.ToDouble(adjustQty);
                            if (IsGuid(PurchaseOrderId))
                            {
                                lot.PrhId = new Guid(PurchaseOrderId);
                            }

                            bool result = business.SaveItem(lot);

                            if (result)
                            {
                                this.DetailStore.DataBind();
                            }
                            else
                            {
                                Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
                            }
                        }
                    }
                    else
                    {
                        this.DetailStore.DataBind();
                        Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), "不存在此二维码").Show();
                    }
                }
            }
        }
        //Edited By Song Yuqi On 20140320 End

        [AjaxMethod]
        public void DoSubmit()
        {
            //IInventoryAdjustBLL business = new InventoryAdjustBLL();
            //更新字段
            //  bool CheckSumbit = true;
            hiddenresult.Text = "true";
            InventoryAdjustHeader mainData = business.GetInventoryAdjustById(new Guid(this.hiddenAdjustId.Text));
            string Messinge = string.Empty;
            if (!string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
            {
                mainData.ProductLineBumId = new Guid(this.cbProductLineWin.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtAdjustReasonWin.Text))
            {
                mainData.UserDescription = this.txtAdjustReasonWin.Text;
            }
            if (!string.IsNullOrEmpty(this.cbReturnTypeWin.SelectedItem.Value))
            {
                mainData.Reason = this.cbReturnTypeWin.SelectedItem.Value;
            }
            if (!string.IsNullOrEmpty(this.cbRsm.SelectedItem.Value))
            {
                mainData.Rsm = this.cbRsm.SelectedItem.Value;
            }
            if (!string.IsNullOrEmpty(this.cbReturnReason.SelectedItem.Value))
            {
                mainData.RetrunReason = this.cbReturnReason.SelectedItem.Value;
            }
            if (!string.IsNullOrEmpty(cbApplyType.SelectedItem.Value))
            {
                mainData.ApplyType = cbApplyType.SelectedItem.Value;
            }
            bool result = false;

            //Added By Song Yuqi On 2016-06-06 Begin
            //校验经销商退换货的UPN是否满足经销商授权
            if (mainData.Reason == AdjustType.Return.ToString()
                || mainData.Reason == AdjustType.Exchange.ToString())
            {
                Messinge = business.CheckProductAuth(new Guid(this.hiddenAdjustId.Text), _context.User.CorpId.Value, mainData.ProductLineBumId.Value);

                if (!string.IsNullOrEmpty(Messinge))
                {
                    Messinge = Messinge.Replace("@@", "<br/>");

                    Ext.Msg.Alert("Warning", Messinge).Show();
                    hiddenresult.Text = "false";
                    return;
                }
            }
            //Added By Song Yuqi On 2016-06-06 End
            if (mainData.Reason == AdjustType.Return.ToString())
            {

                DataSet ds = business.SelectInventoryAdjustLotQrCodeBYDmIdHeadId(hiddenAdjustId.Text, _context.User.CorpId.Value.ToString());
                if (ds.Tables[0].Rows.Count > 0)
                {
                    Messinge = ds.Tables[0].Rows[0][0].ToString();
                    hiddenresult.Text = "false";
                }
                //if (hiddenWhmType.Text == "Consignment")
                //{
                //    DataSet ds2 = business.SelectInventoryAdjustPrhIDBYHeadId(hiddenAdjustId.Text);
                //    if (_context.User.CorpType == DealerType.T2.ToString() && ds2 != null && ds2.Tables[0].Rows.Count > 0 && ds2.Tables[0].Rows[0]["cnt"].ToString() != "0")
                //    {
                //        Messinge += "关联订单号填写不完全";
                //        hiddenresult.Text = "false";
                //    }
                //}
                if (hiddenresult.Text == "false")
                {
                    Messinge = Messinge.Replace(",", "<br/>");
                    Ext.Msg.Alert(GetLocalResourceObject("DoSubmit.True.Alert.Title").ToString(), Messinge).Show();

                    return;
                }
            }
            DealerMaster dma = _dealers.GetDealerMaster(mainData.DmaId);
            if (dma.Taxpayer == "直销医院")
            {
                //如果经销商为直销医院不能包含多个仓库的记录
                DataSet Whmtb = _business.GetInventoryDtBYIahId(mainData.Id.ToString());
                if (Whmtb.Tables[0].Rows.Count > 1)
                {
                    Ext.Msg.Alert(GetLocalResourceObject("DoSubmit.True.Alert.Title").ToString(), "直销医院的退货单不能包含多个仓库的记录").Show();
                    hiddenresult.Text = "false";
                    return;
                }
            }
            try
            {
                if (string.IsNullOrEmpty(Messinge))
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
                if (this._context.User.CorpType == DealerType.T1.ToString() || this._context.User.CorpType == DealerType.LP.ToString() || this._context.User.CorpType == DealerType.LS.ToString())
                {
                    Ext.Msg.Alert(GetLocalResourceObject("DoSubmit.True.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.True.AlertT1.Body").ToString()).Show();
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
        [AjaxMethod]
        public void CbDealerWinChanaeg()
        {

            if (this.hiddenDealerType.Text == DealerType.T2.ToString()
                       && (this.hiddenAdjustTypeId.Text == AdjustType.Return.ToString() || this.hiddenAdjustTypeId.Text == AdjustType.Exchange.ToString())
                       && this.hiddenReturnType.Text == AdjustWarehouseType.Consignment.ToString())
            {
                business.DeleteConsignmentItemByHeaderId(new Guid(this.hiddenAdjustId.Text));
            }
            //一级经销商及物流平台短期寄售产品退货
            else if ((this.hiddenDealerType.Text == DealerType.T1.ToString() || this.hiddenDealerType.Text == DealerType.LP.ToString() || this.hiddenDealerType.Text == DealerType.LS.ToString())
                   && this.hiddenAdjustTypeId.Text == AdjustType.Transfer.ToString()
                   && this.hiddenReturnType.Text == AdjustWarehouseType.Consignment.ToString())
            {
                business.DeleteConsignmentItemByHeaderId(new Guid(this.hiddenAdjustId.Text));
            }
            else
            {
                business.DeleteDetail(new Guid(this.hiddenAdjustId.Text));
            }
            hiddenDealerId.Text = cbDealerWin.SelectedItem.Value;
            this.ProductLineStoreWin.DataSource = GetProductLineStoreDataSourceWin(new Guid(hiddenDealerId.Text));
            this.ProductLineStoreWin.DataBind();
            cbProductLineWin.SelectedItem.Value = this.hiddenProductLineId.Text;
            ReturnReasonApply();
            cbApplyType.SelectedItem.Value = "";
            cbApplyType.SelectedItem.Text = "";
            if ((this.hiddenDealerType.Text == DealerType.T1.ToString() || this.hiddenDealerType.Text == DealerType.LP.ToString() || this.hiddenDealerType.Text == DealerType.LS.ToString()))
            {
                this.cbReturnReason.Hidden = false;
            }
            else
            {
                this.cbReturnReason.Hidden = true;
            }
            #region 根据选择的经销商类型控制列表列的显示与隐藏
            ////this.btnAddConsignment.Disabled = true;
            ////二级经销商寄售退货单
            //if (this.hiddenDealerType.Text == DealerType.T2.ToString()
            //    && hiddenReturnType.Text== AdjustWarehouseType.Consignment.ToString()
            //    && (this.hiddenAdjustTypeId.Text == AdjustType.Return.ToString() ||
            //    this.hiddenAdjustTypeId.Text == AdjustType.Exchange.ToString()))
            //{

            //    this.TabPanel1.ActiveTabIndex = 0;
            //    this.TabConsignment.Disabled = true;
            //    this.TabHeader.Disabled = false;

            //}
            //else if ((this.hiddenDealerType.Text == DealerType.T1.ToString() || this.hiddenDealerType.Text == DealerType.LP.ToString())
            //    && hiddenReturnType.Text == AdjustWarehouseType.Borrow.ToString())
            //{

            //    this.TabPanel1.ActiveTabIndex = 0;
            //    this.TabConsignment.Disabled = true;
            //    this.TabHeader.Disabled = false;
            //    this.GridPanel2.ColumnModel.SetHidden(13, false);
            //    this.GridPanel2.ColumnModel.SetHidden(14, true);
            //    //if (mainData.Status == AdjustStatus.Draft.ToString())
            //    //{
            //    //    this.TabPanel1.ActiveTabIndex = 1;
            //    //    this.TabConsignment.Disabled = false;
            //    //    this.TabHeader.Disabled = true;
            //    //}
            //    //else
            //    //{
            //    //    this.TabPanel1.ActiveTabIndex = 0;
            //    //    this.TabConsignment.Disabled = false;
            //    //    this.TabHeader.Disabled = false;
            //    //}
            //}
            //if (hiddenReturnType.Text == "Normal")
            //{
            //    //如果LP或T1的普通退货申请单，隐藏关联订单，显示价格
            //    GridPanel2.ColumnModel.SetHidden(12, true);
            //    GridPanel2.ColumnModel.SetHidden(15, false);

            //}
            //else if (hiddenReturnType.Text == "Borrow" || hiddenReturnType.Text == "Consignment")
            //{
            //    //如果LP或T1的寄售转移申请单，显示关联订单，隐藏价格
            //    GridPanel2.ColumnModel.SetHidden(12, false);
            //    GridPanel2.ColumnModel.SetHidden(15, true);

            //}
            #endregion

        }
        protected void ExportExcel(object sender, EventArgs e)
        {
            DataTable dt = this.GetInventoryReturn().Tables[0];//dt是从后台生成的要导出的datatable
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

        private DataSet GetInventoryReturn()
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLine", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbReturnType.SelectedItem.Value))
            {
                param.Add("Type", this.cbReturnType.SelectedItem.Value);
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
            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
            {
                param.Add("LPId", RoleModelContext.Current.User.CorpId);
            }
            DataSet ds = business.QueryInventoryReturnForExport(param);
            return ds;
        }

        #region Added By Song Yuqi On 20140320
        protected void PurchaseOrderStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable param = new Hashtable();

            param.Add("DealerId", this.hiddenDealerId.Text);
            param.Add("ProductLineId", this.cbProductLineWin.SelectedItem.Value);
            param.Add("PmaId", this.hiddenPmaId.Text);

            DataSet ds = new DataSet();
            if (this.cbReturnTypeWin.SelectedItem.Value == AdjustType.Transfer.ToString())
            {
                param.Add("LotNumber", this.hiddenLotNumber.Text + "@@" + this.hiddenQRCode.Text);
                //转移给其他经销商,选择短期寄售申请单号
                ds = business.GetConsignmentOrderNbr(param);
            }
            else
            {
                param.Add("LotNumber", this.hiddenLotNumber.Text + "@@" + this.hiddenQRCode.Text);
                ds = business.GetPurchaseOrderNbr(param);
            }

            this.PurchaseOrderStore.DataSource = ds;
            this.PurchaseOrderStore.DataBind();
        }

        protected void ToDealerStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable param = new Hashtable();
            param.Add("ProductLineId", this.cbProductLineWin.SelectedItem.Value);
            param.Add("DmaId", this.hiddenDealerId.Text);

            DataSet ds = business.GetReturnDealerListByFilter(param);

            this.ToDealerStore.DataSource = ds;
            this.ToDealerStore.DataBind();
        }

        [AjaxMethod]
        public void DeleteConsignmentItem(String LotId)
        {
            bool result = false;

            try
            {
                result = business.DeleteConsignmentItem(new Guid(LotId));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                this.ConsignmentDetailStore.DataBind();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("DeleteItem.Alert.Title").ToString(), GetLocalResourceObject("DeleteItem.Alert.Body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void SaveConsignmentItem(String adjustQty, String PurchaseOrderId, String ToDealerId)
        {
            DMS.Model.InventoryAdjustConsignment ac = business.GetInventoryAdjustConsignmentById(new Guid(this.hiddenCurrentEdit.Text));
            ac.ShippedQty = string.IsNullOrEmpty(adjustQty) ? 0 : Convert.ToDecimal(adjustQty);

            if (IsGuid(PurchaseOrderId))
            {

                ac.PrhId = new Guid(PurchaseOrderId);

            }
            if (IsGuid(ToDealerId))
            {
                ac.DmaId = new Guid(ToDealerId);
            }

            bool result = business.SaveConsignmentItem(ac);

            if (result)
            {
                this.ConsignmentDetailStore.DataBind();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
            }
        }

        private bool IsGuid(string strSrc)
        {
            if (String.IsNullOrEmpty(strSrc)) { return false; }

            bool _result = false;
            try
            {
                Guid _t = new Guid(strSrc);
                _result = true;
            }

            catch { }
            return _result;
        }

        #endregion
        #region add lijie on 2016-07-19
        public void BindDealerWin(Store store)
        {
            IRoleModelContext context = RoleModelContext.Current;
            IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();
            //如果是普通用户则检查过滤该用户是否能够看到该Dealer
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
                IList<OrganizationUnit> list = this.GetCurrentProductLinesWin(context);
                Guid[] lines = (from p in list select new Guid(p.Id)).ToArray<Guid>();
                IDealerMasters dealerbiz = new DealerMasters();
                IList<Guid> dealers = dealerbiz.GetDealersBySales(context.User.Id, lines);
                var query = from p in dataSource
                            where dealers.Contains(p.Id.Value)
                            select p;
                dataSource = query.OrderBy(d => d.ChineseName).ToList<DealerMaster>();

                //dataSource = query.ToList<DealerMaster>();

                if (this.hiddenReturnType.Text == "Normal")
                {
                    dataSource = query.Where(d => d.DealerType != DealerType.HQ.ToString()).ToList<DealerMaster>(); ;
                }
                else if (this.hiddenReturnType.Text == "Consignment")
                {
                    dataSource = query.Where(d => d.DealerType != DealerType.LP.ToString() && d.DealerType != DealerType.LS.ToString() && d.DealerType != DealerType.T1.ToString() && d.DealerType != DealerType.HQ.ToString()).ToList<DealerMaster>(); ;
                }
                else if (this.hiddenReturnType.Text == "Borrow")
                {
                    dataSource = query.Where(d => d.DealerType != DealerType.T2.ToString() && d.DealerType != DealerType.HQ.ToString()).ToList<DealerMaster>(); ;
                }
                store.DataSource = dataSource;
                store.DataBind();
                DealerMaster dms = dataSource.OrderBy(p => p.ChineseName).First();
                this.hiddenDealerId.Text = dms.Id.ToString();

            }

        }
        private IList<OrganizationUnit> GetCurrentProductLinesWin(IRoleModelContext context, bool isFilterBySubCompanyAndBrand = true)
        {
            IList<OrganizationUnit> list = new List<OrganizationUnit>();

            IList<OrganizationUnit> units = context.User.OrganizationUnits;
            foreach (var unit in units)
            {

                if (unit.Level < DMS.Common.SR.Organization_ProductLine_Level)
                {
                    var us = OrganizationHelper.GetChildOrganizationUnit(SR.Organization_ProductLine, unit.Id);
                    list = list.Union<OrganizationUnit>(us).ToList<OrganizationUnit>(); ;

                }
                else if (unit.Level == SR.Organization_ProductLine_Level)
                {
                    OrganizationUnit u = unit;
                    if (!list.Contains(u))
                        list.Add(u);
                }
                else
                {
                    OrganizationUnit u = OrganizationHelper.GetParentOrganizationUnit(SR.Organization_ProductLine, unit.Id);
                    if (!list.Contains(u))
                        list.Add(u);
                }

            }
            return isFilterBySubCompanyAndBrand ? BaseService.FilterProductLine(list) : list;
        }
        private object GetProductLineStoreDataSourceWin(Guid DealreId)
        {
            object datasource = null;



            IDealerContracts dealers = new DealerContracts();

            DealerAuthorization param = new DealerAuthorization();
            param.DmaId = DealreId;
            IList<DealerAuthorization> auths = dealers.GetAuthorizationListByDealer(param);

            IList<Lafite.RoleModel.Domain.AttributeDomain> dataSet = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine);

            var lines = from p in dataSet
                        where auths.FirstOrDefault<DealerAuthorization>(c => c.ProductLineBumId.Value == new Guid(p.Id)) != null
                        select p;


            datasource = lines.ToList<Lafite.RoleModel.Domain.AttributeDomain>();
            Lafite.RoleModel.Domain.AttributeDomain Des = lines.First();
            if (Des.Id != null)
            {
                this.hiddenProductLineId.Text = Des.Id.ToString();
            }


            return datasource;
        }
        public void ReturnReasonApply()
        {
            #region 退货类型与退货要求的联动
            Hashtable ht = new Hashtable();
            ht.Add("TypeName", "CONST_AdjustRenturn_Type");
            DataSet ds = new DataSet();
            if ((this.hiddenDealerType.Text == DealerType.T1.ToString() || this.hiddenDealerType.Text == DealerType.LP.ToString()) && this.hiddenReturnType.Text == AdjustWarehouseType.Borrow.ToString() && this.hiddenAdjustTypeId.Text == AdjustType.Transfer.ToString())
            {
                //如果是寄售转移
                ht.Add("DmaType", "LTC");
                ds = _business.SelectAdjustRenturn_Reason(ht);
                List<object> list = new List<object>
                       {
                            new { Value = "转移给其他经销商", Key = "Transfer" }
                       };

                AdjustTypeStore.DataSource = list;
                AdjustTypeStore.DataBind();
                AdjustReturnTypeStore.DataSource = ds;
                AdjustReturnTypeStore.DataBind();
                this.cbApplyType.SetValue(ds.Tables[0].Rows[0]["Key"].ToString());
                this.cbReturnTypeWin.SetValue("Transfer");
                hiddApplyType.Text = ds.Tables[0].Rows[0]["Key"].ToString();
                hiddenWhmType.Text = "Consignment";
            }
            else if (this.hiddenDealerType.Text == DealerType.T1.ToString() || this.hiddenDealerType.Text == DealerType.LP.ToString())
            {

                //如果是T1或品台平台普通退货
                ht.Add("DmaType", "LT");
                ds = _business.SelectAdjustRenturn_Reason(ht);
                AdjustReturnTypeStore.DataSource = ds;
                AdjustReturnTypeStore.DataBind();
                //清空退换货要求sotre
                AdjustTypeStore.RemoveAll();
                AdjustTypeStore.DataBind();
            }
            else if (this.hiddenDealerType.Text == DealerType.T2.ToString())
            {
                ht.Add("DmaType", "T2");
                ht.Add("Rev3", this.hiddenReturnType.Text);
                ds = _business.SelectAdjustRenturn_Reason(ht);
                List<object> list = new List<object>
                        {
                            new {Value = "退货", Key = "Return"},
                            new {Value = "换货", Key = "Exchange"}

                        };
                AdjustReturnTypeStore.DataSource = ds;
                AdjustReturnTypeStore.DataBind();
                AdjustTypeStore.DataSource = list;
                AdjustTypeStore.DataBind();
                cbApplyType.SetValue(ds.Tables[0].Rows[0]["Key"].ToString());
                hiddApplyType.Text = ds.Tables[0].Rows[0]["Key"].ToString();
                hiddenWhmType.Text = ds.Tables[0].Rows[0]["REV3"].ToString();
                //this.cbReturnTypeWin.SetValue("Return");
            }
            //cbApplyType.SelectedItem.Value = hiddApplyType.Text;


            #endregion
        }
        public void ReasonSotreBinda(string TypeId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("TypeName", "CONST_AdjustRenturn_Reason");
            ht.Add("Key", TypeId);
            DataSet ds = _business.SelectAdjustRenturn_Reason(ht);
            RetrunReasonStore.DataSource = ds;
            RetrunReasonStore.DataBind();
        }
        #endregion

        #region Added By Song Yuqi On 2017-04-13 For 附件
        protected void AttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this.hiddenAdjustId.Text);
            int totalCount = 0;

            DataSet ds = attachBll.GetAttachmentByMainId(tid, AttachmentType.ReturnAdjust, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarAttachement.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            AttachmentStore.DataSource = ds;
            AttachmentStore.DataBind();
        }

        protected void ShowAttachmentWindow(object sender, AjaxEventArgs e)
        {
            this.AttachmentWindow.Show();
        }

        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            if (this.FileUploadField1.HasFile)
            {

                bool error = false;

                string fileName = FileUploadField1.PostedFile.FileName;
                string fileExtention = string.Empty;
                string fileExt = string.Empty;
                if (fileName.LastIndexOf(".") < 0)
                {
                    error = true;
                }
                else
                {
                    fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
                    fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                }

                if (error)
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "文件错误",
                        Message = "请上传正确的文件！"
                    });

                    return;
                }

                //构造文件名称

                string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\UploadFile\\AdjustAttachment\\" + newFileName);


                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                this.hiddenFileName.Text = newFileName;

                Attachment attach = new Attachment();
                attach.Id = Guid.NewGuid();
                attach.MainId = new Guid(this.hiddenAdjustId.Text);
                attach.Name = fileExtention;
                attach.Url = newFileName;
                attach.Type = AttachmentType.ReturnAdjust.ToString();
                attach.UploadDate = DateTime.Now;
                attach.UploadUser = new Guid(_context.User.Id);

                attachBll.AddAttachment(attach);

                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = "上传成功",
                    Message = "已成功上传文件！"
                });
            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "上传失败",
                    Message = "文件未被成功上传！"
                });
            }
        }

        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                attachBll.DelAttachment(new Guid(id));
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\AdjustAttachment");
                File.Delete(uploadFile + "\\" + fileName);

            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除附件失败，请联系DMS技术支持").Show();
            }
        }

        [AjaxMethod]
        public void InitBtnAddAttach()
        {
            try
            {
                InventoryAdjustHeader mainData = business.GetInventoryAdjustById(new Guid(this.hiddenAdjustId.Text));
                //判断当前状态是不是为草稿状态，如果为草稿状态，则可以更新
                if (IsDealer)
                {
                    if (this.TabPanel1.ActiveTabIndex == 3)
                    {
                        this.btnAddAttach.Disabled = false;
                    }
                }
                else if (mainData.Status == ShipmentOrderStatus.Draft.ToString())
                {
                    if (this.TabPanel1.ActiveTabIndex == 3)
                    {
                        this.btnAddAttach.Disabled = false;
                    }
                }
                else
                {
                    if (this.TabPanel1.ActiveTabIndex == 3)
                    {
                        this.btnAddAttach.Disabled = true;
                    }
                }
            }
            catch (Exception ex)
            {


            }
            finally
            {

            }
        }
        #endregion
    }
}
