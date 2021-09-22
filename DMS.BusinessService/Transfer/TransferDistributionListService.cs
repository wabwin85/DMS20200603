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
using Lafite.RoleModel.Domain;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Transfer
{
    public class TransferDistributionListService : ABaseQueryService, IQueryExport, IDealerFilterFac
    {
        private ITransferBLL business = new TransferBLL();
        IRoleModelContext context = RoleModelContext.Current;

        #region Ajax Method
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public TransferDistributionListVO Init(TransferDistributionListVO model)
        {
            try
            {
                DealerMasterDao dealerMasterDao = new DealerMasterDao();
                model.LstFromDealer = dealerMasterDao.SelectFilterListAll("");
                if (IsDealer)
                {
                    model.QryFromDealerName = new KeyValue(base.UserInfo.CorpId.ToSafeString(), base.UserInfo.CorpName);
                }

                model.IsDealer = IsDealer;
                model.LstProductLine = GetProductLine();
                model.LstDealer = new ArrayList(DealerList().ToList());
                IDictionary<string, string> dictStatus = DictionaryHelper.GetDictionary(SR.Consts_DealerTransfer_Status);
                var listStatus = from s in dictStatus where s.Key == DealerTransferStatus.Draft.ToString() || s.Key == DealerTransferStatus.Complete.ToString() select s;
                model.LstTransferStatus = new ArrayList(listStatus.ToList());

                //借入经销商
                if (IsDealer)
                {
                    string InitDealerId = context.User.CorpId.Value.ToString();
                    Guid DealerFromId = Guid.Empty;
                    if (!string.IsNullOrEmpty(InitDealerId))
                    {
                        DealerFromId = new Guid(InitDealerId);
                    }
                    IList<DealerMaster> Todicts = new DealerMasters().QueryDealerMasterForTransferByDealerFromId(DealerFromId);
                    model.LstToDealer = new ArrayList(Todicts.ToList());
                    model.LstFromDealer = dealerMasterDao.SelectFilterListAll(UserInfo.CorpName);
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

        public TransferDistributionListVO InitInfoWin(TransferDistributionListVO model)
        {
            try
            {
                DealerMasterDao dealerMasterDao = new DealerMasterDao();
                model.LstFromDealer = dealerMasterDao.SelectFilterListAll("");
                if (IsDealer)
                {
                    model.QryWinDealerFrom = new KeyValue(base.UserInfo.CorpId.ToSafeString(), base.UserInfo.CorpName);
                }

                model.IsDealer = IsDealer;
                model.LstProductLine = GetProductLine();
                model.LstDealer = new ArrayList(DealerList().ToList());

                //借入经销商
                if (IsDealer)
                {
                    string InitDealerId = context.User.CorpId.Value.ToString();
                    Guid DealerFromId = Guid.Empty;
                    if (!string.IsNullOrEmpty(InitDealerId))
                    {
                        DealerFromId = new Guid(InitDealerId);
                    }
                    IList<DealerMaster> Todicts = new DealerMasters().QueryDealerMasterForTransferByDealerFromId(DealerFromId);
                    model.LstToDealer = new ArrayList(Todicts.ToList());
                    model.LstFromDealer = dealerMasterDao.SelectFilterListAll(UserInfo.CorpName);
                }

                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                DMS.Model.Transfer header = null;
                if (string.IsNullOrEmpty(model.InstanceId))
                {
                    string TransType = TransferType.TransferDistribution.ToString();
                    string DealerFromId = model.hidDealerFromId == null ? "" : model.hidDealerFromId;
                    string ProductLineWin = model.QryWinProductLine == null ? "" : model.QryWinProductLine.Key;
                    header = GetNewTransfer(InstanceId, TransType, DealerFromId, ProductLineWin);
                }
                header = business.GetObject(InstanceId);
                model.InstanceId = header.Id.ToString();
                model.hidDealerFromId = header.FromDealerDmaId.ToString();
                if (header != null)
                {
                    //表头信息
                    model.IsDealer = IsDealer;
                    model.QryWinDate = header.TransferDate.Value.ToString("yyyyMMdd");
                    DealerMaster dmaFrom = new DealerMasters().GetDealerMaster(header.FromDealerDmaId.ToSafeGuid());
                    if (!string.IsNullOrEmpty(header.ToDealerDmaId.ToSafeString()))
                    {
                        DealerMaster dmaTo = new DealerMasters().GetDealerMaster(header.ToDealerDmaId.ToSafeGuid());
                        List<DealerMaster> listTo = new List<DealerMaster>() { dmaTo };
                        if (model.LstToDealer == null || model.LstToDealer.Count <= 0)
                            model.LstToDealer = JsonHelper.DataTableToArrayList(listTo.ToDataSet().Tables[0]);
                        model.QryWinDealerTo = new KeyValue(dmaTo.Id.ToString(), dmaTo.ChineseShortName);
                    }
                    if (!string.IsNullOrEmpty(header.ProductLineBumId.ToSafeString()))
                    {
                        var kvProductLine = (from p in model.LstProductLine where p.Key == header.ProductLineBumId.ToSafeString() select p).ToList();
                        model.QryWinProductLine = kvProductLine[0];
                    }
                    model.LstFromDealer = dealerMasterDao.SelectFilterListAll(dmaFrom.ChineseShortName);
                    model.QryWinDealerFrom = new KeyValue(dmaFrom.Id.ToString(), dmaFrom.ChineseShortName);
                    model.QryWinNumber = header.TransferNumber;
                    model.QryWinStatus = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_DealerTransfer_Status, header.Status);

                    //获取仓库信息
                    model.LstFromWarehouse = new ArrayList(TransferWarehouseByDealerAndType(new Guid(model.hidDealerFromId), "Normal").ToList());

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

        public string Query(TransferDistributionListVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryProductLine.Key))
                {
                    param.Add("ProductLine", model.QryProductLine.Key);
                }
                if (!string.IsNullOrEmpty(model.QryFromDealerName.Key))
                {
                    param.Add("FromDealerDmaId", model.QryFromDealerName.Key);
                }
                if (!string.IsNullOrEmpty(model.QryToDealerName.Key))
                {
                    param.Add("ToDealerDmaId", model.QryToDealerName.Key);
                }
                if (!string.IsNullOrEmpty(model.QryTransferDate.StartDate.ToSafeString()))
                {
                    param.Add("TransferDateStart", Convert.ToDateTime(model.QryTransferDate.StartDate).ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryTransferDate.EndDate.ToSafeString()))
                {
                    param.Add("TransferDateEnd", Convert.ToDateTime(model.QryTransferDate.EndDate).ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryTransferNumber.ToSafeString()))
                {
                    param.Add("TransferNumber", model.QryTransferNumber);
                }
                if (!string.IsNullOrEmpty(model.QryTransferStatus.Key))
                {
                    param.Add("Status", model.QryTransferStatus.Key);
                }
                //查询分销出库单
                string[] transferType = new string[1];
                transferType[0] = TransferType.TransferDistribution.ToString();
                param.Add("Type", transferType);

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryTransfer(param, start, model.PageSize, out totalCount);
                model.RstTDLResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstTDLResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        public string QueryProductDetail(TransferDistributionListVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                param.Add("hid", model.InstanceId);

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryTransferLotHasFromToWarehouse(param, start, model.PageSize, out totalCount);
                model.RstWinProductDetail = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstWinProductDetail, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        public TransferDistributionListVO QueryProductList(TransferDistributionListVO model)
        {
            try
            {
                string[] strCriteria;
                int iCriteriaNbr;
                ICurrentInvBLL business = new CurrentInvBLL();

                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryWinDealerFrom.Key))
                {
                    param.Add("DealerId", model.QryWinDealerFrom.Key);
                }
                if (!string.IsNullOrEmpty(model.QryWinProductLine.Key))
                {
                    param.Add("ProductLine", model.QryWinProductLine.Key);
                }
                if (!string.IsNullOrEmpty(model.WinTDLWarehouse.Key))
                {
                    param.Add("WarehouseId", model.WinTDLWarehouse.Key);
                }
                //可以有十个模糊查找的字段
                if (!string.IsNullOrEmpty(model.WinTDLCFN))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.WinTDLCFN);
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

                if (!string.IsNullOrEmpty(model.WinTDLLotNumber))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.WinTDLLotNumber);
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
                if (!string.IsNullOrEmpty(model.WinTDLQrCode))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.WinTDLQrCode);
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
                string[] list = new string[2];
                list[0] = WarehouseType.Normal.ToString();
                list[1] = WarehouseType.DefaultWH.ToString();
                param.Add("QryWarehouseType", list);

                DataSet ds = business.QueryCurrentInv(param);

                model.RstTDLProductItem = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public TransferDistributionListVO ChangeFromDealer(TransferDistributionListVO model)
        {
            IList<DealerMaster> Todicts = new DealerMasters().QueryDealerMasterForTransferByDealerFromId(model.QryFromDealerName.Key.ToSafeGuid());
            model.LstToDealer = new ArrayList(Todicts.ToList());

            return model;
        }
        #endregion

        private DMS.Model.Transfer GetNewTransfer(Guid InstanceId, string TransType, string DealerFromId, string ProductLineWin)
        {
            DMS.Model.Transfer mainData = new DMS.Model.Transfer();
            mainData.Id = InstanceId;
            mainData.Type = TransType;
            mainData.Status = DealerTransferStatus.Draft.ToString();
            mainData.FromDealerDmaId = RoleModelContext.Current.User.CorpId.Value;
            mainData.TransferNumber = NextNumber(DealerFromId, ProductLineWin);
            mainData.TransferDate = DateTime.Now;
            business.Insert(mainData);
            return mainData;
        }

        protected string NextNumber(string DealerFromId, string ProductLineWin)
        {
            AutoNumberBLL an = new AutoNumberBLL();
            if (string.IsNullOrEmpty(DealerFromId) || string.IsNullOrEmpty(ProductLineWin))
            {
                return string.Empty;
            }
            else
                return an.GetNextAutoNumber(new Guid(DealerFromId), OrderType.Next_TransferNbr, ProductLineWin);

        }

        #region 按钮事件

        //删除产品线
        public TransferDistributionListVO DeleteItem(TransferDistributionListVO model)
        {
            try
            {
                bool result = false;
                try
                {
                    result = business.DeleteItem(new Guid(model.LotId));
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }

                if (!result)
                {
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("删除异常");
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

        //修改产品线清除已选择的所有产品
        public TransferDistributionListVO DeleteDetail(TransferDistributionListVO model)
        {
            try
            {
                bool result = false;
                try
                {
                    result = business.DeleteDetail(new Guid(model.InstanceId));
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }
                if (!result)
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("删除明细数据异常");
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

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

        }


        public TransferDistributionListVO SaveDraft(TransferDistributionListVO model)
        {
            try
            {
                //ITransferBLL business = new TransferBLL();
                //更新字段
                //foreach (Newtonsoft.Json.Linq.JObject dtTransfer in model.RstWinProductDetail)
                //{
                for (int i = 0; i < model.RstWinProductDetail.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject dtTransfer = Newtonsoft.Json.Linq.JObject.Parse(model.RstWinProductDetail[i].ToString());
                    SaveTransferItem(dtTransfer["Id"].ToString().Replace("\"", ""), dtTransfer["ToWarehouseId"].ToString().Replace("\"", ""), dtTransfer["TransferQty"].ToString().Replace("\"", ""), dtTransfer["QRCode"].ToString().Replace("\"", ""), dtTransfer["QRCodeEdit"].ToString().Replace("\"", ""), dtTransfer["LotNumber"].ToString().Replace("\"", ""));
                }
                model.RstWinProductDetail = null;
                DMS.Model.Transfer mainData = business.GetObject(new Guid(model.InstanceId));
                if (!string.IsNullOrEmpty(model.QryWinDealerFrom.Key))
                {
                    mainData.FromDealerDmaId = new Guid(model.QryWinDealerFrom.Key);
                }

                if (!string.IsNullOrEmpty(model.QryWinProductLine.Key))
                {
                    mainData.ProductLineBumId = new Guid(model.QryWinProductLine.Key);
                }
                if (!string.IsNullOrEmpty(model.QryWinDealerTo.Key))
                {
                    mainData.ToDealerDmaId = new Guid(model.QryWinDealerTo.Key);
                }

                bool result = false;

                try
                {
                    mainData.TransferUsrUserID = new Guid(context.User.Id);
                    result = business.SaveDraft(mainData);
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }

                if (result)
                {
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("保存成功");
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("保存失败");
                }

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            model.RstWinProductDetail = null;
            return model;
        }

        /// <summary>
        /// 删除草稿
        /// </summary>
        public TransferDistributionListVO DeleteDraft(TransferDistributionListVO model)
        {
            try
            {
                bool result = false;
                try
                {
                    result = business.DeleteDraft(new Guid(model.InstanceId));
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }
                if (result)
                {
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("删除成功");
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("删除草稿失败");
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

        /// <summary>
        /// 提交
        /// </summary>
        public TransferDistributionListVO Submit(TransferDistributionListVO model)
        {
            try
            {
                // ConsignmentMaster header = this.GetFormValue();
                //foreach (Newtonsoft.Json.Linq.JObject dtTransfer in model.RstWinProductDetail)
                //{
                for (int i = 0; i < model.RstWinProductDetail.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject dtTransfer = Newtonsoft.Json.Linq.JObject.Parse(model.RstWinProductDetail[i].ToString());
                    SaveTransferItem(dtTransfer["Id"].ToString().Replace("\"", ""), dtTransfer["ToWarehouseId"].ToString().Replace("\"", ""), dtTransfer["TransferQty"].ToString().Replace("\"", ""), dtTransfer["QRCode"].ToString().Replace("\"", ""), dtTransfer["QRCodeEdit"].ToString().Replace("\"", ""), dtTransfer["LotNumber"].ToString().Replace("\"", ""));
                }
                model.RstWinProductDetail = null;

                bool result = false;
                string errMsg = string.Empty;

                //ITransferBLL business = new TransferBLL();

                DMS.Model.Transfer mainData = business.GetObject(model.InstanceId.ToSafeGuid());
                if (!string.IsNullOrEmpty(model.QryWinDealerFrom.Key))
                {
                    mainData.FromDealerDmaId = model.QryWinDealerFrom.Key.ToSafeGuid();
                }
                if (!string.IsNullOrEmpty(model.QryWinProductLine.Key))
                {
                    mainData.ProductLineBumId = model.QryWinProductLine.Key.ToSafeGuid();
                }
                if (!string.IsNullOrEmpty(model.QryWinDealerTo.Key))
                {
                    mainData.ToDealerDmaId = model.QryWinDealerTo.Key.ToSafeGuid();
                }

                DealerMaster dealerfrom = DealerCacheHelper.GetDealerById(mainData.FromDealerDmaId.Value);
                DealerMaster dealerto = DealerCacheHelper.GetDealerById(mainData.ToDealerDmaId.Value);
                //判断移入和移出经销商红蓝还是否一致；如果不一致则不能提交
                //if (business.IsTransferDealerTypeEqualByTrnID(mainData.FromDealerDmaId.Value, model.QryWinDealerTo.Key.ToSafeGuid()))
                //{

                mainData.TransferUsrUserID = new Guid(context.User.Id);
                result = business.DistributionSubmit(mainData, ReceiptType.TransferDistribution, out errMsg);
                //if ((dealerfrom.DealerType == DealerType.T1.ToString() || dealerfrom.DealerType == DealerType.T2.ToString()) && dealerto.DealerType == DealerType.LP.ToString())
                //{
                //    result = business.BorrowSubmit(mainData, ReceiptType.TransferDistribution, out errMsg);
                //}
                //else
                //{
                //    result = business.Submit(mainData, ReceiptType.TransferDistribution, out errMsg);
                //}

                if (result)
                {
                    model.ExecuteMessage.Add("提交成功！");
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(errMsg);
                }
                //}
                //else
                //{
                //    model.IsSuccess = false;
                //    model.ExecuteMessage.Add("红蓝海经销商之间不能分销！");
                //}
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            model.RstWinProductDetail = null;
            return model;
        }
        #endregion


        #region 弹窗页面添加

        //增加产品
        public TransferDistributionListVO DoAddProductItems(TransferDistributionListVO model)
        {
            try
            {
                int totalCount = 0;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                string param = model.ParamProductItem;
                param = param.Substring(0, param.Length - 1);
                ITransferBLL business = new TransferBLL();
                bool result;
                //modified by bozhenfei on 20100607
                InvTrans invTrans = new InvTrans();
                Guid toWarehouseId = invTrans.GetDefaultWarehouse(model.QryWinDealerTo.Key.ToSafeGuid());
                result = business.AddItemsByType(TransferType.TransferDistribution.ToString(),
                       new Guid(model.InstanceId),
                       new Guid(model.QryWinDealerFrom.Key),
                       new Guid(model.QryWinDealerTo.Key),
                       new Guid(model.QryWinProductLine.Key),
                       param.Split(','),
                       toWarehouseId
                       );
                if (result)
                {
                    Hashtable p = new Hashtable();
                    p.Add("hid", InstanceId);
                    DataTable dtProduct = business.QueryTransferLotHasFromToWarehouse(p, 0, int.MaxValue, out totalCount).Tables[0];
                    model.RstWinProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("添加产品失败");
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
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(Parameters["ProductLine"].ToSafeString()))
            {
                param.Add("ProductLine", Parameters["ProductLine"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["FromDealerDmaId"].ToSafeString()))
            {
                param.Add("FromDealerDmaId", Parameters["FromDealerDmaId"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["ToDealerDmaId"].ToSafeString()))
            {
                param.Add("ToDealerDmaId", Parameters["ToDealerDmaId"].ToSafeString());
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
            //不选则查询除了Rent外的2种类型
            string[] transferType = new string[1];
            transferType[0] = TransferType.TransferDistribution.ToString();
            param.Add("Type", transferType);

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
    }
}
