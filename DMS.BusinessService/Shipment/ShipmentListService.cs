using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Shipment;
using DMS.DataAccess;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.Consignment;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using System.Linq;
using System.Collections.Generic;
using System.Data;
using DMS.Business.Excel;
using System.Collections.Specialized;
using Newtonsoft.Json;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.ViewModel.Common;
using DMS.Model;
using DMS.Model.Data;
using DMS.DataAccess.DataInterface;
using DMS.Business;
using Grapecity.DataAccess.Transaction;

namespace DMS.BusinessService.Shipment
{
    public class ShipmentListService : ABaseQueryService, IDealerFilterFac, IQueryExport
    {
        #region Ajax Method
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public ShipmentListVO Init(ShipmentListVO model)
        {
            try
            {
                IRoleModelContext context = RoleModelContext.Current;
                IShipmentBLL business = new ShipmentBLL();
                model.IsDealer = IsDealer;
                model.WinSLDealerType = context.User.CorpType;

                DealerMasterDao dealerMasterDao = new DealerMasterDao();
                model.LstDealerName = dealerMasterDao.SelectFilterListAll("");
                model.LstDealer = JsonHelper.DataTableToArrayList(GetDealerSource().ToDataSet().Tables[0]);
                model.DealerListType = "3";
                model.LstProductLine = GetProductLine();

                ShipmentHeaderDao daoShip = new ShipmentHeaderDao();
                IDictionary<string, string> dictOrderStatus = daoShip.SelectShipmentOrderStatus();
                var query = from t in dictOrderStatus select t;
                if (RoleModelContext.Current.User.CorpType == DealerType.T2.ToString())
                {
                    query = from t in query where t.Key != ShipmentOrderStatus.Submitted.ToString() select t;
                    query = from t in query where t.Key != ShipmentOrderStatus.Cancelled.ToString() select t;
                }
                model.LstOrderStatus = JsonHelper.DataTableToArrayList(query.ToArray().ToDataSet().Tables[0]);

                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_ShipmentOrder_Type.ToString());
                model.LstShipmentOrderType = JsonHelper.DataTableToArrayList(dicts.ToArray().ToDataSet().Tables[0]);

                if (IsDealer)
                {
                    KeyValue kvDealer = new KeyValue();
                    DealerMaster dealer = dealerMasterDao.GetObject(context.User.CorpId.ToSafeGuid());
                    kvDealer.Key = context.User.CorpId.ToSafeString();
                    kvDealer.Value = dealer.ChineseShortName;
                    model.QryDealerName = kvDealer;
                    model.LstDealerName = dealerMasterDao.SelectFilterListAll(dealer.ChineseName);
                }

                //页面控制
                model.IsAdmin = business.IsAdminRole();
                if (IsDealer)
                {
                    ITIWcDealerBarcodeqRcodeScanBLL remarks = new TIWcDealerBarcodeqRcodeScanBLL();
                    DataSet ds = remarks.selectremark(model.QryDealerName.Key);
                    if (ds.Tables[0].Rows[0]["cnt"].ToString() != "0")
                    {

                        model.ShowRemark = true;
                    }
                    else
                    {
                        model.ShowRemark = false;
                    }
                }
                else
                {
                    Permissions pers = context.User.GetPermissions();
                    model.ShowQuery = pers.IsPermissible(Business.ShipmentBLL.Action_DealerShipment, PermissionType.Read);
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

        public ShipmentListVO InitDetailWin(ShipmentListVO model)
        {
            try
            {
                IRoleModelContext context = RoleModelContext.Current;
                model.IsDealer = IsDealer;

                DealerMasterDao dealerMasterDao = new DealerMasterDao();
                model.LstDealerName = dealerMasterDao.SelectFilterListAll("");

                //产品线
                Guid DealerId = Guid.Empty;
                ShipmentHeaderDao daoShip = new ShipmentHeaderDao();
                bool IsAdminRole = daoShip.SelectAdminRole(new Guid(RoleModelContext.Current.User.Id));
                model.IsAdmin = IsAdminRole;

                if (!IsAdminRole)
                {
                    if (!string.IsNullOrEmpty(model.QryDealerName.Key))
                    {
                        DealerId = new Guid(model.QryDealerName.Key.ToSafeString());
                    }
                    else
                    {
                        DealerId = RoleModelContext.Current.User.CorpId.ToSafeGuid();
                    }
                }
                else
                {
                    if (!string.IsNullOrEmpty(model.QryDealerName.Key))
                    {
                        DealerId = new Guid(model.QryDealerName.Key.ToSafeString());
                    }
                    else
                    {
                        DealerId = new Guid("FB62D945-C9D7-4B0F-8D26-4672D2C728B7");
                    }
                }
                DealerMasters dm = new DealerMasters();
                model.LstWinSLProductLine = JsonHelper.DataTableToArrayList(dm.GetNoLimitProductLineByDealer(DealerId).Tables[0]);

                KeyValue kvDealer = new KeyValue();
                if (IsDealer)
                {
                    DealerMaster dealer = dealerMasterDao.GetObject(context.User.CorpId.ToSafeGuid());
                    kvDealer.Key = context.User.CorpId.ToSafeString();
                    kvDealer.Value = dealer.ChineseShortName;
                    model.LstDealerName = dealerMasterDao.SelectFilterListAll(dealer.ChineseShortName);
                }
                model.WinSLDealer = kvDealer;

                //清空旧页面数据
                model.WinSLOrderNo = string.Empty;
                model.WinSLShipmentDate = null;
                model.WinSLOrderStatus = string.Empty;
                model.WinSLOrderRemark = string.Empty;
                model.WinSLInvoiceDate = null;
                //added by hxw 20130705
                model.WinSLInvoiceHead = string.Empty;
                model.WinSLOrderType = string.Empty;
                //added by songweiming on 20100617
                model.WinSLInvoiceNo = string.Empty;

                Guid id = model.WinSLOrderId.ToSafeGuid();

                ShipmentHeader mainData = null;

                //若id为空，说明为新增，则生成新的id，并新增一条记录
                if (id == Guid.Empty)
                {
                    id = Guid.NewGuid();
                    mainData = new ShipmentHeader();
                    mainData.Id = id;
                    mainData.DealerDmaId = RoleModelContext.Current.User.CorpId.ToSafeGuid();
                    mainData.Status = ShipmentOrderStatus.Draft.ToString();
                    mainData.UpdateDate = DateTime.Now;// added by songweiming on 20100628
                    mainData.Type = model.WinShipmentType.ToSafeString(); //added by hxw
                    if (IsAdminRole || model.WinIsShipmentUpdate.ToSafeString() == "UpdateShipment")
                    {
                        model.WinIsDetailUpdate = true;
                        mainData.AdjType = model.WinIsShipmentUpdate.ToSafeString();
                        if (IsAdminRole)
                        {
                            mainData.DealerDmaId = new Guid("FB62D945-C9D7-4B0F-8D26-4672D2C728B7");
                        }
                    }

                    daoShip.Insert(mainData);

                    //New 经销商为操作人的Corp
                    //this.hiddenDealerType.Text = RoleModelContext.Current.User.CorpType; // Added By Song Yuqi On 20140317
                    model.WinShipmentType = mainData.Type;
                }
                //根据ID查询主表数据，并初始化页面
                mainData = daoShip.GetObject(id);
                model.WinSLOrderId = mainData.Id.ToString();

                //Added By Song Yuqi On 20140317 Begin
                //获得明细单中经销商的类型
                DealerMaster dma = new DealerMasters().GetDealerMaster(new Guid(mainData.DealerDmaId.ToSafeString()));
                //this.hiddenDealerType.Text = dma.DealerType;
                if (dma != null)
                {
                    model.WinSLDealerType = dma.DealerType;
                    model.LstDealerName = dealerMasterDao.SelectFilterListAll(dma.ChineseShortName);
                    model.WinSLDealer = new KeyValue(dma.Id.ToSafeString(), dma.ChineseShortName);
                }

                KeyValue kvProductLine = new KeyValue();
                if (mainData.ProductLineBumId != null)
                {
                    //this.hiddenProductLineId.Text = mainData.ProductLineBumId.Value.ToString();
                    kvProductLine.Key = mainData.ProductLineBumId.Value.ToString();
                }
                model.WinSLProductLine = kvProductLine;

                model.WinSLOrderNo = mainData.ShipmentNbr;
                if (mainData.ShipmentDate != null)
                {
                    model.WinSLShipmentDate = mainData.ShipmentDate;
                    model.HidShipDate = mainData.ShipmentDate.Value.ToString("yyyy-MM-dd");
                    //this.hiddenShipmentDate.Text = mainData.ShipmentDate.Value.ToString("yyyy-MM-dd");
                }

                KeyValue kvHospital = new KeyValue();
                if (mainData.HospitalHosId != null)
                {
                    //this.hiddenHospitalId.Text = mainData.HospitalHosId.Value.ToString();
                    kvHospital.Key = mainData.HospitalHosId.Value.ToString();
                }
                model.WinSLHospital = kvHospital;

                if (mainData.InvoiceDate != null)
                {
                    model.WinSLInvoiceDate = mainData.InvoiceDate;
                }

                //added by songweiming on 20100617
                if (mainData.InvoiceNo != null)
                {
                    model.WinSLInvoiceNo = mainData.InvoiceNo;
                }

                if (mainData.InvoiceTitle != null)
                {
                    model.WinSLInvoiceHead = mainData.InvoiceTitle;
                }

                if (mainData.IsAuth != null)
                {
                    if (mainData.IsAuth.Value)
                    {
                        model.WinIsAuth = "1";
                    }
                    else
                    {
                        model.WinIsAuth = "0";
                    }
                }
                else
                {
                    model.WinIsAuth = "0";
                }

                //Added By Song Yuqi On 20140317 Begin
                if (mainData.Type != null)
                {
                    model.WinShipmentType = mainData.Type;
                }
                //Added By Song Yuqi On 20140317 End

                model.WinSLOrderStatus = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_ShipmentOrder_Status, mainData.Status);
                model.WinSLOrderRemark = mainData.NoteForPumpSerialNbr;
                //added by hxw
                if (mainData.Type != null)
                    model.WinSLOrderType = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_ShipmentOrder_Type, mainData.Type);

                if (!String.IsNullOrEmpty(mainData.Id.ToSafeString()) && !String.IsNullOrEmpty(mainData.ShipmentDate.ToString()))
                {
                    Guid tid = new Guid(mainData.Id.ToSafeString());

                    Hashtable param = new Hashtable();
                    ShipmentLotDao daoLot = new ShipmentLotDao();

                    param.Add("HeaderId", tid);
                    param.Add("ShipmentDate", mainData.ShipmentDate.ToSafeDateTime().ToString("yyyy-MM-dd"));

                    DataSet ds = daoLot.SelectByFilter(param);
                    DataSet dsSum = daoLot.SelectSumByFilter(param);

                    model.WinProductQty = "销售总数量:" + dsSum.Tables[0].Rows[0]["TotalQty"].ToString();
                    model.WinProductSum = "销售总金额:" + dsSum.Tables[0].Rows[0]["TotalPrice"].ToString();
                    model.RstWinSLProductList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                }

                if (IsDealer)
                {

                    if (mainData.Status == ShipmentOrderStatus.Draft.ToString())
                    {

                        //Added By huyong On 20161023 End
                        ShipmentLotDao daoLot = new ShipmentLotDao();
                        model.WinShowReasonBtn = daoLot.SelectShipmentLimitBUCount(RoleModelContext.Current.User.CorpId.Value).Tables[0].Rows[0]["cnt"].ToString() == "0";

                        model = GetShipmentDate(model);
                    }

                    if (mainData.Status == ShipmentOrderStatus.Complete.ToString())
                    {
                        //this.SubmitButton.Text = GetLocalResourceObject("UpdateInvoiceInfo").ToString();

                        if (IsDealer && (context.User.CorpId.Value.ToString() == mainData.DealerDmaId.ToString()))
                        {
                            model.WinDisablePriceBtn = false;
                        }

                        //显示更新发票按钮 added by bozhenfei on 20100709
                        //冲红操作时间限制校验  added by songweiming on 20100617   
                        // 待审核的单据如果没有审核，不能再次点击冲红按钮。
                        if (GetRevokeDate(mainData.ShipmentDate.ToSafeDateTime()) && !daoShip.GetSubmittedOrder(mainData.Id))
                        {
                            if (mainData.Type != "Hospital" && !string.IsNullOrEmpty(mainData.Type))
                            {
                                if (RoleModelContext.Current.User.CorpType != DealerType.T2.ToString())
                                {
                                    model.WinDisableRevokeBtn = false;
                                }
                            }
                            else
                            {
                                model.WinDisableRevokeBtn = false;
                            }

                        }
                    }
                }
                else
                {
                    if (mainData.Status == ShipmentOrderStatus.Complete.ToString())
                    {
                        //this.SubmitButton.Text = GetLocalResourceObject("UpdateInvoiceInfo").ToString();

                        if (IsAdminRole || model.WinIsShipmentUpdate.Equals("UpdateShipment"))
                        {
                            if (mainData.Status == ShipmentOrderStatus.Complete.ToString() && daoShip.SelectAdminRoleAction(mainData.Id))
                            {
                                model.WinDisablePriceBtn = true;
                            }
                            if (mainData.Status == ShipmentOrderStatus.Complete.ToString() && IsDealer && (context.User.CorpId.Value.ToString() == mainData.DealerDmaId.ToString()))
                            {
                                model.WinDisablePriceBtn = true;
                            }
                        }

                    }
                }
                //绑定医院
                Hashtable ht = new Hashtable();

                ht.Add("DealerId", mainData.DealerDmaId);
                //param.Add("DealerId", cbDealerWin.SelectedItem.Value);
                ht.Add("ProductLine", mainData.ProductLineBumId);
                ht.Add("ShipmentDate", mainData.ShipmentDate);

                DataSet dsH = dm.SelectHospitalForDealerByShipmentDate(ht);
                DataView dv = dsH.Tables[0].DefaultView;
                DataTable dt = dv.ToTable(true, "Id", "Name");
                model.LstWinSLHospital = JsonHelper.DataTableToArrayList(dt);

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        
        public ShipmentListVO InitShipmentChooseItem(ShipmentListVO model)
        {
            try
            {
                string warehouseType = string.Empty;
                if (model.WinSLOrderType.ToSafeString() == "销售出库单")
                    warehouseType = "Normal";
                else if (model.WinSLOrderType.ToSafeString() == "寄售产品销售单")
                    warehouseType = "Consignment";
                else
                    warehouseType = "Borrow";
                model.LstWinSCWarehouse = JsonHelper.DataTableToArrayList(GetWarehouseByDealerAndTypeWithoutDWH(model.WinSLDealer.Key.ToSafeGuid(), model.WinSLProductLine.Key.ToSafeGuid(), warehouseType).ToDataSet().Tables[0]);

                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary("Consts_ExpiryDate_Type");
                model.LstWinSCExpired = JsonHelper.DataTableToArrayList(dicts.ToArray().ToDataSet().Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ShipmentListVO InitShipmentHistory(ShipmentListVO model)
        {
            try
            {
                string warehouseType = string.Empty;
                if (model.WinSLOrderType.ToSafeString() == "销售出库单")
                    warehouseType = "Normal";
                else if (model.WinSLOrderType.ToSafeString() == "寄售产品销售单")
                    warehouseType = "Consignment";
                else
                    warehouseType = "Borrow";
                if (!string.IsNullOrEmpty(model.WinSAHospital))
                    model.WinSHHospital = model.WinSAHospital;
                model.LstWinSHWarehouse = JsonHelper.DataTableToArrayList(WarehouseByDealerAndType(model.WinSLDealer.Key.ToSafeGuid(), warehouseType).ToDataSet().Tables[0]);

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ShipmentListVO InitShipmentInventory(ShipmentListVO model)
        {
            try
            {
                string warehouseType = string.Empty;
                if (model.WinSLOrderType.ToSafeString() == "销售出库单")
                    warehouseType = "Normal";
                else if (model.WinSLOrderType.ToSafeString() == "寄售产品销售单")
                    warehouseType = "Consignment";
                else
                    warehouseType = "Borrow";
                model.LstWinSIWarehouse = JsonHelper.DataTableToArrayList(WarehouseByDealerAndType(model.WinSLDealer.Key.ToSafeGuid(), warehouseType).ToDataSet().Tables[0]);

                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary("Consts_ExpiryDate_Type");
                model.LstWinSIExpired = JsonHelper.DataTableToArrayList(dicts.ToArray().ToDataSet().Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(ShipmentListVO model)
        {
            try
            {
                IShipmentBLL business = new ShipmentBLL();
                int totalCount = 0;

                Hashtable param = new Hashtable();

                if (!string.IsNullOrEmpty(model.QryProductLine.Key))
                {
                    param.Add("ProductLine", model.QryProductLine.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryDealerName.Key))
                {
                    param.Add("DealerId", model.QryDealerName.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryHospital))
                {
                    param.Add("HospitalName", model.QryHospital.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryStartDate.StartDate))
                {
                    param.Add("ShipmentDateStart", model.QryStartDate.StartDate.ToSafeDateTime().ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryStartDate.EndDate))
                {
                    param.Add("ShipmentDateEnd", model.QryStartDate.EndDate.ToSafeDateTime().ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryOrderNumber))
                {
                    param.Add("OrderNumber", model.QryOrderNumber.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryOrderStatus.Key))
                {
                    param.Add("Status", model.QryOrderStatus.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryCFN))
                {
                    param.Add("Cfn", model.QryCFN.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryLotNumber))
                {
                    param.Add("LotNumber", model.QryLotNumber.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryShipmentOrderType.Key))
                {
                    param.Add("Type", model.QryShipmentOrderType.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QrySubmitDate.StartDate))
                {
                    param.Add("SubmitDateStart", model.QrySubmitDate.StartDate.ToSafeDateTime().ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QrySubmitDate.EndDate))
                {
                    param.Add("SubmitDateEnd", model.QrySubmitDate.EndDate.ToSafeDateTime().ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryInvoiceStatus.Key))
                {
                    param.Add("InvoiceStatus", model.QryInvoiceStatus.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryInvoiceNo))
                {
                    param.Add("InvoiceNo", model.QryInvoiceNo.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryInvoiceState.Key))
                {
                    param.Add("InvoiceState", model.QryInvoiceState.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryInvoiceState.Key))
                {
                    param.Add("InvoiceNocheck", "1");
                }
                else
                {
                    param.Add("InvoiceNocheck", "0");
                }
                if (!string.IsNullOrEmpty(model.QryInvoiceDate.StartDate))
                {
                    param.Add("txtInvoiceDateStart", model.QryInvoiceDate.StartDate.ToSafeDateTime().ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryInvoiceDate.EndDate))
                {
                    param.Add("txtInvoiceDateend", model.QryInvoiceDate.EndDate.ToSafeDateTime().ToString("yyyyMMdd"));
                }
                //param.Add("OwnerIdentityType", RoleModelContext.Current.User.IdentityType);
                //param.Add("OwnerOrganizationUnits", RoleModelContext.Current.User.GetOrganizationUnits());
                //param.Add("OwnerId", new Guid(RoleModelContext.Current.User.Id));
                //param.Add("OwnerCorpId", RoleModelContext.Current.User.CorpId);
                param = BaseService.AddCommonFilterCondition(param);

                int start = (model.Page - 1) * model.PageSize;
                model.RstShipmentList = JsonHelper.DataTableToArrayList(business.QueryShipmentHeader(param, start, model.PageSize, out totalCount).Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstShipmentList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public ShipmentListVO QueryProductList(ShipmentListVO model)
        {
            try
            {
                if (!String.IsNullOrEmpty(model.WinSLOrderId.ToSafeString()) && !String.IsNullOrEmpty(model.WinSLShipmentDate.ToString()))
                {
                    Guid tid = new Guid(model.WinSLOrderId.ToSafeString());

                    Hashtable param = new Hashtable();
                    ShipmentLotDao daoLot = new ShipmentLotDao();

                    param.Add("HeaderId", tid);
                    param.Add("ShipmentDate", model.WinSLShipmentDate.ToSafeDateTime().ToString("yyyy-MM-dd"));

                    DataSet ds = daoLot.SelectByFilter(param);
                    DataSet dsSum = daoLot.SelectSumByFilter(param);

                    model.WinProductQty = "销售总数量:" + dsSum.Tables[0].Rows[0]["TotalQty"].ToString();
                    model.WinProductSum = "销售总金额:" + dsSum.Tables[0].Rows[0]["TotalPrice"].ToString();
                    model.RstWinSLProductList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

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

        public string QueryOPLog(ShipmentListVO model)
        {
            try
            {
                int totalCount = 0;

                Hashtable param = new Hashtable();
                param.Add("PohId", model.WinSLOrderId);
                PurchaseOrderLogDao dao = new PurchaseOrderLogDao();

                int start = (model.Page - 1) * model.PageSize;
                model.RstWinSLOPLog = JsonHelper.DataTableToArrayList(dao.QueryPurchaseOrderLogByFilter(param, start, model.PageSize, out totalCount).Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstWinSLOPLog, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public string QueryAttachInfo(ShipmentListVO model)
        {
            try
            {
                AttachmentDao dao = new AttachmentDao();
                int totalCount = 0;

                Hashtable param = new Hashtable();
                param.Add("MainId", model.WinSLOrderId);
                param.Add("Type", AttachmentType.ShipmentToHospital.ToString());

                int start = (model.Page - 1) * model.PageSize;
                model.RstWinSLAttachList = JsonHelper.DataTableToArrayList(dao.GetAttachmentByMainId(param, start, model.PageSize, out totalCount).Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstWinSLAttachList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public string QueryInvoiceNo(ShipmentListVO model)
        {
            try
            {
                int totalCount = 0;

                Hashtable param = new Hashtable();
                param.Add("UserId", new Guid(RoleModelContext.Current.User.Id));
                ShipmentInvoiceInitDao dao = new ShipmentInvoiceInitDao();

                int start = (model.Page - 1) * model.PageSize;
                model.RstWinInvoiceNo = JsonHelper.DataTableToArrayList(dao.QueryShipmentInvoiceInitErrorData(param, start, model.PageSize, out totalCount).ToDataSet().Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstWinInvoiceNo, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public string QueryAut(ShipmentListVO model)
        {
            try
            {
                int totalCount = 0;

                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.WinAutDealer))
                {
                    param.Add("DmaId", model.WinAutDealer.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.WinAutUPN))
                {
                    param.Add("AutUpn", model.WinAutUPN.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.WinAutHospital))
                {
                    param.Add("AutHospital", model.WinAutHospital.ToSafeString());
                }
                if (model.WinAutDate != null)
                {
                    param.Add("AutDate", model.WinAutDate.Value.ToShortDateString());
                }
                IShipmentBLL business = new ShipmentBLL();

                int start = (model.Page - 1) * model.PageSize;
                model.RstAutResult = JsonHelper.DataTableToArrayList(business.QueryDealerAuthorizationList(param, start, model.PageSize, out totalCount).Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstAutResult, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public ShipmentListVO QueryShipmentItem(ShipmentListVO model)
        {
            try
            {
                string[] strCriteria;
                int iCriteriaNbr;
                ICurrentInvBLL business = new CurrentInvBLL();
                IShipmentBLL shipmentBiz = new ShipmentBLL();

                string warehouseType = string.Empty;
                if (model.WinSLOrderType.ToSafeString() == "销售出库单")
                    warehouseType = "Normal";
                else if (model.WinSLOrderType.ToSafeString() == "寄售产品销售单")
                    warehouseType = "Consignment";
                else
                    warehouseType = "Borrow";

                Hashtable param = new Hashtable();

                if (string.IsNullOrEmpty(model.HidShipDate))
                {
                    model.IsSuccess = false;
                    return model;
                }
                if (!string.IsNullOrEmpty(model.HidShipDate))
                {
                    param.Add("ShipmentDate", model.HidShipDate.ToSafeDateTime().ToString("yyyy-MM-dd"));
                }


                if (!string.IsNullOrEmpty(model.WinSLDealer.Key))
                {
                    param.Add("DealerId", model.WinSLDealer.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.WinSLProductLine.Key))
                {
                    param.Add("ProductLine", model.WinSLProductLine.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.WinSCWarehouse.Key))
                {
                    param.Add("WarehouseId", model.WinSCWarehouse.Key.ToSafeString());
                }

                //可以有十个模糊查找的字段
                if (!string.IsNullOrEmpty(model.WinSCCFN))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.WinSCCFN);
                    foreach (string strCFN in strCriteria)
                    {
                        if (!string.IsNullOrEmpty(strCFN))
                        {
                            iCriteriaNbr++;
                            if (strCFN.Substring(0, 1) == "+" && strCFN.Length > 2)
                            {
                                param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN.Substring(1, strCFN.Length - 2));
                            }
                            else
                            {
                                param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN);
                            }
                        }
                    }
                    if (iCriteriaNbr > 0) param.Add("ProductCFN", "HasCFNCriteria");
                }

                if (!string.IsNullOrEmpty(model.WinSCLotNumber))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.WinSCLotNumber);
                    foreach (string strLot in strCriteria)
                    {
                        if (!string.IsNullOrEmpty(strLot))
                        {
                            iCriteriaNbr++;
                            if (strLot.Substring(0, 1) == "+" && strLot.Length > 2)
                            {
                                param.Add(string.Format("ProductLotNumber{0}", iCriteriaNbr), strLot.Substring(10, strLot.Length - 12));
                            }
                            else
                            {
                                param.Add(string.Format("ProductLotNumber{0}", iCriteriaNbr), strLot);
                            }
                        }
                    }
                    if (iCriteriaNbr > 0) param.Add("ProductLotNumber", "HasLotCriteria");
                }

                if (!string.IsNullOrEmpty(model.WinSCQrCode))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.WinSCQrCode);
                    foreach (string strQrCode in strCriteria)
                    {
                        if (!string.IsNullOrEmpty(strQrCode))
                        {
                            iCriteriaNbr++;
                            param.Add(string.Format("QrCode{0}", iCriteriaNbr), strQrCode);
                        }
                    }
                    if (iCriteriaNbr > 0) param.Add("QrCode", "HasQrCodeCriteria");
                }
                if (!string.IsNullOrEmpty(model.WinSLHospital.Key))
                {
                    param.Add("HospitalId", model.WinSLHospital.Key.ToSafeString());
                }

                if (!string.IsNullOrEmpty(model.WinSCExpired.Key))
                {
                    param.Add("ExpiryDateType", model.WinSCExpired.Key.ToSafeString());
                }
                param = BaseService.AddCommonFilterCondition(param);

                DataSet ds = null;
                if (!string.IsNullOrEmpty(model.WinSCWarehouse.Key))
                {
                    //Edited By Song Yuqi On 20140317 Begin
                    if (model.WinIsAuth.ToSafeString() == "0")
                    {
                        //二级经销商寄售
                        if (RoleModelContext.Current.User.CorpType == DealerType.T2.ToString() && warehouseType == "Consignment")
                        {
                            //平台寄售、波科寄售
                            param.Add("WarehouseTypes", string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(','));
                            ds = business.QueryCurrentInvForShipmentOrderByT2Consignment(param);
                        }
                        else if (shipmentBiz.IsAdminRole())
                        {
                            ds = business.QueryCurrentInvForShipmentOrderAdjust(param);
                        }
                        else
                        {
                            ds = business.QueryCurrentInvForShipmentOrder(param);
                        }
                    }
                    else
                    {
                        ds = business.QueryCurrentInvForShipmentOrderNoAuth(param);
                    }
                    //Edited By Song Yuqi On 20140317 End
                    //去重
                    string[] column = new string[ds.Tables[0].Columns.Count];
                    for (int i = 0; i < ds.Tables[0].Columns.Count; i++)
                        column[i] = ds.Tables[0].Columns[i].ColumnName;
                    DataView dv = ds.Tables[0].DefaultView;
                    DataTable dt = dv.ToTable(true, column);

                    model.RstSCInventoryItem = JsonHelper.DataTableToArrayList(dt);
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

        public ShipmentListVO QueryShipmentHistory(ShipmentListVO model)
        {
            try
            {
                string[] strCriteria;
                int iCriteriaNbr;
                IShipmentBLL shipmentBiz = new ShipmentBLL();

                Hashtable param = new Hashtable();

                if (!string.IsNullOrEmpty(model.WinSLDealer.Key))
                {
                    param.Add("DealerId", model.WinSLDealer.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.WinSLProductLine.Key))
                {
                    param.Add("ProductLineId", model.WinSLProductLine.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.WinSHWarehouse.Key))
                {
                    param.Add("WarehouseId", model.WinSHWarehouse.Key.ToSafeString());
                }

                //可以有十个模糊查找的字段
                if (!string.IsNullOrEmpty(model.WinSHCFN))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.WinSHCFN);
                    foreach (string strCFN in strCriteria)
                    {
                        if (!string.IsNullOrEmpty(strCFN))
                        {
                            iCriteriaNbr++;
                            if (strCFN.Substring(0, 1) == "+" && strCFN.Length > 2)
                            {
                                param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN.Substring(1, strCFN.Length - 2));
                            }
                            else
                            {
                                param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN);
                            }
                        }
                    }
                    if (iCriteriaNbr > 0) param.Add("ProductCFN", "HasCFNCriteria");
                }

                if (!string.IsNullOrEmpty(model.WinSHLotNumber))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.WinSHLotNumber);
                    foreach (string strLot in strCriteria)
                    {
                        if (!string.IsNullOrEmpty(strLot))
                        {
                            iCriteriaNbr++;
                            if (strLot.Substring(0, 1) == "+" && strLot.Length > 2)
                            {
                                param.Add(string.Format("ProductLotNumber{0}", iCriteriaNbr), strLot.Substring(10, strLot.Length - 12));
                            }
                            else
                            {
                                param.Add(string.Format("ProductLotNumber{0}", iCriteriaNbr), strLot);
                            }
                        }
                    }
                    if (iCriteriaNbr > 0) param.Add("ProductLotNumber", "HasLotCriteria");
                }

                if (!string.IsNullOrEmpty(model.WinSHQrCode))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.WinSHQrCode);
                    foreach (string strQrCode in strCriteria)
                    {
                        if (!string.IsNullOrEmpty(strQrCode))
                        {
                            iCriteriaNbr++;
                            param.Add(string.Format("ProductQrCode{0}", iCriteriaNbr), strQrCode);
                        }
                    }
                    if (iCriteriaNbr > 0) param.Add("ProductQrCode", "HasQrCodeCriteria");
                }

                if (!string.IsNullOrEmpty(model.WinSHShipmentNo))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.WinSHShipmentNo);
                    foreach (string strShipmentNbr in strCriteria)
                    {
                        if (!string.IsNullOrEmpty(strShipmentNbr))
                        {
                            iCriteriaNbr++;
                            param.Add(string.Format("ShipmentNbr{0}", iCriteriaNbr), strShipmentNbr);
                        }
                    }
                    if (iCriteriaNbr > 0) param.Add("ShipmentNbr", "HasShipmentNbrCriteria");
                }
                if (!string.IsNullOrEmpty(model.WinSLHospital.Key))
                {
                    param.Add("HospitalId", model.WinSLHospital.Key.ToSafeString());
                }
                param.Add("ShipmentQtyMinQty", 0);
                //param.Add("OnlyShowQR", 1);

                DataSet ds = null;

                if (!string.IsNullOrEmpty(model.WinSHWarehouse.Key))
                {
                    ds = shipmentBiz.QueryShipmentLotByFilter(param);
                    string[] column = new string[ds.Tables[0].Columns.Count];
                    for (int i = 0; i < ds.Tables[0].Columns.Count; i++)
                        column[i] = ds.Tables[0].Columns[i].ColumnName;
                    DataView dv = ds.Tables[0].DefaultView;
                    DataTable dt = dv.ToTable(true, column);
                    model.RstSHHistoryItem = JsonHelper.DataTableToArrayList(dt);
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

        public ShipmentListVO QueryShipmentInventory(ShipmentListVO model)
        {
            try
            {
                string[] strCriteria;
                int iCriteriaNbr;
                ICurrentInvBLL business = new CurrentInvBLL();
                IShipmentBLL shipmentBiz = new ShipmentBLL();

                Hashtable param = new Hashtable();

                if (string.IsNullOrEmpty(model.HidShipDate))
                {
                    model.IsSuccess = false;
                    return model;
                }
                if (!string.IsNullOrEmpty(model.HidShipDate))
                {
                    param.Add("ShipmentDate", model.HidShipDate.ToSafeDateTime().ToString("yyyy-MM-dd"));
                }
                if (!string.IsNullOrEmpty(model.WinSLDealer.Key))
                {
                    param.Add("DealerId", model.WinSLDealer.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.WinSLProductLine.Key))
                {
                    param.Add("ProductLine", model.WinSLProductLine.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.WinSIWarehouse.Key))
                {
                    param.Add("WarehouseId", model.WinSIWarehouse.Key.ToSafeString());
                }

                //可以有十个模糊查找的字段
                if (!string.IsNullOrEmpty(model.WinSICFN))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.WinSICFN);
                    foreach (string strCFN in strCriteria)
                    {
                        if (!string.IsNullOrEmpty(strCFN))
                        {
                            iCriteriaNbr++;
                            if (strCFN.Substring(0, 1) == "+" && strCFN.Length > 2)
                            {
                                param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN.Substring(1, strCFN.Length - 2));
                            }
                            else
                            {
                                param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN);
                            }
                        }
                    }
                    if (iCriteriaNbr > 0) param.Add("ProductCFN", "HasCFNCriteria");
                }
                if (!string.IsNullOrEmpty(model.WinSILotNumber))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.WinSILotNumber);
                    foreach (string strLot in strCriteria)
                    {
                        if (!string.IsNullOrEmpty(strLot))
                        {
                            iCriteriaNbr++;
                            if (strLot.Substring(0, 1) == "+" && strLot.Length > 2)
                            {
                                param.Add(string.Format("ProductLotNumber{0}", iCriteriaNbr), strLot.Substring(10, strLot.Length - 12));
                            }
                            else
                            {
                                param.Add(string.Format("ProductLotNumber{0}", iCriteriaNbr), strLot);
                            }
                        }
                    }
                    if (iCriteriaNbr > 0) param.Add("ProductLotNumber", "HasLotCriteria");
                }

                if (!string.IsNullOrEmpty(model.WinSIQrCode))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.WinSIQrCode);
                    foreach (string strQrCode in strCriteria)
                    {
                        if (!string.IsNullOrEmpty(strQrCode))
                        {
                            iCriteriaNbr++;
                            param.Add(string.Format("QrCode{0}", iCriteriaNbr), strQrCode);
                        }
                    }
                    if (iCriteriaNbr > 0) param.Add("QrCode", "HasQrCodeCriteria");
                }
                if (!string.IsNullOrEmpty(model.WinSLHospital.Key))
                {
                    param.Add("HospitalId", model.WinSLHospital.Key.ToSafeString());
                }

                if (!string.IsNullOrEmpty(model.WinSIExpired.Key))
                {
                    param.Add("ExpireDateType", model.WinSIExpired.Key.ToSafeString());
                }
                param.Add("LotInvQtyMin", 0);
                param.Add("ProductLineId", model.WinSLProductLine.Key.ToSafeString());
                //param.Add("OnlyShowQR", 1);

                DataSet ds = null;
                if (!string.IsNullOrEmpty(model.WinSIWarehouse.Key))
                {
                    ds = business.QueryCurrentInvForShipmentOrderNoAuth(param);
                    string[] column = new string[ds.Tables[0].Columns.Count];
                    for (int i = 0; i < ds.Tables[0].Columns.Count; i++)
                        column[i] = ds.Tables[0].Columns[i].ColumnName;
                    DataView dv = ds.Tables[0].DefaultView;
                    DataTable dt = dv.ToTable(true, column);
                    model.RstSIInventoryItem = JsonHelper.DataTableToArrayList(dt);
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

        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(Parameters["QryProductLine"].ToSafeString()))
            {
                param.Add("ProductLine", Parameters["QryProductLine"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QryDealerId"].ToSafeString()))
            {
                param.Add("DealerId", Parameters["QryDealerId"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QryHospitalName"].ToSafeString()))
            {
                param.Add("HospitalName", Parameters["QryHospitalName"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QryStartDate_Start"].ToSafeString()))
            {
                param.Add("ShipmentDateStart", Parameters["QryStartDate_Start"].ToSafeDateTime().ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(Parameters["QryStartDate_End"].ToSafeString()))
            {
                param.Add("ShipmentDateEnd", Parameters["QryStartDate_End"].ToSafeDateTime().ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(Parameters["QryOrderNo"].ToSafeString()))
            {
                param.Add("OrderNumber", Parameters["QryOrderNo"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QryOrderStatus"].ToSafeString()))
            {
                param.Add("Status", Parameters["QryOrderStatus"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QryCfn"].ToSafeString()))
            {
                param.Add("Cfn", Parameters["QryCfn"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QryLotNumber"].ToSafeString()))
            {
                param.Add("LotNumber", Parameters["QryLotNumber"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QryOrderType"].ToSafeString()))
            {
                param.Add("Type", Parameters["QryOrderType"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QrySubmitDate_Start"].ToSafeString()))
            {
                param.Add("SubmitDateStart", Parameters["QrySubmitDate_Start"].ToSafeDateTime().ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(Parameters["QrySubmitDate_End"].ToSafeString()))
            {
                param.Add("SubmitDateEnd", Parameters["QrySubmitDate_End"].ToSafeDateTime().ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(Parameters["QryInvoiceStatus"].ToSafeString()))
            {
                param.Add("InvoiceStatus", Parameters["QryInvoiceStatus"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QryInvoiceNo"].ToSafeString()))
            {
                param.Add("InvoiceNo", Parameters["QryInvoiceNo"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QryInvoiceState"].ToSafeString()))
            {
                param.Add("InvoiceState", Parameters["QryInvoiceState"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QryInvoiceState"].ToSafeString()))
            {
                param.Add("InvoiceNocheck", "1");
            }
            else
            {
                param.Add("InvoiceNocheck", "0");
            }
            if (!string.IsNullOrEmpty(Parameters["QryInvoiceDate_Start"].ToSafeString()))
            {
                param.Add("txtInvoiceDateStart", Parameters["QryInvoiceDate_Start"].ToSafeDateTime().ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(Parameters["QryInvoiceDate_End"].ToSafeString()))
            {
                param.Add("txtInvoiceDateend", Parameters["QryInvoiceDate_End"].ToSafeDateTime().ToString("yyyyMMdd"));
            }
            param = BaseService.AddCommonFilterCondition(param);
            if (Parameters["ShipmentListExportType"].ToSafeString() == "Export")
            {
                ShipmentHeaderDao dao = new ShipmentHeaderDao();
                param.Add("OwnerIdentityType", RoleModelContext.Current.User.IdentityType);
                param.Add("OwnerOrganizationUnits", RoleModelContext.Current.User.GetOrganizationUnits());
                param.Add("OwnerId", new Guid(RoleModelContext.Current.User.Id));
                param.Add("OwnerCorpId", RoleModelContext.Current.User.CorpId);

                DataSet queryDs = dao.ExportShipmentByFilter(param);
                DataTable dt = queryDs.Tables[0].Copy();
                DataSet ds = new DataSet("经销商销售数据");

                DataTable dtData = dt;
                dtData.TableName = "经销商销售数据";
                if (null != dtData)
                {
                    #region 调整列的顺序,并重命名列名

                    Dictionary<string, string> dict = new Dictionary<string, string>
                        {
                            {"DealerName", "经销商"},
                            {"DealerCode", "经销商ERP Code"},
                            {"OrderNumber", "销售单号"},
                            {"HospitalName", "医院名称"},
                            {"ShipmentDate", "销售日期"},
                            {"ShipmentName", "上报人"},
                            {"ATTRIBUTE_NAME", "产品线"},
                            {"SubCompanyName", "分子公司"},
                            {"BrandName", "品牌"},
                            {"StatusName", "单据状态"},
                            {"WarehouseName", "仓库"},
                            {"WarehouseTypeName", "仓库类型"},
                            {"CFN", "产品型号"},
                            {"LotNumber", "批次"},
                            {"QRCode", "二维码"},
                            {"SLT_UnitPrice", "单价"},
                            {"ShipmentQty", "销售数量"},
                            {"ConvertFactor", "单位数量"},
                            {"Annexsource","附件来源"},
                            {"Remark", "备注"},
                            {"AttachmentList", "附件信息"}
                        };

                    CommonFunction.SetColumnIndexAndRemoveColumn(dtData, dict);

                    #endregion 调整列的顺序,并重命名列名

                    ds.Tables.Add(dtData);
                }
                ExportFile(ds, DownloadCookie);
            }
            else if (Parameters["ShipmentListExportType"].ToSafeString() == "ExportShipment")
            {
                string strPreAttachmentUrl =
                    System.Configuration.ConfigurationManager.AppSettings["ShimentAttachmentURL"] ?? string.Empty;
                ShipmentHeaderDao dao = new ShipmentHeaderDao();
                param.Add("AttachmentUrl", strPreAttachmentUrl);
                param.Add("OwnerIdentityType", RoleModelContext.Current.User.IdentityType);
                param.Add("OwnerOrganizationUnits", RoleModelContext.Current.User.GetOrganizationUnits());
                param.Add("OwnerId", new Guid(RoleModelContext.Current.User.Id));
                param.Add("OwnerCorpId", RoleModelContext.Current.User.CorpId);
                DataSet ds = dao.ExportShipmentAttachment(param);
                ExportFile(ds, DownloadCookie);
            }
            else if (Parameters["ShipmentListExportType"].ToString() == "ExportErrorData")
            {
                if (!String.IsNullOrEmpty(Parameters["WinSLOrderId"]))
                {
                    Guid tid = Parameters["WinSLOrderId"].ToSafeGuid();
                    IShipmentBLL business = new ShipmentBLL();
                    Hashtable ht = new Hashtable();
                    ht.Add("SphId", tid);
                    DataSet ds = business.GetHospitalShipmentbscBeforeSubmitInitForExport(ht);
                    ExportFile(ds, DownloadCookie);
                }
            }

        }

        public ShipmentListVO ImportInvoiceNo(ShipmentListVO model)
        {
            try
            {
                string RtnVal = string.Empty;
                string RtnMsg = string.Empty;
                IShipmentBLL business = new ShipmentBLL();

                business.InvoiceVerify(1, out RtnVal, out RtnMsg);
                if (RtnVal == "Success")
                {
                    business.DeleteShipmentInvoiceInitByUser();
                    model.ExecuteMessage.Add("导入成功！");
                }
                else if (RtnVal == "Error")
                {
                    model.ExecuteMessage.Add("有错误信息，请修改后重新上传！");
                }
                else
                {
                    model.ExecuteMessage.Add(RtnMsg);
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

        public ShipmentListVO ChangeDealer(ShipmentListVO model)
        {
            Guid DealerId = Guid.Empty;
            IShipmentBLL business = new ShipmentBLL();

            if (!business.IsAdminRole())
            {
                if (!string.IsNullOrEmpty(model.WinSLDealer.Key))
                {
                    DealerId = model.WinSLDealer.Key.ToSafeGuid();
                }
            }
            else
            {
                if (!string.IsNullOrEmpty(model.WinSLDealer.Key))
                {
                    DealerId = model.WinSLDealer.Key.ToSafeGuid();
                }
                else
                {
                    DealerId = new Guid("FB62D945-C9D7-4B0F-8D26-4672D2C728B7");
                }
            }
            DealerMasters dm = new DealerMasters();
            DataSet ds = dm.GetNoLimitProductLineByDealer(DealerId);
            model.LstWinSLProductLine = JsonHelper.DataTableToArrayList(ds.Tables[0]);

            Hashtable param = new Hashtable();

            param.Add("DealerId", string.IsNullOrEmpty(model.WinSLDealer.Key) ? model.WinSLDealer.Key.ToSafeString() : "FB62D945-C9D7-4B0F-8D26-4672D2C728B7");

            if (!string.IsNullOrEmpty(model.WinSLProductLine.Key))
            {
                param.Add("ProductLine", model.WinSLProductLine.Key);
            }
            if (string.IsNullOrEmpty(model.WinSLShipmentDate.ToString()))
            {
                model.LstWinSLHospital = null;
            }
            else
            {
                param.Add("ShipmentDate", model.WinSLShipmentDate);
                DataSet dsHos = dm.SelectHospitalForDealerByShipmentDate(param);
                DataView dvHos = dsHos.Tables[0].DefaultView;
                DataTable dtHos = dvHos.ToTable(true, "Id", "Name");
                model.LstWinSLHospital = JsonHelper.DataTableToArrayList(dtHos);
            }

            return model;
        }

        public ShipmentListVO ChangeProductLine(ShipmentListVO model)
        {
            IShipmentBLL business = new ShipmentBLL();
            try
            {
                business.DeleteDetail(model.WinSLOrderId.ToSafeGuid());

                //删除销售调整中数据
                this.DeleteAllAdjust(model.WinSLOrderId.ToSafeGuid());

                if (!business.IsAdminRole() && !model.WinIsShipmentUpdate.Equals("UpdateShipment"))
                {
                    model = GetShipmentDate(model);
                }
                //this.Bind_Hospital(this.HospitalWinStore, this.hiddenProductLineId.Text,DateTime.MinValue);
                //产品线变更，清空医院信息
                model.LstWinSLHospital = null;
                //Edited By Song Yuqi On 20140319 End
                //如果为ENDO红海判断是否在6个工作日之内 lijie add
                if (!business.IsAdminRole() && !model.WinIsShipmentUpdate.Equals("UpdateShipment"))
                {
                    if (business.GetCalendarDateSix() > 0)
                    {
                        //如果经销是红海，且产品线为Endo在6个工作日之内
                        DateTime dttim = DateTime.Now;

                        //model.WinSLShipDate_Min = dttim.AddDays(1 - dttim.Day).AddMonths(-1).Date;
                        //model.WinSLShipDate_Max = dttim.AddDays(1 - dttim.Day).AddDays(-1).Date;

                    }
                }
                if (!String.IsNullOrEmpty(model.WinSLOrderId) && !String.IsNullOrEmpty(model.WinSLShipmentDate.ToString()))
                {
                    Guid tid = model.WinSLOrderId.ToSafeGuid();

                    Hashtable param = new Hashtable();
                    ShipmentLotDao daoLot = new ShipmentLotDao();

                    param.Add("HeaderId", tid);
                    param.Add("ShipmentDate", model.WinSLShipmentDate.ToSafeDateTime().ToString("yyyy-MM-dd"));

                    DataSet ds = daoLot.SelectByFilter(param);
                    DataSet dsSum = daoLot.SelectSumByFilter(param);

                    model.WinProductQty = "销售总数量:" + dsSum.Tables[0].Rows[0]["TotalQty"].ToString();
                    model.WinProductSum = "销售总金额:" + dsSum.Tables[0].Rows[0]["TotalPrice"].ToString();
                    model.RstWinSLProductList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

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

        public ShipmentListVO ChangeShipDate(ShipmentListVO model)
        {
            //重新绑定医院下拉列表
            Hashtable param = new Hashtable();

            param.Add("DealerId", model.WinSLDealer.Key);
            //param.Add("DealerId", cbDealerWin.SelectedItem.Value);
            param.Add("ProductLine", model.WinSLProductLine.Key);
            param.Add("ShipmentDate", model.WinSLShipmentDate.Value);

            DealerMasters dm = new DealerMasters();
            DataSet ds = dm.SelectHospitalForDealerByShipmentDate(param);
            DataView dv = ds.Tables[0].DefaultView;
            DataTable dt = dv.ToTable(true, "Id", "Name");
            model.LstWinSLHospital = JsonHelper.DataTableToArrayList(dt);

            model.HidShipDate = model.WinSLShipmentDate.Value.ToString("yyyy-MM-dd");
            return model;
        }

        public ShipmentListVO ChangeHospital(ShipmentListVO model)
        {
            IShipmentBLL business = new ShipmentBLL();
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("ShipmentId", model.WinSLOrderId);
                obj.Add("ShipmentType", model.WinShipmentType);
                obj.Add("DealerId", model.WinSLDealer.Key);
                obj.Add("ProductLineId", model.WinSLProductLine.Key);
                obj.Add("HospitalId", model.WinSLHospital.Key);
                obj.Add("ShipmentDate", model.HidShipDate);
                string massage = business.DeleteShipmentNotAuthCfn(obj);
                if (!String.IsNullOrEmpty(model.WinSLOrderId) && !String.IsNullOrEmpty(model.WinSLShipmentDate.ToString()))
                {
                    Guid tid = model.WinSLOrderId.ToSafeGuid();

                    Hashtable param = new Hashtable();
                    ShipmentLotDao daoLot = new ShipmentLotDao();

                    param.Add("HeaderId", tid);
                    param.Add("ShipmentDate", model.WinSLShipmentDate.ToSafeDateTime().ToString("yyyy-MM-dd"));

                    DataSet ds = daoLot.SelectByFilter(param);
                    DataSet dsSum = daoLot.SelectSumByFilter(param);

                    model.WinProductQty = "销售总数量:" + dsSum.Tables[0].Rows[0]["TotalQty"].ToString();
                    model.WinProductSum = "销售总金额:" + dsSum.Tables[0].Rows[0]["TotalPrice"].ToString();
                    model.RstWinSLProductList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

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

        public ShipmentListVO AddItemsToDetail(ShipmentListVO model)
        {
            try
            {

                string param = model.ParaChooseItem.ToSafeString();

                param = param.Substring(0, param.Length - 1);

                IShipmentBLL business = new ShipmentBLL();
                //Edited By Song Yuqi On 20140317 Begin
                bool result = false;
                result = business.AddItems(model.WinSLOrderId.ToSafeGuid(), model.WinSLDealer.Key.ToSafeGuid(), model.WinSLHospital.Key.ToSafeGuid(), param.Split(','));

                //Edited By Song Yuqi On 20140317 End

                if (result)
                {
                    if (!String.IsNullOrEmpty(model.WinSLOrderId) && !String.IsNullOrEmpty(model.WinSLShipmentDate.ToString()))
                    {
                        Guid tid = model.WinSLOrderId.ToSafeGuid();

                        Hashtable para = new Hashtable();
                        ShipmentLotDao daoLot = new ShipmentLotDao();

                        para.Add("HeaderId", tid);
                        para.Add("ShipmentDate", model.WinSLShipmentDate.ToSafeDateTime().ToString("yyyy-MM-dd"));

                        DataSet ds = daoLot.SelectByFilter(para);
                        DataSet dsSum = daoLot.SelectSumByFilter(para);

                        model.WinProductQty = "销售总数量:" + dsSum.Tables[0].Rows[0]["TotalQty"].ToString();
                        model.WinProductSum = "销售总金额:" + dsSum.Tables[0].Rows[0]["TotalPrice"].ToString();
                        model.RstWinSLProductList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                    }
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("保存失败！");
                    return model;
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

        public ShipmentListVO AddAdjustItems(ShipmentListVO model)
        {
            try
            {
                string rtnVal = "";
                string rtnMsg = "";
                IShipmentBLL business = new ShipmentBLL();

                //插入选中的数据
                if (model.ParaHistoryItem != null)
                {
                    string param = model.ParaHistoryItem.ToSafeString();
                    param = param.Substring(0, param.Length - 1);

                    business.AddShipmentItems(model.WinSLOrderId.ToSafeGuid(), model.WinSLDealer.Key.ToSafeGuid(), model.WinSLHospital.Key.ToSafeGuid(), param, "Shipment", out rtnVal, out rtnMsg);
                    model.RstSAHistoryOrderData = null;

                }
                if (model.ParaInventoryItem != null)
                {
                    string param = model.ParaInventoryItem.ToSafeString();
                    param = param.Substring(0, param.Length - 1);

                    business.AddShipmentItems(model.WinSLOrderId.ToSafeGuid(), model.WinSLDealer.Key.ToSafeGuid(), model.WinSLHospital.Key.ToSafeGuid(), param, "Inventory", out rtnVal, out rtnMsg);
                    model.RstSAInventoryData = null;

                }
                if (!String.IsNullOrEmpty(model.WinSLOrderId) && !String.IsNullOrEmpty(model.WinSLShipmentDate.ToString()))
                {
                    Guid headId = model.WinSLOrderId.ToSafeGuid();

                    DataSet dsHis = business.QueryShipmentAdjustLotForShipmentBySphId(headId);

                    model.RstSAHistoryOrderData = JsonHelper.DataTableToArrayList(dsHis.Tables[0]);

                    DataSet dsInv = business.QueryShipmentAdjustLotForInventoryBySphId(headId);

                    model.RstSAInventoryData = JsonHelper.DataTableToArrayList(dsInv.Tables[0]);
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

        public ShipmentListVO AddShipmentAdjustToShipmentLot(ShipmentListVO model)
        {
            try
            {
                string rtnVal = "";
                string rtnMsg = "";
                IShipmentBLL business = new ShipmentBLL();

                //保存价格
                //foreach (Newtonsoft.Json.Linq.JObject dtHistory in model.RstSAHistoryOrderData)
                //{
                for (int i = 0; i < model.RstSAHistoryOrderData.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject dtHistory = Newtonsoft.Json.Linq.JObject.Parse(model.RstSAHistoryOrderData[i].ToString());
                    string shipmentPrice = dtHistory["ShipmentPrice"].ToString().Replace("\"", "").Replace("null", "");
                    ShipmentAdjustLot obj = business.GetShipmentAdjustLotById(dtHistory["Id"].ToString().Replace("\"", "").ToSafeGuid());

                    if (obj != null)
                    {
                        obj.ShipmentPrice = string.IsNullOrEmpty(shipmentPrice) ? obj.ShipmentPrice : decimal.Parse(shipmentPrice);

                        business.SaveShipmentAdjust(obj);

                    }
                }
                //foreach (Newtonsoft.Json.Linq.JObject dtInventory in model.RstSAInventoryData)
                //{
                for (int i = 0; i < model.RstSAInventoryData.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject dtInventory = Newtonsoft.Json.Linq.JObject.Parse(model.RstSAInventoryData[i].ToString());
                    string shipmentPrice = dtInventory["ShipmentPrice"].ToString().Replace("\"", "").Replace("null", "");
                    string shipmentQty = dtInventory["ShipmentQty"].ToString().Replace("\"", "").Replace("null", "");
                    ShipmentAdjustLot obj = business.GetShipmentAdjustLotById(dtInventory["Id"].ToString().Replace("\"", "").ToSafeGuid());

                    if (obj != null)
                    {
                        obj.ShipmentQty = string.IsNullOrEmpty(shipmentQty) ? obj.ShipmentQty : decimal.Parse(shipmentQty);
                        obj.ShipmentPrice = string.IsNullOrEmpty(shipmentPrice) ? obj.ShipmentPrice : decimal.Parse(shipmentPrice);

                        business.SaveShipmentAdjust(obj);

                    }
                }

                model.RstSAHistoryOrderData = null;
                model.RstSAInventoryData = null;

                if (string.IsNullOrEmpty(model.WinSAAdjustReason.Key))
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("请选择调整原因！");
                    return model;
                }

                string ShipmentDate = null;
                if (!RoleModelContext.Current.IsInRole("Administrators"))
                {
                    ShipmentDate = model.WinSLShipmentDate.HasValue ? model.WinSLShipmentDate.Value.ToString("yyyy-MM-dd") : null;
                }
                else
                {
                    ShipmentDate = model.WinSAShipDate.HasValue ? model.WinSAShipDate.Value.ToString("yyyy-MM-dd") : null;
                }
                string Reason = model.WinSAAdjustReason.Key;
                Guid headId = model.WinSLOrderId.ToSafeGuid();
                Guid dealerId = model.WinSLDealer.Key.ToSafeGuid();
                Guid hosId = model.WinSLHospital.Key.ToSafeGuid();
                string OpsUser = "";
                if (model.WinIsShipmentUpdate.Equals("UpdateShipment")
                    && !business.IsAdminRole())
                {
                    OpsUser = "Dealer";
                }
                business.AddShipmentAdjustToShipmentLot(headId, dealerId, hosId, ShipmentDate, Reason, OpsUser, out rtnVal, out rtnMsg);

                if (rtnVal == "Success")
                {
                    model.WinSLOrderRemark = Reason;
                    if (!String.IsNullOrEmpty(model.WinSLOrderId) && !String.IsNullOrEmpty(model.WinSLShipmentDate.ToString()))
                    {
                        Guid tid = model.WinSLOrderId.ToSafeGuid();

                        Hashtable param = new Hashtable();
                        ShipmentLotDao daoLot = new ShipmentLotDao();

                        param.Add("HeaderId", tid);
                        param.Add("ShipmentDate", model.WinSLShipmentDate.ToSafeDateTime().ToString("yyyy-MM-dd"));

                        DataSet ds = daoLot.SelectByFilter(param);
                        DataSet dsSum = daoLot.SelectSumByFilter(param);

                        model.WinProductQty = "销售总数量:" + dsSum.Tables[0].Rows[0]["TotalQty"].ToString();
                        model.WinProductSum = "销售总金额:" + dsSum.Tables[0].Rows[0]["TotalPrice"].ToString();
                        model.RstWinSLProductList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                    }
                }
                else if (rtnVal == "Error")
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(rtnMsg.Replace("$$", "<BR/>"));
                    return model;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(rtnMsg);
                    return model;
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            model.RstSAHistoryOrderData = null;
            model.RstSAInventoryData = null;
            return model;
        }

        public ShipmentListVO DeleteItem(ShipmentListVO model)
        {
            try
            {
                bool result = false;
                IShipmentBLL business = new ShipmentBLL();
                result = business.DeleteItem(model.DelProductId.ToSafeGuid());

                if (result)
                {
                    if (!String.IsNullOrEmpty(model.WinSLOrderId.ToSafeString()) && !String.IsNullOrEmpty(model.WinSLShipmentDate.ToString()))
                    {
                        Guid tid = new Guid(model.WinSLOrderId.ToSafeString());

                        Hashtable param = new Hashtable();
                        ShipmentLotDao daoLot = new ShipmentLotDao();

                        param.Add("HeaderId", tid);
                        param.Add("ShipmentDate", model.WinSLShipmentDate.ToSafeDateTime().ToString("yyyy-MM-dd"));

                        DataSet ds = daoLot.SelectByFilter(param);
                        DataSet dsSum = daoLot.SelectSumByFilter(param);

                        model.WinProductQty = "销售总数量:" + dsSum.Tables[0].Rows[0]["TotalQty"].ToString();
                        model.WinProductSum = "销售总金额:" + dsSum.Tables[0].Rows[0]["TotalPrice"].ToString();
                        model.RstWinSLProductList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                    }
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("删除失败！");
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

        public ShipmentListVO DeleteAttach(ShipmentListVO model)
        {
            try
            {
                using (AttachmentDao dao = new AttachmentDao())
                {
                    dao.Delete(model.DelAttachId.ToSafeGuid());
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

        public ShipmentListVO DeleteAdjustItem(ShipmentListVO model)
        {
            try
            {
                IShipmentBLL business = new ShipmentBLL();
                business.DeleteAdjustItem(model.DelAdjustId.ToSafeGuid(), model.WinSLOrderId.ToSafeGuid(), model.DelAdjustLotId.ToSafeGuid());
                if (!String.IsNullOrEmpty(model.WinSLOrderId) && !String.IsNullOrEmpty(model.WinSLShipmentDate.ToString()))
                {
                    Guid headId = model.WinSLOrderId.ToSafeGuid();

                    DataSet dsHis = business.QueryShipmentAdjustLotForShipmentBySphId(headId);

                    model.RstSAHistoryOrderData = JsonHelper.DataTableToArrayList(dsHis.Tables[0]);

                    DataSet dsInv = business.QueryShipmentAdjustLotForInventoryBySphId(headId);

                    model.RstSAInventoryData = JsonHelper.DataTableToArrayList(dsInv.Tables[0]);
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

        protected void ExportFile(DataSet ds, string Cookie)
        {
            DataSet[] result = new DataSet[1];
            result[0] = ds;

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("ExportFile");
            xlsExport.Export(ht, result, Cookie);
        }

        public ShipmentListVO DoConfirm(ShipmentListVO model)
        {
            try
            {
                foreach (KeyValue kv in GetProductLine())
                {
                    UploadLog log = new UploadLog();
                    log.Id = Guid.NewGuid();
                    log.Type = "销售";
                    log.ProductLineID = kv.Key.ToSafeGuid();
                    log.CreateUser = new Guid(RoleModelContext.Current.User.Id);
                    log.UploadDate = DateTime.Now;
                    log.DmaId = RoleModelContext.Current.User.CorpId.Value;

                    using (UploadLogDao dao = new UploadLogDao())
                    {
                        dao.Insert(log);
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

        public ShipmentListVO SaveDraft(ShipmentListVO model)
        {
            try
            {
                //调用方法更新明细数据
                string rtnUpdate = saveShipmentLot(model.RstWinSLProductList);
                model.RstWinSLProductList = null;
                if (!string.IsNullOrEmpty(rtnUpdate))
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(rtnUpdate);
                    return model;
                }
                else
                {
                    IShipmentBLL business = new ShipmentBLL();
                    //更新字段
                    ShipmentHeader mainData = business.GetShipmentHeaderById(model.WinSLOrderId.ToSafeGuid());

                    if ((business.IsAdminRole() || model.WinIsShipmentUpdate.ToSafeString().Equals("UpdateShipment")) && !string.IsNullOrEmpty(model.WinSLDealer.Key))
                    {
                        mainData.DealerDmaId = model.WinSLDealer.Key.ToSafeGuid();
                    }

                    if (!string.IsNullOrEmpty(model.WinSLProductLine.Key))
                    {
                        mainData.ProductLineBumId = model.WinSLProductLine.Key.ToSafeGuid();
                    }
                    if (!string.IsNullOrEmpty(model.WinSLHospital.Key))
                    {
                        mainData.HospitalHosId = model.WinSLHospital.Key.ToSafeGuid();
                    }
                    if (!string.IsNullOrEmpty(model.WinSLOrderRemark.ToSafeString()))
                    {
                        mainData.NoteForPumpSerialNbr = model.WinSLOrderRemark.ToSafeString();
                    }

                    //added by bozhenfei on 20100608 销售时间
                    if (model.WinSLShipmentDate == null || model.WinSLShipmentDate == DateTime.MinValue)
                    {
                        mainData.ShipmentDate = null;
                    }
                    else
                    {
                        mainData.ShipmentDate = model.WinSLShipmentDate;
                    }

                    if (model.WinSLInvoiceDate == null || model.WinSLInvoiceDate == DateTime.MinValue)
                    {
                        mainData.InvoiceDate = null;
                    }
                    else
                    {
                        mainData.InvoiceDate = model.WinSLInvoiceDate;
                    }

                    //added by songweiming on 20100617 发票号码
                    if (!string.IsNullOrEmpty(model.WinSLInvoiceNo))
                    {
                        mainData.InvoiceNo = model.WinSLInvoiceNo.ToSafeString();
                    }

                    if (!string.IsNullOrEmpty(model.WinSLInvoiceHead))
                    {
                        mainData.InvoiceTitle = model.WinSLInvoiceHead.ToSafeString();
                    }

                    bool result = false;

                    mainData.ShipmentUser = new Guid(RoleModelContext.Current.User.Id);
                    result = business.SaveDraft(mainData);

                    if (result)
                    {
                        model.IsSuccess = true;
                        model.ExecuteMessage.Add("保存草稿成功！");
                    }
                    else
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("保存草稿失败！");
                    }
                }
                model.RstWinSLProductList = null;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ShipmentListVO DeleteDraft(ShipmentListVO model)
        {
            try
            {
                Guid id = model.WinSLOrderId.ToSafeGuid();
                using (TransactionScope trans = new TransactionScope())
                {
                    ShipmentHeaderDao mainDao = new ShipmentHeaderDao();
                    ShipmentLineDao lineDao = new ShipmentLineDao();
                    ShipmentLotDao lotDao = new ShipmentLotDao();
                    ShipmentOperationDao operDao = new ShipmentOperationDao();
                    //判断表头中状态是否是草稿
                    ShipmentHeader main = mainDao.GetObject(id);
                    if (main.Status == ShipmentOrderStatus.Draft.ToString())
                    {
                        //删除lot表
                        lotDao.DeleteByHeaderId(id);
                        //删除line表
                        lineDao.DeleteByHeaderId(id);
                        //删除operation表
                        operDao.DeleteByHeaderId(id);
                        //删除主表
                        mainDao.Delete(id);

                        //二级经销商寄售订单删除ShipmentConsignment表
                        if (main.Type == ShipmentOrderType.Consignment.ToString())
                        {
                            ShipmentConsignmentDao consignmentDao = new ShipmentConsignmentDao();
                            consignmentDao.DeleteByHeaderId(id);
                        }
                    }
                    trans.Complete();
                }
                DeleteAllAdjust(id);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        //冲红
        public ShipmentListVO DoRevoke(ShipmentListVO model)
        {
            try
            {
                model.WinDisableRevokeBtn = true;
                bool result = false;
                string orderStatus = string.Empty;

                Guid id = model.WinSLOrderId.ToSafeGuid();
                IShipmentBLL business = new ShipmentBLL();
                ShipmentHeader mainData = business.GetShipmentHeaderById(id);

                if (mainData.Type != "Hospital" && !string.IsNullOrEmpty(mainData.Type))
                {
                    if (RoleModelContext.Current.User.CorpType == DealerType.T1.ToString() ||
                           RoleModelContext.Current.User.CorpType == DealerType.LP.ToString() ||
                           RoleModelContext.Current.User.CorpType == DealerType.LS.ToString())
                    {
                        orderStatus = "ToApprove";
                    }
                }

                result = business.Revoke(model.WinSLOrderId.ToSafeGuid(), orderStatus);

                if (result)
                {
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("撤销成功！");
                }
                else
                {
                    model.ExecuteMessage.Add("撤销失败！");
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

        public ShipmentListVO DoSubmit(ShipmentListVO model)
        {
            try
            {
                IShipmentBLL business = new ShipmentBLL();
                //如果是草稿，则提交操作需要先将错误的数据删除
                if (model.WinSLOrderStatus == "草稿")
                {
                    Hashtable obj = new Hashtable();
                    obj.Add("ShipmentId", model.WinSLOrderId);
                    int delRowCnt = business.DeleteErrorShipmentLot(obj);
                }

                Boolean dateCheck = true;
                bool ShiplotChecked = true;
                string Messing = string.Empty;
                DataSet ds = business.SelectShipmentLotByChecked(model.WinSLOrderId);
                DataSet lotDs = business.SelectShipmentdistictLotid(model.WinSLOrderId);
                if (model.WinSLOrderStatus == "草稿")
                {
                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        //非管理员（经销商）提交的销售需要校验NoQR数据
                        if (!business.IsAdminRole() && row["QrCode"].ToString() == "NoQR")
                        {
                            //20191220
                            //if (string.IsNullOrEmpty(row["EditQrCode"].ToString()) && row["Wtype"].ToString() != "Normal" && row["Wtype"].ToString() != "Frozen" && (row["Wcode"].ToString().ToUpper().IndexOf("NOQR") < 0))
                            //{
                            //    ShiplotChecked = false;
                            //    Messing = Messing + "批次号" + row["LotNumber"].ToString() + "的二维码填写错误<BR/>";
                            //}
                            if (row["EditQrCode"] != null && row["EditQrCode"].ToString() != ""
                                   && row["ShipmentQty"] != null && decimal.Parse(row["ShipmentQty"].ToString()) > 1)
                            {
                                if (row["EditQrCode"].ToString().ToUpper() != "NOQR")
                                {
                                    ShiplotChecked = false;
                                    Messing = Messing + "批次号" + row["LotNumber"].ToString() + "的二维码产品数量不得大于一<BR/>";
                                }
                            }
                            else if (ValidateQrUnique(ds.Tables[0], row, "EditQrCode"))
                            {
                                ShiplotChecked = false;
                                Messing = Messing + "批次号" + row["LotNumber"].ToString() + "的二维码" + row["EditQrCode"].ToString() + "出现多次<BR/>";
                            }
                            else if (ValidateQrUnique(ds.Tables[0], row, "QRCode"))
                            {
                                ShiplotChecked = false;
                                Messing = Messing + "批次号" + row["LotNumber"].ToString() + "的二维码" + row["EditQrCode"].ToString() + "已被使用<BR/>";
                            }
                        }
                    }
                    foreach (DataRow row in lotDs.Tables[0].Rows)
                    {
                        DataSet qtyDs = business.SelectShipmentLotQty(row["SLT_LOT_ID"].ToString(), model.WinSLOrderId);
                        if (float.Parse((qtyDs.Tables[0].Rows[0]["TotalQty"].ToString())) < float.Parse((qtyDs.Tables[0].Rows[0]["ShipmentQty"].ToString())))
                        {
                            ShiplotChecked = false;
                            Messing = Messing + "批次号" + qtyDs.Tables[0].Rows[0]["LotNumber"].ToString() + "的库存量小于销售数量<BR/>";
                        }
                    }

                }



                if (ShiplotChecked)
                {
                    ShipmentHeader mainData = business.GetShipmentHeaderById(model.WinSLOrderId.ToSafeGuid());

                    //首先判断当前单据的状态，如果是完成状态，则只保存发票号码，草稿状态则保存整张单据
                    if (mainData.Status == ShipmentOrderStatus.Complete.ToString())
                    {

                        mainData.InvoiceNo = model.WinSLInvoiceNo;
                        if (!string.IsNullOrEmpty(model.WinSLInvoiceDate.ToString()))
                        {
                            mainData.InvoiceDate = model.WinSLInvoiceDate;
                        }
                        else
                        {
                            mainData.InvoiceDate = null;
                        }
                        mainData.InvoiceTitle = model.WinSLInvoiceHead;
                        mainData.UpdateDate = DateTime.Now;// added by songweiming on 20100628
                        if (!string.IsNullOrEmpty(mainData.InvoiceNo) && mainData.InvoiceFirstDate == null)
                        {
                            mainData.InvoiceFirstDate = DateTime.Now;
                        }
                        business.UpdateMainDataInvoiceNo(mainData);
                        model.ExecuteMessage.Add("更新发票信息成功！");

                    }
                    else
                    {

                        //更新字段
                        if ((business.IsAdminRole() || model.WinIsShipmentUpdate.Equals("UpdateShipment")) && !string.IsNullOrEmpty(model.WinSLDealer.Key))
                        {
                            mainData.DealerDmaId = model.WinSLDealer.Key.ToSafeGuid();
                        }
                        if (!string.IsNullOrEmpty(model.WinSLProductLine.Key))
                        {
                            mainData.ProductLineBumId = model.WinSLProductLine.Key.ToSafeGuid();

                        }
                        if (!string.IsNullOrEmpty(model.WinSLHospital.Key))
                        {
                            mainData.HospitalHosId = model.WinSLHospital.Key.ToSafeGuid();
                        }
                        if (!string.IsNullOrEmpty(model.WinSLOrderRemark))
                        {
                            mainData.NoteForPumpSerialNbr = model.WinSLOrderRemark;
                        }
                        //added by songyuqi on 20100707 发票号码
                        if (!string.IsNullOrEmpty(model.WinSLInvoiceNo))
                        {
                            mainData.InvoiceNo = model.WinSLInvoiceNo;
                        }

                        //added by hxw
                        if (!string.IsNullOrEmpty(model.WinSLInvoiceHead))
                        {
                            mainData.InvoiceTitle = model.WinSLInvoiceHead;
                        }

                        if (!string.IsNullOrEmpty(model.WinSLInvoiceDate.ToString()))
                        {
                            mainData.InvoiceDate = model.WinSLInvoiceDate;
                        }
                        mainData.IsAuth = model.WinIsAuth == "0" ? false : true;

                        //added by bozhenfei on 20100608 销售时间
                        if (!string.IsNullOrEmpty(model.WinSLShipmentDate.ToString()))
                        {
                            mainData.ShipmentDate = model.WinSLShipmentDate;
                            dateCheck = new ShipmentUtil().GetDateConstraints("ShipmentDate", mainData.ShipmentDate.Value, mainData.ProductLineBumId.Value);

                            string result = "";
                            model.WinSLShipDate_Min = DateTime.Now.AddDays(1);

                            if (dateCheck || business.IsAdminRole() || model.WinIsShipmentUpdate.Equals("UpdateShipment"))
                            {

                                mainData.ShipmentUser = RoleModelContext.Current.User.Id.ToSafeGuid();
                                result = business.Submit(mainData, model.WinIsShipmentUpdate.ToSafeString());
                                //二级经销商寄售提交自动生成补货单
                                string RtnVal = string.Empty;
                                string RtnMsg = string.Empty;
                                string ShipmentType = string.Empty;
                                business.ConsignmentForOrder(mainData, ShipmentType, out RtnVal, out RtnMsg);

                                if (result == "Success")
                                {
                                    model.ExecuteMessage.Add("提交成功！");
                                }
                                else
                                {
                                    model.IsSuccess = false;
                                    model.ExecuteMessage.Add(result);
                                }
                            }
                            else
                            {
                                model.IsSuccess = false;
                                model.ExecuteMessage.Add("填写的销售日期不在限定的时间范围内！");
                            }
                        }
                        else
                        {
                            model.IsSuccess = false;
                            model.ExecuteMessage.Add("请填写销售日期！");
                        }

                    }
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(Messing);
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

        public ShipmentListVO CheckSubmit(ShipmentListVO model)
        {
            try
            {
                IShipmentBLL business = new ShipmentBLL();
                string strBasicChkRtn = "";
                int qtyCheck = 0;
                List<string> qrcode = new List<string>();
                List<string> qredit = new List<string>();

                //foreach (Newtonsoft.Json.Linq.JObject record in model.RstWinSLProductList)
                for (int i = 0; i < model.RstWinSLProductList.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject record = Newtonsoft.Json.Linq.JObject.Parse(model.RstWinSLProductList[i].ToString());
                    //寄售销售单的采购单价是必填的
                    if (business.IsAdminRole() && model.WinSLOrderType == "寄售产品销售单" && (record["AdjAction"] == null || record["AdjAction"].ToString().Replace("\"", "") == ""))
                    {
                        strBasicChkRtn += "批号：" + record["LotNumber"].ToString().Replace("\"", "") + " 请填写产品采购单价！<br>";
                    }
                    //if (!business.IsAdminRole() && record["WhType"].ToString().Replace("\"", "") != "Normal" && record["WhType"].ToString().Replace("\"", "") != "Frozen" && record["QRCode"].ToString().Replace("\"", "") == "NoQR" && (record["QRCodeEdit"].ToString().Replace("\"", "") == "" || record["QRCodeEdit"] == null) && !record["WhCode"].ToString().Replace("\"", "").ToUpper().Contains("NOQR"))
                    //{
                    //    strBasicChkRtn += "批号："+ record["LotNumber"].ToString().Replace("\"", "") + " 必须填写二维码！<br>";
                    //}
                    if (record["QRCodeEdit"].ToString().Replace("\"", "") != "" && qredit.Contains(record["QRCodeEdit"].ToString().Replace("\"", "")) && record["QRCodeEdit"].ToString().Replace("\"", "") != "NoQR")
                    {
                        strBasicChkRtn += "二维码" + record["QRCodeEdit"].ToString().Replace("\"", "") + "出现多次";
                    }
                    else
                    {
                        qredit.Add(record["QRCodeEdit"].ToString().Replace("\"", ""));
                    }
                    if (record["QRCode"].ToString().Replace("\"", "") != "" && qrcode.Contains(record["QRCode"].ToString().Replace("\"", "")) && record["QRCode"].ToString().Replace("\"", "") != "NoQR")
                    {
                        strBasicChkRtn += "二维码" + record["QRCode"] + "已使用";
                    }
                    else
                    {
                        if (record["QRCode"].ToString().Replace("\"", "") != "NoQR")
                        {
                            qrcode.Add(record["QRCode"].ToString().Replace("\"", ""));
                        }
                    }
                    qtyCheck += record["ShipmentQty"].ToString().Replace("\"", "").ToSafeInt();
                }
                if (!business.IsAdminRole() && model.WinIsShipmentUpdate == "UpdateShipment" && qtyCheck != 0)
                {
                    strBasicChkRtn += "调整数量设置不准确";
                }
                if (strBasicChkRtn != "")
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(strBasicChkRtn);
                    model.RstWinSLProductList = null;
                    return model;
                }
                string rtnUpdate = saveShipmentLot(model.RstWinSLProductList);
                model.RstWinSLProductList = null;
                if (!string.IsNullOrEmpty(rtnUpdate))
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(rtnUpdate);
                    model.RstWinSLProductList = null;
                    return model;
                }

                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;

                Guid sphId = model.WinSLOrderId.ToSafeGuid();

                string dealerId = string.Empty;

                if (model.WinSLDealer != null && !string.IsNullOrEmpty(model.WinSLDealer.Key))
                {
                    dealerId = model.WinSLDealer.Key;
                }
                else
                {
                    dealerId = "FB62D945-C9D7-4B0F-8D26-4672D2C728B7";
                }

                bool result = business.CheckSubmit(sphId
                                                , model.HidShipDate
                                                , RoleModelContext.Current.User.Id.ToSafeGuid()
                                                , new Guid(dealerId)
                                                , model.WinSLProductLine.Key.ToSafeGuid()
                                                , model.WinSLHospital.Key.ToSafeGuid()
                                                , out rtnVal
                                                , out rtnMsg);

                if (rtnVal.Equals("Error"))
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(rtnMsg);
                }
                model.RstWinSLProductList = null;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            model.RstWinSLProductList = null;
            return model;
        }

        public ShipmentListVO ShowReason(ShipmentListVO model)
        {
            try
            {
                using (ShipmentLotDao dao = new ShipmentLotDao())
                {
                    DataSet ds = dao.SelectLimitNumber(RoleModelContext.Current.User.CorpId.Value);
                    model.RstWinSLReason = JsonHelper.DataTableToArrayList(ds.Tables[0]);
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

        public ShipmentListVO GetShipmentOperation(ShipmentListVO model)
        {
            try
            {
                //获取报台信息
                IShipmentBLL business = new ShipmentBLL();
                IList<ShipmentOperation> list = business.GetShipmentOperationByHeaderId(model.WinSLOrderId.ToSafeGuid());
                ShipmentOperation DMSO = null;
                if (list.Count > 0)
                {
                    DMSO = list[0];
                }
                else
                {
                    //新增记录
                    DMSO = new ShipmentOperation();
                    DMSO.Id = Guid.NewGuid();
                    DMSO.SphId = model.WinSLOrderId.ToSafeGuid();
                    business.InsertShipmentOperation(DMSO);
                }
                model.WinSPOId = DMSO.Id.ToString();
                model.WinSLOrderId = DMSO.SphId.ToString();
                model.WinSOOfficeName = DMSO.OfficeName;
                model.WinSODoctorName = DMSO.DoctorName;
                model.WinSOPatientName = DMSO.PatientName;
                model.WinSOPatientGender = DMSO.PatientGender == "男" ? true : false;
                model.WinSOPatientPIN = DMSO.Patientpin;
                model.WinSOHospitalNo = DMSO.HospitalNo;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ShipmentListVO SaveShipmentOperation(ShipmentListVO model)
        {
            try
            {
                //保存报台信息
                IShipmentBLL business = new ShipmentBLL();
                ShipmentOperation DMSO = new ShipmentOperation();
                DMSO.Id = model.WinSPOId.ToSafeGuid();
                DMSO.SphId = model.WinSLOrderId.ToSafeGuid();
                DMSO.OfficeName = model.WinSOOfficeName.ToSafeString();
                DMSO.DoctorName = model.WinSODoctorName.ToSafeString();
                DMSO.PatientName = model.WinSOPatientName.ToSafeString();
                DMSO.PatientGender = model.WinSOPatientGender ? "男" : "女";
                DMSO.Patientpin = model.WinSOPatientPIN.ToSafeString();
                DMSO.HospitalNo = model.WinSOHospitalNo.ToSafeString();
                business.UpdateShipmentOperation(DMSO);
                model.ExecuteMessage.Add("保存成功！");
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ShipmentListVO OrderPriceList(ShipmentListVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.WinSLOrderId) && !string.IsNullOrEmpty(model.HidShipDate))
                {
                    using (ShipmentLotDao dao = new ShipmentLotDao())
                    {
                        Hashtable param = new Hashtable();

                        param.Add("HeaderId", model.WinSLOrderId.ToSafeGuid());
                        param.Add("ShipmentDate", model.HidShipDate.ToSafeDateTime().ToString("yyyy-MM-dd"));
                        model.RstSLWinOrderPrice = JsonHelper.DataTableToArrayList(dao.SelectByFilter(param).Tables[0]);
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

        public ShipmentListVO SaveUpdatePrice(ShipmentListVO model)
        {
            try
            {
                IShipmentBLL business = new ShipmentBLL();
                //foreach (Newtonsoft.Json.Linq.JObject dtPrice in model.RstSLWinOrderPrice)
                //{
                for (int i = 0; i < model.RstSLWinOrderPrice.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject dtPrice = Newtonsoft.Json.Linq.JObject.Parse(model.RstSLWinOrderPrice[i].ToString());
                    string unitprice = dtPrice["UnitPrice"].ToString().Replace("\"", "");
                    bool result = false; ;
                    ShipmentLot lot = business.GetShipmentLotById(dtPrice["Id"].ToString().Replace("\"", "").ToSafeGuid());
                    if (!string.IsNullOrEmpty(unitprice))
                    {
                        lot.UnitPrice = Convert.ToDecimal(unitprice);
                    }

                    double price = string.IsNullOrEmpty(unitprice) ? 0 : Convert.ToDouble(unitprice);
                    result = business.SaveItem(lot, price);
                    if (!result)
                    {
                        model.IsSuccess = false;
                        model.RstSLWinOrderPrice = null;
                        model.ExecuteMessage.Add("保存产品批号 " + lot.QrLotNumber + " 出错！");
                        return model;
                    }
                    else
                    {
                        //记录修改log
                        business.SaveUpdateLog(lot);
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            model.RstSLWinOrderPrice = null;
            return model;
        }

        public ShipmentListVO CheckSubmitResult(ShipmentListVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.WinSLOrderId) && !string.IsNullOrEmpty(model.HidShipDate))
                {
                    IShipmentBLL business = new ShipmentBLL();
                    Hashtable param = new Hashtable();

                    param.Add("SphId", model.WinSLOrderId.ToSafeGuid());

                    model.RstSLWinCheckResult = JsonHelper.DataTableToArrayList(business.GetHospitalShipmentbscBeforeSubmitInitByCondition(param).Tables[0]);

                    //更新表头的记录
                    DataSet dsSum = business.GetHospitalShipmentSumBeforeSubmitInitByCondition(param);
                    model.WinWrongCnt = "错误记录数：" + dsSum.Tables[0].Rows[0]["ErrorCnt"].ToString() + "条";
                    model.WinCorrectCnt = "正确记录数:" + dsSum.Tables[0].Rows[0]["CorrectCnt"].ToString() + "条";
                    model.WinProductQty = "销售总数量:" + dsSum.Tables[0].Rows[0]["TotalQty"].ToString();
                    model.WinProductSum = "销售总金额:" + dsSum.Tables[0].Rows[0]["TotalPrice"].ToString();
                }
                else
                {
                    model.IsSuccess = false;
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

        private void DeleteAllAdjust(Guid sphId)
        {
            using (ShipmentAdjustLotDao dao = new ShipmentAdjustLotDao())
            {
                int i = dao.DeleteShipmentAdjustLotBySphId(sphId);
            }
        }

        private string saveShipmentLot(ArrayList jsonData)
        {
            string rtnMsg = "";
            bool result = false;

            //获取json格式的Store信息，然后将json转换成datatable
            //DataTable dtShiplot = JsonHelper.JsonToDataTable(jsonData);

            string qty = null;
            string unitprice = null;
            string sphdate = null;
            string remark = null;
            //string cahid = null;
            string qrCode = null;
            string editQrCode = null;
            string lotNbumber = null;
            string adjAction = null;

            ShipmentLot lot = new ShipmentLot();
            InventoryAdjustBLL iaBll = new InventoryAdjustBLL();
            IShipmentBLL business = new ShipmentBLL();

            //遍历datatable，获取数据并更新shipmentlot明细信息
            //for (int i = 0; i < dtShiplot.Rows.Count; i++)
            //foreach (Newtonsoft.Json.Linq.JObject dtShiplot in jsonData)
            //{
            for (int i = 0; i < jsonData.Count; i++)
            {
                Newtonsoft.Json.Linq.JObject dtShiplot = Newtonsoft.Json.Linq.JObject.Parse(jsonData[i].ToString());
                lot = business.GetShipmentLotById(dtShiplot["Id"].ToString().Replace("\"", "").ToSafeGuid());

                qty = dtShiplot["ShipmentQty"].ToString().Replace("\"", "");
                unitprice = dtShiplot["UnitPrice"].ToString().Replace("\"", "");
                sphdate = dtShiplot["ShipmentDate"].ToString().Replace("\"", "");
                remark = dtShiplot["Remark"].ToString().Replace("\"", "");
                //cahid = dtShiplot["字段名"].ToString().Replace("\"", "");
                qrCode = dtShiplot["QRCode"].ToString().Replace("\"", "");
                editQrCode = dtShiplot["QRCodeEdit"].ToString().Replace("\"", "");
                lotNbumber = dtShiplot["LotNumber"].ToString().Replace("\"", "");
                adjAction = dtShiplot["AdjAction"].ToString().Replace("\"", "");

                if (!string.IsNullOrEmpty(qty) && qty.ToUpper() != "NULL")
                {
                    lot.LotShippedQty = string.IsNullOrEmpty(qty) ? 0 : Convert.ToDouble(qty);
                }

                if (!string.IsNullOrEmpty(unitprice) && unitprice.ToUpper() != "NULL")
                {
                    lot.UnitPrice = Convert.ToDecimal(unitprice);
                }

                if (!string.IsNullOrEmpty(sphdate) && sphdate.ToUpper() != "NULL")
                {
                    lot.ShipmentDate = Convert.ToDateTime(Convert.ToDateTime(sphdate.Substring(0, 10)).ToString("yyyy-MM-dd"));
                }

                if (!string.IsNullOrEmpty(adjAction) && adjAction.ToUpper() != "NULL")
                {
                    lot.AdjAction = Convert.ToDecimal(adjAction).ToString("0.000000");
                }

                if (!string.IsNullOrEmpty(remark) && remark.ToUpper() != "NULL")
                {
                    lot.Remark = remark;
                }

                //if (IsGuid(cahid))
                //{
                //    lot.CahId = new Guid(cahid);
                //}

                if (qrCode == "NoQR" && !string.IsNullOrEmpty(editQrCode) && editQrCode.ToUpper() != "NULL")
                {

                    if (iaBll.QueryQrCodeIsExist(editQrCode))
                    {
                        lot.QrLotNumber = lotNbumber + "@@" + editQrCode;
                    }
                    else
                    {
                        rtnMsg = "二维码：" + editQrCode + "，在DMS系统中不存在";
                    }
                }

                //保存明细数据
                result = business.SaveItem(lot, 0.00);
                if (!result)
                {
                    if (string.IsNullOrEmpty(rtnMsg))
                    {
                        rtnMsg = "二维码：" + editQrCode + "记录保存出错";
                    }
                    else
                    {
                        rtnMsg = rtnMsg + "记录保存出错";
                    }
                }
            }

            return rtnMsg;
        }

        public bool ValidateQrUnique(DataTable dt, DataRow row, string type)
        {
            bool result = false;

            DataTable newdt = new DataTable();
            newdt = dt.Clone();
            DataRow[] dr;
            if (type == "EditQrCode")
            {
                dr = dt.Select("EditQrCode='" + row["EditQrCode"].ToString() + "'");
                if (row["EditQrCode"] != null && row["EditQrCode"].ToString() != "" && dr.Count() > 1)
                {
                    if (row["EditQrCode"].ToString() != "NoQR")
                    {
                        result = true;
                    }
                }
            }
            else if (type == "QRCode")
            {
                dr = dt.Select("QRCode='" + row["EditQrCode"].ToString() + "'");
                if (row["QRCode"].ToString().ToUpper() == "NOQR" && row["EditQrCode"] != null
                    && row["EditQrCode"].ToString() != "" && dr.Count() > 0)
                {
                    result = true;
                }
            }

            return result;
        }

        private ShipmentListVO GetShipmentDate(ShipmentListVO model)
        {
            ShipmentUtil util = new ShipmentUtil();
            CalendarDate cd = util.GetCalendarDate();

            DealerMasters dm = new DealerMasters();
            DataSet ds = dm.GetProductLineByDealer(RoleModelContext.Current.User.CorpId.Value);

            Nullable<DateTime> EffectiveDate = null;
            Nullable<DateTime> ExpirationDate = null;
            int ActiveFlag;
            int IsShare;
            DataTable dt = util.GetContractDate(RoleModelContext.Current.User.CorpId.Value, string.IsNullOrEmpty(model.WinSLProductLine.Key) ? ds.Tables[0].Rows[0]["Id"].ToString() : model.WinSLProductLine.Key.ToSafeString());
            if (cd != null)
            {
                int limitNo = Convert.ToInt32(cd.Date1);
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
                        //当天是在上个月的销量报告截止日期以内的，则用户可以上报从上个月的1日到当天的任意一天销量；否则，用户可以上报当月1日到当天的任意一天销量
                        if (currentMonth)
                        {
                            if (day >= limitNo)
                            {
                                model.WinSLShipDate_Min = DateTime.Now.AddDays(-day).Date > EffectiveDate.Value ? DateTime.Now.AddDays(-day).Date : EffectiveDate.Value;
                            }
                            else
                            {
                                model.WinSLShipDate_Min = DateTime.Now.AddDays(-day).AddMonths(-1).Date > EffectiveDate.Value ? DateTime.Now.AddDays(-day).AddMonths(-1).Date : EffectiveDate.Value;
                            }
                            model.WinSLShipDate_Max = DateTime.Now.Date > ExpirationDate.Value ? ExpirationDate.Value : DateTime.Now.Date;
                        }
                        else
                        {
                            //在工作日内只能报上月，在工作日外只能报当前月
                            if (day >= limitNo)
                            {
                                model.WinSLShipDate_Min = DateTime.Now.AddDays(-day).Date > EffectiveDate.Value ? DateTime.Now.AddDays(-day).Date : EffectiveDate.Value;
                                model.WinSLShipDate_Max = DateTime.Now.Date > EffectiveDate.Value ? DateTime.Now.Date : EffectiveDate.Value;

                            }
                            else
                            {
                                model.WinSLShipDate_Min = DateTime.Now.AddDays(-day).AddMonths(-1).Date > EffectiveDate.Value ? DateTime.Now.AddDays(-day).AddMonths(-1).Date : EffectiveDate.Value;
                                model.WinSLShipDate_Max = DateTime.Now.AddDays(-day - 1).Date > EffectiveDate.Value ? DateTime.Now.AddDays(-day - 1).Date : EffectiveDate.Value;

                            }
                        }
                    }
                    else if (ActiveFlag == 0 && IsShare > 0)
                    {
                        if (day >= limitNo)
                        {
                            model.WinSLShipDate_Min = DateTime.Now.AddDays(-day).Date;
                        }
                        else
                        {
                            model.WinSLShipDate_Min = DateTime.Now.AddDays(-day).AddMonths(-1).Date;
                        }
                        model.WinSLShipDate_Max = DateTime.Now.Date;
                    }
                    else
                    {
                        model.WinSLShipDate_Min = EffectiveDate.Value;
                        model.WinSLShipDate_Max = ExpirationDate.Value;
                    }
                }
                else
                {
                    if (day >= limitNo)
                    {
                        model.WinSLShipDate_Min = DateTime.Now.AddDays(-day).Date;
                    }
                    else
                    {
                        model.WinSLShipDate_Min = DateTime.Now.AddDays(-day).AddMonths(-1).Date;
                    }
                    model.WinSLShipDate_Max = DateTime.Now.Date;
                }

            }
            return model;

        }

        private bool GetRevokeDate(DateTime shipDate)
        {
            ShipmentUtil util = new ShipmentUtil();
            CalendarDate cd = util.GetCalendarDate();
            DateTime minDate = DateTime.MinValue;

            if (cd != null)
            {
                int limitNo = Convert.ToInt32(cd.Date1);

                int day = DateTime.Now.Day - 1;
                if (day >= limitNo)
                {
                    minDate = DateTime.Now.AddDays(-day).Date;

                }
                else
                {
                    minDate = DateTime.Now.AddDays(-day).AddMonths(-1).Date;

                }

            }
            if (DateTime.Compare(minDate, shipDate) > 0)
            {
                return false;
            }
            else
            {
                return true;
            }

        }

    }
}
