using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Collections.Specialized;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Consign;
using DMS.ViewModel.Common;
using DMS.DataAccess;
using DMS.DataAccess.ContractElectronic;
using Lafite.RoleModel.Security;
using DMS.Model.Data;
using DMS.Common.Extention;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.BusinessService.Util.EmployeeFilter;
using DMS.BusinessService.Util.EmployeeFilter.Impl;
using DMS.BusinessService.Util.HospitalFilter;
using DMS.BusinessService.Util.HospitalFilter.Impl;
using DMS.ViewModel.Consign.Common;
using Grapecity.DataAccess.Transaction;
using DMS.DataAccess.Consignment;
using DMS.Model.Consignment;
using DMS.DataAccess.Lafite;
using DMS.DataAccess.MasterData;
using DMS.DataAccess.Interface;
using DMS.BusinessService.Util;
using DMS.Business;
using DMS.Business.EKPWorkflow;
using DMS.Model.EKPWorkflow;

namespace DMS.BusinessService.Consign
{
    public class ConsignTransferInfoService : ABaseBusinessService, IDealerFilterFac, IEmployeeFilterFac, IHospitalFilterFac
    {
        public AHospitalFilter CreateHospitalFilter()
        {
            return new DealerAuthHospitalFilter();
        }

        public ADealerFilter CreateDealerFilter()
        {
            //TODO 寄售合同管理 需要根据红蓝海属性过滤
            return new AllDealerFilter();
        }

        public AEmployeeFilter CreateEmployeeFilter()
        {
            return new SalesRepFilter();
        }

