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
using DMS.Common.Extention;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using Lafite.RoleModel.Security;
using Grapecity.DataAccess.Transaction;
using DMS.BusinessService.Util;
using DMS.DataAccess.Lafite;
using DMS.DataAccess.Consignment;
using DMS.Business.EKPWorkflow;
using DMS.Model.EKPWorkflow;

namespace DMS.BusinessService.Consign
{
    public class ConsignmentTerminationInfoService : ABaseBusinessService, IDealerFilterFac
    {
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public ConsignmentTerminationInfoVO Init(ConsignmentTerminationInfoVO model)
        {
            try
            {

                ConsignmentTerminationDao consignmentTermination = new ConsignmentTerminationDao();
                ConsignInventoryAdjustHeaderDao ConsignInventoryAdjustHeader = new ConsignInventoryAdjustHeaderDao();
                ContractHeaderDao ContractHeader = new ContractHeaderDao();
                IdentityDao identityDao = new IdentityDao();
                model.LstBu = base.GetProductLine();

                if (model.InstanceId.IsNullOrEmpty())
                {
                    model.IsNewApply = true;
                    model.CheckCreateUser = true;
                    model.ViewMode = "Edit";
                    model.InstanceId = Guid.NewGuid().ToSafeString();
                    model.IptApplyBasic = base.CreateDefaultApplyBasic();

                }
                else
                {
                    model.IsNewApply = false;
                    DataTable TerminationInfo = consignmentTermination.SelectConsignTerminationInfo(model.InstanceId.ToSafeString());

                    if (TerminationInfo.Rows.Count > 0)
                    {

                        if (TerminationInfo.Rows[0]["CST_CreateUser"].ToSafeString().ToLower()== RoleModelContext.Current.User.Id.ToLower())
                        {
                            model.CheckCreateUser = true;
                        }
                        DataTable UserName = ConsignInventoryAdjustHeader.SelectUserName(TerminationInfo.Rows[0]["CST_CreateUser"].ToSafeString());
                        model.IptApplyBasic = new ApplyBasic(Convert.ToDateTime(TerminationInfo.Rows[0]["CST_CreateDate"]).To_yyyy_MM_dd_HH_mm_ss(), identityDao.SelectUserName(new Guid(TerminationInfo.Rows[0]["CST_CreateUser"].ToSafeString())), TerminationInfo.Rows[0]["CST_No"].ToSafeString(), DictionaryHelper.GetDictionaryNameById(SR.Consignment_ConsignmentTermination_Status, TerminationInfo.Rows[0]["CST_Status"].ToSafeString()));
                        model.IptBu = KeyValueHelper.CreateProductLine(new Guid(TerminationInfo.Rows[0]["CCH_ProductLine_BUM_ID"].ToSafeString()));
                        model.IptReason = TerminationInfo.Rows[0]["CST_Reason"].ToSafeString(); 
                        model.LstContract = JsonHelper.DataTableToArrayList(TerminationInfo);
                        model.IptDealer = KeyValueHelper.CreateDealer(new Guid(TerminationInfo.Rows[0]["CCH_DMA_ID"].ToString()));

                        if (new Guid(TerminationInfo.Rows[0]["CCH_ID"].ToSafeString()) != null && ! new Guid(TerminationInfo.Rows[0]["CCH_ID"].ToSafeString()).Equals(Guid.Empty))
                        {
                            model.IptConsignContract = new ViewModel.Consign.Common.ConsignContract(TerminationInfo.Rows[0]["CCH_ID"].ToSafeString(), TerminationInfo.Rows[0]["CCH_Name"].ToSafeString(), TerminationInfo.Rows[0]["CCH_No"].ToSafeString(), TerminationInfo.Rows[0]["CCH_ConsignmentDay"].ToSafeString(), TerminationInfo.Rows[0]["CCH_DelayNumber"].ToSafeString(), (TerminationInfo.Rows[0].GetSafeDatetimeValue("CCH_CreateDate").To_yyyy_MM_dd() + "-" + TerminationInfo.Rows[0].GetSafeDatetimeValue("CCH_EndDate").To_yyyy_MM_dd()), Convert.ToBoolean(TerminationInfo.Rows[0]["CCH_IsKB"]), Convert.ToBoolean(TerminationInfo.Rows[0]["CCH_IsFixedMoney"]), Convert.ToBoolean(TerminationInfo.Rows[0]["CCH_IsFixedQty"]), Convert.ToBoolean(TerminationInfo.Rows[0]["CCH_IsUseDiscount"]), TerminationInfo.Rows[0]["CCH_Remark"].ToSafeString());
                        }
                        model.RstOperationLog = base.GetLog("Consignment_TerminationInfo", model.InstanceId.ToSafeGuid());
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

        public ConsignmentTerminationInfoVO ChangeBu(ConsignmentTerminationInfoVO model)
        {
            try
            {
                ContractHeaderDao contractHeaderDao = new ContractHeaderDao();

                model.LstConsignContract = contractHeaderDao.SelectActiveList(model.IptBu.Key.ToSafeGuid(), model.IptDealer.Key.ToSafeGuid());
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ConsignmentTerminationInfoVO Submit(ConsignmentTerminationInfoVO model)
        {
            try
            {
                //EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();
                kmReviewWebserviceBLL ekpBll = new kmReviewWebserviceBLL();
                model = this.CheckApply(model);

                if (model.IsSuccess)
                {
                    using (TransactionScope trans = new TransactionScope())
                    {
                        string Number = "";
                        ConsignmentTerminationDao ContractHeader = new ConsignmentTerminationDao();
                        if (model.IsNewApply)
                        {
                            ContractHeader.InsertConsignmentTerminationSubmit(model.InstanceId, model.IptConsignContract.ContractId, model.IptReason, model.IptRemark, RoleModelContext.Current.User.Id.ToSafeString(), "",new Guid(model.IptBu.Key));
                        }
                        else
                        {
                            ContractHeader.UpdateConsignmentTerminationSubmit(model.InstanceId, model.IptConsignContract.ContractId, model.IptReason, model.IptRemark, RoleModelContext.Current.User.Id.ToSafeString(), "");
                        }

                        Number = ContractHeader.GetNumber(new Guid(model.InstanceId));
                        if (!string.IsNullOrEmpty(Number))
                        {
                            string templateId = DictionaryHelper.GetDictionaryNameById("CONST_TemplateId", "ConsignmentTermination");
                            if (string.IsNullOrEmpty(templateId))
                            {
                                throw new Exception("OA流程ID未配置！");
                            }
                            ekpBll.DoSubmit(RoleModelContext.Current.User.LoginId, model.InstanceId, Number, "ConsignmentTermination", string.Format("{0}寄售合同终止", Number)
                           , EkpModelId.ConsignmentTermination.ToString(), EkpTemplateFormId.ConsignmentTerminationTemplate.ToString(), templateId);
                        }
                        base.InsertLog("Consignment_TerminationInfo", model.InstanceId.ToSafeGuid(), model.ToLogJsonString(), "提交", "申请人");

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
        public ConsignmentTerminationInfoVO Save(ConsignmentTerminationInfoVO model)
        {
            try
            {
                model = this.CheckApply(model);

                if (model.IsSuccess)
                {
                    using (TransactionScope trans = new TransactionScope())
                    {
                        ConsignmentTerminationDao ContractHeader = new ConsignmentTerminationDao();
                        if (model.IsNewApply)
                        {
                            ContractHeader.InsertConsignmentTerminationSave(model.InstanceId, model.IptConsignContract.ContractId, model.IptReason, model.IptRemark, RoleModelContext.Current.User.Id.ToSafeString(), "",new Guid(model.IptBu.Key));
                        }
                        else
                        {
                            ContractHeader.UpdateConsignmentTerminationSave(model.InstanceId, model.IptConsignContract.ContractId, model.IptReason, model.IptRemark, RoleModelContext.Current.User.Id.ToSafeString(), "");
                        }

                        base.InsertLog("Consignment_TerminationInfo", model.InstanceId.ToSafeGuid(), model.ToLogJsonString(), "草稿", "申请人");

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

        public ConsignmentTerminationInfoVO Delete(ConsignmentTerminationInfoVO model)
        {


            ConsignmentTerminationDao ContractHeader = new ConsignmentTerminationDao();
            try
            {
                ContractHeader.Delete(new Guid(model.InstanceId));

                base.InsertLog("Consignment_TerminationInfo", model.InstanceId.ToSafeGuid(), model.ToLogJsonString(), "删除", "申请人");

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return model;

        }

        private ConsignmentTerminationInfoVO CheckApply(ConsignmentTerminationInfoVO model)
        {
            return model;
        }
    }
}
