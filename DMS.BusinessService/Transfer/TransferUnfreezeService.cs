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
using DMS.ViewModel.Transfer;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Transfer
{
    public class TransferUnfreezeService : ABaseQueryService, IDealerFilterFac, IQueryExport
    {
        #region Ajax Method
        private ITransferBLL business = new TransferBLL();
        IPurchaseOrderBLL logbll = new PurchaseOrderBLL();
        IRoleModelContext context = RoleModelContext.Current;
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public TransferUnfreezeVO Init(TransferUnfreezeVO model)
        {
            try
            {
                DealerMasterDao dealerMasterDao = new DealerMasterDao();
                model.LstDealer = JsonHelper.DataTableToArrayList(GetDealerSource().ToDataSet().Tables[0]);
                model.LstDealerName = dealerMasterDao.SelectFilterListAll("");
                
                model.IsDealer = IsDealer;
                model.LstProductLine = base.GetProductLine();
                model.LstStatus = new ArrayList(DictionaryHelper.GetDictionary(SR.Consts_TransferOrder_Status).ToArray());
                //
                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_TransferOrder_Type);
                var list = from t in dicts where t.Key != TransferType.Rent.ToString() select t;
                list = from t in list where t.Key != TransferType.RentConsignment.ToString() select t;
                model.LstType = new ArrayList(list.ToList());
                //控制查询按钮
                Permissions pers = context.User.GetPermissions();
                model.ShowSearch = pers.IsPermissible(Business.TransferBLL.Action_TransferApply, PermissionType.Read);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public TransferUnfreezeVO InitInfoWin(TransferUnfreezeVO model)
        {
            try
            {
                DealerMasterDao dealerMasterDao = new DealerMasterDao();
                model.LstProductLine = base.GetProductLine();
                model.LstDealerName = dealerMasterDao.SelectFilterListAll("");
                model.IsDealer = IsDealer;

                //初始化detail窗口

                Guid id = model.WinTransferId.ToSafeGuid();

                string TransType = model.WinTransferType.ToSafeString();
                
                DMS.Model.Transfer mainData = null;

                //若id为空，说明为新增，则生成新的id，并新增一条记录

                if (id == Guid.Empty)
                {
                    id = Guid.NewGuid();
                    model.WinTransferId = id.ToString();

                    mainData = new DMS.Model.Transfer();
                    mainData.Id = id;
                    mainData.Type = TransType;
                    mainData.Status = DealerTransferStatus.Draft.ToString();
                    string DealerId = GetDealerSource().Count == 0 ? "00000000-0000-0000-0000-000000000000" : GetDealerSource()[0].Id.ToSafeString();
                    mainData.FromDealerDmaId = new Guid(DealerId);
                    mainData.ToDealerDmaId = new Guid(DealerId);
                    mainData.TransferNumber = string.Empty;
                    mainData.TransferDate = DateTime.Now;
                    business.Insert(mainData);
                }
                //根据ID查询主表数据，并初始化页面

                //business = new TransferBLL();
                mainData = business.GetObject(id);
                
                model.WinTransferId = mainData.Id.ToString();
                model.WinTransferType = mainData.Type;
                if (mainData.FromDealerDmaId != null)
                {
                    DealerMaster dmaFrom = new DealerMasters().GetDealerMaster(new Guid(mainData.FromDealerDmaId.ToSafeString()));
                    model.LstDealerName = dealerMasterDao.SelectFilterListAll(dmaFrom.ChineseShortName);
                    model.WinDealer = new KeyValue(dmaFrom.Id.ToSafeString(), dmaFrom.ChineseShortName);
                }
                if (mainData.ProductLineBumId != null)
                {
                    ProductLineBLL productLine = new ProductLineBLL();
                    var pdl = (from p in model.LstProductLine where p.Key == mainData.ProductLineBumId.ToSafeString() select p).ToList();
                    model.WinProductLine = pdl[0];
                }
                model.WinTransferNumber = mainData.TransferNumber;
                if (mainData.TransferDate != null)
                {
                    model.WinDate = mainData.TransferDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                }
                model.WinTransferStatus = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_TransferOrder_Status, mainData.Status);

                //产品明细
                int totalCount = 0;
                Hashtable param = new Hashtable();
                param.Add("hid", mainData.Id);
                DataTable dtProduct = business.QueryTransferLotHasFromToWarehouse(param, 0, int.MaxValue, out totalCount).Tables[0];
                model.RstWinProductList = JsonHelper.DataTableToArrayList(dtProduct);

                DataTable dtLog = logbll.QueryPurchaseOrderLogByHeaderId(mainData.Id, 0, int.MaxValue, out totalCount).Tables[0];
                model.RstWinOPLog = JsonHelper.DataTableToArrayList(dtLog);

                Hashtable ht = new Hashtable();
                ht.Add("TrnId", mainData.Id);
                TransferBLL transferBLL = new TransferBLL();
                Decimal lineNum = transferBLL.GetTransferLineProductNumByTrnId(ht);
                model.WinProductSum = "产品总数量：" + lineNum.ToString();

                IList<Warehouse> listWarehouse = WarehouseByDealerAndType(new Guid(mainData.FromDealerDmaId.Value.ToString()), "Noanddefault");
                if (listWarehouse.Count > 0)
                {
                    model.WinWarehouse = new KeyValue(listWarehouse[0].Id.ToSafeString(), listWarehouse[0].Name);
                }
                model.LstWarehouse = JsonHelper.DataTableToArrayList(listWarehouse.ToDataSet().Tables[0]);

                //窗口状态控制
                model.ShowSearch = false;
                model.ShowAdd = false;
                model.HideUPN = ConfigurationManager.AppSettings["HiddenUPN"].ToSafeBool();
                model.HideUOM = ConfigurationManager.AppSettings["HiddenUOM"].ToSafeBool();

                if (mainData.Status == DealerTransferStatus.Draft.ToString())
                {
                    if (mainData.FromDealerDmaId != null && mainData.ToDealerDmaId != null && mainData.ProductLineBumId != null)
                    {
                        model.ShowAdd = true;
                    }
                    model.ShowSearch = !(business.SelectLimitBUCount(new Guid(mainData.FromDealerDmaId.Value.ToString())).Tables[0].Rows[0]["cnt"].ToString() == "0");
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

        public TransferUnfreezeVO InitProductChoose(TransferUnfreezeVO model)
        {
            try
            {
                model.HideUPN = ConfigurationManager.AppSettings["HiddenUPN"].ToSafeBool();
                model.HideUOM = ConfigurationManager.AppSettings["HiddenUOM"].ToSafeBool();
                string warehousetype = string.Empty;
                if (model.WinTransferType == TransferType.Transfer.ToString())
                {
                    warehousetype = "Frozen";
                }
                else if (model.WinTransferType == TransferType.Rent.ToString())
                {
                    warehousetype = "Normal";
                }
                else
                {
                    warehousetype = "Consignment";
                }
                if (model.WinTransferType == TransferType.Transfer.ToString())
                {
                    if (context.User.LoginId.Contains("_99"))
                    {
                        model.LstFreezeWarehouse = JsonHelper.DataTableToArrayList(NormalWarehousType(model.WinDealer.Key.ToSafeGuid(), model.WinProductLine.Key.ToSafeGuid(), warehousetype).ToDataSet().Tables[0]);
                    }
                    else
                    {
                        model.LstFreezeWarehouse = JsonHelper.DataTableToArrayList(GetWarehouseByDealerAndTypeWithoutDWH(model.WinDealer.Key.ToSafeGuid(), model.WinProductLine.Key.ToSafeGuid(), warehousetype).ToDataSet().Tables[0]);
                    }
                }
                else
                {
                    model.LstFreezeWarehouse = JsonHelper.DataTableToArrayList(NormalWarehousType(model.WinDealer.Key.ToSafeGuid(), model.WinProductLine.Key.ToSafeGuid(), warehousetype).ToDataSet().Tables[0]);
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

        public string Query(TransferUnfreezeVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryProductLine.Key))
                    param.Add("ProductLine", model.QryProductLine.Key);

                if (!string.IsNullOrEmpty(model.QryDealer.Key))
                {
                    param.Add("FromDealerDmaId", model.QryDealer.Key);
                    param.Add("QueryType", "LPHQ");
                }

                if (!string.IsNullOrEmpty(model.QryApplyDate.StartDate.ToSafeString()))
                {
                    param.Add("TransferDateStart", Convert.ToDateTime(model.QryApplyDate.StartDate).ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryApplyDate.EndDate.ToSafeString()))
                {
                    param.Add("TransferDateEnd", Convert.ToDateTime(model.QryApplyDate.EndDate).ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryTransferNumber.ToSafeString()))
                {
                    param.Add("TransferNumber", model.QryTransferNumber);
                }
                if (!string.IsNullOrEmpty(model.QryTransferStatus.Key))
                    param.Add("Status", model.QryTransferStatus.Key);

                if (!string.IsNullOrEmpty(model.QryCFN.ToSafeString()))
                {
                    param.Add("Cfn", model.QryCFN);
                }
                //if (!string.IsNullOrEmpty(model.QryCFN.ToSafeString()))
                //{
                //    param.Add("Upn", model.QryCFN);
                //}
                if (!string.IsNullOrEmpty(model.QryLotNumber.ToSafeString()))
                {
                    param.Add("LotNumber", model.QryLotNumber);
                }
                //不选则查询除了Rent外的2种类型
                string[] transferType = new string[2];
                if (!string.IsNullOrEmpty(model.QryTransferType.Key))
                {
                    transferType[0] = model.QryTransferType.Key;
                    param.Add("Type", transferType);
                }
                else
                {
                    transferType[0] = TransferType.Transfer.ToString();
                    transferType[1] = TransferType.TransferConsignment.ToString();
                    param.Add("Type", transferType);
                }

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.SelectByFilterTransferFrozen(param, start, model.PageSize, out totalCount);
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

        public TransferUnfreezeVO QueryProductItem(TransferUnfreezeVO model)
        {
            try
            {
                string[] strCriteria;
                int iCriteriaNbr;
                ICurrentInvBLL business = new CurrentInvBLL();

                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.WinDealer.Key))
                {
                    param.Add("DealerId", model.WinDealer.Key);
                }
                if (!string.IsNullOrEmpty(model.WinProductLine.Key))
                {
                    param.Add("ProductLine", model.WinProductLine.Key);
                }
                if (!string.IsNullOrEmpty(model.WinFreezeWarehouse.Key))
                {
                    param.Add("WarehouseId", model.WinFreezeWarehouse.Key);
                }
                //可以有十个模糊查找的字段
                if (!string.IsNullOrEmpty(model.WinCFN))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.WinCFN);
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
                
                if (!string.IsNullOrEmpty(model.WinLotNumber))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.WinLotNumber);
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
                if (!string.IsNullOrEmpty(model.WinQrCode))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.WinQrCode);
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
                if (model.WinTransferType == TransferType.Transfer.ToString() || model.WinTransferType == TransferType.Rent.ToString())
                {
                    string[] list = new string[1];
                    list[0] = WarehouseType.Frozen.ToString();
                    param.Add("QryWarehouseType", list);
                }
                else if (model.WinTransferType == TransferType.RentConsignment.ToString())
                {
                    if (context.User.CorpType == DealerType.HQ.ToString())
                    {
                        param.Add("QryWarehouseType", WarehouseType.Consignment.ToString().Split(','));
                    }
                    else
                    {
                        param.Add("QryWarehouseType", string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(','));
                    }
                }
                else
                {
                    if (context.User.CorpType == DealerType.LP.ToString() || context.User.CorpType == DealerType.LS.ToString() || context.User.CorpType == DealerType.T1.ToString())
                    {
                        param.Add("QryWarehouseType", WarehouseType.Consignment.ToString().Split(','));
                    }
                    else
                    {
                        param.Add("QryWarehouseType", WarehouseType.LP_Consignment.ToString().Split(','));
                    }
                }
                
                DataTable dt = business.QueryCurrentInv(param).Tables[0];
                model.RstProductItem = JsonHelper.DataTableToArrayList(dt);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public TransferUnfreezeVO AddItemsToDetail(TransferUnfreezeVO model)
        {
            try
            {
                bool result;

                //modified by bozhenfei on 20100607
                result = business.AddItemsByType(model.WinTransferType,
                       model.WinTransferId.ToSafeGuid(),
                       model.WinDealer.Key.ToSafeGuid(),
                       model.WinDealer.Key.ToSafeGuid(),
                       model.WinProductLine.Key.ToSafeGuid(),
                       model.ParaChooseItem.Split(','),
                       model.WinWarehouse.Key.ToSafeGuid()
                       );
                if (result)
                {
                    //产品明细
                    int totalCount = 0;
                    Hashtable param = new Hashtable();
                    param.Add("hid", model.WinTransferId);
                    DataTable dtProduct = business.QueryTransferLotHasFromToWarehouse(param, 0, int.MaxValue, out totalCount).Tables[0];
                    model.RstWinProductList = JsonHelper.DataTableToArrayList(dtProduct);

                    Hashtable ht = new Hashtable();
                    ht.Add("TrnId", model.WinTransferId);
                    TransferBLL transferBLL = new TransferBLL();
                    Decimal lineNum = transferBLL.GetTransferLineProductNumByTrnId(ht);
                    model.WinProductSum = "产品总数量：" + lineNum.ToString();
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

        public TransferUnfreezeVO ShowReason(TransferUnfreezeVO model)
        {
            try
            {
                DataSet ds = business.SelectLimitReason(context.User.CorpId.Value);
                model.RstWinReason = JsonHelper.DataTableToArrayList(ds.Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public TransferUnfreezeVO DeleteItem(TransferUnfreezeVO model)
        {
            try
            {
                bool result = false;
                result = business.DeleteItem(model.DeleteItemId.ToSafeGuid());
                if (result)
                {
                    model.ExecuteMessage.Add("删除成功！");
                    if(!string.IsNullOrEmpty(model.WinTransferId))
                    {
                        //产品明细
                        int totalCount = 0;
                        Hashtable param = new Hashtable();
                        param.Add("hid", model.WinTransferId);
                        DataTable dtProduct = business.QueryTransferLotHasFromToWarehouse(param, 0, int.MaxValue, out totalCount).Tables[0];
                        model.RstWinProductList = JsonHelper.DataTableToArrayList(dtProduct);

                        Hashtable ht = new Hashtable();
                        ht.Add("TrnId", model.WinTransferId);
                        TransferBLL transferBLL = new TransferBLL();
                        Decimal lineNum = transferBLL.GetTransferLineProductNumByTrnId(ht);
                        model.WinProductSum = "产品总数量：" + lineNum.ToString();
                    }
                }
                else
                {
                    model.ExecuteMessage.Add("删除出错！");
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

        public TransferUnfreezeVO DeleteDetail(TransferUnfreezeVO model)
        {
            try
            {
                bool result = false;
                result = business.DeleteDetail(model.WinTransferId.ToSafeGuid());

                if (!result)
                {
                    model.ExecuteMessage.Add("删除明细数据失败！");
                }
                if (!string.IsNullOrEmpty(model.WinDealer.Key))
                {
                    IList<Warehouse> listWarehouse = WarehouseByDealerAndType(model.WinDealer.Key.ToSafeGuid(), "Noanddefault");
                    if (listWarehouse.Count > 0)
                    {
                        model.WinWarehouse = new KeyValue(listWarehouse[0].Id.ToSafeString(), listWarehouse[0].Name);
                    }
                    model.LstWarehouse = JsonHelper.DataTableToArrayList(listWarehouse.ToDataSet().Tables[0]);
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

        public TransferUnfreezeVO DeleteDraft(TransferUnfreezeVO model)
        {
            try
            {
                bool result = false;
                result = business.DeleteDraft(model.WinTransferId.ToSafeGuid());
                
                if (result)
                {
                    model.ExecuteMessage.Add("删除草稿成功！");
                }
                else
                {
                    model.ExecuteMessage.Add("删除草稿失败！");
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

        public TransferUnfreezeVO SaveDraft(TransferUnfreezeVO model)
        {
            try
            {
                //foreach (Newtonsoft.Json.Linq.JObject dtTransfer in model.RstWinProductList)
                //{
                for (int i = 0; i < model.RstWinProductList.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject dtTransfer = Newtonsoft.Json.Linq.JObject.Parse(model.RstWinProductList[i].ToString());
                    string msg = SaveTransferItem(dtTransfer["Id"].ToString().Replace("\"", ""), dtTransfer["ToWarehouseId"].ToString().Replace("\"", ""), dtTransfer["TransferQty"].ToString().Replace("\"", ""), dtTransfer["QRCode"].ToString().Replace("\"", ""), dtTransfer["QRCodeEdit"].ToString().Replace("\"", ""), dtTransfer["LotNumber"].ToString().Replace("\"", ""));
                    if (msg != "")
                    {
                        model.ExecuteMessage.Add(msg);
                        model.RstWinProductList = null;
                        return model;
                    }
                }
                model.RstWinProductList = null;
                DMS.Model.Transfer mainData = business.GetObject(model.WinTransferId.ToSafeGuid());
                if (!string.IsNullOrEmpty(model.WinDealer.Key))
                {
                    mainData.FromDealerDmaId = model.WinDealer.Key.ToSafeGuid();
                }

                if (!string.IsNullOrEmpty(model.WinProductLine.Key))
                {
                    mainData.ProductLineBumId = model.WinProductLine.Key.ToSafeGuid();
                }
                if (!string.IsNullOrEmpty(model.WinDealer.Key))
                {
                    mainData.ToDealerDmaId = model.WinDealer.Key.ToSafeGuid();
                }

                bool result = false;
                mainData.TransferUsrUserID = new Guid(context.User.Id);
                result = business.SaveDraft(mainData);
                
                if (!result)
                {
                    model.ExecuteMessage.Add("保存草稿失败！");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            model.RstWinProductList = null;
            return model;
        }

        public TransferUnfreezeVO Submit(TransferUnfreezeVO model)
        {
            try
            {
                //foreach (Newtonsoft.Json.Linq.JObject dtTransfer in model.RstWinProductList)
                //{
                for (int i = 0; i < model.RstWinProductList.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject dtTransfer = Newtonsoft.Json.Linq.JObject.Parse(model.RstWinProductList[i].ToString());
                    string msg = SaveTransferItem(dtTransfer["Id"].ToString().Replace("\"", ""), dtTransfer["ToWarehouseId"].ToString().Replace("\"", ""), dtTransfer["TransferQty"].ToString().Replace("\"", ""), dtTransfer["QRCode"].ToString().Replace("\"", ""), dtTransfer["QRCodeEdit"].ToString().Replace("\"", ""), dtTransfer["LotNumber"].ToString().Replace("\"", ""));
                    if (msg != "")
                    {
                        model.ExecuteMessage.Add(msg);
                        model.RstWinProductList = null;
                        return model;
                    }
                }
                model.RstWinProductList = null;

                bool result = false;
                string errMsg = string.Empty;
                
                //判断line表中移入库与移出库是否一致；如果一致则不能提交
                if (!business.IsTransferLineWarehouseEqualByTrnID(model.WinTransferId))
                {
                    //更新字段
                    DMS.Model.Transfer mainData = business.GetObject(model.WinTransferId.ToSafeGuid());
                    mainData.FromDealerDmaId = model.WinDealer.Key.ToSafeGuid();
                    mainData.ToDealerDmaId = model.WinDealer.Key.ToSafeGuid();

                    if (!string.IsNullOrEmpty(model.WinProductLine.Key))
                    {
                        mainData.ProductLineBumId = model.WinProductLine.Key.ToSafeGuid();
                    }

                    DataSet ds = business.SelectTransferLotByFilter(model.WinTransferId.ToSafeGuid());

                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        errMsg = ds.Tables[0].Rows[0][0].ToString();
                    }

                    if (!string.IsNullOrEmpty(errMsg))
                    {
                        errMsg = errMsg.Replace(",", "<br/>");
                        model.ExecuteMessage.Add(errMsg);
                        return model;
                    }

                    mainData.TransferUsrUserID = new Guid(context.User.Id);
                    result = business.TransferSubmit(mainData, out errMsg);
                    
                    if (result)
                    {
                        model.ExecuteMessage.Add("WarehouseNotEqual");
                        return model;
                    }
                    else
                    {
                        model.ExecuteMessage.Add(errMsg);
                        return model;
                    }
                }
                else
                {
                    model.ExecuteMessage.Add("WarehouseEqual");
                    return model;
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            model.RstWinProductList = null;
            return model;
        }

        #endregion

        public string SaveTransferItem(String LotId, string ToWarehouseId, String TransferQty, String QRCode, String EditQrCode, String LotNumber)
        {
            bool result = false;
            string errMsg = string.Empty;

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
                
                if (!result)
                {
                    errMsg = "批号：" + LotNumber + "保存出错！";
                }
                if (!bl)
                {
                    errMsg = "二维码："+ EditQrCode + "不存在！";
                }

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
            return errMsg;

        }

        #region 下载
        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(Parameters["ProductLine"].ToSafeString()))
            {
                param.Add("ProductLine", Parameters["ProductLine"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Dealer"].ToSafeString()))
            {
                param.Add("FromDealerDmaId", Parameters["Dealer"].ToSafeString());
                param.Add("QueryType", "LPHQ");
            }
            if (!string.IsNullOrEmpty(Parameters["TransferDateStart"].ToSafeString()))
            {
                param.Add("TransferDateStart", Parameters["TransferDateStart"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["TransferDateEnd"].ToSafeString()))
            {
                param.Add("TransferDateEnd", Parameters["TransferDateEnd"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["TransferNumber"].ToSafeString()))
            {
                param.Add("TransferNumber", Parameters["TransferNumber"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Status"].ToSafeString()))
            {
                param.Add("Status", Parameters["Status"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Cfn"].ToSafeString()))
            {
                param.Add("Cfn", Parameters["Cfn"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["LotNumber"].ToSafeString()))
            {
                param.Add("LotNumber", Parameters["LotNumber"].ToSafeString());
            }
            //不选则查询除了Rent外的2种类型
            string[] transferType = new string[2];
            if (!string.IsNullOrEmpty(Parameters["TransferType"].ToSafeString()))
            {
                transferType[0] = Parameters["TransferType"].ToSafeString();
                param.Add("Type", transferType);
            }
            else
            {
                transferType[0] = TransferType.Transfer.ToString();
                transferType[1] = TransferType.TransferConsignment.ToString();
                param.Add("Type", transferType);
            }

            DataSet ds = business.SelectByFilterTransferForExport(param);
            if (ds != null)
            {
                DataTable dt = ds.Tables[0];
                DataSet[] result = new DataSet[1];
                result[0] = new DataSet();
                result[0].Tables.Add(dt.Copy());

                Hashtable ht = new Hashtable();
                XlsExport xlsExport = new XlsExport("ExportFile");
                xlsExport.Export(ht, result, DownloadCookie);
            }

        }
        #endregion

        #region 导入
        public TransferUnfreezeVO InitImportWin(TransferUnfreezeVO model)
        {
            try
            {

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        public string QueryImportData(TransferUnfreezeVO model)
        {
            try
            {
                ITransferBLL bll = new TransferBLL();

                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                IList<DMS.Model.TransferInit> list = bll.QueryTransferInitErrorData(start, model.PageSize, out outCont);
                model.ImportErrorGrid = new ArrayList(list.ToList());

                model.DataCount = outCont;
                model.IsSuccess = true;

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.ImportErrorGrid, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        /// <summary>
        /// 保存
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public TransferUnfreezeVO SaveImport(TransferUnfreezeVO model)
        {
            try
            {
                DMS.Model.TransferInit r = new DMS.Model.TransferInit();
                TransferBLL bll = new TransferBLL();
                r.Id = new Guid(model.Id);
                r.WarehouseFrom = model.WarehouseFrom;
                r.WarehouseTo = model.WarehouseTo;
                r.ArticleNumber = model.ArticleNumber;
                r.LotNumber = model.LotNumber + "@@" + model.QRCode;
                r.TransferQty = model.TransferQty;
                bll.Update(r);

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public TransferUnfreezeVO DeleteImport(TransferUnfreezeVO model)
        {
            try
            {
                TransferBLL bll = new TransferBLL();
                bll.Delete(new Guid(model.Id));
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        /// <summary>
        /// 导入数据库
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public TransferUnfreezeVO ImportDB(TransferUnfreezeVO model)
        {
            try
            {
                string importType = "Import";
                string errMsg = string.Empty;
                string IsValid = string.Empty;
                TransferBLL bll = new TransferBLL();
                if (bll.VerifyTransferInit(importType, out IsValid))
                {
                    if (IsValid == "Success")
                    {
                        if (importType == "Upload")
                        {
                            //ImportButtonDisabled = true;
                            errMsg = "已成功上传文件！";
                        }
                        else
                        {
                            errMsg = "数据导入成功！";
                        }
                    }
                    else if (IsValid == "Error")
                    {
                        errMsg = "数据包含错误！";
                    }
                    else
                    {
                        errMsg = "数据导入异常！";
                    }
                }
                else
                {
                    errMsg = "导入数据过程发生错误！";
                }
                if (IsValid != "Success")
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(errMsg);
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
    }
}