        public ConsignTransferInfoVO Init(ConsignTransferInfoVO model)
        {
            try
            {
                TransferHeaderDao transferHeaderDao = new TransferHeaderDao();
                TransferDetailDao transferDetailDao = new TransferDetailDao();
                IdentityDao identityDao = new IdentityDao();
                ContractHeaderDao contractHeaderDao = new ContractHeaderDao();
                TransferConfirmDao transferConfirmDao = new TransferConfirmDao();

                model.LstBu = base.GetProductLine();

                if (model.InstanceId.IsNullOrEmpty())
                {
                    model.IsNewApply = true;
                    model.ViewMode = "Edit";

                    model.InstanceId = Guid.NewGuid().ToSafeString();

                    model.IptApplyBasic = base.CreateDefaultApplyBasic();
                    model.IptDealerIn = new KeyValue(base.UserInfo.CorpId.ToSafeString(), base.UserInfo.CorpName);
                }
                else
                {
                    TransferHeaderPO transferHeader = transferHeaderDao.SelectById(model.InstanceId.ToSafeGuid());

                    model.IsNewApply = false;
                    model.ViewMode = transferHeader.TH_Status.Equals("Draft") && transferHeader.TH_DMA_ID_To.Value.Equals(base.UserInfo.CorpId.Value) ? "Edit" : "View";

                    model.IptApplyBasic = new ApplyBasic(transferHeader.TH_CreateDate.Value.To_yyyy_MM_dd_HH_mm_ss(),
                                                         identityDao.SelectUserName(transferHeader.TH_CreateUser.Value),
                                                         transferHeader.TH_No,
                                                         DictionaryHelper.GetDictionaryNameById(SR.Consign_ConsignTransfer_Status, transferHeader.TH_Status));
                    model.IptBu = KeyValueHelper.CreateProductLine(transferHeader.TH_ProductLine_BUM_ID);
                    model.IptDealerOut = KeyValueHelper.CreateDealer(transferHeader.TH_DMA_ID_From);
                    model.IptDealerIn = KeyValueHelper.CreateDealer(transferHeader.TH_DMA_ID_To);
                    model.IptHospital = KeyValueHelper.CreateHospital(transferHeader.TH_HospitalId);
                    model.IptSales = KeyValueHelper.CreateSales(transferHeader.TH_SalesAccount);
                    model.IptRemark = transferHeader.TH_Remark;

                    if (transferHeader.TH_CCH_ID != null && !transferHeader.TH_CCH_ID.Value.Equals(Guid.Empty))
                    {
                        ContractHeaderPO contractHead = contractHeaderDao.SelectById(transferHeader.TH_CCH_ID.Value);

                        model.IptConsignContract = new ConsignContract(contractHead.CCH_ID.ToSafeString(),
                                                                       contractHead.CCH_Name,
                                                                       contractHead.CCH_No,
                                                                       contractHead.CCH_ConsignmentDay.Value.ToIntString(),
                                                                       contractHead.CCH_DelayNumber.Value.ToIntString(),
                                                                       contractHead.CCH_BeginDate.Value.To_yyyy_MM_dd() + " - " + contractHead.CCH_EndDate.Value.To_yyyy_MM_dd(),
                                                                       contractHead.CCH_IsKB.Value,
                                                                       contractHead.CCH_IsFixedMoney.Value,
                                                                       contractHead.CCH_IsFixedQty.Value,
                                                                       contractHead.CCH_IsUseDiscount.Value,
                                                                       contractHead.CCH_Remark);
                    }

                    model.LstConsignContract = contractHeaderDao.SelectActiveList(transferHeader.TH_ProductLine_BUM_ID.Value, transferHeader.TH_DMA_ID_To.Value);

                    IList<Hashtable> detailList = transferDetailDao.SelectByHeadId(model.InstanceId.ToSafeGuid(), BaseService.CurrentSubCompany?.Key, BaseService.CurrentBrand?.Key);
                    IList<Hashtable> confirmedList = transferConfirmDao.SelectConfirmedList(model.InstanceId.ToSafeGuid());

                    model.RstDetailList = new List<ContractTransferUpnItem>();
                    model.RstConfirmList = new List<ContractTransferConfirmList>();

                    foreach (Hashtable detail in detailList)
                    {
                        ContractTransferUpnItem item = new ContractTransferUpnItem();
                        item.UpnId = detail.GetSafeStringValue("UpnId");
                        item.UpnNo = detail.GetSafeStringValue("UpnNo");
                        item.UpnShortNo = detail.GetSafeStringValue("UpnShortNo");
                        item.UpnName = detail.GetSafeStringValue("UpnName");
                        item.UpnEngName = detail.GetSafeStringValue("UpnEngName");
                        item.Unit = detail.GetSafeStringValue("Unit");
                        item.Quantity = detail.GetSafeIntValue("Quantity");
                        item.Price = detail.GetSafeDecimalValue("Price");
                        item.Total = detail.GetSafeDecimalValue("Total");
                        item.ConfirmQuantity = detail.GetSafeIntValue("ConfirmQuantity");

                        model.RstDetailList.Add(item);

                        ContractTransferConfirmList itemList = new ContractTransferConfirmList();
                        itemList.UpnId = detail.GetSafeStringValue("UpnId");
                        itemList.ItemList = new List<ContractTransferConfirmItem>();

                        foreach (Hashtable confirmed in confirmedList)
                        {
                            if (itemList.UpnId.Equals(confirmed.GetSafeStringValue("UpnId")))
                            {
                                ContractTransferConfirmItem confirmedItem = new ContractTransferConfirmItem();
                                confirmedItem.DetailId = confirmed.GetSafeStringValue("DetailId");
                                confirmedItem.LotMasterId = confirmed.GetSafeStringValue("LotMasterId");
                                confirmedItem.UpnId = confirmed.GetSafeStringValue("UpnId");
                                confirmedItem.WarehouseId = confirmed.GetSafeStringValue("WarehouseId");
                                confirmedItem.WarehouseName = confirmed.GetSafeStringValue("WarehouseName");
                                confirmedItem.ProductId = confirmed.GetSafeStringValue("ProductId");
                                confirmedItem.LotId = confirmed.GetSafeStringValue("LotId");
                                confirmedItem.Lot = confirmed.GetSafeStringValue("Lot");
                                confirmedItem.QrCode = confirmed.GetSafeStringValue("QrCode");

                                itemList.ItemList.Add(confirmedItem);
                            }
                        }

                        model.RstConfirmList.Add(itemList);
                    }

                    model.RstOperationLog = base.GetLog("Consignment_Transfer", model.InstanceId.ToSafeGuid());
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

        public ConsignTransferInfoVO ChangeBu(ConsignTransferInfoVO model)
        {
            try
            {
                ContractHeaderDao contractHeaderDao = new ContractHeaderDao();

                model.LstConsignContract = contractHeaderDao.SelectActiveList(model.IptBu.Key.ToSafeGuid(), base.UserInfo.CorpId.Value);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ConsignTransferInfoVO AddDetail(ConsignTransferInfoVO model)
        {
            try
            {
                ContractDetailDao contractDetailDao = new ContractDetailDao();

                IList<Hashtable> upnList = new List<Hashtable>();
                if (model.LstUpn != null && model.LstUpn.Count > 0)
                {
                    upnList = contractDetailDao.SelectContractUpnPrice(base.UserInfo.CorpId.Value, model.LstUpn, BaseService.CurrentSubCompany?.Key, BaseService.CurrentBrand?.Key);
                }

                model.LstDetailList = new List<ContractTransferUpnItem>();
                foreach (Hashtable upn in upnList)
                {
                    ContractTransferUpnItem item = new ContractTransferUpnItem();
                    item.UpnId = upn.GetSafeStringValue("UpnId");
                    item.UpnNo = upn.GetSafeStringValue("UpnNo");
                    item.UpnShortNo = upn.GetSafeStringValue("UpnShortNo");
                    item.UpnName = upn.GetSafeStringValue("UpnName");
                    item.UpnEngName = upn.GetSafeStringValue("UpnEngName");
                    item.Unit = upn.GetSafeStringValue("Unit");
                    item.Quantity = upn.GetSafeIntValue("Quantity");
                    item.Price = upn.GetSafeDecimalValue("Price");
                    item.Total = upn.GetSafeDecimalValue("Total");

                    model.LstDetailList.Add(item);
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

        public ConsignTransferInfoVO Delete(ConsignTransferInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    TransferHeaderDao transferHeaderDao = new TransferHeaderDao();

                    transferHeaderDao.UpdateStatus(model.InstanceId.ToSafeGuid(), "Delete");

                    base.InsertLog("Consignment_Transfer", model.InstanceId.ToSafeGuid(), model.ToLogJsonString(), "删除", "申请人");

                    trans.Complete();
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

        public ConsignTransferInfoVO Save(ConsignTransferInfoVO model)
        {
            try
            {
                this.SaveApply(model, "Draft");
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ConsignTransferInfoVO Submit(ConsignTransferInfoVO model)
        {
            try
            {
                
                this.SaveApply(model, "Confirming");
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        private ConsignTransferInfoVO CheckApply(ConsignTransferInfoVO model)
        {
            return model;
        }

        private ConsignTransferInfoVO SaveApply(ConsignTransferInfoVO model, String status)
        {
            try
            {
                model = this.CheckApply(model);

                if (model.IsSuccess)
                {
                    using (TransactionScope trans = new TransactionScope())
                    {
                        TransferHeaderDao transferHeaderDao = new TransferHeaderDao();
                        TransferDetailDao transferDetailDao = new TransferDetailDao();
                        ConsignCommonDao consignCommonDao = new ConsignCommonDao();

                        TransferHeaderPO transferHeader = new TransferHeaderPO();
                        transferHeader.TH_ID = model.InstanceId.ToSafeGuid();
                        transferHeader.TH_DMA_ID_To = model.IptDealerIn.Key.ToGuid();
                        transferHeader.TH_DMA_ID_From = model.IptDealerOut.Key.ToGuid();
                        transferHeader.TH_ProductLine_BUM_ID = model.IptBu.Key.ToGuid();
                        transferHeader.TH_CCH_ID = model.IptConsignContract.ContractId.ToGuid();
                        transferHeader.TH_Status = status;
                        transferHeader.TH_HospitalId = model.IptHospital.Key.ToGuid();
                        transferHeader.TH_Remark = model.IptRemark;
                        transferHeader.TH_SalesAccount = model.IptSales.Key;

                        if (model.IsNewApply)
                        {
                            transferHeader.TH_No = consignCommonDao.ProcGetNextAutoNumber(null, model.IptBu.Key.ToSafeGuid(), "CSTT", "ConsignTrnsfer");
                            transferHeader.TH_CreateUser = base.UserInfo.Id.ToGuid();
                            transferHeader.TH_CreateDate = DateTime.Now;

                            transferHeaderDao.Insert(transferHeader);
                        }
                        else
                        {
                            transferHeaderDao.Update(transferHeader);
                        }

                        transferDetailDao.DeleteByHeadId(model.InstanceId.ToSafeGuid());

                        foreach (ContractTransferUpnItem item in model.RstDetailList)
                        {
                            TransferDetailPO transferDetail = new TransferDetailPO();
                            transferDetail.TD_ID = Guid.NewGuid();
                            transferDetail.TD_TH_ID = model.InstanceId.ToSafeGuid();
                            transferDetail.TD_CFN_ID = item.UpnId.ToGuid();
                            transferDetail.TD_UOM = item.Unit;
                            transferDetail.TD_QTY = item.Quantity;
                            transferDetail.TD_CFN_Price = item.Price;
                            transferDetail.TD_Amount = item.Quantity * item.Price;

                            transferDetailDao.Insert(transferDetail);
                        }
                        if (status== "Confirming")
                        {
                            kmReviewWebserviceBLL ekpBll = new kmReviewWebserviceBLL();
                            string templateId = DictionaryHelper.GetDictionaryNameById("CONST_TemplateId", "ConsignmentTransfer");
                            if (string.IsNullOrEmpty(templateId))
                            {
                                throw new Exception("OA流程ID未配置！");
                            }
                            ekpBll.DoSubmit(model.IptSales.Key, model.InstanceId, transferHeader.TH_No, "ConsignmentTransfer", string.Format("{0}寄售合同转移", transferHeader.TH_No)
                           , EkpModelId.ConsignmentTransfer.ToString(), EkpTemplateFormId.ConsignmentTransferTemplate.ToString(), templateId);
                        }
                        base.InsertLog("Consignment_Transfer", model.InstanceId.ToSafeGuid(), model.ToLogJsonString(), status.Equals("Draft") ? "草稿" : "提交", "申请人");

                        trans.Complete();
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
    }
}
