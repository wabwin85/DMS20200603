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
    public partial class InventoryAdjustAudit : BasePage
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
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.btnInsert.Visible = false;

                this.Bind_ProductLine(this.ProductLineStore);
                this.Bind_DealerListByFilter(this.DealerStore,false);
                this.Bind_Status(this.AdjustStatusStore);

                //加载AdjustTypeStore
                List<object> list = new List<object>
                {
                    new {Value = "退货", Key = "Return"},
                    new {Value = "换货", Key = "Exchange"}                   
                };
                AdjustTypeStore.DataSource = list;
                AdjustTypeStore.DataBind();

                if (IsDealer)
                {
                    this.btnImport.Hidden = true;
                    
                    //this.cbDealer.Disabled = true;
                    //this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    if (_context.User.CorpType.Equals(DealerType.LP.ToString()))
                    {
                        this.btnImport.Hidden = false;
                    }
                }
                else if (_context.IsInRole("经销商短期寄售管理员") || _context.IsInRole("Administrators"))
                {
                    //审批结果导入功能不需要
                    //this.btnImport.Hidden = false;
                    this.btnImport.Hidden = true;
                   

                }

                //控制查询按钮
                //Permissions pers = this._context.User.GetPermissions();
                //this.btnSearch.Visible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryReturnAudit, PermissionType.Read);
                //查询功能不控制
                this.btnSearch.Visible = true;
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            this.InventoryAdjustDialog1.GridStore = this.DetailStore;
            //this.InventoryAdjustEditor1.GridStore = this.DetailStore;
        }


        protected void Bind_Status(Store store)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_AdjustQty_Status);
            
            IList list = dicts.ToList().FindAll(item => item.Key != AdjustStatus.Draft.ToString() && item.Key != AdjustStatus.Submit.ToString()&& item.Key != AdjustStatus.Cancelled.ToString());


            store.DataSource = list;
            store.DataBind();
            
        }

        protected void Store_AdjustTypeStore(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_AdjustQty_Type);

            //IList list = dicts.ToList().FindAll(item => item.Key != AdjustType.Scrap.ToString() && item.Key != AdjustType.Other.ToString());
            var list = from d in dicts where d.Key.Equals(AdjustType.Return.ToString()) select d;
            //删除报废类型
            //dicts.Remove(AdjustType.Scrap.ToString());

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = list;
                store1.DataBind();
            }
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
            DataSet ds = business.QueryInventoryAdjustHeaderReturnAudit(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

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

        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this.hiddenAdjustId.Text);
            int totalCount = 0;
            DataSet ds = _logbll.QueryPurchaseOrderLogByHeaderId(tid, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();
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
            this.InventoryAdjustDialog1.Show(new Guid(this.hiddenAdjustId.Text), new Guid(this.hiddenDealerId.Text), new Guid(this.hiddenProductLineId.Text), this.cbReturnTypeWin.SelectedItem.Value, this.hiddenReturnType.Text,"");
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
            this.GridPanel2.ColumnModel.SetHidden(12, true);
            this.cbProductLineWin.Disabled = true;
            //this.cbAdjustTypeWin.Disabled = true;
            //this.txtAdjustReasonWin.Disabled = true;
            this.txtAdjustReasonWin.ReadOnly = true;
            //this.txtAduitNoteWin.Disabled = true;
            this.txtAduitNoteWin.ReadOnly = true;
            this.RejectButton.Disabled = true;
            this.ApprovalButton.Disabled = true;
            this.AddItemsButton.Disabled = true;

            if (mainData.WarehouseType != null)
            {
                this.hiddenReturnType.Text = mainData.WarehouseType;
            }
            this.cbReturnTypeWin.Disabled = true;
            this.cbReturnTypeWin.SetValue(mainData.Reason);

            if (IsDealer)
            {
                if (mainData.Status == AdjustStatus.Submitted.ToString() && _context.User.CorpType == DealerType.LP.ToString())
                {
                    //this.RejectButton.Disabled = false;
                    //this.ApprovalButton.Disabled = false;
                    this.txtAduitNoteWin.ReadOnly = false;
                }
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
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.true.Alert.Title").ToString(), GetLocalResourceObject("SaveDraft.true.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.false.Alert.Title").ToString(), GetLocalResourceObject("SaveDraft.false.Alert.Body").ToString()).Show();
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
                Ext.Msg.Alert(GetLocalResourceObject("DeleteDraft.true.Alert.Title").ToString(), GetLocalResourceObject("DeleteDraft.true.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("DeleteDraft.false.Alert.Title").ToString(), GetLocalResourceObject("DeleteDraft.false.Alert.Body").ToString()).Show();
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
        public void EditItem(String LotId, String Type)
        {
            //this.InventoryAdjustEditor1.Show(new Guid(LotId), Type);
        }

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
                Ext.Msg.Alert(GetLocalResourceObject("DoSubmit.true.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.true.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoSubmit.false.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.false.Alert.Body").ToString()).Show();
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
                Ext.Msg.Alert(GetLocalResourceObject("DoRevoke.true.Alert.Title").ToString(), GetLocalResourceObject("DoRevoke.true.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoRevoke.false.Alert.Title").ToString(), GetLocalResourceObject("DoRevoke.false.Alert.Body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void DoReject()
        {
            //IInventoryAdjustBLL business = new InventoryAdjustBLL();
            //更新字段
            InventoryAdjustHeader mainData = business.GetInventoryAdjustById(new Guid(this.hiddenAdjustId.Text));

            if (!string.IsNullOrEmpty(this.txtAduitNoteWin.Text))
            {
                mainData.AuditorNotes = this.txtAduitNoteWin.Text;
            }
            bool result = false;

            try
            {
                result = business.Reject(mainData);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoReject.true.Alert.Title").ToString(), GetLocalResourceObject("DoReject.true.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoReject.false.Alert.Title").ToString(), GetLocalResourceObject("DoReject.false.Alert.Body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void DoApprove()
        {
            //IInventoryAdjustBLL business = new InventoryAdjustBLL();
            //更新字段
            InventoryAdjustHeader mainData = business.GetInventoryAdjustById(new Guid(this.hiddenAdjustId.Text));

            if (!string.IsNullOrEmpty(this.txtAduitNoteWin.Text))
            {
                mainData.AuditorNotes = this.txtAduitNoteWin.Text;
            }
            bool result = false;

            try
            {
                result = business.Approve(mainData);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoApprove.true.Alert.Title").ToString(), GetLocalResourceObject("DoApprove.true.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoApprove.false.Alert.Title").ToString(), GetLocalResourceObject("DoApprove.false.Alert.Body").ToString()).Show();
            }
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
            DataSet ds = business.QueryInventoryAdjustAuditForExport(param);
            return ds;
        }
    }
}
