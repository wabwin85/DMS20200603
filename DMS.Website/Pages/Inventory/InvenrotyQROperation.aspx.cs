using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using Lafite.RoleModel.Security;
using DMS.Business;
using DMS.Model.Data;
using DMS.Model;
using System.Collections;
using System.Data;
using System.Text;
using DMS.Common;
using DMS.Business.Cache;
using DMS.Common.Common;
using System.IO;

namespace DMS.Website.Pages.Inventory
{
    public partial class InvenrotyQROperation : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private ITIWcDealerBarcodeqRcodeScanBLL business = new TIWcDealerBarcodeqRcodeScanBLL();

        private IAttachmentBLL attachBll = new AttachmentBLL();
        private IDealerMasters _dealers = Global.ApplicationContainer.Resolve<IDealerMasters>();
        private IShipmentBLL _business = new ShipmentBLL();


        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_ProductLine(this.ProductLineStore);
                this.Bind_DealerListByFilter(DealerStore, true);

                this.Bind_TransferType(this.TransferTypeStore);
                if (IsDealer)
                {
                    this.cbDealer.Enabled = false;
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    DataSet ds = business.selectremark(this.cbDealer.SelectedItem.Value);
                    if (ds.Tables[0].Rows[0]["cnt"].ToString() != "0")
                    {
                        this.Remark.Hidden = false;
                    }
                    else
                    {
                        this.Remark.Hidden = true;
                    }
                }
            }
        }

        #region Store
        protected internal virtual void Store_AllWarehouseByDealer(object sender, StoreRefreshDataEventArgs e)
        {
            Warehouses whbusiness = new Warehouses();

            Guid DealerId = Guid.Empty;
            if (e.Parameters["DealerId"] != null || !string.IsNullOrEmpty(e.Parameters["DealerId"].ToString()))
            {
                DealerId = new Guid(e.Parameters["DealerId"].ToString());
            }
            IList<Warehouse> list = whbusiness.GetAllWarehouseByDealer(DealerId);

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = list;
                store1.DataBind();
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable table = GetQueryHashtable();

            DataSet ds = business.QueryTIWcDealerBarcodeqRcodeScanByFilter(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string InventoryType = "";
            if (e.Parameters["InventoryType"] != null && !string.IsNullOrEmpty(e.Parameters["InventoryType"].ToString()))
            {
                InventoryType = e.Parameters["InventoryType"].ToString();
            }

            Bind_DetailStore(InventoryType);
        }

        protected void ShipmentQRCodeDetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable table = new Hashtable();
            table.Add("Upn", hidUPN.Text);
            table.Add("QrCode", hidQrCode.Text);
            table.Add("DealerId", hidDealerId.Text);
            table.Add("LotNumber", hidLotNumber.Text);
            DataSet ds = business.QueryTIWcDealerBarcodeqRcodeScanByUpnCode(table);
            if (ds.Tables[0].Rows.Count > 0)
            {
                hidiShipHeadid.Text = ds.Tables[0].Rows[0]["SPH_ID"].ToString();
                hidPmaId.Text = ds.Tables[0].Rows[0]["PMA_ID"].ToString();
            }
            ShipmentQRCodeDetailStore.DataSource = ds;
            ShipmentQRCodeDetailStore.DataBind();
        }

        protected void StockQRCodeDetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!string.IsNullOrEmpty(tfWinStockOutQrCode.Text))
            {
                Hashtable table = new Hashtable();
                table.Add("LotNumber", hidLotNumber.Text);
                table.Add("Upn", hidUPN.Text);
                table.Add("QrCode", tfWinStockOutQrCode.Text);
                table.Add("WarehouseId", hidWhmId.Text);
                table.Add("DealerId", hidDealerId.Text);
                DataSet ds = business.SelectStockCfnBYUpnQrCodeLot(table);
                StockQRCodeDetailStore.DataSource = ds;
                StockQRCodeDetailStore.DataBind();
            }
        }
        protected void AttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this._context.User.CorpId.Value.ToString());
            int totalCount = 0;

            DataSet ds = attachBll.GetAttachmentByMainId(tid, AttachmentType.Dealer_Shipment_Qr, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarAttachement.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            AttachmentStore.DataSource = ds;
            AttachmentStore.DataBind();
        }
        private void Bind_DetailStore(string inventoryType)
        {
            Hashtable table = new Hashtable();
            List<string> warehouseTypeList = new List<string>();
            if (InventoryQrType.Shipment.Equals(Enum.Parse(typeof(InventoryQrType), inventoryType, true)))
            {
                if (this.cbWinShipmentProductLine.SelectedItem != null && !string.IsNullOrEmpty(this.cbWinShipmentProductLine.SelectedItem.Value))
                {
                    table.Add("ProductLine", this.cbWinShipmentProductLine.SelectedItem.Value);
                }
            }
            else if (InventoryQrType.Transfer.Equals(Enum.Parse(typeof(InventoryQrType), inventoryType, true)))
            {
                if (this.cbWinTransferProductLine.SelectedItem != null && !string.IsNullOrEmpty(this.cbWinTransferProductLine.SelectedItem.Value))
                {
                    table.Add("ProductLine", this.cbWinTransferProductLine.SelectedItem.Value);
                }
                if (this.cbWinTransferType.SelectedItem != null && !string.IsNullOrEmpty(this.cbWinTransferType.SelectedItem.Value))
                {
                    if (this.cbWinTransferType.SelectedItem.Value == TransferType.Transfer.ToString())
                    {
                        warehouseTypeList.Add(WarehouseType.Normal.ToString());
                        warehouseTypeList.Add(WarehouseType.DefaultWH.ToString());
                        //将冻结库的库存包含到移库查询条件里面 lijie add 2017-01-09
                        warehouseTypeList.Add(WarehouseType.Frozen.ToString());
                    }
                    else if (this.cbWinTransferType.SelectedItem.Value == TransferType.TransferConsignment.ToString())
                    {
                        DealerMaster dealer = DealerCacheHelper.GetDealerById(_context.User.CorpId.Value);

                        switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                        {
                            case DealerType.LP:
                                //平台，显示波科寄售库
                                warehouseTypeList.Add(WarehouseType.Consignment.ToString());
                                break;
                            case DealerType.T1:
                                warehouseTypeList.Add(WarehouseType.Consignment.ToString());
                                break;
                            case DealerType.T2:
                                //二级经销商，显示平台寄售库
                                warehouseTypeList.Add(WarehouseType.LP_Consignment.ToString());
                                break;
                            default: break;
                        }
                    }

                    table.Add("WarehouseType", warehouseTypeList);
                }
            }

            table.Add("CreateUser", _context.User.Id);
            table.Add("OperationType", Enum.Parse(typeof(InventoryQrType), inventoryType, true).ToString());
            table.Add("Status", InventoryQrStatus.New.ToString());

            DataSet ds = business.QueryInventoryqrOperationByFilter(table);

            if (inventoryType == InventoryQrType.Shipment.ToString())
            {
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    this.lbShipmentRecordSum.Text = ds.Tables[0].Rows.Count.ToString();
                    this.lbShipmentQtySum.Text = Math.Round(Convert.ToDecimal(ds.Tables[0].Compute("SUM(Qty)", "")), 2).ToString();
                }
                else
                {
                    this.lbShipmentRecordSum.Text = "0";
                    this.lbShipmentQtySum.Text = "0";
                }
            }
            else if (inventoryType == InventoryQrType.Transfer.ToString())
            {
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    this.lbTransferRecordSum.Text = ds.Tables[0].Rows.Count.ToString();
                    this.lbTransferQtySum.Text = Math.Round(Convert.ToDecimal(ds.Tables[0].Compute("SUM(Qty)", "")), 2).ToString();
                }
                else
                {
                    this.lbTransferRecordSum.Text = "0";
                    this.lbTransferQtySum.Text = "0";
                }
            }

            this.DetailStore.DataSource = ds;
            this.DetailStore.DataBind();

        }

        private Hashtable GetQueryHashtable()
        {
            Hashtable table = new Hashtable();

            if (this.cbDealer.SelectedItem != null && !string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                table.Add("DmaId", this.cbDealer.SelectedItem.Value);
            }
            if (this.cbWarehouse.SelectedItem != null && !string.IsNullOrEmpty(this.cbWarehouse.SelectedItem.Value))
            {
                table.Add("WarehouseId", this.cbWarehouse.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtRemark.Text))
            {
                table.Add("Remark", this.txtRemark.Text);
            }
            if (this.cbProductLine.SelectedItem != null && !string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                table.Add("ProductLineId", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                table.Add("Upn", this.txtCFN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            {
                table.Add("Lot", this.txtLotNumber.Text);
            }
            if (!string.IsNullOrEmpty(this.txtCfnChineseName.Text))
            {
                table.Add("CfnChineseName", this.txtCfnChineseName.Text);
            }
            if (!this.txtExpiredDateStart.IsNull)
            {
                table.Add("ExpiredDateStart", this.txtExpiredDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtExpiredDateEnd.IsNull)
            {
                table.Add("ExpiredDateEnd", this.txtExpiredDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtQrCode.Text))
            {
                table.Add("QrCode", this.txtQrCode.Text);
            }
            if (!this.txtRemarkDateStart.IsNull)
            {
                table.Add("RemarkDateStart", this.txtRemarkDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtRemarkDateEnd.IsNull)
            {
                table.Add("RemarkDateEnd", this.txtRemarkDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtCreateDateStart.IsNull)
            {
                table.Add("CreateDateStart", this.txtCreateDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtCreateDateEnd.IsNull)
            {
                table.Add("CreateDateEnd", this.txtCreateDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (this.cbScanType.SelectedItem != null && !string.IsNullOrEmpty(this.cbScanType.SelectedItem.Value))
            {
                table.Add("ScanType", this.cbScanType.SelectedItem.Value);
            }
            if (this.cbQtyIsZero.SelectedItem != null && !string.IsNullOrEmpty(this.cbQtyIsZero.SelectedItem.Value))
            {
                if (this.cbQtyIsZero.SelectedItem.Value == "0")
                {
                    table.Add("ZeroInventory", cbQtyIsZero.SelectedItem.Value);
                }
                else if (this.cbQtyIsZero.SelectedItem.Value == "1")
                {
                    table.Add("NotZeroInventory", cbQtyIsZero.SelectedItem.Value);
                }
                else
                {
                    table.Add("NullInventory", cbQtyIsZero.SelectedItem.Value);
                }
            }
            if (!string.IsNullOrEmpty(cbShipmentState.SelectedItem.Value))
            {
                table.Add("ShipmentState", cbShipmentState.SelectedItem.Value);
            }
            table.Add("Status", InventoryQrStatus.New.ToString());
            return table;
        }

        #region 移库
        protected void Bind_TransferType(Store store)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_TransferOrder_Type);
            var list = from t in dicts where t.Key != TransferType.Rent.ToString() select t;
            list = from t in list where t.Key != TransferType.RentConsignment.ToString() select t;

            store.DataSource = list;
            store.DataBind();
        }

        public virtual void TransferWarehouseSrote_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string DealerWarehouseType = "";
            if (e.Parameters["DealerWarehouseType"] != null && !string.IsNullOrEmpty(e.Parameters["DealerWarehouseType"].ToString()))
            {
                DealerWarehouseType = e.Parameters["DealerWarehouseType"].ToString();
            }

            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(_context.User.CorpId.Value);

            if (list == null)
                list = new List<Warehouse>();

            //获得经销商信息
            DealerMaster dealer = DealerCacheHelper.GetDealerById(_context.User.CorpId.Value);

            string dealerWarehouseType = "";

            if (DealerWarehouseType == TransferType.Transfer.ToString())
            {
                dealerWarehouseType = "Normal";
            }
            else if (DealerWarehouseType == TransferType.TransferConsignment.ToString())
            {
                dealerWarehouseType = "Consignment";
            }

            if (dealerWarehouseType.Equals("Normal"))
            {
                list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString() select t).ToList<Warehouse>();
            }
            else if (dealerWarehouseType.Equals("Consignment"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科借货库
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台借货库
                        list = (from t in list where t.Type == WarehouseType.LP_Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Complain"))
            {
                Warehouse wh = new Warehouse();
                wh.Id = Guid.Empty;
                wh.Name = "销售到医院";

                list.Add(wh);
            }
            else
            {
                list = new List<Warehouse>();
            }

            TransferWarehouseStore.DataSource = list;
            TransferWarehouseStore.DataBind();
        }
        #endregion
        #endregion

        #region AjaxMethods
        [AjaxMethod]
        public void AddItem(string param, string invType)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            business.AddItem(new Guid(_context.User.Id), _context.User.CorpId.Value, param.Substring(0, param.Length - 1), Enum.Parse(typeof(InventoryQrType), invType, true).ToString(), out rtnVal, out rtnMsg);

            if (rtnVal == "Success")
            {
                Ext.Notification.Show(new Notification.Config
                {
                    Title = "提醒",
                    Icon = Icon.Information,
                    //AutoHide = true,
                    HideDelay = 300,
                    Html = "添加成功!",
                    Height = 60,
                    Width = 100,
                    CloseVisible = true
                });
            }

            this.hidRtnVal.Text = rtnVal;
            this.hidRtnMsg.Text = rtnMsg;
        }

        [AjaxMethod]
        public void DeleteOperationItem(string itemId)
        {
            business.DeleteOperationItem(itemId);
        }

        [AjaxMethod]
        public void DeleteItem(string id)
        {
            bool result = business.DeleteItem(new Guid(id));
        }

        [AjaxMethod]
        public void DeleteItems(string param)
        {
            bool result = business.DeleteItems(param.Substring(0, param.Length - 1).Split(','));
            if (result)
            {
                this.hidRtnVal.Text = "Success";
            }
            else
            {
                this.hidRtnVal.Text = "Error";
                this.hidRtnMsg.Text = "批量删除失败";
            }
        }

        [AjaxMethod]
        public void DeleteOperationByType(string type)
        {
            business.DeleteOperationItem(_context.User.CorpId.Value.ToString(), type);
        }
        [AjaxMethod]
        public void GetCfnPrice()
        {
            this.hidRtnVal.Clear();
            this.hidRtnMsg.Clear();
            string RtnVal = string.Empty;
            string RtnMsg = string.Empty;
            business.GetCfnPriceHistorybyUpnLotDmaid(_context.User.CorpId.ToString(), cbWinShipmentHospital.SelectedItem.Value, out RtnVal, out RtnMsg);
            this.hidRtnVal.Text = RtnVal;

        }

        #region 上报销量
        [AjaxMethod]
        public void ShowShipmentWindow()
        {
            TabAttachment.Hide();
            TabSearch.Show();
            this.tfWinShipmentDealerName.Text = _context.User.CorpName;
            this.GetShipmentDate();
            this.Bind_Hospital(this.HospitalStore, this.cbWinShipmentProductLine.SelectedItem.Value, this.dfWinShipmentDate.SelectedDate);
            ShipmentProductLineChange();
        }

        [AjaxMethod]
        public void ChangeShipmentDate()
        {
            this.Bind_Hospital(this.HospitalStore, this.cbWinShipmentProductLine.SelectedItem.Value, this.dfWinShipmentDate.SelectedDate);
        }

        [AjaxMethod]
        public void ShipmentProductLineChange()
        {
            this.GetShipmentDate();

            //产品线变更，清空医院信息
            Store store = HospitalStore;
            store.DataSource = new DataTable();
            store.DataBind();

            this.Bind_DetailStore(InventoryQrType.Shipment.ToString());
            DealerMaster dmst = _dealers.SelectDealerMasterParentTypebyId(RoleModelContext.Current.User.CorpId.Value);
            int IsSix = 0;
            #region 2018-7-25 add by Chang.hu  当月6个工作日之内 用量日期只能选上月日期

            //if ((dmst.Taxpayer == "红海" && cbWinShipmentProductLine.SelectedItem.Value == "8f15d92a-47e4-462f-a603-f61983d61b7b" && dmst.DealerType == "T2") || (cbWinShipmentProductLine.SelectedItem.Value == "8f15d92a-47e4-462f-a603-f61983d61b7b" && dmst.DealerType == "T1"))
            //{
                //如果经销是红海，且产品线为Endo要判断是否在6和工作日之内,如在本月6个工作日之内则日期只可选择上个月最后一条否则还是按照原来的逻辑 lije add 20160922
                #endregion
                IsSix = _business.GetCalendarDateSix();
            
                 if (IsSix > 0)
            {
                //如果经销是红海，且产品线为Endo在6和工作日之内
                DateTime dttim = DateTime.Now;


                this.dfWinShipmentDate.MinDate = dttim.AddDays(1 - dttim.Day).AddMonths(-1).Date;
                this.dfWinShipmentDate.MaxDate = dttim.AddDays(1 - dttim.Day).AddDays(-1).Date;

            }
                 else
                 {
                     GetShipmentDate();
                 }
            //}
            //else
            //{
            //    GetShipmentDate();
            //}

           
        }

        [AjaxMethod]
        public void SubmitShipment()
        {
            Guid dealerId = _context.User.CorpId.HasValue ? _context.User.CorpId.Value : Guid.Empty;
            Guid productLineId = new Guid(this.cbWinShipmentProductLine.SelectedItem.Value);
            Guid hospitalId = new Guid(this.cbWinShipmentHospital.SelectedItem.Value);
            DateTime shipmentDate = this.dfWinShipmentDate.SelectedDate;
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;

            string headerXML = "<HEADER>" + this.GetHeaderXMLForBeforeSubmit() + "</HEADER>";

            business.SubmitShipment(dealerId, productLineId, hospitalId, shipmentDate, headerXML, out rtnVal, out rtnMsg);

            this.hidRtnVal.Text = rtnVal;
            this.hidRtnMsg.Text = rtnMsg;
        }

        [AjaxMethod]
        public void UpdateShipmentItem(string qty, string price)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;

            Guid Id = new Guid(this.hidEditItemId.Text);

            decimal? dprice = null;
            if (!string.IsNullOrEmpty(price))
            {
                dprice = decimal.Parse(price);
            }

            bool result = business.UpdateOperationItemForShipment(Id, decimal.Parse(qty), dprice);
            rtnVal = "Success";

            //this.hidRtnVal.Text = rtnVal;
        }
        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                attachBll.DelAttachment(new Guid(id));
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\ShipmentAttachment");
                File.Delete(uploadFile + "\\" + fileName);

            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除附件失败，请联系DMS技术支持").Show();
            }
        }
        #endregion

        #region 移库
        [AjaxMethod]
        public void ShowTransferWindow()
        {
            this.tfWinTransferDealerName.Text = _context.User.CorpName;
            //this.Bind_WarehouseByDealerAndType(this.WarehouseStore, _context.User.CorpId.Value, mainData.Type == TransferType.Transfer.ToString() ? "Normal" : "Consignment");
        }

        [AjaxMethod]
        public void TransferProductLineChange()
        {
            this.Bind_DetailStore(InventoryQrType.Transfer.ToString());
        }

        [AjaxMethod]
        public void UpdateTransferItem(string qty, string toWarehouseId)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;

            Guid Id = new Guid(this.hidEditItemId.Text);

            bool result = business.UpdateOperationItemForTransfer(Id, decimal.Parse(qty), string.IsNullOrEmpty(toWarehouseId) ? (Guid?)null : new Guid(toWarehouseId));
            rtnVal = "Success";
        }

        [AjaxMethod]
        public void UpdateToWarehouse(string toWarehouseId)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            List<string> warehouseTypeList = new List<string>();

            Hashtable table = new Hashtable();
            table.Add("CreateUser", _context.User.Id);
            if (this.cbWinTransferProductLine.SelectedItem != null && !string.IsNullOrEmpty(this.cbWinTransferProductLine.SelectedItem.Value))
            {
                table.Add("ProductLine", this.cbWinTransferProductLine.SelectedItem.Value);
            }

            if (this.cbWinTransferType.SelectedItem.Value == TransferType.Transfer.ToString())
            {
                warehouseTypeList.Add(WarehouseType.Normal.ToString());
                warehouseTypeList.Add(WarehouseType.DefaultWH.ToString());
            }
            else if (this.cbWinTransferType.SelectedItem.Value == TransferType.TransferConsignment.ToString())
            {
                DealerMaster dealer = DealerCacheHelper.GetDealerById(_context.User.CorpId.Value);

                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        warehouseTypeList.Add(WarehouseType.Consignment.ToString());
                        break;
                    case DealerType.T1:
                        warehouseTypeList.Add(WarehouseType.Consignment.ToString());
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台寄售库
                        warehouseTypeList.Add(WarehouseType.LP_Consignment.ToString());
                        break;
                    default: break;
                }
            }
            //仓库类型
            table.Add("WarehouseType", warehouseTypeList);
            //转移仓库Id
            table.Add("ToWarehouseId", toWarehouseId);
            //操作类型:移库
            table.Add("OperationType", InventoryQrType.Transfer.ToString());

            bool result = business.UpdateInventoryqrOfToWarahouseIdByFilter(table);
            rtnVal = "Success";
            this.hidRtnVal.Text = rtnVal;
        }

        [AjaxMethod]
        public void SubmitTransfer()
        {
            Guid dealerId = _context.User.CorpId.HasValue ? _context.User.CorpId.Value : Guid.Empty;
            Guid productLineId = new Guid(this.cbWinTransferProductLine.SelectedItem.Value);
            string transferType = this.cbWinTransferType.SelectedItem.Value;

            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;

            business.SubmitTransfer(dealerId, productLineId, transferType, out rtnVal, out rtnMsg);

            this.hidRtnVal.Text = rtnVal;
            this.hidRtnMsg.Text = rtnMsg;
        }

        #endregion

        #region 销售二维码替换
        [AjaxMethod]
        public void ShowShipmentQRCodeWindows(string strlist)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            tfWinQrCodeConvertUsedQrCode.Clear();
            tfWinQrCodeConvertNewQrCode.Clear();
            hidWhmId.Clear();
            hidQrCode.Clear();
            hidUPN.Clear();
            hidDealerId.Clear();//清空信息
            hidLotNumber.Clear();
            hidLotId.Clear();
            hidHeadId.Clear();

            string id = strlist.Split('@')[1];
            hidHeadId.Text = id;
            TIWcDealerBarcodeqRcodeScan TIW = business.GetObject(new Guid(id));
            this.tfWinQrCodeConvertDealerName.Text = _context.User.CorpName;
            this.tfWinQrCodeConvertLotNumber.Text = TIW.Lot;
            DataSet ds = business.SelectCfnBUby(TIW.Upn);
            if (ds.Tables[0].Rows.Count > 0)
            {
                this.cbfWinQrCodeConvertProductLine.SelectedItem.Value = ds.Tables[0].Rows[0]["CFN_ProductLine_BUM_ID"].ToString();
            }
            cbWinQrCodeCOnert.SelectedItem.Value = "二维码替换";
            tfWinQrCodeConvertUsedQrCode.Text = TIW.QrCode;
            tfWinQrCodeConvertUpn.Text = TIW.Upn;
            hidQrCode.Text = TIW.QrCode;
            hidDealerId.Text = TIW.DmaId.ToString();
            hidUPN.Text = TIW.Upn;
            hidLotNumber.Text = TIW.Lot;

            rtnVal = "Success";
            hidRtnMsg.Text = rtnMsg;
            hidRtnVal.Text = rtnVal;

        }

        [AjaxMethod]
        public void QrCodeConvertChecked(string param)
        {
            if (!string.IsNullOrEmpty(tfWinQrCodeConvertNewQrCode.Text))
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                param = param.Substring(0, param.Length - 1);
                business.QrCodeConvert_CheckSumbit(new Guid(hidDealerId.Text), tfWinQrCodeConvertNewQrCode.Text, param, hidLotNumber.Text, hidUPN.Text, tfWinQrCodeConvertUsedQrCode.Text, _context.User.Id.ToString(), hidiShipHeadid.Text, hidPmaId.Text, hidWhmId.Text, out rtnVal, out rtnMsg);
                hidRtnVal.Text = rtnVal;
                hidRtnMsg.Text = rtnMsg;
            }
            else
            {
                hidRtnVal.Text = "Error";
                hidRtnMsg.Text = "请填写二维码";
            }
        }
        [AjaxMethod]
        public void SubmitQrCodeConvert()
        {
            TIWcDealerBarcodeqRcodeScan TIW = business.GetObject(new Guid(hidHeadId.Text));
        }

        #endregion

        #region 库存二维码替换
        [AjaxMethod]
        public void ShowInventoryAdjustQRCodeWindows(string strlist, string whmtype)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            string WarehouseType = string.Empty;
            this.tfWinStockDealerName.Clear();
            this.tfWinStockLotNumber.Clear();
            this.tfWinStockUpn.Clear();
            this.tfWinStockOutQrCode.Clear();
            this.tfWinStockinQrCode.Clear();
            this.hidQrCode.Clear();
            this.hidUPN.Clear();
            this.hidLotNumber.Clear();
            this.hidDealerId.Clear();
            this.hidWhmId.Clear();
            WarehouseType = whmtype;
            string id = strlist.Split('@')[1];
            TIWcDealerBarcodeqRcodeScan TIW = business.GetObject(new Guid(id));
            if (WarehouseType != "DefaultWH" && WarehouseType != "Normal" && WarehouseType != string.Empty)
            {
                rtnVal = "Error";
                rtnMsg = "只允普通仓库进行该操作";
            }
            else
            {
                this.tfWinStockDealerName.Text = _context.User.CorpName;
                this.tfWinStockLotNumber.Text = TIW.Lot;
                this.tfWinStockUpn.Text = TIW.Upn;
                DataSet ds = business.SelectCfnBUby(TIW.Upn);
                hidQrCode.Text = TIW.QrCode;
                tfWinStockinQrCode.Text = TIW.QrCode;
                hidUPN.Text = TIW.Upn;
                hidLotNumber.Text = TIW.Lot;
                hidDealerId.Text = TIW.DmaId.ToString();
                this.cbWinStockreason.SelectedItem.Value = "二维码替换";
                if (ds.Tables[0].Rows.Count > 0)
                {
                    this.cbWinStockProductLine.SelectedItem.Value = ds.Tables[0].Rows[0]["CFN_ProductLine_BUM_ID"].ToString();
                    hiddencbWinStockProductLine.Text = ds.Tables[0].Rows[0]["CFN_ProductLine_BUM_ID"].ToString();
                }

                rtnVal = "Success";

            }
            hidRtnMsg.Text = rtnMsg;
            hidRtnVal.Text = rtnVal;

        }

        [AjaxMethod]
        public void StockQrCodeConvertCheckedSumbit()
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            business.StockQrCodeConvertCheckedSumbit(new Guid(hidDealerId.Text), hidQrCode.Text, hidLotNumber.Text, hidUPN.Text, _context.User.Id.ToString(), hidWhmId.Text, out rtnVal, out rtnMsg);
            hidRtnMsg.Text = rtnMsg;
            hidRtnVal.Text = rtnVal;
        }

        [AjaxMethod]
        public void StockSumbit()
        {
            bool bl = business.StockSumbit(new Guid(hidDealerId.Text), hidLotNumber.Text, hidQrCode.Text, tfWinStockOutQrCode.Text, hidWhmId.Text, hidUPN.Text, hiddencbWinStockProductLine.Text);
            if (bl)
            {

                hidRtnVal.Text = "Success";
            }
            else
            {
                hidRtnVal.Text = "Error";
                hidRtnMsg.Text = "提交失败";
            }
        }
        #endregion
        #endregion

        #region 私有方法
        public void GetShipmentDate()
        {
            ShipmentUtil util = new ShipmentUtil();
            CalendarDate cd = util.GetCalendarDate();

            DealerMasters dm = new DealerMasters();
            DataSet ds = dm.GetProductLineByDealer(RoleModelContext.Current.User.CorpId.Value);

            Nullable<DateTime> EffectiveDate = null;
            Nullable<DateTime> ExpirationDate = null;
            int ActiveFlag;
            int IsShare;
            DataTable dt = util.GetContractDate(RoleModelContext.Current.User.CorpId.Value, this.cbWinShipmentProductLine.SelectedItem.Value == "" ? ds.Tables[0].Rows[0]["Id"].ToString() : cbWinShipmentProductLine.SelectedItem.Value);
            if (cd != null)
            {
                int limitNo = Convert.ToInt32(cd.Date1);

                int day = DateTime.Now.Day - 1;

                if (dt.Rows.Count > 0)
                {
                    EffectiveDate = Convert.ToDateTime(dt.Rows[0]["EffectiveDate"].ToString());
                    ExpirationDate = Convert.ToDateTime(dt.Rows[0]["ExpirationDate"].ToString());
                    ActiveFlag = Convert.ToInt32(dt.Rows[0]["ActiveFlag"].ToString());
                    IsShare = Convert.ToInt32(dt.Rows[0]["IsShare"].ToString());
                    if (ActiveFlag > 0)
                    {
                        if (day >= limitNo)
                        {
                            this.dfWinShipmentDate.MinDate = DateTime.Now.AddDays(-day).Date > EffectiveDate.Value ? DateTime.Now.AddDays(-day).Date : EffectiveDate.Value;

                        }
                        else
                        {
                            this.dfWinShipmentDate.MinDate = DateTime.Now.AddDays(-day).AddMonths(-1).Date > EffectiveDate.Value ? DateTime.Now.AddDays(-day).AddMonths(-1).Date : EffectiveDate.Value;

                        }
                        this.dfWinShipmentDate.MaxDate = DateTime.Now.Date > ExpirationDate.Value ? ExpirationDate.Value : DateTime.Now.Date;
                    }
                    else if (ActiveFlag == 0 && IsShare > 0)
                    {
                        if (day >= limitNo)
                        {
                            this.dfWinShipmentDate.MinDate = DateTime.Now.AddDays(-day).Date;

                        }
                        else
                        {
                            this.dfWinShipmentDate.MinDate = DateTime.Now.AddDays(-day).AddMonths(-1).Date;

                        }
                        this.dfWinShipmentDate.MaxDate = DateTime.Now.Date;
                    }
                    else
                    {
                        this.dfWinShipmentDate.MinDate = EffectiveDate.Value;
                        this.dfWinShipmentDate.MaxDate = ExpirationDate.Value;
                    }
                }
                else
                {
                    if (day >= limitNo)
                    {
                        this.dfWinShipmentDate.MinDate = DateTime.Now.AddDays(-day).Date;

                    }
                    else
                    {
                        this.dfWinShipmentDate.MinDate = DateTime.Now.AddDays(-day).AddMonths(-1).Date;

                    }
                    this.dfWinShipmentDate.MaxDate = DateTime.Now.Date;
                }
            }
        }

        public void Bind_Hospital(Store store, string ProductLine, DateTime ShipmentDate)
        {
            Hashtable param = new Hashtable();

            param.Add("DealerId", _context.User.CorpId.HasValue ? _context.User.CorpId.Value : Guid.Empty);

            if (!string.IsNullOrEmpty(ProductLine))
            {
                param.Add("ProductLine", ProductLine);
            }
            if (ShipmentDate == DateTime.MinValue)
            {
                store.DataSource = new DataTable();
                store.DataBind();
            }
            else
            {
                param.Add("ShipmentDate", ShipmentDate);
                DealerMasters dm = new DealerMasters();
                DataSet ds = dm.SelectHospitalForDealerByShipmentDate(param);
                store.DataSource = ds;
                store.DataBind();
            }
        }

        private string GetHeaderXMLForBeforeSubmit()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<SHIPMENTINVOICENO>" + this.tfWinShipmentInvoiceNo.Text + "</SHIPMENTINVOICENO>");
            sb.Append("<SHIPMENTINVOICETITLE>" + this.tfWinShipmentInvoiceTitle.Text + "</SHIPMENTINVOICETITLE>");
            sb.Append("<SHIPMENTINVOICEDATE>" + (this.dfWinShipmentInvoiceDate.IsNull ? "" : this.dfWinShipmentInvoiceDate.SelectedDate.ToString("yyyyMMdd")) + "</SHIPMENTINVOICEDATE>");
            sb.Append("<SHIPMENTDEPAERMENT>" + this.tfWinShipmentDepartment.Text + "</SHIPMENTDEPAERMENT>");
            sb.Append("<SHIPMENTREMARK>" + this.tfWinShipmentRemark.Text + "</SHIPMENTREMARK>");
            return sb.ToString();
        }
        #endregion

        #region 页面事件
        protected void ExportDetail(object sender, EventArgs e)
        {
            Hashtable table = GetQueryHashtable();

            DataSet queryDs = business.QueryTIWcDealerBarcodeqRcodeScanByFilter(table);

            DataTable dt = queryDs.Tables[0].Copy();

            DataSet ds = new DataSet("二维码产品数据");

            #region 构造日志信息Table

            DataTable dtData = dt;
            dtData.TableName = "二维码产品数据";
            if (null != dtData)
            {
                #region 调整列的顺序,并重命名列名

                Dictionary<string, string> dict = new Dictionary<string, string>
                        {
                            {"BarCode1", "上报类型"},
                            {"DealerName", "经销商"},
                            {"DealerCode", "经销商ERP Code"},
                            {"WarehouseName", "仓库"},
                            {"WarehouseTypeName", "仓库类型"},
                            {"QrCode", "二维码"},
                            {"Remark", "备注"},
                            {"ProductLineName", "产品线"},
                            {"Upn", "产品型号"},
                            {"Sku2", "短编号"},
                            {"CfnCnName", "产品名称"},
                            {"Lot", "批次号"},
                            {"ExpiredDate", "有效期"},
                            {"RemarkDate", "上报日期"},
                            {"UOM", "单位"},
                            {"LotQty", "库存数量"},
                            {"CreateUserName", "上报人"}
                        };

                CommonFunction.SetColumnIndexAndRemoveColumn(dtData, dict);

                #endregion 调整列的顺序,并重命名列名

                ds.Tables.Add(dtData);
            }

            #endregion 构造日志信息Table

            ExcelExporter.ExportDataSetToExcel(ds);
        }

        protected void ShowAttachmentWindow(object sender, AjaxEventArgs e)
        {
            this.hidRtnVal.Clear();
            this.hidRtnMsg.Clear();
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

                string file = Server.MapPath("\\Upload\\UploadFile\\ShipmentAttachment\\" + newFileName);


                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                this.hiddenFileName.Text = newFileName;

                Attachment attach = new Attachment();
                attach.Id = Guid.NewGuid();
                attach.MainId = new Guid(this._context.User.CorpId.Value.ToString());
                attach.Name = fileExtention;
                attach.Url = newFileName;
                attach.Type = AttachmentType.Dealer_Shipment_Qr.ToString();
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

        #endregion
    }
}
