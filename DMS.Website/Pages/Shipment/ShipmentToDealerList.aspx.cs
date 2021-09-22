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
using System.Xml;
using System.Xml.Xsl;

namespace DMS.Website.Pages.Shipment
{
    public partial class ShipmentToDealerList : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IShipmentBLL _business = null;
        const string DIBProductLineID = "5cff995d-8ffc-44f6-a0aa-ff750cc36312";
        [Dependency]
        public IShipmentBLL business
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

                if (IsDealer)
                {
                    this.cbDealer.Disabled = true;
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_SHIPMENT);
                }
                else
                {
                    //控制查询按钮
                    Permissions pers = this._context.User.GetPermissions();
                    this.btnSearch.Visible = pers.IsPermissible(Business.ShipmentBLL.Action_DealerShipment, PermissionType.Read);
                }
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            this.ShipmentDialog1.GridStore = this.DetailStore;
        }

        protected void Store_OrderStatus(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_ShipmentOrder_Status);

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dicts;
                store1.DataBind();
            }
        }

        protected void Store_RefreshProductLineWin(object sender, StoreRefreshDataEventArgs e)
        {
            Guid DealerId = Guid.Empty;
            if (e.Parameters["DealerId"] != null && !string.IsNullOrEmpty(e.Parameters["DealerId"].ToString()))
            {
                DealerId = new Guid(e.Parameters["DealerId"].ToString());
            }

            DealerMasters dm = new DealerMasters();
            DataSet ds = dm.GetProductLineByDealer(DealerId);

            if (sender is Store)
            {
                Store store1 = (sender as Store);
                store1.DataSource = ds;
                store1.DataBind();
            }
        }

        protected void Store_RefreshHospitalWin(object sender, StoreRefreshDataEventArgs e)
        {
            Guid DealerId = Guid.Empty;
            Guid ProductLineId = Guid.Empty;
            Hashtable param = new Hashtable();
            if (e.Parameters["DealerId"] != null && !string.IsNullOrEmpty(e.Parameters["DealerId"].ToString()))
            {
                DealerId = new Guid(e.Parameters["DealerId"].ToString());
                param.Add("DealerId", DealerId);
            }
            if (e.Parameters["ProductLineId"] != null && !string.IsNullOrEmpty(e.Parameters["ProductLineId"].ToString()))
            {
                ProductLineId = new Guid(e.Parameters["ProductLineId"].ToString());
                param.Add("ProductLine", ProductLineId);
            }

            DealerMasters dm = new DealerMasters();
            DataSet ds = dm.GetHospitalForDealerByFilter(param);

            if (sender is Store)
            {
                Store store1 = (sender as Store);
                store1.DataSource = ds;
                store1.DataBind();
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //IShipmentBLL business = new ShipmentBLL();

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
            if (!string.IsNullOrEmpty(this.txtHospital.Text))
            {
                param.Add("HospitalName", this.txtHospital.Text);
            }
            if (!this.txtStartDate.IsNull)
            {
                param.Add("ShipmentDateStart", this.txtStartDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtEndDate.IsNull)
            {
                param.Add("ShipmentDateEnd", this.txtEndDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtOrderNumber.Text))
            {
                param.Add("OrderNumber", this.txtOrderNumber.Text);
            }
            if (!string.IsNullOrEmpty(this.cbOrderStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbOrderStatus.SelectedItem.Value);
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
            DataSet ds = business.QueryShipmentHeader(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this.hiddenOrderId.Text);

            //IShipmentBLL business = new ShipmentBLL();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            param.Add("HeaderId", tid);

            DataSet ds = business.QueryShipmentLot(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.DetailStore.DataSource = ds;
            this.DetailStore.DataBind();

            this.txtTotalAmount.Text = business.GetShipmentTotalAmount(tid).ToString();
            this.txtTotalQty.Text = business.GetShipmentTotalQty(tid).ToString();
        }

        protected void ShowDialog(object sender, AjaxEventArgs e)
        {
            //判断是否符合打开对话框的条件
            //1、产品线 2、销售医院
            if (string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value) || string.IsNullOrEmpty(this.cbHospitalWin.SelectedItem.Value))
            {
                Ext.Msg.Alert(GetLocalResourceObject("ShowDialog.Alert.Title").ToString(), GetLocalResourceObject("ShowDialog.Alert.Body").ToString()).Show();
                return;
            }
            this.ShipmentDialog1.Show(new Guid(this.hiddenOrderId.Text), new Guid(this.hiddenDealerId.Text), new Guid(this.hiddenProductLineId.Text), new Guid(this.hiddenHospitalId.Text),"NULL",0,"");
        }

        protected void ShowDetails(object sender, AjaxEventArgs e)
        {
            //初始化detail窗口,因为只有dealer才可以新增，因此打开页面默认选中session中的经销商
            this.hiddenOrderId.Text = string.Empty;
            this.hiddenDealerId.Text = string.Empty;
            this.hiddenProductLineId.Text = string.Empty;
            this.hiddenHospitalId.Text = string.Empty;

            this.txtOrderNumberWin.Text = string.Empty;
            this.txtShipmentDateWin.Clear();
            this.txtOrderStatusWin.Text = string.Empty;
            this.txtMemoWin.Text = string.Empty;
            this.txtTotalAmount.Text = string.Empty;
            this.txtTotalQty.Text = string.Empty;

            //added by bozhenfei on 20100607
            this.hiddenCurrentEditShipmentId.Text = string.Empty;
            this.hiddenIsEditting.Text = string.Empty;
            //end

            //added by songweiming on 20100617
            this.txtInvoice.Text = string.Empty;

            Guid id = new Guid(e.ExtraParams["OrderId"].ToString());


            //IShipmentBLL business = new ShipmentBLL();
            ShipmentHeader mainData = null;

            //若id为空，说明为新增，则生成新的id，并新增一条记录
            if (id == Guid.Empty)
            {
                id = Guid.NewGuid();
                this.hiddenOrderId.Text = id.ToString();
                mainData = new ShipmentHeader();
                mainData.Id = id;
                mainData.DealerDmaId = RoleModelContext.Current.User.CorpId.Value;
                mainData.Status = ShipmentOrderStatus.Draft.ToString();
                mainData.UpdateDate = DateTime.Now;// added by songweiming on 20100628
                //mainData.Type = "个人";
                business.InsertShipmentHeader(mainData);
            }
            //根据ID查询主表数据，并初始化页面
            mainData = business.GetShipmentHeaderById(id);
            this.hiddenOrderId.Text = mainData.Id.ToString();
            this.hiddenDealerId.Text = mainData.DealerDmaId.ToString();


            if (mainData.ProductLineBumId != null)
            {
                this.hiddenProductLineId.Text = mainData.ProductLineBumId.Value.ToString();
                //if (mainData.ProductLineBumId.Value.ToString() == DIBProductLineID)
                //{
                //    this.orderTypeWin.Show();
                //    //显示订单种类@2009/11/25 by Steven
                //    this.rbPersonalWin.Checked = (mainData.Type == "个人");
                //    this.rbHospitalWin.Checked = (mainData.Type == "医院");
                //}
                //else
                //{
                //    this.orderTypeWin.Hide();
                //}
            }
            if (mainData.HospitalHosId != null)
            {
                this.hiddenHospitalId.Text = mainData.HospitalHosId.Value.ToString();
            }
            this.txtOrderNumberWin.Text = mainData.ShipmentNbr;
            if (mainData.ShipmentDate != null)
            {
                this.txtShipmentDateWin.SelectedDate = mainData.ShipmentDate.Value;
            }

            //added by songweiming on 20100617
            if (mainData.InvoiceNo != null)
            {
                this.txtInvoice.Text = mainData.InvoiceNo;
            }
            this.txtOrderStatusWin.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_ShipmentOrder_Status, mainData.Status);
            this.txtMemoWin.Text = mainData.NoteForPumpSerialNbr;
            //窗口状态控制
            this.cbDealerWin.Disabled = true;
            this.GridPanel2.ColumnModel.SetEditable(7, false);
            this.GridPanel2.ColumnModel.SetEditable(8, false);
            this.GridPanel2.ColumnModel.SetHidden(9, true);
            //this.GridPanel2.ColumnModel.SetHidden(10, true);
            this.cbProductLineWin.Disabled = true;
            this.cbHospitalWin.Disabled = true;
            //this.txtMemoWin.Disabled = true;
            this.txtMemoWin.ReadOnly = true;
            this.txtInvoice.Disabled = true;
            this.DraftButton.Disabled = true;
            this.DeleteButton.Disabled = true;
            this.SubmitButton.Disabled = true;
            this.RevokeButton.Disabled = true;
            this.AddItemsButton.Disabled = true;
            this.orderTypeWin.Disabled = true;
            this.txtShipmentDateWin.Disabled = true;
            if (IsDealer)
            {
                if (mainData.Status == ShipmentOrderStatus.Draft.ToString())
                {
                    this.cbProductLineWin.Disabled = false;
                    this.cbHospitalWin.Disabled = false;
                    //this.txtMemoWin.Disabled = false;
                    this.txtMemoWin.ReadOnly = false;
                    this.txtInvoice.Disabled = false;
                    this.DraftButton.Disabled = false;
                    this.DeleteButton.Disabled = false;
                    this.SubmitButton.Disabled = false;
                    this.orderTypeWin.Disabled = false;
                    this.txtShipmentDateWin.Disabled = false;
                    this.GridPanel2.ColumnModel.SetEditable(7, true);
                    this.GridPanel2.ColumnModel.SetEditable(8, true);
                    this.GridPanel2.ColumnModel.SetHidden(9, false);
                    //this.GridPanel2.ColumnModel.SetHidden(10, false);

                    if (mainData.ProductLineBumId != null && mainData.HospitalHosId != null)
                    {
                        this.AddItemsButton.Disabled = false;
                    }
                }
                if (mainData.Status == ShipmentOrderStatus.Complete.ToString())
                {
                    //显示更新发票按钮 added by bozhenfei on 20100709
                    //this.SubmitButton.Text = "更新发票";
                    //this.GridPanel2.ColumnModel.SetHidden(10, true);
                    //冲红操作时间限制校验  added by songweiming on 20100617                   
                    if (new ShipmentUtil().GetDateConstraints("RevokeDate", mainData.ShipmentDate.Value, mainData.ProductLineBumId.Value))
                    {
                        this.RevokeButton.Disabled = false;
                    }
                    //完成状态的单据仍然可以提交保存，但保存仅限于发票号码 added by songweiming on 20100617    
                    this.SubmitButton.Disabled = false;
                    this.txtInvoice.Disabled = false;
                    this.GridPanel2.ColumnModel.SetEditable(7, false);
                    this.GridPanel2.ColumnModel.SetEditable(8, false);
                }
            }
            else
            {
                //this.GridPanel2.ColumnModel.SetHidden(10, false);
            }
            //显示窗口
            this.DetailWindow.Show();
        }

        [AjaxMethod]
        public void SaveDraft()
        {
            //IShipmentBLL business = new ShipmentBLL();
            //更新字段
            ShipmentHeader mainData = business.GetShipmentHeaderById(new Guid(this.hiddenOrderId.Text));

            if (!string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
            {
                mainData.ProductLineBumId = new Guid(this.cbProductLineWin.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbHospitalWin.SelectedItem.Value))
            {
                mainData.HospitalHosId = new Guid(this.cbHospitalWin.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtMemoWin.Text))
            {
                mainData.NoteForPumpSerialNbr = this.txtMemoWin.Text;
            }

            //added by bozhenfei on 20100608 销售时间
            if (this.txtShipmentDateWin.SelectedDate == DateTime.MinValue)
            {
                mainData.ShipmentDate = null;
            }
            else
            {
                mainData.ShipmentDate = this.txtShipmentDateWin.SelectedDate;
            }

            //added by songweiming on 20100617 发票号码
            if (!string.IsNullOrEmpty(this.txtInvoice.Text))
            {
                mainData.InvoiceNo = this.txtInvoice.Text;
            }


            bool result = false;

            try
            {
                mainData.ShipmentUser = new Guid(this._context.User.Id);
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
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("SaveDraft.False.Alert.Body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void DeleteDraft()
        {
            //IShipmentBLL business = new ShipmentBLL();

            bool result = false;

            try
            {
                result = business.DeleteDraft(new Guid(this.hiddenOrderId.Text));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DeleteDraft.True.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DeleteDraft.False.Alert.Body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void OnProductLineChange()
        {
            //IShipmentBLL business = new ShipmentBLL();
            try
            {
                business.DeleteDetail(new Guid(this.hiddenOrderId.Text));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        [AjaxMethod]
        public void OnHospitalChange()
        {
            //IShipmentBLL business = new ShipmentBLL();
            try
            {
                business.DeleteDetail(new Guid(this.hiddenOrderId.Text));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        [AjaxMethod]
        public void DeleteItem()
        {
            //IShipmentBLL business = new ShipmentBLL();
            RowSelectionModel sm = this.GridPanel2.SelectionModel.Primary as RowSelectionModel;

            bool result = false;

            try
            {
                result = business.DeleteItem(new Guid(sm.SelectedRow.RecordID));
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
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DeleteItem.Alert.Body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void EditItem(String LotId)
        {
            //this.ShipmentEditor1.Show(new Guid(LotId));
        }

        [AjaxMethod]
        public void SaveItem(string qty, string unitprice)
        {
            ShipmentLot lot = business.GetShipmentLotById(new Guid(this.hiddenCurrentEditShipmentId.Text));
            lot.LotShippedQty = string.IsNullOrEmpty(qty) ? 0 : Convert.ToDouble(qty);
            double price = string.IsNullOrEmpty(unitprice) ? 0 : Convert.ToDouble(unitprice);
            bool result = business.SaveItem(lot, price);

            if (result)
            {
                this.DetailStore.DataBind();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public Boolean OperationDateCheck()
        {
            ShipmentHeader mainData = business.GetShipmentHeaderById(new Guid(this.hiddenOrderId.Text));
            //判断当前状态是不是为草稿状态，如果为草稿状态，则可以更新
            if (mainData.Status == ShipmentOrderStatus.Draft.ToString())
            {
                return true;
            }
            else if (mainData.Status == ShipmentOrderStatus.Complete.ToString())
            {
                //判断当前状态是不是已提交状态，如果是已提交状态，则校验时间
                Boolean dateCheck = new ShipmentUtil().GetDateConstraints("OperationDate", mainData.ShipmentDate.Value, mainData.ProductLineBumId.Value);
                return dateCheck;
            }
            else
            {
                //其他状态都不可编辑
                return false;
            }
        }

        [AjaxMethod]
        public string DoSubmit()
        {



            //IShipmentBLL business = new ShipmentBLL();
            Boolean dateCheck = true;
            ShipmentHeader mainData = business.GetShipmentHeaderById(new Guid(this.hiddenOrderId.Text));

            //首先判断当前单据的状态，如果是完成状态，则只保存发票号码，草稿状态则保存整张单据
            if (mainData.Status == ShipmentOrderStatus.Complete.ToString())
            {
                try
                {
                    mainData.InvoiceNo = this.txtInvoice.Text;
                    mainData.UpdateDate = DateTime.Now;// added by songweiming on 20100628
                    business.UpdateMainDataInvoiceNo(mainData);
                    Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.Alert.Body").ToString()).Show();
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }
                return "Done";
            }
            else
            {

                //更新字段
                if (!string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
                {
                    mainData.ProductLineBumId = new Guid(this.cbProductLineWin.SelectedItem.Value);

                }
                if (!string.IsNullOrEmpty(this.cbHospitalWin.SelectedItem.Value))
                {
                    mainData.HospitalHosId = new Guid(this.cbHospitalWin.SelectedItem.Value);
                }
                if (!string.IsNullOrEmpty(this.txtMemoWin.Text))
                {
                    mainData.NoteForPumpSerialNbr = this.txtMemoWin.Text;
                }
                //added by songyuqi on 20100707 发票号码
                if (!string.IsNullOrEmpty(this.txtInvoice.Text))
                {
                    mainData.InvoiceNo = this.txtInvoice.Text;
                }

                //added by bozhenfei on 20100608 销售时间
                if (this.txtShipmentDateWin.SelectedDate != DateTime.MinValue)
                {
                    mainData.ShipmentDate = this.txtShipmentDateWin.SelectedDate;
                    dateCheck = new ShipmentUtil().GetDateConstraints("ShipmentDate", mainData.ShipmentDate.Value, mainData.ProductLineBumId.Value);

                    string result = "";

                    if (dateCheck)
                    {
                        try
                        {
                            mainData.ShipmentUser = new Guid(this._context.User.Id);
                            result = business.Submit(mainData,"");
                        }
                        catch (Exception e)
                        {
                            throw new Exception(e.Message);
                        }

                        if (result == "Success")
                        {
                            Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.dateCheck.True.Alert.Body").ToString()).Show();
                        }
                        else
                        {
                            Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), result).Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.Alert.Body1").ToString()).Show();
                        return "DateError";
                    }
                }
                else
                {
                    Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.Alert.Body2").ToString()).Show();
                    return "DateError";
                }

                return "Done";
            }
        }

        [AjaxMethod]
        public void DoRevoke()
        {
            //IShipmentBLL business = new ShipmentBLL();

            bool result = false;

            try
            {
                result = business.Revoke(new Guid(this.hiddenOrderId.Text),"");
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DoRevoke.True.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DoRevoke.False.Alert.Bodys").ToString()).Show();
            }
        }
    }
}
