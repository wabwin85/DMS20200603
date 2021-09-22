using System;
using System.Collections;
using System.Collections.Generic;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Consign;
using DMS.DataAccess;
using DMS.DataAccess.ContractElectronic;
using Grapecity.DataAccess.Transaction;
using DMS.Common.Extention;
using Lafite.RoleModel.Security;
using DMS.Model.Data;
using DMS.Model;
using DMS.Business;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Model.Consignment;
using System.Data;
using DMS.BusinessService.Util;
using DMS.DataAccess.Consignment;
using DMS.Business.EKPWorkflow;
using DMS.Model.EKPWorkflow;
using DMS.Business.Cache;
using DMS.BusinessService.Util.EmployeeFilter;
using DMS.BusinessService.Util.EmployeeFilter.Impl;

namespace DMS.BusinessService.Consign
{
    public class ConsignInventoryAdjustHeaderInfoService : ABaseBusinessService, IDealerFilterFac
    {

        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        private IInventoryAdjustBLL _business = null;

        public IInventoryAdjustBLL business
        {
            get { return _business; }
            set { _business = value; }
        }

        public ConsignInventoryAdjustHeaderInfoVO Init(ConsignInventoryAdjustHeaderInfoVO model)
        {
            try
            {

                ConsignInventoryAdjustHeaderDao ConsignInventoryAdjustHeader = new ConsignInventoryAdjustHeaderDao();
                model.IptType = "经销商申请买断";
                model.LstBu = base.GetProductLine();
                if (model.InstanceId.IsNullOrEmpty())
                {
                    model.IsNewApply = true;
                    model.ViewMode = "Edit";
                    model.InstanceId = Guid.NewGuid().ToSafeString();
                    model.IptApplyBasic = base.CreateDefaultApplyBasic();
                    model.IptDealer = KeyValueHelper.CreateDealer(RoleModelContext.Current.User.CorpId);
                    model.CheckCreateUser = true;
                }
                else
                {
                    model.IsNewApply = false;
                    ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao();
                    DealerMasterDao DealerMaster = new DealerMasterDao();
                    string DivisionCode;

                    ConsignInventoryAdjustHeaderPO po = ConsignInventoryAdjustHeader.SelectConsignInventoryAdjustHeader(model.InstanceId);
                    if (po.IAH_CreatedBy_USR_UserID.ToSafeString().ToUpper() == RoleModelContext.Current.User.Id.ToUpper())
                    {
                        model.CheckCreateUser = true;
                    }
                    string Name = ConsignInventoryAdjustHeader.GetSalesName(po.SaleRep);
                    DataTable tb = ConsignInventoryAdjustHeader.SelectUserName(po.IAH_CreatedBy_USR_UserID.ToSafeString());
                    DealerMaster Dealer = DealerMaster.GetObject(po.IAH_DMA_ID);
                    if (!string.IsNullOrEmpty(po.IAH_ProductLine_BUM_ID.ToSafeString()))
                    {
                        DivisionCode = dao.GetProductLineVsDivisionCode(po.IAH_ProductLine_BUM_ID.ToSafeString()).Tables[0].Rows[0]["DivisionCode"].ToString();
                        model.LstBoSales = JsonHelper.DataTableToArrayList(dao.GetProductLineVsDealerSale(DivisionCode).Tables[0]);
                    }


                    model.IptApplyBasic = new ViewModel.Common.ApplyBasic(po.IAH_CreatedDate.ToSafeString(), tb.Rows.Count > 0 ? tb.Rows[0]["IDENTITY_NAME"].ToSafeString() : "", po.IAH_Inv_Adj_Nbr, DictionaryHelper.GetDictionaryNameById(SR.CONST_AdjustQty_Status, po.IAH_Status));
                    model.IptDealer = KeyValueHelper.CreateDealer(po.IAH_DMA_ID);
                    model.IptProductLine = KeyValueHelper.CreateProductLine(po.IAH_ProductLine_BUM_ID);
                    model.IptBoSales = new ViewModel.Common.KeyValue(po.SaleRep, Name);
                    model.IptRemark = po.IAH_UserDescription;
                    model.LstInventoryAdjustDetail = JsonHelper.DataTableToArrayList(ConsignInventoryAdjustHeader.QueryInventoryAdjustDetail(model.InstanceId));
                    model.IptType = po.VALUE1;
                    model.RstOperationLog = base.GetLog("Consign_InventoryAdjustHeaderInfo", model.InstanceId.ToSafeGuid());
                }
                if (IsDealer)
                {
                    model.IsDealer = true;
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

        public ConsignInventoryAdjustHeaderInfoVO Save(ConsignInventoryAdjustHeaderInfoVO model)
        {
            try
            {
                model = this.CheckApply(model);

                if (model.CheckBoSales)
                {
                    IInventoryAdjustBLL business = new InventoryAdjustBLL();
                    ConsignInventoryAdjustHeaderDao ConsignInventoryAdjustHeader = new ConsignInventoryAdjustHeaderDao();
                    using (TransactionScope trans = new TransactionScope())
                    {
                        string LOTID = "";
                        string Price = "";
                        for (int j = 0; j < model.IptLOTID.Count; j++)
                        {
                            LOTID = LOTID + model.IptLOTID[j].ToSafeString() + ",";
                            Price = Price + model.IptPrice[j].ToSafeString() + ",";
                        }
                        if (model.IptLOTID.Count > 0)
                        {
                            LOTID = LOTID.Substring(0, LOTID.Length - 1);
                            Price = Price.Substring(0, Price.Length - 1);
                        }

                        bool result1 = false;

                        if (model.IsNewApply)
                        {
                            #region 主档信息
                            InventoryAdjustHeader mainData = null;
                            mainData = new InventoryAdjustHeader();
                            mainData.Id = new Guid(model.InstanceId);
                            mainData.CreateDate = DateTime.Now;
                            mainData.CreateUser = new Guid(RoleModelContext.Current.User.Id);
                            mainData.DmaId = RoleModelContext.Current.User.CorpId.Value;
                            mainData.Status = AdjustStatus.Draft.ToString();
                            mainData.Reason = AdjustType.CTOS.ToString();
                            mainData.WarehouseType = "";
                            mainData.SaleRep = model.IptBoSales.Key;
                            mainData.ProductLineBumId = new Guid(model.IptProductLine.Key);
                            mainData.UserDescription = model.IptRemark;

                            business.ConsignInsertInventoryAdjustHeader(mainData);
                            if (model.IptLOTID.Count > 0 && model.IptPrice.Count > 0)
                            {
                                result1 = business.ConsignAddItems("", new Guid(model.InstanceId), new Guid(model.IptDealer.Key), "", LOTID.Split(','), Price.Split(','), "");
                            }
                            #endregion
                        }
                        else
                        {
                            ConsignInventoryAdjustHeader.DeleteInventoryAdjustLot(new Guid(model.InstanceId));
                            ConsignInventoryAdjustHeader.DeleteInventoryAdjustDetail(new Guid(model.InstanceId));
                            ConsignInventoryAdjustHeader.UpdateInventoryAdjustHeaderSave(model.InstanceId, model.IptBoSales.Key, model.IptRemark);
                            if (model.IptLOTID.Count > 0 && model.IptPrice.Count > 0)
                            {
                                result1 = business.ConsignAddItems("", new Guid(model.InstanceId), new Guid(model.IptDealer.Key), "", LOTID.Split(','), Price.Split(','), "");
                            }
                        }
                        if (model.IptLOTID.Count > 0 && model.IptPrice.Count > 0)
                        {
                            InventoryAdjustHeader mainData2 = business.GetInventoryAdjustById(new Guid(model.InstanceId == "" ? model.InstanceId : model.InstanceId));
                            mainData2.ProductLineBumId = new Guid(model.IptProductLine.Key);
                            mainData2.SaleRep = model.IptBoSales.Key;
                            mainData2.UserDescription = model.IptRemark;
                            bool result = false;
                            try
                            {
                                result = business.SaveDraft(mainData2);
                                base.InsertLog("Consign_InventoryAdjustHeaderInfo", model.InstanceId.ToSafeGuid(), model.ToLogJsonString(), "草稿", "申请人");
                            }
                            catch (Exception e)
                            {
                                throw new Exception(e.Message);
                            }
                        }

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


        public ConsignInventoryAdjustHeaderInfoVO Submit(ConsignInventoryAdjustHeaderInfoVO model)
        {
            ConsignInventoryAdjustHeaderDao ConsignInventoryAdjustHeader = new ConsignInventoryAdjustHeaderDao();
            model = this.CheckApply(model);

            kmReviewWebserviceBLL ekpBll = new kmReviewWebserviceBLL();
            try
            {
                if (model.CheckBoSales)
                {
                    IInventoryAdjustBLL business = new InventoryAdjustBLL();

                    using (TransactionScope trans = new TransactionScope())
                    {
                        string LOTID = "";
                        string Price = "";
                        for (int j = 0; j < model.IptLOTID.Count; j++)
                        {
                            LOTID = LOTID + model.IptLOTID[j].ToSafeString() + ",";
                            Price = Price + model.IptPrice[j].ToSafeString() + ",";
                        }
                        if (model.IptLOTID.Count > 0)
                        {
                            LOTID = LOTID.Substring(0, LOTID.Length - 1);
                            Price = Price.Substring(0, Price.Length - 1);
                        }


                        bool result1 = false;


                        if (!string.IsNullOrEmpty(model.InstanceId) && model.IsNewApply)
                        {
                            #region 主档信息
                            InventoryAdjustHeader mainData = null;
                            mainData = new InventoryAdjustHeader();
                            mainData.Id = new Guid(model.InstanceId);
                            mainData.CreateDate = DateTime.Now;
                            mainData.CreateUser = new Guid(RoleModelContext.Current.User.Id);
                            mainData.DmaId = RoleModelContext.Current.User.CorpId.Value;
                            mainData.Status = AdjustStatus.Draft.ToString();
                            mainData.Reason = AdjustType.CTOS.ToString();
                            mainData.WarehouseType = "";
                            mainData.SaleRep = model.IptBoSales.Key;
                            mainData.ProductLineBumId = new Guid(model.IptProductLine.Key);
                            mainData.UserDescription = model.IptRemark;
                            business.ConsignInsertInventoryAdjustHeader(mainData);
                            if (model.IptLOTID.Count > 0 && model.IptPrice.Count > 0)
                            {
                                result1 = business.ConsignAddItems("", new Guid(model.InstanceId), new Guid(model.IptDealer.Key), "", LOTID.Split(','), Price.Split(','), "");
                            }
                            #endregion
                        }
                        else
                        {
                            ConsignInventoryAdjustHeader.DeleteInventoryAdjustLot(new Guid(model.InstanceId));
                            ConsignInventoryAdjustHeader.DeleteInventoryAdjustDetail(new Guid(model.InstanceId));
                            ConsignInventoryAdjustHeader.UpdateInventoryAdjustHeaderSave(model.InstanceId, model.IptBoSales.Key, model.IptRemark);
                            if (model.IptLOTID.Count > 0 && model.IptPrice.Count > 0)
                            {
                                result1 = business.ConsignAddItems("", new Guid(model.InstanceId), new Guid(model.IptDealer.Key), "", LOTID.Split(','), Price.Split(','), "");
                            }

                        }

                        if (model.IptLOTID.Count > 0 && model.IptPrice.Count > 0)
                        {
                            string Number = "";
                            string account = "";
                            InventoryAdjustHeader mainData2 = business.GetInventoryAdjustById(new Guid(model.InstanceId == "" ? model.InstanceId : model.InstanceId));
                            mainData2.ProductLineBumId = new Guid(model.IptProductLine.Key);
                            mainData2.SaleRep = model.IptBoSales.Key;
                            mainData2.UserDescription = model.IptRemark;
                            bool result = false;
                            try
                            {
                                result = business.Submit(mainData2);
                                Number = ConsignInventoryAdjustHeader.GetNumber(new Guid(model.InstanceId));
                                account = ConsignInventoryAdjustHeader.GetAccount(model.IptBoSales.Key);
                                if (!string.IsNullOrEmpty(Number))
                                {
                                    String rtnVal = "";
                                    String rtnMsg = "";
                                    ConsignInventoryAdjustHeader.Consignment_Proc_InventoryAdjust("CTS", Number, "Frozen", out rtnVal, out rtnMsg);
                                    if (rtnVal == "Failure")
                                    {
                                        throw new Exception(rtnMsg);
                                    }

                                    DealerMaster dealer = DealerCacheHelper.GetDealerById(RoleModelContext.Current.User.CorpId.ToSafeGuid());

                                    string templateId = DictionaryHelper.GetDictionaryNameById("CONST_TemplateId", "ConsignmentPurchase");
                                    if (string.IsNullOrEmpty(templateId))
                                    {
                                        throw new Exception("OA流程ID未配置！");
                                    }
                                    if (dealer.DealerType == DealerType.LP.ToSafeString() || dealer.DealerType == DealerType.LS.ToSafeString() || dealer.DealerType == DealerType.T1.ToSafeString())
                                    {
                                        ekpBll.DoSubmit(account, model.InstanceId, Number, "ConsignmentPurchase", string.Format("{0} {1}寄售买断", Number, model.IptDealer.Value)
                                         , EkpModelId.ConsignmentPurchase.ToString(), EkpTemplateFormId.ConsignmentPurchaseTemplate.ToString(), templateId);
                                    }
                                    base.InsertLog("Consign_InventoryAdjustHeaderInfo", model.InstanceId.ToSafeGuid(), model.ToLogJsonString(), "提交", "申请人");
                                    ConsignInventoryAdjustHeader.ConsignInventoryAdjustHeaderUpdateStatus(Number);
                                }
                            }
                            catch (Exception e)
                            {
                                throw new Exception(e.Message);
                            }
                        }
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

        public ConsignInventoryAdjustHeaderInfoVO BoSalesChange(ConsignInventoryAdjustHeaderInfoVO model)
        {

            ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao();

            string DivisionCode;
            DivisionCode = dao.GetProductLineVsDivisionCode(model.IptProductLine.Key).Tables[0].Rows[0]["DivisionCode"].ToString();
            model.LstBoSales = JsonHelper.DataTableToArrayList(dao.GetProductLineVsDealerSale(DivisionCode).Tables[0]);

            return model;

        }
        public ConsignInventoryAdjustHeaderInfoVO Delete(ConsignInventoryAdjustHeaderInfoVO model)
        {

            bool result = false;
            IInventoryAdjustBLL business = new InventoryAdjustBLL();
            try
            {
                result = business.DeleteDraft(new Guid(model.InstanceId));
                base.InsertLog("Consign_InventoryAdjustHeaderInfo", model.InstanceId.ToSafeGuid(), model.ToLogJsonString(), "删除", "申请人");
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return model;

        }

        private ConsignInventoryAdjustHeaderInfoVO CheckApply(ConsignInventoryAdjustHeaderInfoVO model)
        {
            DealerMaster dealer = DealerCacheHelper.GetDealerById(RoleModelContext.Current.User.CorpId.ToSafeGuid());

            if (model.IptBoSales.Key == "" && dealer.DealerType != DealerType.T2.ToSafeString())
            {
                model.CheckBoSales = false;
            }
            else
            {
                model.CheckBoSales = true;
            }
            return model;
        }



    }
}
