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
using DMS.Business.EKPWorkflow;
using DMS.Model.EKPWorkflow;

namespace DMS.BusinessService.Consign
{
    public class ConsignTransferConfirmService : ABaseBusinessService
    {
        public ConsignTransferConfirmVO Init(ConsignTransferConfirmVO model)
        {
            try
            {
                TransferHeaderDao transferHeaderDao = new TransferHeaderDao();
                TransferDetailDao transferDetailDao = new TransferDetailDao();
                TransferConfirmDao transferConfirmDao = new TransferConfirmDao();
                IdentityDao identityDao = new IdentityDao();
                ContractHeaderDao contractHeaderDao = new ContractHeaderDao();

                if (model.InstanceId.IsNullOrEmpty())
                {
                    throw new Exception("找不到相应的寄售转移申请单");
                }
                else
                {
                    TransferHeaderPO transferHeader = transferHeaderDao.SelectById(model.InstanceId.ToSafeGuid());

                    if (transferHeader.TH_Status.Equals("Confirming") && transferHeader.TH_DMA_ID_From == base.UserInfo.CorpId)
                    {
                        model.ViewMode = "Edit";
                    }
                    else
                    {
                        model.ViewMode = "View";
                    }

                    model.IptApplyBasic = new ApplyBasic(transferHeader.TH_CreateDate.Value.To_yyyy_MM_dd_HH_mm_ss(),
                                                         identityDao.SelectUserName(transferHeader.TH_CreateUser.Value),
                                                         transferHeader.TH_No,
                                                         DictionaryHelper.GetDictionaryNameById(SR.Consign_ConsignTransfer_Status, transferHeader.TH_Status));
                    model.IptBu = KeyValueHelper.CreateProductLine(transferHeader.TH_ProductLine_BUM_ID).Value;
                    model.IptDealerOut = KeyValueHelper.CreateDealer(transferHeader.TH_DMA_ID_From).Value;
                    model.IptDealerIn = KeyValueHelper.CreateDealer(transferHeader.TH_DMA_ID_To).Value;
                    model.IptHospital = KeyValueHelper.CreateHospital(transferHeader.TH_HospitalId).Value;
                    model.IptSales = KeyValueHelper.CreateSales(transferHeader.TH_SalesAccount).Value;
                    model.IptRemark = transferHeader.TH_Remark;

                    IList<Hashtable> detailList = transferDetailDao.SelectForConfirmByHeadId(model.InstanceId.ToSafeGuid());
                    IList<Hashtable> confirmedList = transferConfirmDao.SelectConfirmedList(model.InstanceId.ToSafeGuid());

                    model.RstDetailList = new List<ContractTransferUpnItem>();
                    model.RstConfirmList = new List<ContractTransferConfirmList>();

                    foreach (Hashtable detail in detailList)
                    {//产品明细
                        ContractTransferUpnItem item = new ContractTransferUpnItem();
                        item.DetailId = detail.GetSafeStringValue("DetailId");
                        item.UpnId = detail.GetSafeStringValue("UpnId");
                        item.UpnNo = detail.GetSafeStringValue("UpnNo");
                        item.UpnShortNo = detail.GetSafeStringValue("UpnShortNo");
                        item.UpnName = detail.GetSafeStringValue("UpnName");
                        item.UpnEngName = detail.GetSafeStringValue("UpnEngName");
                        item.Unit = detail.GetSafeStringValue("Unit");
                        item.Quantity = detail.GetSafeIntValue("Quantity");
                        item.ConfirmQuantity = detail.GetSafeIntValue("ConfirmQuantity");
                        item.Difference = item.ConfirmQuantity - item.Quantity;
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
                                confirmedItem.DOM = confirmed.GetSafeStringValue("DOM");
                                confirmedItem.ExpiredDate = confirmed.GetDatetimeValue("ExpiredDate");
                                itemList.ItemList.Add(confirmedItem);
                            }
                        }

                        model.RstConfirmList.Add(itemList);
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

        public ConsignTransferConfirmVO ChangeUpn(ConsignTransferConfirmVO model)
        {
            try
            {
                TransferConfirmDao transferConfirmDao = new TransferConfirmDao();

                IList<Hashtable> detailList = transferConfirmDao.SelectInventoryList(model.IptUpnId.ToSafeGuid(), base.UserInfo.CorpId.Value);
                //确认产品
                model.RstInventoryList = new List<ContractTransferConfirmItem>();
                foreach (Hashtable detail in detailList)
                {
                    ContractTransferConfirmItem item = new ContractTransferConfirmItem();
                    item.DetailId = model.IptDetailId;
                    item.LotMasterId = detail.GetSafeStringValue("LotMasterId");
                    item.UpnId = detail.GetSafeStringValue("UpnId");
                    item.WarehouseId = detail.GetSafeStringValue("WarehouseId");
                    item.WarehouseName = detail.GetSafeStringValue("WarehouseName");
                    item.ProductId = detail.GetSafeStringValue("ProductId");
                    item.LotId = detail.GetSafeStringValue("LotId");
                    item.Lot = detail.GetSafeStringValue("Lot");
                    item.QrCode = detail.GetSafeStringValue("QrCode");
                    item.DOM = detail.GetSafeStringValue("DOM");
                    item.ExpiredDate = detail.GetDatetimeValue("ExpiredDate");
                    model.RstInventoryList.Add(item);
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

        public ConsignTransferConfirmVO Confirm(ConsignTransferConfirmVO model)
        {
            try
            {
                model = this.CheckApply(model);

                if (model.IsSuccess)
                {
                    using (TransactionScope trans = new TransactionScope())
                    {
                        ConsignInventoryAdjustHeaderDao ConsignInventoryAdjustHeader = new ConsignInventoryAdjustHeaderDao();
                        TransferConfirmDao transferConfirmDao = new TransferConfirmDao();
                        TransferHeaderDao transferHeaderDao = new TransferHeaderDao();
                        ConsignInventoryAdjustHeaderDao consignInventoryAdjustHeaderDao = new ConsignInventoryAdjustHeaderDao();
                        EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();

                        TransferHeaderPO transferHeader = transferHeaderDao.SelectById(model.InstanceId.ToSafeGuid());

                        foreach (ContractTransferConfirmList upn in model.RstConfirmList)
                        {
                            foreach (ContractTransferConfirmItem product in upn.ItemList)
                            {
                                TransferConfirmPO confirm = new TransferConfirmPO();
                                confirm.TC_ID = Guid.NewGuid();
                                confirm.TC_TD_ID = product.DetailId.ToSafeGuid();
                                confirm.TC_WHM_ID = product.WarehouseId.ToSafeGuid();
                                confirm.TC_PMA_ID = product.ProductId.ToSafeGuid();
                                confirm.TC_LOT_ID = product.LotId.ToSafeGuid();
                                confirm.TC_QTY = 1;
                                confirm.TC_ConfirmUser = base.UserInfo.Id.ToSafeGuid();
                                confirm.TC_ConfirmDate = DateTime.Now;
                                confirm.TC_Lot = product.Lot;
                                confirm.TC_QRCode = product.QrCode;
                                confirm.TC_DOM = product.DOM;
                                confirm.TC_ExpiredDate = product.ExpiredDate;
                                transferConfirmDao.Insert(confirm);
                            }
                        }

                        transferHeaderDao.UpdateStatus(model.InstanceId.ToSafeGuid(), "InApproval");

                        String rtnVal = "";
                        String rtnMsg = "";
                        string account = ConsignInventoryAdjustHeader.GetAccount(transferHeader.TH_SalesAccount);
                        consignInventoryAdjustHeaderDao.Consignment_Proc_InventoryAdjust("ConsignTransfer", transferHeader.TH_No, "Frozen", out rtnVal, out rtnMsg);
                        if (rtnVal.Equals("Failure"))
                        {
                            throw new Exception(rtnMsg);
                        }
                        base.InsertLog("Consignment_Transfer", model.InstanceId.ToSafeGuid(), model.ToLogJsonString(), "确认", "移出经销商");

                        ekpBll.DoSubmit(account, model.InstanceId, transferHeader.TH_No, "ConsignmentTransfer",
                            string.Format("{0} {1}寄售转移",
                            transferHeader.TH_No,
                            KeyValueHelper.CreateDealer(transferHeader.TH_DMA_ID_To).Value)
                         , EkpModelId.ConsignmentTransfer.ToString(), EkpTemplateFormId.ConsignmentTransferTemplate.ToString());
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

        private ConsignTransferConfirmVO CheckApply(ConsignTransferConfirmVO model)
        {
            return model;
        }
    }
}
