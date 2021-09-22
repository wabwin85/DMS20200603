using DMS.Business;
using DMS.Business.Cache;
using DMS.Business.Excel;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.Inventory;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Inventory
{
    public class InventoryQROperationService : ABaseQueryService, IDealerFilterFac, IQueryExport
    {
        #region Ajax Method
        IRoleModelContext context = RoleModelContext.Current;
        ITIWcDealerBarcodeqRcodeScanBLL business = new TIWcDealerBarcodeqRcodeScanBLL();

        IAttachmentBLL attachBll = new AttachmentBLL();
        IDealerMasters iDealers = new DealerMasters();
        IShipmentBLL shipBll = new ShipmentBLL();
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }

        public InventoryQROperationVO Init(InventoryQROperationVO model)
        {
            try
            {
                DealerMasterDao dealerMasterDao = new DealerMasterDao();
                model.LstDealerName = dealerMasterDao.SelectFilterListAll("");

                model.IsDealer = IsDealer;
                model.LstProductLine = base.GetProductLine();
                
                //控制页面
                if (IsDealer)
                {
                    model.LstDealerName = dealerMasterDao.SelectFilterListAll(context.User.CorpName);
                    model.QryDealer = new KeyValue(context.User.CorpId.ToSafeString(), context.User.CorpName);
                    DataSet ds = business.selectremark(context.User.CorpId.ToSafeString());
                    if (ds.Tables[0].Rows[0]["cnt"].ToString() != "0")
                    {
                        model.ShowRemark = true;
                    }
                    else
                    {
                        model.ShowRemark = false;
                    }

                    Warehouses whbusiness = new Warehouses();
                    Guid DealerId = context.User.CorpId.Value;
                    IList<Warehouse> list = whbusiness.GetAllWarehouseByDealer(DealerId);
                    model.LstWarehouse = JsonHelper.DataTableToArrayList(list.ToDataSet().Tables[0]);
                }

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(InventoryQROperationVO model)
        {
            try
            {
                Hashtable table = new Hashtable();

                if (!string.IsNullOrEmpty(model.QryDealer.ToSafeString()) && !string.IsNullOrEmpty(model.QryDealer.Key.ToSafeString()))
                {
                    table.Add("DmaId", model.QryDealer.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryWarehouse.ToSafeString()) && !string.IsNullOrEmpty(model.QryWarehouse.Key.ToSafeString()))
                {
                    table.Add("WarehouseId", model.QryWarehouse.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryRemark))
                {
                    table.Add("Remark", model.QryRemark.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryProductLine.ToSafeString()) && !string.IsNullOrEmpty(model.QryProductLine.Key.ToSafeString()))
                {
                    table.Add("ProductLineId", model.QryProductLine.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryCFN))
                {
                    table.Add("Upn", model.QryCFN.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryLotNumber))
                {
                    table.Add("Lot", model.QryLotNumber.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryCfnChineseName))
                {
                    table.Add("CfnChineseName", model.QryCfnChineseName.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryExpiredDate.StartDate.ToSafeString()))
                {
                    table.Add("ExpiredDateStart", Convert.ToDateTime(model.QryExpiredDate.StartDate).ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryExpiredDate.EndDate.ToSafeString()))
                {
                    table.Add("ExpiredDateEnd", Convert.ToDateTime(model.QryExpiredDate.EndDate).ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryQrCode))
                {
                    table.Add("QrCode", model.QryQrCode.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryRemarkDate.StartDate.ToSafeString()))
                {
                    table.Add("RemarkDateStart", Convert.ToDateTime(model.QryRemarkDate.StartDate).ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryRemarkDate.EndDate.ToSafeString()))
                {
                    table.Add("RemarkDateEnd", Convert.ToDateTime(model.QryRemarkDate.EndDate).ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryCreateDate.StartDate.ToSafeString()))
                {
                    table.Add("CreateDateStart", Convert.ToDateTime(model.QryCreateDate.StartDate).ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryCreateDate.EndDate.ToSafeString()))
                {
                    table.Add("CreateDateEnd", Convert.ToDateTime(model.QryCreateDate.EndDate).ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryScanType.ToSafeString()) && !string.IsNullOrEmpty(model.QryScanType.Key.ToSafeString()))
                {
                    table.Add("ScanType", model.QryScanType.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryQtyIsZero.ToSafeString()) && !string.IsNullOrEmpty(model.QryQtyIsZero.Key.ToSafeString()))
                {
                    if (model.QryQtyIsZero.Key.ToSafeString() == "0")
                    {
                        table.Add("ZeroInventory", model.QryQtyIsZero.Key.ToSafeString());
                    }
                    else if (model.QryQtyIsZero.Key.ToSafeString() == "1")
                    {
                        table.Add("NotZeroInventory", model.QryQtyIsZero.Key.ToSafeString());
                    }
                    else
                    {
                        table.Add("NullInventory", model.QryQtyIsZero.Key.ToSafeString());
                    }
                }
                if (!string.IsNullOrEmpty(model.QryShipmentState.ToSafeString()) && !string.IsNullOrEmpty(model.QryShipmentState.Key.ToSafeString()))
                {
                    table.Add("ShipmentState", model.QryShipmentState.Key.ToSafeString());
                }
                table.Add("Status", InventoryQrStatus.New.ToString());

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryTIWcDealerBarcodeqRcodeScanByFilter(table, start, model.PageSize, out totalCount);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        public InventoryQROperationVO DealerChange(InventoryQROperationVO model)
        {
            try
            {
                if(!string.IsNullOrEmpty(model.QryDealer.ToSafeString()))
                {
                    Warehouses whbusiness = new Warehouses();
                    Guid DealerId = model.QryDealer.Key.ToSafeGuid();
                    IList<Warehouse> list = whbusiness.GetAllWarehouseByDealer(DealerId);
                    model.LstWarehouse = JsonHelper.DataTableToArrayList(list.ToDataSet().Tables[0]);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InventoryQROperationVO AddItem(InventoryQROperationVO model)
        {
            try
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                business.AddItem(new Guid(context.User.Id), context.User.CorpId.Value, model.ChooseParam, Enum.Parse(typeof(InventoryQrType), model.InvType, true).ToString(), out rtnVal, out rtnMsg);

                if (rtnVal == "Success")
                {
                    model.ExecuteMessage.Add(rtnVal);
                }
                else
                {
                    model.ExecuteMessage.Add(rtnMsg);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InventoryQROperationVO DeleteItem(InventoryQROperationVO model)
        {
            try
            {
                bool result = business.DeleteItem(model.DelItem.ToSafeGuid());
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InventoryQROperationVO DeleteItems(InventoryQROperationVO model)
        {
            try
            {
                bool result = business.DeleteItems(model.ChooseParam.Split(','));
                if (result)
                {
                    model.ExecuteMessage.Add("Success");
                }
                else
                {
                    model.ExecuteMessage.Add("批量删除失败！");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        //销售单部分
        public InventoryQROperationVO InitShipmentWin(InventoryQROperationVO model)
        {
            try
            {
                model.WinShipmentDealerName = context.User.CorpName;
                model.LstProductLine = base.GetProductLine();
                model.HidDealerId = context.User.CorpId == null ? Guid.Empty.ToSafeString() : context.User.CorpId.Value.ToSafeString();
                model = Bind_DetailStore(model);
                model = GetShipmentDate(model);

                Hashtable param = new Hashtable();

                param.Add("DealerId", context.User.CorpId.HasValue ? context.User.CorpId.Value : Guid.Empty);

                if (!string.IsNullOrEmpty(model.WinShipmentProductLine.ToSafeString()) && !string.IsNullOrEmpty(model.WinShipmentProductLine.Key.ToSafeString()))
                {
                    param.Add("ProductLine", model.WinShipmentProductLine.Key.ToSafeString());
                }
                if (model.WinShipmentDate == DateTime.MinValue)
                {
                    model.LstShipmentHospital = null;
                }
                else
                {
                    param.Add("ShipmentDate", model.WinShipmentDate);
                    DealerMasters dm = new DealerMasters();
                    DataSet ds = dm.SelectHospitalForDealerByShipmentDate(param);
                    model.LstShipmentHospital = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                }
                model = ShipmentProductLineChange(model);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InventoryQROperationVO GetShipmentDate(InventoryQROperationVO model)
        {
            try
            {
                ShipmentUtil util = new ShipmentUtil();
                CalendarDate cd = util.GetCalendarDate();

                DealerMasters dm = new DealerMasters();
                DataSet ds = dm.GetProductLineByDealer(context.User.CorpId.Value);

                Nullable<DateTime> EffectiveDate = null;
                Nullable<DateTime> ExpirationDate = null;
                int ActiveFlag;
                int IsShare;
                DataTable dt = util.GetContractDate(context.User.CorpId.Value, (string.IsNullOrEmpty(model.WinShipmentProductLine.ToSafeString()) || string.IsNullOrEmpty(model.WinShipmentProductLine.Key.ToSafeString())) ? ds.Tables[0].Rows[0]["Id"].ToString() : model.WinShipmentProductLine.Key.ToSafeString());
                if (cd != null)
                {
                    int limitNo = Convert.ToInt32(cd.Date1);
                    //当月上报还是上月上报
                    bool currentMonth = Convert.ToBoolean(cd.Date10);
                    int day = DateTime.Now.Day - 1;

                    if (dt.Rows.Count > 0)
                    {
                        EffectiveDate = Convert.ToDateTime(dt.Rows[0]["EffectiveDate"].ToString());
                        ExpirationDate = Convert.ToDateTime(dt.Rows[0]["ExpirationDate"].ToString());
                        ActiveFlag = Convert.ToInt32(dt.Rows[0]["ActiveFlag"].ToString());
                        IsShare = Convert.ToInt32(dt.Rows[0]["IsShare"].ToString());
                        if (ActiveFlag > 0)
                        {
                            if (currentMonth)
                            {
                                if (day >= limitNo)
                                {
                                    model.WinShipmentDate_Min = (DateTime.Now.AddDays(-day).Date > EffectiveDate.Value ? DateTime.Now.AddDays(-day).Date : EffectiveDate.Value).ToString("yyyy-MM-dd");
                                }
                                else
                                {
                                    model.WinShipmentDate_Min = (DateTime.Now.AddDays(-day).AddMonths(-1).Date > EffectiveDate.Value ? DateTime.Now.AddDays(-day).AddMonths(-1).Date : EffectiveDate.Value).ToString("yyyy-MM-dd");

                                }
                                model.WinShipmentDate_Max = (DateTime.Now.Date > ExpirationDate.Value ? ExpirationDate.Value : DateTime.Now.Date).ToString("yyyy-MM-dd");
                            }
                            else
                            {
                                //在工作日内只能报上月，在工作日外只能报当前月
                                if (day >= limitNo)
                                {
                                    model.WinShipmentDate_Min = (DateTime.Now.AddDays(-day).Date > EffectiveDate.Value ? DateTime.Now.AddDays(-day).Date : EffectiveDate.Value).ToString("yyyy-MM-dd");
                                    model.WinShipmentDate_Max = (DateTime.Now.Date > EffectiveDate.Value ? DateTime.Now.Date : EffectiveDate.Value).ToString("yyyy-MM-dd");

                                }
                                else
                                {
                                    model.WinShipmentDate_Min = (DateTime.Now.AddDays(-day).AddMonths(-1).Date > EffectiveDate.Value ? DateTime.Now.AddDays(-day).AddMonths(-1).Date : EffectiveDate.Value).ToString("yyyy-MM-dd");
                                    model.WinShipmentDate_Max = (DateTime.Now.AddDays(-day - 1).Date > EffectiveDate.Value ? DateTime.Now.AddDays(-day - 1).Date : EffectiveDate.Value).ToString("yyyy-MM-dd");

                                }
                            }
                        }
                        else if (ActiveFlag == 0 && IsShare > 0)
                        {
                            if (day >= limitNo)
                            {
                                model.WinShipmentDate_Min = DateTime.Now.AddDays(-day).Date.ToString("yyyy-MM-dd");
                            }
                            else
                            {
                                model.WinShipmentDate_Min = DateTime.Now.AddDays(-day).AddMonths(-1).Date.ToString("yyyy-MM-dd");
                            }
                            model.WinShipmentDate_Max = DateTime.Now.Date.ToString("yyyy-MM-dd");
                        }
                        else
                        {
                            model.WinShipmentDate_Min = EffectiveDate.Value.ToString("yyyy-MM-dd");
                            model.WinShipmentDate_Max = ExpirationDate.Value.ToString("yyyy-MM-dd");
                        }
                    }
                    else
                    {
                        if (day >= limitNo)
                        {
                            model.WinShipmentDate_Min = DateTime.Now.AddDays(-day).Date.ToString("yyyy-MM-dd");
                        }
                        else
                        {
                            model.WinShipmentDate_Min = DateTime.Now.AddDays(-day).AddMonths(-1).Date.ToString("yyyy-MM-dd");
                        }
                        model.WinShipmentDate_Max = DateTime.Now.Date.ToString("yyyy-MM-dd");
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            
            return model;
        }

        public InventoryQROperationVO Bind_DetailStore(InventoryQROperationVO model)
        {
            try
            {
                Hashtable table = new Hashtable();
                string inventoryType = model.InvType.ToSafeString();
                List<string> warehouseTypeList = new List<string>();
                if (InventoryQrType.Shipment.Equals(Enum.Parse(typeof(InventoryQrType), inventoryType, true)))
                {
                    if (!string.IsNullOrEmpty(model.WinShipmentProductLine.ToSafeString()) && !string.IsNullOrEmpty(model.WinShipmentProductLine.Key.ToSafeString()))
                    {
                        table.Add("ProductLine", model.WinShipmentProductLine.Key.ToSafeString());
                    }
                }
                else if (InventoryQrType.Transfer.Equals(Enum.Parse(typeof(InventoryQrType), inventoryType, true)))
                {
                    if (!string.IsNullOrEmpty(model.WinTransferProductLine.ToSafeString()) && !string.IsNullOrEmpty(model.WinTransferProductLine.Key.ToSafeString()))
                    {
                        table.Add("ProductLine", model.WinTransferProductLine.Key.ToSafeString());
                    }
                    if (!string.IsNullOrEmpty(model.WinTransferType.ToSafeString()) && !string.IsNullOrEmpty(model.WinTransferType.Key.ToSafeString()))
                    {
                        if (model.WinTransferType.Key.ToSafeString() == TransferType.Transfer.ToString())
                        {
                            warehouseTypeList.Add(WarehouseType.Normal.ToString());
                            warehouseTypeList.Add(WarehouseType.DefaultWH.ToString());
                            //将冻结库的库存包含到移库查询条件里面 lijie add 2017-01-09
                            warehouseTypeList.Add(WarehouseType.Frozen.ToString());
                        }
                        else if (model.WinTransferType.Key.ToSafeString() == TransferType.TransferConsignment.ToString())
                        {
                            DealerMaster dealer = DealerCacheHelper.GetDealerById(context.User.CorpId.Value);

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

                table.Add("CreateUser", context.User.Id);
                table.Add("OperationType", Enum.Parse(typeof(InventoryQrType), inventoryType, true).ToString());
                table.Add("Status", InventoryQrStatus.New.ToString());

                DataSet ds = business.QueryInventoryqrOperationByFilter(table);

                if (inventoryType == InventoryQrType.Shipment.ToString())
                {
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        model.RstWinShipmentList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                        model.ShipmentRecordSum = ds.Tables[0].Rows.Count.ToString();
                        model.ShipmentQtySum = Math.Round(Convert.ToDecimal(ds.Tables[0].Compute("SUM(Qty)", "")), 2).ToString();
                    }
                    else
                    {
                        model.ShipmentRecordSum = "0";
                        model.ShipmentQtySum = "0";
                    }
                }
                else if (inventoryType == InventoryQrType.Transfer.ToString())
                {
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        model.RstWinTransferList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                        model.TransferRecordSum = ds.Tables[0].Rows.Count.ToString();
                        model.TransferQtySum = Math.Round(Convert.ToDecimal(ds.Tables[0].Compute("SUM(Qty)", "")), 2).ToString();
                    }
                    else
                    {
                        model.TransferRecordSum = "0";
                        model.TransferQtySum = "0";
                    }
                }

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            
            return model;
        }

        public InventoryQROperationVO ShipmentProductLineChange(InventoryQROperationVO model)
        {
            try
            {
                model = GetShipmentDate(model);

                //产品线变更，清空医院信息
                model.LstShipmentHospital = null;

                model = Bind_DetailStore(model);
                DealerMaster dmst = iDealers.SelectDealerMasterParentTypebyId(context.User.CorpId.Value);
                int IsSix = 0;

                IsSix = shipBll.GetCalendarDateSix();

                if (IsSix > 0)
                {
                    //如果经销是红海，且产品线为Endo在6和工作日之内
                    DateTime dttim = DateTime.Now;

                    //model.WinShipmentDate_Min = dttim.AddDays(1 - dttim.Day).AddMonths(-1).Date.ToString("yyyy-MM-dd");
                    //model.WinShipmentDate_Max = dttim.AddDays(1 - dttim.Day).AddDays(-1).Date.ToString("yyyy-MM-dd");

                }
                else
                {
                    model = GetShipmentDate(model);
                }
                model.WinShipmentDate = DateTime.MinValue;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InventoryQROperationVO ChangeShipmentDate(InventoryQROperationVO model)
        {
            try
            {
                Hashtable param = new Hashtable();

                param.Add("DealerId", context.User.CorpId.HasValue ? context.User.CorpId.Value : Guid.Empty);

                if (!string.IsNullOrEmpty(model.WinShipmentProductLine.ToSafeString()) && !string.IsNullOrEmpty(model.WinShipmentProductLine.Key.ToSafeString()))
                {
                    param.Add("ProductLine", model.WinShipmentProductLine.Key.ToSafeString());
                }
                if (model.WinShipmentDate == DateTime.MinValue)
                {
                    model.LstShipmentHospital = null;
                }
                else
                {
                    param.Add("ShipmentDate", model.WinShipmentDate);
                    DealerMasters dm = new DealerMasters();
                    DataSet ds = dm.SelectHospitalForDealerByShipmentDate(param);
                    DataView dv = ds.Tables[0].DefaultView;
                    DataTable dt = dv.ToTable(true, "Id", "Name");
                    model.LstShipmentHospital = JsonHelper.DataTableToArrayList(dt);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InventoryQROperationVO GetCfnPrice(InventoryQROperationVO model)
        {
            try
            {
                string RtnVal = string.Empty;
                string RtnMsg = string.Empty;
                business.GetCfnPriceHistorybyUpnLotDmaid(context.User.CorpId.ToString(), model.WinShipmentHospital.Key.ToSafeString(), out RtnVal, out RtnMsg);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InventoryQROperationVO DeleteOperationByType(InventoryQROperationVO model)
        {
            try
            {
                business.DeleteOperationItem(context.User.CorpId.Value.ToString(), model.InvType.ToSafeString());
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InventoryQROperationVO SubmitShipment(InventoryQROperationVO model)
        {
            try
            {
                //保存grid数据
                //foreach (Newtonsoft.Json.Linq.JObject dtInventory in model.RstWinShipmentList)
                //{
                for (int i = 0; i < model.RstWinShipmentList.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject dtInventory = Newtonsoft.Json.Linq.JObject.Parse(model.RstWinShipmentList[i].ToString());
                    string shipmentPrice = dtInventory["ShipmentPrice"].ToString().Replace("\"", "").Replace("null", "");
                    string shipmentQty = dtInventory["Qty"].ToString().Replace("\"", "").Replace("null", "");
                    
                    Guid Id = new Guid(dtInventory["Id"].ToString().Replace("\"", "").Replace("null", ""));

                    decimal? dprice = null;
                    if (!string.IsNullOrEmpty(shipmentPrice))
                    {
                        dprice = decimal.Parse(shipmentPrice);
                    }

                    business.UpdateOperationItemForShipment(Id, decimal.Parse(shipmentQty), dprice);
                }

                Guid dealerId = context.User.CorpId.HasValue ? context.User.CorpId.Value : Guid.Empty;
                Guid productLineId = model.WinShipmentProductLine.Key.ToSafeGuid();
                Guid hospitalId = model.WinShipmentHospital.Key.ToSafeGuid();
                DateTime shipmentDate = model.WinShipmentDate;
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;

                StringBuilder sb = new StringBuilder();
                sb.Append("<SHIPMENTINVOICENO>" + model.WinShipmentInvoiceNo.ToSafeString() + "</SHIPMENTINVOICENO>");
                sb.Append("<SHIPMENTINVOICETITLE>" + model.WinShipmentInvoiceTitle.ToSafeString() + "</SHIPMENTINVOICETITLE>");
                sb.Append("<SHIPMENTINVOICEDATE>" + (model.WinShipmentInvoiceDate == DateTime.MinValue ? "" : model.WinShipmentInvoiceDate.ToString("yyyyMMdd")) + "</SHIPMENTINVOICEDATE>");
                sb.Append("<SHIPMENTDEPAERMENT>" + model.WinShipmentDepartment.ToSafeString() + "</SHIPMENTDEPAERMENT>");
                sb.Append("<SHIPMENTREMARK>" + model.WinShipmentRemark.ToSafeString() + "</SHIPMENTREMARK>");
                string headerXML = "<HEADER>" + sb.ToString() + "</HEADER>";

                business.SubmitShipment(dealerId, productLineId, hospitalId, shipmentDate, headerXML, out rtnVal, out rtnMsg);
                
                if (rtnVal == "Success")
                {
                    model.ExecuteMessage.Add(rtnVal);
                }
                else
                {
                    model.ExecuteMessage.Add(rtnMsg);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            model.RstWinShipmentList = null;
            return model;
        }

        public string QueryAttachInfo(InventoryQROperationVO model)
        {
            try
            {
                Guid tid = new Guid(context.User.CorpId.Value.ToString());

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = attachBll.GetAttachmentByMainId(tid, AttachmentType.Dealer_Shipment_Qr, start, model.PageSize, out totalCount);
                model.RstWinAttachList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstWinAttachList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        public InventoryQROperationVO DeleteAttach(InventoryQROperationVO model)
        {
            try
            {
                attachBll.DelAttachment(model.DelAttachId.ToSafeGuid());
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InventoryQROperationVO DeleteOperationItem(InventoryQROperationVO model)
        {
            try
            {
                business.DeleteOperationItem(model.DelProductId);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        //移库单部分
        public InventoryQROperationVO InitTransferWin(InventoryQROperationVO model)
        {
            try
            {
                model.WinTransferDealerName = context.User.CorpName;
                model.LstProductLine = base.GetProductLine();

                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_TransferOrder_Type);
                var listType = from t in dicts where t.Key != TransferType.Rent.ToString() select t;
                listType = from t in listType where t.Key != TransferType.RentConsignment.ToString() select t;
                model.LstTransferType = JsonHelper.DataTableToArrayList(listType.ToList().ToDataSet().Tables[0]);
                model.WinTransferType = new KeyValue(listType.ToList()[0].Key.ToSafeString(), listType.ToList()[0].Value.ToSafeString());
                model = GetTransferWarehouseByType(model);
                
                model = Bind_DetailStore(model);

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InventoryQROperationVO GetTransferWarehouseByType(InventoryQROperationVO model)
        {
            try
            {
                string DealerWarehouseType = (model.WinTransferType == null || string.IsNullOrEmpty(model.WinTransferType.Key.ToSafeString())) ? TransferType.Transfer.ToString() : model.WinTransferType.Key.ToSafeString();

                Warehouses business = new Warehouses();
                //取得经销商的所有仓库
                IList<Warehouse> listWarehouse = business.GetWarehouseByDealer(context.User.CorpId.Value);

                if (listWarehouse == null)
                    listWarehouse = new List<Warehouse>();

                //获得经销商信息
                DealerMaster dealer = DealerCacheHelper.GetDealerById(context.User.CorpId.Value);

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
                    listWarehouse = (from t in listWarehouse where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString() select t).ToList<Warehouse>();
                }
                else if (dealerWarehouseType.Equals("Consignment"))
                {
                    switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                    {
                        case DealerType.LP:
                            //平台，显示波科寄售库
                            listWarehouse = (from t in listWarehouse where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                            break;
                        case DealerType.T1:
                            listWarehouse = (from t in listWarehouse where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                            break;
                        case DealerType.T2:
                            //二级经销商，显示波科寄售库
                            listWarehouse = (from t in listWarehouse where t.Type == WarehouseType.LP_Consignment.ToString() select t).ToList<Warehouse>();
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
                            listWarehouse = (from t in listWarehouse where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                            break;
                        case DealerType.T1:
                            listWarehouse = (from t in listWarehouse where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                            break;
                        case DealerType.T2:
                            //二级经销商，显示平台借货库
                            listWarehouse = (from t in listWarehouse where t.Type == WarehouseType.LP_Borrow.ToString() select t).ToList<Warehouse>();
                            break;
                        default: break;
                    }
                }
                else if (dealerWarehouseType.Equals("Complain"))
                {
                    Warehouse wh = new Warehouse();
                    wh.Id = Guid.Empty;
                    wh.Name = "销售到医院";

                    listWarehouse.Add(wh);
                }
                else
                {
                    listWarehouse = new List<Warehouse>();
                }
                model.LstTransferWarehouse = JsonHelper.DataTableToArrayList(listWarehouse.ToDataSet().Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InventoryQROperationVO UpdateToWarehouse(InventoryQROperationVO model)
        {
            try
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                List<string> warehouseTypeList = new List<string>();

                Hashtable table = new Hashtable();
                table.Add("CreateUser", context.User.Id);
                if (!string.IsNullOrEmpty(model.WinTransferProductLine.ToSafeString()) && !string.IsNullOrEmpty(model.WinTransferProductLine.Key.ToSafeString()))
                {
                    table.Add("ProductLine", model.WinTransferProductLine.Key.ToSafeString());
                }

                if (model.WinTransferType.Key.ToSafeString() == TransferType.Transfer.ToString())
                {
                    warehouseTypeList.Add(WarehouseType.Normal.ToString());
                    warehouseTypeList.Add(WarehouseType.DefaultWH.ToString());
                }
                else if (model.WinTransferType.Key.ToSafeString() == TransferType.TransferConsignment.ToString())
                {
                    DealerMaster dealer = DealerCacheHelper.GetDealerById(context.User.CorpId.Value);

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
                table.Add("ToWarehouseId", model.WinTransferWarehouse.Key.ToSafeString());
                //操作类型:移库
                table.Add("OperationType", InventoryQrType.Transfer.ToString());

                bool result = business.UpdateInventoryqrOfToWarahouseIdByFilter(table);
                rtnVal = "Success";
                model.ExecuteMessage.Add(rtnVal);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InventoryQROperationVO SubmitTransfer(InventoryQROperationVO model)
        {
            try
            {
                //保存grid数据
                //foreach (Newtonsoft.Json.Linq.JObject dtInventory in model.RstWinTransferList)
                //{
                for (int i = 0; i < model.RstWinTransferList.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject dtInventory = Newtonsoft.Json.Linq.JObject.Parse(model.RstWinTransferList[i].ToString());
                    string toWarehouseId = dtInventory["ToWarehouseId"].ToString().Replace("\"", "").Replace("null", "");
                    string transferQty = dtInventory["Qty"].ToString().Replace("\"", "").Replace("null", "");
                    
                    Guid Id = new Guid(dtInventory["Id"].ToString().Replace("\"", "").Replace("null", ""));

                    business.UpdateOperationItemForTransfer(Id, decimal.Parse(transferQty), string.IsNullOrEmpty(toWarehouseId) ? (Guid?)null : new Guid(toWarehouseId));
                }

                Guid dealerId = context.User.CorpId.HasValue ? context.User.CorpId.Value : Guid.Empty;
                Guid productLineId = model.WinTransferProductLine.Key.ToSafeGuid();
                string transferType = model.WinTransferType.Key.ToSafeString();

                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;

                business.SubmitTransfer(dealerId, productLineId, transferType, out rtnVal, out rtnMsg);

                if (rtnVal == "Success")
                {
                    model.ExecuteMessage.Add(rtnVal);
                }
                else
                {
                    model.ExecuteMessage.Add(rtnMsg);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            model.RstWinTransferList = null;
            return model;
        }

        //销售单二维码替换部分
        public InventoryQROperationVO InitQrCodeConvertWin(InventoryQROperationVO model)
        {
            try
            {
                model.LstDealer = JsonHelper.DataTableToArrayList(GetDealerSource().ToDataSet().Tables[0]);
                model.LstProductLine = base.GetProductLine();
                
                string id = model.ChooseParam.Split('@')[1];
                model.HidHeadId = id;
                TIWcDealerBarcodeqRcodeScan TIW = business.GetObject(new Guid(id));
                model.WinQrCodeConvertDealerName = context.User.CorpName;
                model.WinQrCodeConvertLotNumber = TIW.Lot;
                DataSet ds = business.SelectCfnBUby(TIW.Upn);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    var pdl = (from p in model.LstProductLine where p.Key == ds.Tables[0].Rows[0]["CFN_ProductLine_BUM_ID"].ToSafeString() select p).ToList();
                    model.WinQrCodeConvertProductLine = pdl[0];
                }
                model.WinQrCodeConvertUsedQrCode = TIW.QrCode;
                model.WinQrCodeConvertUpn = TIW.Upn;
                model.HidDealerId = TIW.DmaId.ToString();
                //二维码仓库
                Warehouses whbusiness = new Warehouses();
                IList<Warehouse> list = whbusiness.GetAllWarehouseByDealer(new Guid(model.HidDealerId));
                List<Warehouse> Wlist = new List<Warehouse>(list);
                Wlist = new List<Warehouse>((from t in Wlist
                                             where (t.Type == "Normal" || t.Type == "DefaultWH")
                                             select t));
                model.LstWarehouse = JsonHelper.DataTableToArrayList(Wlist.ToDataSet().Tables[0]);
                //产品信息
                model = Bind_ShipmentQrCodeDetail(model);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InventoryQROperationVO Bind_ShipmentQrCodeDetail(InventoryQROperationVO model)
        {
            try
            {
                Hashtable table = new Hashtable();
                table.Add("Upn", model.WinQrCodeConvertUpn.ToSafeString());
                table.Add("QrCode", model.WinQrCodeConvertUsedQrCode.ToSafeString());
                table.Add("DealerId", model.HidDealerId.ToSafeString());
                table.Add("LotNumber", model.WinQrCodeConvertLotNumber.ToSafeString());
                DataSet ds = business.QueryTIWcDealerBarcodeqRcodeScanByUpnCode(table);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    model.HidShipHeadId = ds.Tables[0].Rows[0]["SPH_ID"].ToString();
                    model.HidPmaId = ds.Tables[0].Rows[0]["PMA_ID"].ToString();
                }
                model.RstWinQrCodeConvertList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string QueryShipQrCode(InventoryQROperationVO model)
        {
            try
            {
                Hashtable ht = new Hashtable();
                ITIWcDealerBarcodeqRcodeScanBLL Bll = new TIWcDealerBarcodeqRcodeScanBLL();
                if (!string.IsNullOrEmpty(model.WinQrCodeWarehouse.Key))
                {
                    ht.Add("WarehouseId", model.WinQrCodeWarehouse.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.WinQrCode))
                {
                    ht.Add("NewQrCode", model.WinQrCode.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.WinQrCodeConvertUpn))
                {
                    ht.Add("Upn", model.WinQrCodeConvertUpn.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.WinQrCodeConvertLotNumber))
                {
                    ht.Add("LotNumber", model.WinQrCodeConvertLotNumber.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.WinQrCodeConvertUsedQrCode))
                {
                    ht.Add("QrCode", model.WinQrCodeConvertUsedQrCode.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.HidDealerId))
                {
                    ht.Add("DealerId", model.HidDealerId.ToSafeString());
                }
                
                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = Bll.QueryTIWShipmentCfnBY(ht, start, model.PageSize, out totalCount);
                
                model.RstWinQrCodeCfnList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstWinQrCodeCfnList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        public InventoryQROperationVO QrCodeConvertChecked(InventoryQROperationVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.WinQrCodeConvertNewQrCode))
                {
                    string rtnVal = string.Empty;
                    string rtnMsg = string.Empty;
                    string param = model.ChangeParam.Substring(0, model.ChangeParam.Length - 1);
                    business.QrCodeConvert_CheckSumbit(model.HidDealerId.ToSafeGuid(), model.WinQrCodeConvertNewQrCode.ToSafeString(), param, model.WinQrCodeConvertLotNumber.ToSafeString(), model.WinQrCodeConvertUpn.ToSafeString(), model.WinQrCodeConvertUsedQrCode.ToSafeString(), context.User.Id.ToString(), model.HidShipHeadId.ToSafeString(), model.HidPmaId.ToSafeString(), model.HidWhmId.ToSafeString(), out rtnVal, out rtnMsg);
                    
                    if (rtnVal == "Success")
                    {
                        model.ExecuteMessage.Add("Success");
                    }
                    else
                    {
                        model.ExecuteMessage.Add(rtnMsg);
                    }
                }
                else
                {
                    model.ExecuteMessage.Add("请填写二维码！");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        #endregion

        #region 下载
        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            Hashtable table = new Hashtable();

            if (!string.IsNullOrEmpty(Parameters["DmaId"].ToSafeString()))
            {
                table.Add("DmaId", Parameters["DmaId"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["WarehouseId"].ToSafeString()))
            {
                table.Add("WarehouseId", Parameters["WarehouseId"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Remark"].ToSafeString()))
            {
                table.Add("Remark", Parameters["Remark"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["ProductLineId"].ToSafeString()))
            {
                table.Add("ProductLineId", Parameters["ProductLineId"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Upn"].ToSafeString()))
            {
                table.Add("Upn", Parameters["Upn"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Lot"].ToSafeString()))
            {
                table.Add("Lot", Parameters["Lot"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["CfnChineseName"].ToSafeString()))
            {
                table.Add("CfnChineseName", Parameters["CfnChineseName"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["ExpiredDateStart"].ToSafeString()))
            {
                table.Add("ExpiredDateStart", Convert.ToDateTime(Parameters["ExpiredDateStart"].ToSafeString()).ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(Parameters["ExpiredDateEnd"].ToSafeString()))
            {
                table.Add("ExpiredDateEnd", Convert.ToDateTime(Parameters["ExpiredDateEnd"].ToSafeString()).ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(Parameters["QrCode"].ToSafeString()))
            {
                table.Add("QrCode", Parameters["QrCode"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["RemarkDateStart"].ToSafeString()))
            {
                table.Add("RemarkDateStart", Convert.ToDateTime(Parameters["RemarkDateStart"].ToSafeString()).ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(Parameters["RemarkDateEnd"].ToSafeString()))
            {
                table.Add("RemarkDateEnd", Convert.ToDateTime(Parameters["RemarkDateEnd"].ToSafeString()).ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(Parameters["CreateDateStart"].ToSafeString()))
            {
                table.Add("CreateDateStart", Convert.ToDateTime(Parameters["CreateDateStart"].ToSafeString()).ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(Parameters["CreateDateEnd"].ToSafeString()))
            {
                table.Add("CreateDateEnd", Convert.ToDateTime(Parameters["CreateDateEnd"].ToSafeString()).ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(Parameters["ScanType"].ToSafeString()))
            {
                table.Add("ScanType", Parameters["ScanType"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QtyIsZero"].ToSafeString()))
            {
                if (Parameters["QtyIsZero"].ToSafeString() == "0")
                {
                    table.Add("ZeroInventory", Parameters["QtyIsZero"].ToSafeString());
                }
                else if (Parameters["QtyIsZero"].ToSafeString() == "1")
                {
                    table.Add("NotZeroInventory", Parameters["QtyIsZero"].ToSafeString());
                }
                else
                {
                    table.Add("NullInventory", Parameters["QtyIsZero"].ToSafeString());
                }
            }
            if (!string.IsNullOrEmpty(Parameters["ShipmentState"].ToSafeString()))
            {
                table.Add("ShipmentState", Parameters["ShipmentState"].ToSafeString());
            }
            table.Add("Status", InventoryQrStatus.New.ToString());

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
                            {"SubCompanyName", "分子公司"},
                            {"BrandName", "品牌"},
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
            if (ds != null)
            {
                DataTable dtCopy = ds.Tables[0];
                DataSet[] result = new DataSet[1];
                result[0] = new DataSet();
                result[0].Tables.Add(dtCopy.Copy());

                Hashtable ht = new Hashtable();
                XlsExport xlsExport = new XlsExport("ExportFile");
                xlsExport.Export(ht, result, DownloadCookie);
            }

        }
        #endregion
    }
}
