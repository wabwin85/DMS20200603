using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business;
using DMS.Model;
using Lafite.RoleModel.Security;
using DMS.Common;
using DMS.Model.Data;
using DMS.Business.Cache;
using Microsoft.Practices.Unity;
using System.Data;
using System.Collections;

namespace DMS.Website.Pages.Transfer
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.None)]
    public partial class TransferAudit : BasePage
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

                this.Bind_ProductLine(this.ProductLineStore);
                this.Bind_DealerListByFilter(this.DealerStore,false);
                this.Bind_TransferStatus(this.TransferStatusStore);

                if (IsDealer)
                {
                    //this.cbDealerFrom.Disabled = true;

                    //this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    //this.cbDealerFrom.SelectedItem.Value = (RoleModelContext.Current.User.CorpId.Value.ToString());
                    DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_RENT);
                }
                else
                {
                    
                }

                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.TransferBLL.Action_TransferAudit, PermissionType.Read);
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            this.TransferDialog1.GridStore = this.DetailStore;
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
            if (this.txtStartDate.SelectedDate > DateTime.MinValue)
            {
                param.Add("TransferDateStart", this.txtStartDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (this.txtEndDate.SelectedDate > DateTime.MinValue)
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


            DataSet ds = business.QueryTransferForAudit(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        protected void Bind_TransferStatus(Store store)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_TransferOrder_Status);
            dicts.Remove(DealerTransferStatus.Draft.ToString());

            store.DataSource = dicts;
            store.DataBind();
        }

        protected void Bind_TransferType(Store store)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_TransferOrder_Type);
            dicts.Remove(TransferType.Rent.ToString());
            dicts.Remove(TransferType.RentConsignment.ToString());

            store.DataSource = dicts;
            store.DataBind();
        }

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this.hiddenTransferId.Text);

            //ITransferBLL business = new TransferBLL();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            param.Add("hid", tid);

            DataSet ds = business.QueryTransferLotHasFromToWarehouse(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.DetailStore.DataSource = ds;
            this.DetailStore.DataBind();

        }

        //added by huyong 2013-7-4
        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this.hiddenTransferId.Text);
            int totalCount = 0;
            DataSet ds = _logbll.QueryPurchaseOrderLogByHeaderId(tid, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();

            if (ds.Tables.Count > 0)
            {
                DataRow[] dr = ds.Tables[0].Select("OperNote is not null");
                if (dr.Length > 0)
                {
                    this.txtAduitNoteWin.Text = dr[0]["OperNote"].ToString();
                }
            }
        }

        protected void ShowDialog(object sender, AjaxEventArgs e)
        {
            if (string.IsNullOrEmpty(this.hiddenDealerToId.Text) || string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
            {
                Ext.Msg.Alert(GetLocalResourceObject("CheckQty.Alert.Title").ToString(), GetLocalResourceObject("ShowDialog.Alert.Body").ToString()).Show();
                return;
            }
            Guid id = new Guid(e.ExtraParams["TransferId"].ToString());
            System.Diagnostics.Debug.WriteLine("ShowDialog : " + id.ToString());
            if (this.hiddenTransType.Text == TransferType.Transfer.ToString())
            {
                this.TransferDialog1.Show(TransferType.Transfer, new Guid(this.hiddenDealerFromId.Text), new Guid(this.hiddenDealerFromId.Text), new Guid(this.cbProductLineWin.SelectedItem.Value), new Guid(this.hiddenDealerToId.Text), string.IsNullOrEmpty(this.cbWarehouseWin.SelectedItem.Value) ? Guid.Empty : (new Guid(this.cbWarehouseWin.SelectedItem.Value)));
            }
            else
            {
                this.TransferDialog1.Show(TransferType.TransferConsignment, new Guid(this.hiddenDealerFromId.Text), new Guid(this.hiddenDealerFromId.Text), new Guid(this.cbProductLineWin.SelectedItem.Value), new Guid(this.hiddenDealerToId.Text), string.IsNullOrEmpty(this.cbWarehouseWin.SelectedItem.Value) ? Guid.Empty : (new Guid(this.cbWarehouseWin.SelectedItem.Value)));
            }
        }

        protected string NextNumber()
        {
            AutoNumberBLL an = new AutoNumberBLL();
            if ((this.hiddenDealerFromId.Text == string.Empty) || (this.cbProductLineWin.SelectedItem.Value == string.Empty))
            {
                return string.Empty;
            }
            else
                return an.GetNextAutoNumber(new Guid(this.hiddenDealerFromId.Text), OrderType.Next_TransferNbr, this.cbProductLineWin.SelectedItem.Value);

        }

        protected void ShowDetails(object sender, AjaxEventArgs e)
        {
            //初始化detail窗口
            this.hiddenTransferId.Text = string.Empty;
            this.hiddenDealerFromId.Text = string.Empty;
            this.hiddenDealerToId.Text = string.Empty;
            this.hiddenProductLineId.Text = string.Empty;

            this.hidInitWarehouseId.Text = string.Empty;

            this.txtNumber.Text = string.Empty;
            this.txtDate.Text = string.Empty;
            this.txtStatus.Text = string.Empty;

            //added by bozhenfei on 20100607
            this.hiddenCurrentEdit.Text = string.Empty;
            this.hiddenIsEditting.Text = string.Empty;
            //end

            Guid id = new Guid(e.ExtraParams["TransferId"].ToString());

            this.hiddenTransType.Text = e.ExtraParams["TransType"].ToString();

            //ITransferBLL business = new TransferBLL();
            DMS.Model.Transfer mainData = null;

            //若id为空，说明为新增，则生成新的id，并新增一条记录

            if (id == Guid.Empty)
            {
                id = Guid.NewGuid();
                this.hiddenTransferId.Text = id.ToString();

                mainData = new DMS.Model.Transfer();
                mainData.Id = id;
                mainData.Type = this.hiddenTransType.Value.ToString();
                mainData.Status = DealerTransferStatus.Draft.ToString();
                mainData.FromDealerDmaId = RoleModelContext.Current.User.CorpId.Value;
                mainData.ToDealerDmaId = RoleModelContext.Current.User.CorpId.Value;
                mainData.TransferNumber = NextNumber();
                mainData.TransferDate = DateTime.Now;
                business.Insert(mainData);
            }
            //根据ID查询主表数据，并初始化页面

            //business = new TransferBLL();
            mainData = business.GetObject(id);
            this.hiddenTransferId.Text = mainData.Id.ToString();
            if (mainData.FromDealerDmaId != null)
            {
                this.hiddenDealerFromId.Text = mainData.FromDealerDmaId.Value.ToString();

                this.hidInitDealerId.Text = mainData.FromDealerDmaId.Value.ToString();
            }
            if (mainData.ToDealerDmaId != null)
            {
                this.hiddenDealerToId.Text = mainData.ToDealerDmaId.Value.ToString();
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
            this.txtStatus.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_TransferOrder_Status, mainData.Status);

            //绑定Detail页面的控件
            this.Bind_ProductLine(this.ProductLineStore);
            this.Bind_WarehouseByDealerAndType(this.WarehouseStore, mainData.FromDealerDmaId.Value, mainData.Type == TransferType.Transfer.ToString() ? "Normal" : "Consignment");



            //窗口状态控制

            this.cbDealerFromWin.Hidden = false;
            this.cbDealerFromWin.Disabled = true;
            this.cbProductLineWin.Disabled = true;
            this.cbWarehouseWin.Disabled = true;
            this.AgreeButton.Disabled = true;
            this.DenyButton.Disabled = true;
            this.txtAduitNoteWin.Disabled = true;
            this.GridPanel2.ColumnModel.SetHidden(8, false);
            this.GridPanel2.ColumnModel.SetHidden(9, false);
            this.GridPanel2.ColumnModel.SetHidden(10, true);
            this.GridPanel2.ColumnModel.SetHidden(11, true);
            this.GridPanel2.ColumnModel.SetHidden(12, true);

            if (IsDealer)
            {
                if (mainData.Status == DealerTransferStatus.Submitted.ToString())
                {
                    //this.cbProductLineWin.Disabled = false;
                    //this.cbWarehouseWin.Disabled = false;
                    this.AgreeButton.Disabled = false;
                    this.DenyButton.Disabled = false;
                    this.txtAduitNoteWin.Disabled = false;
                }

            }

            this.DetailWindow.Show();

        }


        [AjaxMethod]
        public void Agree()
        {
            
            bool result = false;

            try
            {
                DMS.Model.Transfer mainData = business.GetObject(new Guid(this.hiddenTransferId.Text));
                result = business.TransferAudit(mainData,"Agree",this.txtAduitNoteWin.Text);
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
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("SaveTransferItem.Alert.Body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void Deny()
        {
            bool result = false;

            try
            {
                DMS.Model.Transfer mainData = business.GetObject(new Guid(this.hiddenTransferId.Text));
                result = business.TransferAudit(mainData, "Deny", this.txtAduitNoteWin.Text);
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
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
            }
        }

        

    }
}
