using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Coolite.Ext.Web;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using DMS.Business;
using Microsoft.Practices.Unity;
using DMS.Common;
using DMS.Model.Data;
using DMS.Business.Cache;

namespace DMS.Website.Pages.Transfer
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.None)]
    public partial class Transfer1 : BasePage
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
                this.Bind_DealerList(this.DealerStore);
                this.Bind_DealerList(this.DealerStoremain);
                this.Bind_TransferStatus(this.TransferStatusStore);
                this.Bind_TransferType(this.TransferTypeStore);


                //this.cbDealerFrom.SelectedItem.Value = (RoleModelContext.Current.User.CorpId.Value.ToString());
                DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_RENT);



                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.TransferBLL.Action_TransferApply, PermissionType.Read);
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            this.TransferUnfreezeDialog1.GridStore = this.DetailStore;
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
                param.Add("QueryType", "LPHQ");
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
            //不选则查询除了Rent外的2种类型
            string[] transferType = new string[2];
            if (!string.IsNullOrEmpty(this.cbTransferType.SelectedItem.Value))
            {
                transferType[0] = this.cbTransferType.SelectedItem.Value;
                param.Add("Type", transferType);
            }
            else
            {
                transferType[0] = TransferType.Transfer.ToString();
                transferType[1] = TransferType.TransferConsignment.ToString();
                param.Add("Type", transferType);
            }

            DataSet ds = business.SelectByFilterTransferFrozen(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        protected void Bind_TransferStatus(Store store)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_TransferOrder_Status);

            store.DataSource = dicts;
            store.DataBind();
        }

        protected void Bind_TransferType(Store store)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_TransferOrder_Type);
            var list = from t in dicts where t.Key != TransferType.Rent.ToString() select t;
            list = from t in list where t.Key != TransferType.RentConsignment.ToString() select t;

            store.DataSource = list;
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

            CaculateSumValue();
        }

        protected void ReasonStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DataSet ds = business.SelectLimitReason(RoleModelContext.Current.User.CorpId.Value);

            this.ReasonStore.DataSource = ds;
            this.ReasonStore.DataBind();
        }


        private void CaculateSumValue()
        {
            //获取移库总数量
            Hashtable param = new Hashtable();
            param.Add("TrnId", new Guid(this.hiddenTransferId.Text));
            TransferBLL transferBLL = new TransferBLL();
            Decimal lineNum = transferBLL.GetTransferLineProductNumByTrnId(param);
            this.lblProductSum.Text = "产品总数量：" + lineNum.ToString();
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

        protected void ShowDialog(object sender, AjaxEventArgs e)
        {
            if (string.IsNullOrEmpty(this.hiddenDealerToId.Text) || string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
            {
                Ext.Msg.Alert("错误", "请选择经销商、借入经销商和产品线后再添加产品！").Show();
                return;
            }
            Guid id = new Guid(e.ExtraParams["TransferId"].ToString());
            System.Diagnostics.Debug.WriteLine("ShowDialog : " + id.ToString());
            if (this.hiddenTransType.Text == TransferType.Transfer.ToString())
            {
                this.TransferUnfreezeDialog1.Show(TransferType.Transfer, id, new Guid(this.hiddenDealerFromId.Text), new Guid(this.cbProductLineWin.SelectedItem.Value), new Guid(this.hiddenDealerToId.Text), string.IsNullOrEmpty(this.cbWarehouseWin.SelectedItem.Value) ? Guid.Empty : (new Guid(this.cbWarehouseWin.SelectedItem.Value)));
            }
            else
            {
                this.TransferUnfreezeDialog1.Show(TransferType.TransferConsignment, id, new Guid(this.hiddenDealerFromId.Text), new Guid(this.cbProductLineWin.SelectedItem.Value), new Guid(this.hiddenDealerToId.Text), string.IsNullOrEmpty(this.cbWarehouseWin.SelectedItem.Value) ? Guid.Empty : (new Guid(this.cbWarehouseWin.SelectedItem.Value)));
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
            this.cbDealerFromWin.Disabled = false;
            this.cbDealerFromWin.Hidden = false;
            this.cbWarehouseWin.Disabled = false;
            this.cbProductLineWin.Disabled = false;
            this.hidInitWarehouseId.Text = string.Empty;

            this.txtNumber.Text = string.Empty;
            this.txtDate.Text = string.Empty;
            this.txtStatus.Text = string.Empty;

            //added by bozhenfei on 20100607
            this.hiddenCurrentEdit.Text = string.Empty;
            this.hiddenIsEditting.Text = string.Empty;
            //end


            //added by songweiming on 2013-11-25
            this.lblProductSum.Text = string.Empty;
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
                string DealerId = this.cbDealerFromWin.SelectedItem.Value == "" ? "00000000-0000-0000-0000-000000000000" : this.cbDealerFromWin.SelectedItem.Value;
                mainData.FromDealerDmaId = new Guid(DealerId);
                mainData.ToDealerDmaId = new Guid(DealerId);
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
                this.txtDate.Text = mainData.TransferDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
            }
            this.txtStatus.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_TransferOrder_Status, mainData.Status);

            //绑定Detail页面的控件,普通移库需要校验产品线
            if (this.hiddenTransType.Text == "Transfer")
            {
                this.Bind_LimitProductLine(this.ProductLineWinStore);

            }
            else
            {
                this.Bind_ProductLine(this.ProductLineWinStore);
            }
            this.Bind_WarehouseByDealerAndType(this.WarehouseStore, new Guid(mainData.FromDealerDmaId.Value.ToString()), "Noanddefault");



            //窗口状态控制

            this.cbDealerFromWin.Disabled = true;
            this.cbDealerFromWin.Hidden = false;
            this.cbWarehouseWin.Disabled = true;
            this.cbProductLineWin.Disabled = true;

            this.DraftButton.Disabled = true;
            this.SubmitButton.Disabled = true;
            this.DeleteButton.Disabled = true;
            this.AddItemsButton.Disabled = true;
            this.BtnReason.Hidden = true;
            this.GridPanel2.ColumnModel.SetHidden(10, true);
            this.GridPanel2.ColumnModel.SetHidden(11, true);
            this.GridPanel2.ColumnModel.SetHidden(12, true);
            this.GridPanel2.ColumnModel.SetHidden(13, true);
            this.GridPanel2.ColumnModel.SetHidden(15, true);
            this.GridPanel2.ColumnModel.SetEditable(14, true);

            if (mainData.Status == DealerTransferStatus.Draft.ToString())
            {
                this.cbDealerFromWin.Disabled = false;
                this.cbProductLineWin.Disabled = false;
                this.cbWarehouseWin.Disabled = false;
                this.DraftButton.Disabled = false;
                this.SubmitButton.Disabled = false;
                this.DeleteButton.Disabled = false;
                if (mainData.FromDealerDmaId != null && mainData.ToDealerDmaId != null && mainData.ProductLineBumId != null)
                {
                    this.AddItemsButton.Disabled = false;
                }
                this.GridPanel2.ColumnModel.SetHidden(12, false);
                this.GridPanel2.ColumnModel.SetHidden(13, false);
                this.GridPanel2.ColumnModel.SetHidden(15, false);
                this.GridPanel2.ColumnModel.SetHidden(14, false);
                Renderer r = new Renderer();
                r.Fn = "SetCellCssEditable";
                this.GridPanel2.ColumnModel.SetRenderer(12, r);

                this.BtnReason.Hidden = business.SelectLimitBUCount(new Guid(this.hiddenDealerFromId.Text)).Tables[0].Rows[0]["cnt"].ToString() == "0";
                this.GridPanel2.ColumnModel.SetHidden(10, true);
                this.GridPanel2.ColumnModel.SetHidden(11, true);
                this.GridPanel2.ColumnModel.SetEditable(14, true);
                //this.GridPanel2.ColumnModel.SetRenderer(10, r);
            }
            else
            {
                this.GridPanel2.ColumnModel.SetHidden(14, true);
                this.GridPanel2.ColumnModel.SetHidden(10, false);
                this.GridPanel2.ColumnModel.SetHidden(11, false);
                Renderer r = new Renderer();
                r.Fn = "SetCellCssNonEditable";
                //this.GridPanel2.ColumnModel.SetRenderer(11, r);
                this.GridPanel2.ColumnModel.SetEditable(14, false);
                //this.GridPanel2.ColumnModel.SetRenderer(10, r);
            }



            this.DetailWindow.Show();
        }





        //获取默认仓库信息（下拉列表）
        protected void WarehouseStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            this.Bind_WarehouseByDealerAndType(this.WarehouseStore, new Guid(this.hiddenDealerFromId.Text), "Noanddefault");
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
            if (!string.IsNullOrEmpty(this.cbDealerFromWin.SelectedItem.Value))
            {
                mainData.ToDealerDmaId = new Guid(this.cbDealerFromWin.SelectedItem.Value);
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
                Ext.Msg.Alert("消息", "保存草稿成功").Show();
            }
            else
            {
                Ext.Msg.Alert("消息", "保存草稿失败").Show();
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
                Ext.Msg.Alert("消息", "删除草稿成功").Show();
            }
            else
            {
                Ext.Msg.Alert("消息", "撤销出库单失败").Show();
            }
        }

        [AjaxMethod]
        public void DeleteDetail()
        {
            //ITransferBLL business = new TransferBLL();

            bool result = false;

            try
            {
                result = business.DeleteDetail(new Guid(this.hiddenTransferId.Text));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                //Ext.Msg.Alert("Message", "删除明细数据成功", new JFunction { Handler = "#{DetailStore}.reload();" }).Show();
            }
            else
            {
                Ext.Msg.Alert("消息", "删除明细数据失败").Show();
            }
        }

        [AjaxMethod]
        public void SaveTransferItem(String LotId, string ToWarehouseId, String TransferQty, String QRCode, String EditQrCode, String LotNumber)
        {
            //ITransferBLL business = new TransferBLL();

            bool result = false;

            try
            {

                string Number = string.Empty;

                bool bl = true;
                InventoryAdjustBLL bll = new InventoryAdjustBLL();

                Guid? whid = null;
                if (!string.IsNullOrEmpty(ToWarehouseId))
                {
                    whid = new Guid(ToWarehouseId);
                }
                if (QRCode == "NoQR" && !string.IsNullOrEmpty(EditQrCode))
                {
                    if (bll.QueryQrCodeIsExist(EditQrCode))
                    {
                        Number = LotNumber + "@@" + EditQrCode;
                    }
                    else
                    {
                        bl = false;
                    }
                }
                result = business.SaveTransferItem(new Guid(LotId), whid, Convert.ToDouble(TransferQty), Number);

                this.DetailStore.DataBind();
                if (!result)
                {
                    Ext.Msg.Alert("消息", "保存出错").Show();
                }
                if (!bl)
                {
                    Ext.Msg.Alert("Messing", "该二维码不存在").Show();
                }


            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }


        }

        [AjaxMethod]
        public void SaveItem(String LotId, String ToWarehouseId, String TransferQty, String QRCode, String EditQrCode, String LotNumber)
        {
            //ITransferBLL business = new TransferBLL();

            bool result = false;

            try
            {
                result = business.SaveTransferItem(new Guid(LotId), new Guid(ToWarehouseId), Convert.ToDouble(TransferQty), LotNumber);
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
                Ext.Msg.Alert("消息", "保存出错").Show();
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
                Ext.Msg.Alert("消息", "删除出错").Show();
            }
        }
        [AjaxMethod]
        public string DoSubmit()
        {

            bool result = false;
            string errMsg = string.Empty;

            //ITransferBLL business = new TransferBLL();

            //判断line表中移入库与移出库是否一致；如果一致则不能提交
            if (!business.IsTransferLineWarehouseEqualByTrnID(this.hiddenTransferId.Text))
            {

                //更新字段
                DMS.Model.Transfer mainData = business.GetObject(new Guid(this.hiddenTransferId.Text));
                mainData.FromDealerDmaId = new Guid(this.cbDealerFromWin.SelectedItem.Value);
                mainData.ToDealerDmaId = new Guid(this.cbDealerFromWin.SelectedItem.Value);

                if (!string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
                {
                    mainData.ProductLineBumId = new Guid(this.cbProductLineWin.SelectedItem.Value);
                }

                DataSet ds = business.SelectTransferLotByFilter(new Guid(this.hiddenTransferId.Text));

                if (ds.Tables[0].Rows.Count > 0)
                {
                    errMsg = ds.Tables[0].Rows[0][0].ToString();
                }

                if (!string.IsNullOrEmpty(errMsg))
                {
                    errMsg = errMsg.Replace(",", "<br/>");
                    Ext.Msg.Alert("Error", errMsg).Show();

                    return "False";
                }

                try
                {
                    mainData.TransferUsrUserID = new Guid(this._context.User.Id);
                    result = business.TransferSubmit(mainData, out errMsg);
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }

                if (result)
                {
                    Ext.Msg.Alert("消息", "提交成功").Show();

                    return "WarehouseNotEqual";
                }
                else
                {
                    Ext.Msg.Alert("消息", errMsg.ToString()).Show();
                    return "False";
                }
            }
            else
            {
                return "WarehouseEqual";
            }
        }

        protected void ShowReason(object sender, AjaxEventArgs e)
        {

            this.ReasonWindow.Show();
        }


    }
}