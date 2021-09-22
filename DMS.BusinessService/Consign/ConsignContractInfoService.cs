using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Consign;
using DMS.ViewModel.Common;
using DMS.DataAccess;
using DMS.Business.EKPWorkflow;
using Grapecity.DataAccess.Transaction;
using DMS.Common.Extention;
using Lafite.RoleModel.Security;
using DMS.Model.Data;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.BusinessService.Util;
using DMS.Model;
using DMS.Business;
using DMS.Model.EKPWorkflow;
using DMS.DataAccess.Consignment;
using DMS.ViewModel.Consign.Common;

namespace DMS.BusinessService.Consign
{
    public class ConsignContractInfoService : ABaseBusinessService, IDealerFilterFac
    {
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public ConsignContractInfoVO Init(ConsignContractInfoVO model)
        {
            try
            {

                ContractHeaderDao ContractHeader = new ContractHeaderDao();
                ContractDetailDao ContractDetailDao = new ContractDetailDao();

                model.LstBu = base.GetProductLine();
                model.IsDealer = IsDealer;
                if (model.InstanceId.IsNullOrEmpty())
                {
                    model.IsNewApply = true;
                    model.ViewMode = "Edit";
                    model.InstanceId = Guid.NewGuid().ToSafeString();
                    model.IptApplyBasic = base.CreateDefaultApplyBasic();
                    model.CheckCreateUser = true;
                }
                else
                {
                    model.IsNewApply = false;
                    DataTable ContractInfo = ContractHeader.SelectContractInfo(model.InstanceId);
                    model.ViewMode = ContractInfo.Rows[0]["CCH_Status"].ToString().Equals("Draft") && new Guid(ContractInfo.Rows[0]["CCH_DMA_ID"].ToString()).Equals(base.UserInfo.CorpId.Value) ? "Edit" : "View";

                    string userId = ContractInfo.Rows[0]["CCH_CreateUser"].ToSafeString().ToLower();
                    if (userId == RoleModelContext.Current.User.Id.ToLower())
                    {
                        model.CheckCreateUser = true;
                    }
                    model.IptApplyBasic = new ApplyBasic(ContractInfo.Rows[0]["CCH_CreateDate"].ToSafeString(), ContractInfo.Rows[0]["IDENTITY_NAME"].ToString(), ContractInfo.Rows[0]["CCH_No"].ToString(), ContractInfo.Rows[0]["CCH_Status"].ToString());
                    model.IptProductLine = KeyValueHelper.CreateProductLine(new Guid(ContractInfo.Rows[0]["CCH_ProductLine_BUM_ID"].ToSafeString()));
                    model.IptDealer = KeyValueHelper.CreateDealer(new Guid(ContractInfo.Rows[0]["CCH_DMA_ID"].ToString()));
                    model.IptContractName = ContractInfo.Rows[0]["CCH_Name"].ToString();
                    model.IptConsignmentDay = ContractInfo.Rows[0]["CCH_ConsignmentDay"].ToString();
                    model.IptDelayNumber = ContractInfo.Rows[0]["CCH_DelayNumber"].ToString();
                    model.IptIsFixedMoney = Convert.ToBoolean(ContractInfo.Rows[0]["CCH_IsFixedMoney"]);
                    model.IptIsFixedQty = Convert.ToBoolean(ContractInfo.Rows[0]["CCH_IsFixedQty"]);
                    model.IptIsKB = Convert.ToBoolean(ContractInfo.Rows[0]["CCH_IsKB"]);
                    model.IptIsUseDiscount = Convert.ToBoolean(ContractInfo.Rows[0]["CCH_IsUseDiscount"]);
                    model.IptRemark = ContractInfo.Rows[0]["CCH_Remark"].ToString();
                    model.IptContractDate = new DatePickerRange(ContractInfo.Rows[0].GetSafeDatetimeValue("CCH_BeginDate").To_yyyy_MM_dd(), ContractInfo.Rows[0].GetSafeDatetimeValue("CCH_EndDate").To_yyyy_MM_dd());
                    model.RstContractDetail = JsonHelper.DataTableToArrayList(ContractDetailDao.QueryConsignmentContractDetail(model.InstanceId));

                    model.RstOperationLog = base.GetLog("Consign_ContractInfo", model.InstanceId.ToSafeGuid());
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

        private ConsignContractInfoVO CheckApply(ConsignContractInfoVO model)
        {
            return model;
        }

        public ConsignContractInfoVO Save(ConsignContractInfoVO model)
        {
            try
            {
                model = this.CheckApply(model);

                if (model.IsSuccess)
                {
                    using (TransactionScope trans = new TransactionScope())
                    {
                        ContractHeaderDao ContractHeader = new ContractHeaderDao();
                        ContractDetailDao ContractDetailDao = new ContractDetailDao();


                        Hashtable UPNChecktb = new Hashtable();
                        model.UPNCheck = "";
                        string IptCFN_Property1 = "";
                        for (int j = 0; j < model.IptCFN_Property1.Count; j++)
                        {
                            IptCFN_Property1 += model.IptCFN_Property1[j].ToSafeString()  + ",";
                        }
                        
                        UPNChecktb.Add("Dealer", model.IptDealer.Key);
                        UPNChecktb.Add("ProductLine", model.IptProductLine.Key);
                        UPNChecktb.Add("BeginDate", model.IptContractDate.StartDate);
                        UPNChecktb.Add("EndDate", model.IptContractDate.EndDate);
                        UPNChecktb.Add("IptCFN_Property", IptCFN_Property1);
                        IptCFN_Property1 = ContractHeader.UPNCheck(UPNChecktb);
                        if (!string.IsNullOrEmpty(IptCFN_Property1))
                        {
                            model.UPNCheck = IptCFN_Property1.Replace(",","<br/>");
                            return model;
                        }



                        if (model.IsNewApply)
                        {
                            ContractHeader.InsertConsignContractInfoSave(new Guid(model.InstanceId), model.IptConsignmentDay, model.IptContractDate.StartDate, model.IptContractDate.EndDate, model.IptDealer.Key, model.IptDelayNumber, model.IptIsFixedMoney, model.IptIsFixedQty, model.IptIsKB, model.IptIsUseDiscount, model.IptProductLine.Key, model.IptRemark, model.IptStatus, RoleModelContext.Current.User.Id, model.IptContractName);
                        }
                        else
                        {
                            ContractHeader.UpateConsignContractInfoSave(new Guid(model.InstanceId), model.IptConsignmentDay, model.IptContractDate.StartDate, model.IptContractDate.EndDate, model.IptDealer.Key, model.IptDelayNumber, model.IptIsFixedMoney, model.IptIsFixedQty, model.IptIsKB, model.IptIsUseDiscount, model.IptProductLine.Key, model.IptRemark, model.IptStatus, RoleModelContext.Current.User.Id, model.IptContractName);
                        }
                        ContractDetailDao.Delete(new Guid(model.InstanceId));
                        ContractDetailDao.InsertConsignmentContractDetail(new Guid(model.InstanceId), model.IptCFN_Property1, model.IptType);

                        base.InsertLog("Consign_ContractInfo", model.InstanceId.ToSafeGuid(), model.ToLogJsonString(), "草稿", "申请人");

                        trans.Complete();
                    }

                }

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

        public ConsignContractInfoVO Submit(ConsignContractInfoVO model)
        {
            try
            {
                kmReviewWebserviceBLL ekpBll = new kmReviewWebserviceBLL();
                model = this.CheckApply(model);

                if (model.IsSuccess)
                {
                    using (TransactionScope trans = new TransactionScope())
                    {
                        string Number = "";
                        ContractHeaderDao ContractHeader = new ContractHeaderDao();
                        ContractDetailDao ContractDetailDao = new ContractDetailDao();

                        Hashtable UPNChecktb = new Hashtable();
                        model.UPNCheck = "";
                        string IptCFN_Property1 = "";
                        for (int j = 0; j < model.IptCFN_Property1.Count; j++)
                        {
                            IptCFN_Property1 += model.IptCFN_Property1[j].ToSafeString() + ",";
                        }

                        UPNChecktb.Add("Dealer", model.IptDealer.Key);
                        UPNChecktb.Add("ProductLine", model.IptProductLine.Key);
                        UPNChecktb.Add("BeginDate", model.IptContractDate.StartDate);
                        UPNChecktb.Add("EndDate", model.IptContractDate.EndDate);
                        UPNChecktb.Add("IptCFN_Property", IptCFN_Property1);
                        IptCFN_Property1 = ContractHeader.UPNCheck(UPNChecktb);
                        if (!string.IsNullOrEmpty(IptCFN_Property1))
                        {
                            model.UPNCheck = IptCFN_Property1.Replace(",", "<br/>");
                            return model;
                        }

                        if (model.IsNewApply)
                        {
                            ContractHeader.InsertConsignContractInfoSubmit(new Guid(model.InstanceId), model.IptConsignmentDay, model.IptContractDate.StartDate, model.IptContractDate.EndDate, model.IptDealer.Key, model.IptDelayNumber, model.IptIsFixedMoney, model.IptIsFixedQty, model.IptIsKB, model.IptIsUseDiscount, model.IptProductLine.Key, model.IptRemark, model.IptStatus, RoleModelContext.Current.User.Id, model.IptContractName);
                        }
                        else
                        {
                            ContractHeader.UpateConsignContractInfoSubmit(new Guid(model.InstanceId), model.IptConsignmentDay, model.IptContractDate.StartDate, model.IptContractDate.EndDate, model.IptDealer.Key, model.IptDelayNumber, model.IptIsFixedMoney, model.IptIsFixedQty, model.IptIsKB, model.IptIsUseDiscount, model.IptProductLine.Key, model.IptRemark, model.IptStatus, RoleModelContext.Current.User.Id, model.IptContractName);
                        }
                        ContractDetailDao.Delete(new Guid(model.InstanceId));
                        ContractDetailDao.InsertConsignmentContractDetail(new Guid(model.InstanceId), model.IptCFN_Property1, model.IptType);

                        Number = ContractHeader.GetNumber(new Guid(model.InstanceId));
                        if (!string.IsNullOrEmpty(Number))
                        {
                            string templateId = DictionaryHelper.GetDictionaryNameById("CONST_TemplateId", "ConsignmentContract");
                            if (string.IsNullOrEmpty(templateId))
                            {
                                throw new Exception("OA流程ID未配置！");
                            }
                            ekpBll.DoSubmit(RoleModelContext.Current.User.LoginId, model.InstanceId, Number, "ConsignmentContract", string.Format("{0} {1}寄售合同申请", Number, model.IptDealer.Value)
                            , EkpModelId.ConsignmentContract.ToString(), EkpTemplateFormId.ConsignmentContractTemplate.ToString(),templateId);//
                        }

                        base.InsertLog("Consign_ContractInfo", model.InstanceId.ToSafeGuid(), model.ToLogJsonString(), "提交", "申请人");

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


        public ConsignContractInfoVO Delete(ConsignContractInfoVO model)
        {


            ContractHeaderDao ContractHeader = new ContractHeaderDao();
            ContractDetailDao ContractDetailDao = new ContractDetailDao();
            try
            {
                ContractHeader.Delete(new Guid(model.InstanceId));
                ContractDetailDao.Delete(new Guid(model.InstanceId));

                base.InsertLog("Consign_ContractInfo", model.InstanceId.ToSafeGuid(), model.ToLogJsonString(), "删除", "申请人");

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return model;

        }
        public string Isnull(string Model)
        {
            if (string.IsNullOrEmpty(Model))
            {
                return null;
            }
            else
            {
                return Model.Trim();
            }

        }


        public ConsignContractInfoVO AddDetail(ConsignContractInfoVO model)
        {
            try
            {
                ContractDetailDao contractDetailDao = new ContractDetailDao();

                IList<Hashtable> upnList = new List<Hashtable>();
                IList<Hashtable> setList = new List<Hashtable>();
                if (model.LstUpn != null && model.LstUpn.Count > 0)
                {
                    upnList = contractDetailDao.SelectUPN(new Guid(model.IptProductLine.Key), new Guid(model.IptDealer.Key), model.LstUpn);
                }
                if (model.LstSet != null && model.LstSet.Count > 0)
                {
                    setList = contractDetailDao.SelectSet(new Guid(model.IptProductLine.Key), new Guid(model.IptDealer.Key), model.LstSet);
                }

                foreach (Hashtable set in setList)
                {
                    bool isExists = false;
                    foreach (Hashtable upn in upnList)
                    {
                        if (upn.GetSafeStringValue("Id").Equals(set.GetSafeStringValue("Id")))
                        {
                            isExists = true;
                            break;
                        }
                    }
                    if (!isExists)
                    {
                        upnList.Add(set);
                    }
                }

                model.LstContractDetail = new List<ConsignContractUPN>();
                foreach (Hashtable upn in setList)
                {
                    ConsignContractUPN item = new ConsignContractUPN();
                    item.Id = upn.GetSafeStringValue("CFN_ID");
                    item.CFN_CustomerFaceNbr = upn.GetSafeStringValue("PMA_UPN");
                    item.CFN_Property1 = upn.GetSafeStringValue("CFN_Property1");
                    item.CFN_ChineseName = upn.GetSafeStringValue("CFNS_ChineseName");
                    item.PMA_ConvertFactor = upn.GetSafeStringValue("PMA_ConvertFactor");
                    item.CFN_Property3 = upn.GetSafeStringValue("CFN_Property3");
                    item.Type = upn.GetSafeStringValue("Type");
                    model.LstContractDetail.Add(item);
                }

                foreach (Hashtable upn in upnList)
                {
                    ConsignContractUPN item = new ConsignContractUPN();
                    item.Id = upn.GetSafeStringValue("CFN_ID");
                    item.CFN_CustomerFaceNbr = upn.GetSafeStringValue("PMA_UPN");
                    item.CFN_Property1 = upn.GetSafeStringValue("CFN_Property1");
                    item.CFN_ChineseName = upn.GetSafeStringValue("CFN_ChineseName");
                    item.PMA_ConvertFactor = upn.GetSafeStringValue("PMA_ConvertFactor");
                    item.CFN_Property3 = upn.GetSafeStringValue("CFN_Property3");
                    item.Type = upn.GetSafeStringValue("Type");
                    model.LstContractDetail.Add(item);
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
