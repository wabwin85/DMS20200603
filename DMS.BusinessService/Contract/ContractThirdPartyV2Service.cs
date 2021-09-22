using DMS.Business;
using DMS.Business.Cache;
using DMS.Business.Contract;
using DMS.Business.DataInterface;
using DMS.Business.Excel;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.Contract;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Contract
{
    public class ContractThirdPartyV2Service : ABaseQueryService, IQueryExport
    {
        #region Ajax Method
        IRoleModelContext context = RoleModelContext.Current;
        IThirdPartyDisclosureService thirdPartyDisclosure = new ThirdPartyDisclosureService();
        IContractMasterBLL masterBll = new ContractMasterBLL();
        IDealerMasters dealerMasters = new DealerMasters();
        IMessageBLL messageBll = new MessageBLL();
        IAttachmentBLL attachmentBLL = new AttachmentBLL();
        private DataTable RepeatRemove(DataTable dt)
        {
            //------------去掉重复行---------Start
            DataView dv = new DataView(dt);
            //合并后的数据按合同编号排序
            dv.Sort = "ProductLineId asc";
            string[] columnsArray = { "ProductLineId", "ProductLineName", "DivisionName"};
            //去除所有列都重复的行
            dt = dv.ToTable(true, columnsArray);
            //去掉合同内码列重复的行
            for (int i = 1; i < dt.Rows.Count; i++)
            {
                //执行到每一行都和上一行进行比较，如果期望列的列值相同则删除当前行，同时游标退后一步 
                if (dt.Rows[i]["ProductLineId"].ToString() == dt.Rows[i - 1]["ProductLineId"].ToString())
                {
                    dt.Rows.RemoveAt(i);
                    i--;
                }
            }
            dt.AcceptChanges();
            return dt;
            //------------去掉重复行---------End
        }
        public ContractThirdPartyV2VO Init(ContractThirdPartyV2VO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.HidDealerId))
                {
                    DealerMaster dMaster = dealerMasters.GetDealerMaster(model.HidDealerId.ToSafeGuid());
                    
                    model.DealerType = dMaster.DealerType;
                    model.QryDealerName = dMaster.ChineseName;
                    DataTable dt = dealerMasters.GetDealerProductLine(model.HidDealerId.ToSafeGuid()).Tables[0];
                    model.RstWinProductLine = JsonHelper.DataTableToArrayList(RepeatRemove(dt));

                    //同步合同信息到第三方披露表上
                    thirdPartyDisclosure.SynchronousHospitalToThirdParty(model.HidDealerId.ToSafeGuid());
                    
                }

                if (!context.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                {
                    model.DisableFlag = true;
                }
                if (model.DealerType == "T2" && !IsDealer || !context.User.Roles.Contains(SR.Const_UserRole_ChannelOperation) && !IsDealer)
                {
                    model.HideFlag = true;
                }
                
                if (IsDealer)
                {
                    DealerMaster dMaster = dealerMasters.GetDealerMaster(context.User.CorpId.ToSafeGuid());
                    //model.QryDealerName = dMaster.ChineseName;
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

        public ContractThirdPartyV2VO InitDetail(ContractThirdPartyV2VO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.DisclosureId))
                {
                    DataTable ThirdParty = thirdPartyDisclosure.GetThirdPartyDisclosureListById(model.DisclosureId.ToSafeGuid()).Tables[0];
                    if (ThirdParty.Rows.Count > 0)
                    {
                        model.WinPhone = ThirdParty.Rows[0]["Position"].ToString();
                        model.WinSubmitName = ThirdParty.Rows[0]["SubmitterName"].ToString();
                        model.HospitalId = ThirdParty.Rows[0]["HosId"].ToString();
                        model.WinHospitalName = ThirdParty.Rows[0]["HospitalName"].ToString();
                        model.WinCompanyName = ThirdParty.Rows[0]["CompanyName"].ToString();
                        model.WinRsm = new KeyValue(ThirdParty.Rows[0]["Rsm"].ToString(), ThirdParty.Rows[0]["Rsm"].ToString());
                        model.WinApprovalRemark = ThirdParty.Rows[0]["ApprovalRemark"].ToString();
                        model.HidApproveStatus = ThirdParty.Rows[0]["ApprovalStatus"].ToString();
                        model.WinProductLine = ThirdParty.Rows[0]["ProductNameString"].ToString();
                        model.WinApplicationNote = ThirdParty.Rows[0]["ApplicationNote"].ToString();
                        if (ThirdParty.Rows[0]["TerminationDate"].ToString() != "")
                        {
                            model.WinTerminationDate = Convert.ToDateTime(ThirdParty.Rows[0]["TerminationDate"].ToString());
                        }
                        if (model.HidApproveStatus == "申请审批中")
                        {    //平台登录
                            if (ThirdParty.Rows[0]["DealerType"].ToString() == "T2" && RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                            {
                                model.LPLogin = true;
                                model.EnableApproveRemark = true;
                            }
                            //管理员登录
                            if (ThirdParty.Rows[0]["DealerType"].ToString() != "T2" && !IsDealer && RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                            {
                                model.AdminLogin = true;
                                model.EnableApproveRemark = true;
                            }
                            if (ThirdParty.Rows[0]["DMA_ID"].ToString() == context.User.CorpId.ToString())
                            {
                                model.DealerLogin = true;
                            }

                        }
                        if (model.HidApproveStatus == "申请审批通过")
                        {

                            model.WinBeginDate = Convert.ToDateTime(ThirdParty.Rows[0]["BeginDate"].ToString());
                            model.WinEndDate = Convert.ToDateTime(ThirdParty.Rows[0]["EndDate"].ToString());
                            if (ThirdParty.Rows[0]["DealerType"].ToString() != "T2" && !IsDealer && RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation) || ThirdParty.Rows[0]["DealerType"].ToString() == "T2" && RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                            {
                                if (DateTime.Compare(DateTime.Now, model.WinEndDate) < 0)
                                {
                                    model.BtnApproveText = "终止披露";
                                    model.ShowApprove = true;
                                    model.ShowTermDate = true;

                                }
                                model.ShowRenew = true;
                            }
                            if (ThirdParty.Rows[0]["DMA_ID"].ToString() == context.User.CorpId.ToString())
                            {
                                if (DateTime.Compare(DateTime.Now, model.WinEndDate) < 0)
                                {
                                    model.ShowEndThird = true;
                                }
                                model.ShowRenew = true;
                            }
                            
                        }
                        
                        if (model.HidApproveStatus == "终止申请审批中")
                        {
                            model.WinBeginDate = Convert.ToDateTime(ThirdParty.Rows[0]["BeginDate"].ToString());
                            model.WinEndDate = Convert.ToDateTime(ThirdParty.Rows[0]["EndDate"].ToString());
                            if (ThirdParty.Rows[0]["DealerType"].ToString() == "T2" && RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                            {
                                model.BtnApproveText = "终止披露审批通过";
                                model.ShowApprove = true;//终止披露审批通过
                                model.ShowRefuseEnd = true;//终止披露审批拒绝
                                model.EnableApproveRemark = true;

                            }
                            if (ThirdParty.Rows[0]["DealerType"].ToString() != "T2" && !IsDealer && RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                            {
                                model.BtnApproveText = "终止披露审批通过";
                                model.ShowApprove = true;//终止披露审批通过
                                model.ShowRefuseEnd = true;//终止披露审批拒绝
                                model.EnableApproveRemark = true;
                            }

                        }
                        
                    }
                    
                }
                else
                {
                    if (context.User.CorpType != null && context.User.CorpType.Equals(DealerType.LP.ToString()) && model.DealerType.ToSafeString() == "T2" || model.DealerType.ToSafeString() != "T2" && !IsDealer && RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                    {
                        model.BtnSubmitText = "披露提交";
                    }

                    Hashtable hs = new Hashtable();
                    hs.Add("DmaId", model.HidDealerId.ToSafeString());
                    DataSet dt = thirdPartyDisclosure.Authorinformation(hs);
                    if (dt.Tables[0].Rows.Count > 0)
                    {
                        model.WinSubmitName = dt.Tables[0].Rows[0]["TDL_SubmitterName"].ToString();
                        model.WinPhone = dt.Tables[0].Rows[0]["TDL_Position"].ToString();
                    }
                    model.DisclosureId = Guid.NewGuid().ToSafeString();
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

        public string QueryAutHosp(ContractThirdPartyV2VO model)
        {
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("DmaId", model.HidDealerId.ToSafeString());
                if (!string.IsNullOrEmpty(model.QryHospitalName))
                {
                    obj.Add("HospitalName", model.QryHospitalName.ToSafeString());
                }

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = thirdPartyDisclosure.DealerAuthorizationHospital(obj, start, model.PageSize, out totalCount);
                model.RstAutHospList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstAutHospList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        public string QueryPubHosp(ContractThirdPartyV2VO model)
        {
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("DmaId", model.HidDealerId.ToSafeString());
                if (!string.IsNullOrEmpty(model.QryHospitalName))
                {
                    obj.Add("HospitalName", model.QryHospitalName.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryType.Key))
                {
                    obj.Add("type", model.QryType.Key.ToSafeString());
                }

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = thirdPartyDisclosure.ThirdPartylist(obj, start, model.PageSize, out totalCount);
                model.RstPubHospList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstPubHospList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        public string QueryAttach(ContractThirdPartyV2VO model)
        {
            try
            {
                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = attachmentBLL.GetAttachmentByMainId(model.DisclosureId.ToSafeGuid(), AttachmentType.HospitalThirdPart, start, model.PageSize, out totalCount);
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

        public ContractThirdPartyV2VO DeleteAttach(ContractThirdPartyV2VO model)
        {
            try
            {
                //逻辑删除
                attachmentBLL.DelAttachment(model.DeleteId.ToSafeGuid());
                if (model.HidType == "old" && model.HidDealerId == context.User.CorpId.ToString() && model.HidType != "new")
                {
                    ChangeAttachment("EMAIL_ThirdParty_ChangeAttachment_LPCO", model);

                }
                if (context.User.CorpType != null && context.User.CorpType.Equals(DealerType.LP.ToString())
                      && model.DealerType == "T2" && model.HidType != "new" || model.DealerType != "T2" && !IsDealer && context.User.Roles.Contains(SR.Const_UserRole_ChannelOperation) && model.HidType != "new")
                {
                    SandMailApproval("ChangeAttachment", "EMAIL_ThirdParty_ChangeAttachment_LPT2", model);

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

        public ContractThirdPartyV2VO EndThirdPartylist(ContractThirdPartyV2VO model)
        {
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("Id", model.DisclosureId.ToSafeString());
                obj.Add("ApprovalStatus", "终止申请审批中");
                obj.Add("ApplicationNote", model.WinApplicationNote.ToSafeString());
                obj.Add("TerminationDate", model.WinTerminationDate.ToShortDateString());


                thirdPartyDisclosure.RefuseThirdPartyDisclosureList(obj);
                ChangeAttachment("EMAIL_ThirdPartyEnd_LPCO", model);
                SandMailAudit(model);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ContractThirdPartyV2VO RenewSubmit(ContractThirdPartyV2VO model)
        {
            try
            {
                string massage = "";
                ThirdPartyDisclosureList ThirdParty = new ThirdPartyDisclosureList();
                string resful = string.Empty;
                string detailId = string.Empty;
                Verification(model, model.HospitalId.ToSafeString(), model.WinCompanyName.ToSafeString(), model.WinProductLine.ToSafeString(), "申请审批中", model.WinRsm.Key.ToSafeString(), out resful, out detailId);
                if (resful == "true")
                {
                    massage += "当前披露在审批中不允许重复提交申请<br/>";
                }
                if (massage == "")
                {
                    if (context.User.CorpType != null && context.User.CorpType.Equals(DealerType.LP.ToString()) && model.DealerType == "T2" || model.DealerType != "T2" && !IsDealer && context.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                    {

                        ThirdParty.Id = model.DisclosureId.ToSafeGuid();
                        ThirdParty.DmaId = model.HidDealerId.ToSafeGuid();
                        ThirdParty.HosId = model.HospitalId.ToSafeGuid();
                        ThirdParty.CompanyName = model.WinCompanyName.ToSafeString();
                        ThirdParty.Rsm = model.WinRsm.Key.ToSafeString();
                        ThirdParty.CreatUser = context.User.Id.ToSafeGuid();
                        ThirdParty.CreatDate = DateTime.Now;
                        ThirdParty.ProductNameString = model.WinProductLine.ToSafeString();
                        ThirdParty.ApprovalRemark = model.WinApprovalRemark.ToSafeString();
                        ThirdParty.ApprovalUser = context.User.Id.ToSafeGuid();
                        ThirdParty.SubmitterName = model.WinSubmitName.ToSafeString();
                        ThirdParty.Position = model.WinPhone.ToSafeString();
                        ThirdParty.ApprovalStatus = "申请审批通过";
                        ThirdParty.ApprovalDate = DateTime.Now;
                        thirdPartyDisclosure.InsertThirdPartyDisclosureListLp(ThirdParty);
                        //SandMailApproval("Approval", "EMAIL_ThirdParty_Approval");
                        Hashtable obj = new Hashtable();
                        obj.Add("DmaId", model.HidDealerId.ToSafeString());
                        DealerMaster dm = dealerMasters.GetDealerMaster(model.HidDealerId.ToSafeGuid());
                        //DataSet dsb = _thirdPartyDisclosure.SelectThirdPartyDisclosureHospitBU(obj);
                        DataSet dt = thirdPartyDisclosure.ThirdPartyDisclosureListByBU(obj);
                        string Remarks = context.UserName + "在" + DateTime.Now + "对" + dm.ChineseName + ":";
                        string hospital = dt.Tables[0].Rows[0]["HOS_HospitalName"].ToString();
                        string productline = dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() != null ? dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() : "";
                        Remarks += hospital + productline + "," + "申请审批通过";
                        Hashtable logobj = new Hashtable();
                        logobj.Add("ContractUser", context.User.Id);
                        logobj.Add("DMAId", model.HidDealerId.ToSafeString());
                        logobj.Add("Remarks", Remarks);
                        thirdPartyDisclosure.InsertContractLog(logobj);
                        SandMailAudit(model);
                        SandMailApproval("new", "EMAIL_RenewalContract_LPT2", model);
                        if (model.HidApproveStatus == "申请审批通过")
                        {
                            Hashtable hs = new Hashtable();
                            hs.Add("enddate", DateTime.Now);
                            hs.Add("Id", detailId);
                            thirdPartyDisclosure.TerminationThirdPartyList(hs);
                        }
                    }
                    else
                    {
                        ThirdParty.Id = model.DisclosureId.ToSafeGuid();
                        ThirdParty.DmaId = model.HidDealerId.ToSafeGuid();
                        ThirdParty.HosId = model.HospitalId.ToSafeGuid();
                        ThirdParty.CompanyName = model.WinCompanyName.ToSafeString();
                        ThirdParty.Rsm = model.WinRsm.Key.ToSafeString();
                        ThirdParty.CreatUser = context.User.Id.ToSafeGuid();
                        ThirdParty.SubmitterName = model.WinSubmitName.ToSafeString();
                        ThirdParty.Position = model.WinPhone.ToSafeString();
                        ThirdParty.CreatDate = DateTime.Now;
                        ThirdParty.ProductNameString = model.WinProductLine.ToSafeString();
                        ThirdParty.ApprovalStatus = "申请审批中";

                        thirdPartyDisclosure.SaveThirdPartyDisclosureList(ThirdParty);
                        SandMailAudit(model);
                        ChangeAttachment("EMAIL_RenewalContract", model);
                    }
                }
                else
                {
                    throw new Exception(massage);
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

        public ContractThirdPartyV2VO Renew(ContractThirdPartyV2VO model)
        {
            try
            {
                model.DisclosureId = Guid.NewGuid().ToSafeString();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ContractThirdPartyV2VO EndThirdPartylistApprover(ContractThirdPartyV2VO model)
        {
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("Id", model.DisclosureId.ToSafeString());
                obj.Add("ApprovalStatus", "终止申请审批通过");
                obj.Add("ApprovalDate", DateTime.Now);
                obj.Add("ApprovalName", context.User.Id);
                obj.Add("ApprovalRemark", model.WinApprovalRemark.ToSafeString());
                obj.Add("ApplicationNote", model.WinApplicationNote.ToSafeString());
                if (model.WinTerminationDate.ToSafeString() != "")
                {
                    obj.Add("TerminationDate", model.WinTerminationDate.ToShortDateString());
                }

                thirdPartyDisclosure.UpdateThirdPartyDisclosureListend(obj);
                SandMailAudit(model);
                if (model.HidApproveStatus == "申请审批通过")
                {
                    SandMailApproval("new", "EMAIL_ThirdPartyListend_LPT2", model);
                }
                if (model.HidApproveStatus == "终止申请审批中")
                {
                    SandMailApproval("Approval", "EMAIL_ThirdPartyDisclosureList_EndApproval", model);
                }
                obj.Add("DmaId", model.HidDealerId.ToSafeString());
                DealerMaster dm = dealerMasters.GetDealerMaster(model.HidDealerId.ToSafeGuid());
                //DataSet dsb = _thirdPartyDisclosure.SelectThirdPartyDisclosureHospitBU(obj);
                DataSet dt = thirdPartyDisclosure.ThirdPartyDisclosureListByBU(obj);
                string Remarks = context.UserName + "在" + DateTime.Now + "对" + dm.ChineseName + ":";
                string hospital = dt.Tables[0].Rows[0]["HOS_HospitalName"].ToString();
                string productline = dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() != null ? dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() : "";
                Remarks += hospital + productline + "," + "终止申请审批通过";
                Hashtable logobj = new Hashtable();
                logobj.Add("ContractUser", context.User.Id);
                logobj.Add("DMAId", model.HidDealerId.ToSafeString());
                logobj.Add("Remarks", Remarks);
                thirdPartyDisclosure.InsertContractLog(logobj);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ContractThirdPartyV2VO RefuseEndThirdPartylist(ContractThirdPartyV2VO model)
        {
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("Id", model.DisclosureId.ToSafeString());
                obj.Add("ApprovalStatus", "终止申请审批拒绝");
                obj.Add("ApprovalDate", DateTime.Now.ToString());
                obj.Add("ApprovalName", context.User.Id);
                obj.Add("ApprovalRemark", model.WinApprovalRemark.ToSafeString());
                thirdPartyDisclosure.endThirdPartyList(obj);
                SandMailApproval("Reject", "EMAIL_ThirdPartyDisclosureList_EndReject", model);
                obj.Add("DmaId", model.HidDealerId.ToSafeString());
                DealerMaster dm = dealerMasters.GetDealerMaster(model.HidDealerId.ToSafeGuid());
                //DataSet dsb = _thirdPartyDisclosure.SelectThirdPartyDisclosureHospitBU(obj);
                DataSet dt = thirdPartyDisclosure.ThirdPartyDisclosureListByBU(obj);
                string Remarks = context.UserName + "在" + DateTime.Now + "对" + dm.ChineseName + ":";
                string hospital = dt.Tables[0].Rows[0]["HOS_HospitalName"].ToString();
                string productline = dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() != null ? dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() : "";
                Remarks += hospital + productline + "," + "终止申请审批拒绝";
                Hashtable logobj = new Hashtable();
                logobj.Add("ContractUser", context.User.Id);
                logobj.Add("DMAId", model.HidDealerId.ToSafeString());
                logobj.Add("Remarks", Remarks);
                thirdPartyDisclosure.InsertContractLog(logobj);
                SandMailAudit(model);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ContractThirdPartyV2VO Approval(ContractThirdPartyV2VO model)
        {
            try
            {
                string resful = string.Empty;
                string detailId = string.Empty;
                if (model.HidApproveStatus == "")
                {
                    Verification(model, model.HospitalId.ToSafeString(), model.WinCompanyName.ToSafeString(), model.WinProductLine.ToSafeString(), "申请审批通过", model.WinRsm.Key.ToSafeString(), out resful, out detailId);
                }
                if (model.HidApproveStatus == "申请审批中")
                {
                    Verification(model,model.HospitalId.ToSafeString(), model.WinCompanyName.ToSafeString(), model.WinProductLine.ToSafeString(), "申请审批通过", model.WinRsm.Key.ToSafeString(), out resful, out detailId);
                }
                if (resful == "true")
                {
                    Hashtable hs = new Hashtable();
                    
                    hs.Add("hosid", model.HospitalId.ToSafeString());
                    hs.Add("CompanyName", model.WinCompanyName.ToSafeString());
                    hs.Add("rsm", model.WinRsm.Key.ToSafeString());
                    hs.Add("productline", model.WinProductLine);
                    hs.Add("ApprovalStatus", "申请审批通过");
                    hs.Add("dmaid", model.HidDealerId.ToSafeString());
                    thirdPartyDisclosure.updateendThirdPartyList(hs);
                    
                }
                Hashtable obj = new Hashtable();
                obj.Add("Id", model.DisclosureId.ToSafeString());
                obj.Add("ApprovalStatus", "申请审批通过");
                obj.Add("ApprovalDate", DateTime.Now.ToString());
                obj.Add("ApprovalName", context.User.Id);
                obj.Add("ApprovalRemark", model.WinApprovalRemark.ToSafeString());
                thirdPartyDisclosure.ApprovalThirdPartyDisclosureList(obj);

                SandMailAudit(model);
                SandMailApproval("Approval", "EMAIL_ThirdParty_Approval", model);
                obj.Add("DmaId", model.HidDealerId.ToSafeString());
                DealerMaster dm = dealerMasters.GetDealerMaster(model.HidDealerId.ToSafeGuid());
                //DataSet dsb = _thirdPartyDisclosure.SelectThirdPartyDisclosureHospitBU(obj);
                DataSet dt = thirdPartyDisclosure.ThirdPartyDisclosureListByBU(obj);
                string Remarks = context.UserName + "在" + DateTime.Now + "对" + dm.ChineseName + ":";
                string hospital = dt.Tables[0].Rows[0]["HOS_HospitalName"].ToString();
                string productline = dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() != null ? dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() : "";
                Remarks += hospital + productline + "," + "申请审批通过";
                Hashtable logobj = new Hashtable();
                logobj.Add("ContractUser", context.User.Id);
                logobj.Add("DMAId", model.HidDealerId.ToSafeString());
                logobj.Add("Remarks", Remarks);
                thirdPartyDisclosure.InsertContractLog(logobj);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ContractThirdPartyV2VO Reject(ContractThirdPartyV2VO model)
        {
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("Id", model.DisclosureId.ToSafeString());
                obj.Add("ApprovalStatus", "申请审批拒绝");
                obj.Add("ApprovalDate", DateTime.Now.ToString());
                obj.Add("ApprovalName", context.User.Id);
                obj.Add("ApprovalRemark", model.WinApprovalRemark.ToSafeString());
                thirdPartyDisclosure.RefuseThirdPartyDisclosureList(obj);
                SandMailAudit(model);
                SandMailApproval("Reject", "EMAIL_ThirdParty_Reject", model);
                obj.Add("DmaId", model.HidDealerId.ToSafeString());
                DealerMaster dm = dealerMasters.GetDealerMaster(model.HidDealerId.ToSafeGuid());
                //DataSet dsb = _thirdPartyDisclosure.SelectThirdPartyDisclosureHospitBU(obj);
                DataSet dt = thirdPartyDisclosure.ThirdPartyDisclosureListByBU(obj);
                string Remarks = context.UserName + "在" + DateTime.Now + "对" + dm.ChineseName + ":";
                string hospital = dt.Tables[0].Rows[0]["HOS_HospitalName"].ToString();
                string productline = dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() != null ? dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() : "";
                Remarks += hospital + productline + "," + "申请审批拒绝";
                Hashtable logobj = new Hashtable();
                logobj.Add("ContractUser", context.User.Id);
                logobj.Add("DMAId", model.HidDealerId.ToSafeString());
                logobj.Add("Remarks", Remarks);
                thirdPartyDisclosure.InsertContractLog(logobj);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ContractThirdPartyV2VO SaveThirdParty(ContractThirdPartyV2VO model)
        {
            try
            {
                string massage = "";
                ThirdPartyDisclosureList ThirdParty = new ThirdPartyDisclosureList();

                if (String.IsNullOrEmpty(model.WinCompanyName.ToSafeString()))
                {
                    massage += "请填写公司名称<br/>";
                }
                if (String.IsNullOrEmpty(model.WinRsm.Key.ToSafeString()))
                {
                    massage += "请填写与贵司或医院关系<br/>";
                }
                if (String.IsNullOrEmpty(model.WinProductLine.ToSafeString()))
                {
                    massage += "请选择合作的产品线<br/>";
                }
                if (String.IsNullOrEmpty(model.WinPhone.ToSafeString()))
                {
                    massage += "请填写提交人手机<br/>";
                }
                if (String.IsNullOrEmpty(model.WinSubmitName.ToSafeString()))
                {
                    massage += "请填写提交人姓名/职务<br/>";
                }
                string resful = string.Empty;
                string detailId = string.Empty;
                Verification(model, model.HospitalId.ToSafeString(), model.WinCompanyName.ToSafeString(), model.WinProductLine.ToSafeString(), "申请审批中", model.WinRsm.Key.ToSafeString(), out resful, out detailId);
                if (resful == "true")
                {
                    massage += "具有相同的披露在审批中，不允许重复提交申请<br/>";
                }
                
                if (massage == "")
                {
                    //Create
                    if (model.HidType.ToSafeString() == "new")
                    {
                        if (context.User.CorpType != null && context.User.CorpType.Equals(DealerType.LP.ToString()) && model.DealerType == "T2" || model.DealerType != "T2" && !IsDealer && context.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                        {
                            Verification(model, model.HospitalId.ToSafeString(), model.WinCompanyName.ToSafeString(), model.WinProductLine.ToSafeString(), "申请审批通过", model.WinRsm.Key.ToSafeString(), out resful, out detailId);
                            if (resful == "true")
                            {
                                Hashtable hs = new Hashtable();
                                
                                hs.Add("hosid", model.HospitalId.ToSafeString());
                                hs.Add("CompanyName", model.WinCompanyName.ToSafeString());
                                hs.Add("rsm", model.WinRsm.Key.ToSafeString());
                                hs.Add("productline", model.WinProductLine.ToSafeString());
                                hs.Add("ApprovalStatus", "申请审批通过");
                                hs.Add("dmaid", model.HidDealerId.ToSafeString());
                                thirdPartyDisclosure.updateendThirdPartyList(hs);

                            }
                            
                            ThirdParty.Id = model.DisclosureId.ToSafeGuid();
                            ThirdParty.DmaId = model.HidDealerId.ToSafeGuid();
                            //ThirdParty.ProductLineId = new Guid(this.hdProductLineId.Value.ToString());
                            ThirdParty.HosId = model.HospitalId.ToSafeGuid();
                            ThirdParty.CompanyName = model.WinCompanyName.ToSafeString();
                            ThirdParty.Rsm = model.WinRsm.Key.ToSafeString();
                            ThirdParty.CreatUser = new Guid(context.User.Id);
                            ThirdParty.CreatDate = DateTime.Now;
                            ThirdParty.ProductNameString = model.WinProductLine.ToSafeString();
                            ThirdParty.ApprovalDate = DateTime.Now;
                            ThirdParty.Position = model.WinPhone.ToSafeString();
                            ThirdParty.SubmitterName = model.WinSubmitName.ToSafeString();
                            ThirdParty.ApprovalRemark = model.WinApprovalRemark.ToSafeString();
                            ThirdParty.ApplicationNote = model.WinApplicationNote.ToSafeString();
                            ThirdParty.ApprovalUser = new Guid(context.User.Id);
                            ThirdParty.ApprovalStatus = "申请审批通过";
                            thirdPartyDisclosure.InsertThirdPartyDisclosureListLp(ThirdParty);
                            //SandMailApproval("Approval", "EMAIL_ThirdParty_Approval");
                            
                            Hashtable obj = new Hashtable();
                            obj.Add("DmaId", model.HidDealerId.ToSafeString());
                            DealerMaster dm = dealerMasters.GetDealerMaster(model.HidDealerId.ToSafeGuid());
                            //DataSet dsb = _thirdPartyDisclosure.SelectThirdPartyDisclosureHospitBU(obj);
                            DataSet dt = thirdPartyDisclosure.ThirdPartyDisclosureListByBU(obj);
                            string Remarks = context.UserName + "在" + DateTime.Now + "对" + dm.ChineseName + ":";
                            string hospital = dt.Tables[0].Rows[0]["HOS_HospitalName"].ToString();
                            string productline = dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() != null ? dt.Tables[0].Rows[0]["TDL_ProductNameString"].ToString() : "";
                            Remarks += hospital + productline + "," + "申请审批通过";
                            Hashtable logobj = new Hashtable();
                            logobj.Add("ContractUser", context.User.Id);
                            logobj.Add("DMAId", model.HidDealerId.ToSafeString());
                            logobj.Add("Remarks", Remarks);
                            thirdPartyDisclosure.InsertContractLog(logobj);
                            SandMailApproval("new", "EMAIL_ThirdPartyListinsert_LPT2", model);
                            SandMailAudit(model);
                            
                        }
                        else
                        {
                            ThirdParty.Id = model.DisclosureId.ToSafeGuid();
                            ThirdParty.DmaId = model.HidDealerId.ToSafeGuid();
                            ThirdParty.HosId = model.HospitalId.ToSafeGuid();
                            ThirdParty.CompanyName = model.WinCompanyName.ToSafeString();
                            ThirdParty.Rsm = model.WinRsm.Key.ToSafeString();
                            ThirdParty.CreatUser = new Guid(this.context.User.Id);
                            ThirdParty.Position = model.WinPhone.ToSafeString();
                            ThirdParty.SubmitterName = model.WinSubmitName.ToSafeString();
                            ThirdParty.CreatDate = DateTime.Now;
                            ThirdParty.ProductNameString = model.WinProductLine.ToSafeString();
                            ThirdParty.ApplicationNote = model.WinApplicationNote.ToSafeString();
                            ThirdParty.ApprovalStatus = "申请审批中";
                            
                            thirdPartyDisclosure.SaveThirdPartyDisclosureList(ThirdParty);
                            ChangeAttachment("EMAIL_ThirdPartyInsert_LPCO", model);
                            SandMailAudit(model);
                        }
                    }
                }
                else
                {
                    throw new Exception(massage);
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

            if (!string.IsNullOrEmpty(Parameters["DealerId"].ToSafeString()))
            {
                param.Add("DmaId", Parameters["DealerId"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["HospitalName"].ToSafeString()))
            {
                param.Add("HospitalName", Parameters["HospitalName"].ToSafeString());
            }
            
            DataSet ds = thirdPartyDisclosure.ExportThirdPartylist(param);
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

        #region 邮件/验证相关方法
        public void ChangeAttachment(string MessageTemplatelpco, ContractThirdPartyV2VO model)
        {

            Hashtable obj = new Hashtable();
            obj.Add("DmaId", model.HidDealerId.ToSafeString());
            obj.Add("MainId", model.DisclosureId.ToSafeString());
            DataTable dsb = thirdPartyDisclosure.SelectThirdPartyDisclosureListHospitBU(obj).Tables[0];
            string hospital = dsb.Rows[0]["HospitalName"].ToString();
            string bu = dsb.Rows[0]["ProductNameString"].ToString();
            string CompanyName = dsb.Rows[0]["CompanyName"].ToString();
            string DMA_ChineseName = dsb.Rows[0]["DMA_ChineseName"].ToString();

            DealerMaster dMaster = dealerMasters.GetDealerMaster(model.HidDealerId.ToSafeGuid());
            MailMessageTemplate mailMessage = null;
            IList<MailDeliveryAddress> Addresslist = null;
            if (dMaster.DealerType.ToSafeString().Equals(DealerType.T2.ToString()))
            {
                mailMessage = messageBll.GetMailMessageTemplate(MessageTemplatelpco);

                Hashtable tbaddress = new Hashtable();
                tbaddress.Add("MailType", "DCMS");
                tbaddress.Add("DealerId", model.HidDealerId.ToSafeString());
                Addresslist = masterBll.GetLPMailDeliveryAddressByDealerId(tbaddress);
            }
            else
            {
                mailMessage = messageBll.GetMailMessageTemplate(MessageTemplatelpco);
                Hashtable tbaddress = new Hashtable();
                tbaddress.Add("MailType", "Role");
                tbaddress.Add("MailTo", SR.Const_UserRole_ChannelOperation);
                Addresslist = masterBll.GetMailDeliveryAddress(tbaddress);
            }

            //发邮件给平台和CO
            Hashtable hasButype = new Hashtable();
            hasButype.Add("DmaId", model.HidDealerId.ToSafeString());
            DataTable dtButype = thirdPartyDisclosure.GetThirdPartyDisclosureListBuType(hasButype).Tables[0];
            DataRow drButype = null;
            if (dtButype.Rows.Count > 0)
            {
                drButype = dtButype.Rows[0];
            }
            string titalSubject = mailMessage.Subject;
            if (drButype != null && drButype[0] != null && drButype[0].ToString() != "")
            {
                titalSubject += ("(" + drButype[0].ToString() + ")");
            }
            
            if (Addresslist != null && Addresslist.Count > 0)
            {
                //发邮件通知CO确认IAF信息
                foreach (MailDeliveryAddress mailAddress in Addresslist)
                {
                    MailMessageQueue mail = new MailMessageQueue();
                    mail.Id = Guid.NewGuid();
                    mail.QueueNo = "email";
                    mail.From = "";
                    mail.To = mailAddress.MailAddress;
                    mail.Subject = titalSubject.Replace("{#Delertype}", model.DealerType.ToSafeString());
                    mail.Body = mailMessage.Body.Replace("{#DealerName}", DMA_ChineseName).Replace("{#hospital}", hospital).Replace("{#CompanyName}", CompanyName).Replace("{#ProductNameString}", bu);
                    mail.CreateDate = DateTime.Now;
                    mail.Status = "Waiting";
                    messageBll.AddToMailMessageQueue(mail);
                }
            }

        }

        public void SandMailApproval(string Type, string MessageTemplate, ContractThirdPartyV2VO model)
        {
            MailMessageTemplate mailMessage = null;
            if (Type == "Reject")
            {
                mailMessage = messageBll.GetMailMessageTemplate(MessageTemplate);
            }
            else if (Type == "Approval")
            {
                mailMessage = messageBll.GetMailMessageTemplate(MessageTemplate);
            }
            else if (Type == "ChangeAttachment")
            {
                mailMessage = messageBll.GetMailMessageTemplate(MessageTemplate);
            }
            else if (Type == "new")
            {

                mailMessage = messageBll.GetMailMessageTemplate(MessageTemplate);

            }
            string role = "";
            DealerMaster dealermaster = dealerMasters.GetDealerMaster(model.HidDealerId.ToSafeGuid());

            if (!IsDealer)
            {
                role = "波科渠道管理员";
            }
            else
            {
                role = model.QryDealerName.ToSafeString();
            }
            if (!dealermaster.Email.ToString().Equals(""))
            {
                MailMessageQueue mail = new MailMessageQueue();
                mail.Id = Guid.NewGuid();
                mail.QueueNo = "email";
                mail.From = "";
                mail.To = dealermaster.Email.ToString();
                mail.Subject = mailMessage.Subject.Replace("{#role}", role);
                mail.Body = mailMessage.Body.Replace("{#DealerName}", model.QryDealerName.ToSafeString()).Replace("{#Hospital}", model.WinHospitalName.ToSafeString()).Replace("{#ProductNameString}", model.WinProductLine.ToSafeString()).Replace("{#CompanyName}", model.WinCompanyName.ToSafeString()).Replace("{#role}", role);
                mail.Status = "Waiting";
                mail.CreateDate = DateTime.Now;
                messageBll.AddToMailMessageQueue(mail);
            }
        }

        public void SandMailAudit(ContractThirdPartyV2VO model)
        {
            MailMessageTemplate mailMessage = messageBll.GetMailMessageTemplate("EMAIL_ThirdParty_ChangeNotice_Audit");

            Hashtable tbaddress = new Hashtable();
            tbaddress.Add("MailType", "DCMS");
            tbaddress.Add("MailTo", "Audit");
            IList<MailDeliveryAddress> Addresslist = masterBll.GetMailDeliveryAddress(tbaddress);
            SendMail(mailMessage, Addresslist, model);
        }

        private void SendMail(MailMessageTemplate mailMessage, IList<MailDeliveryAddress> Addresslist, ContractThirdPartyV2VO model)
        {
            Hashtable hasButype = new Hashtable();
            hasButype.Add("DmaId", model.HidDealerId.ToSafeString());
            DataTable dtButype = thirdPartyDisclosure.GetThirdPartyDisclosureListBuType(hasButype).Tables[0];
            DataRow drButype = null;
            if (dtButype.Rows.Count > 0)
            {
                drButype = dtButype.Rows[0];
            }
            string titalSubject = mailMessage.Subject;
            if (drButype != null && drButype[0] != null && drButype[0].ToString() != "")
            {
                titalSubject += ("(" + drButype[0].ToString() + ")");
            }
            //发邮件给平台或者CO时，需要添加该医院所属BU信息    LIJIE ADD 20160816
            Hashtable obj = new Hashtable();
            obj.Add("ID", model.DisclosureId.ToSafeString());
            DataTable dsb = thirdPartyDisclosure.ThirdPartyDisclosureListALL(obj).Tables[0];

            if (dsb.Rows.Count > 0)
            {

                string ProductNameString = dsb.Rows[0]["TDL_ProductNameString"].ToString();
                string HospitalName = dsb.Rows[0]["HOS_HospitalName"].ToString();
                string CompanyName = dsb.Rows[0]["TDL_CompanyName"].ToString();
                
                if (Addresslist != null && Addresslist.Count > 0)
                {
                    //发邮件通知CO确认IAF信息
                    foreach (MailDeliveryAddress mailAddress in Addresslist)
                    {
                        MailMessageQueue mail = new MailMessageQueue();
                        mail.Id = Guid.NewGuid();
                        mail.QueueNo = "email";
                        mail.From = "";
                        mail.To = mailAddress.MailAddress;
                        mail.Subject = titalSubject;
                        mail.Body = mailMessage.Body.Replace("{#DealerName}", model.QryDealerName.ToSafeString()).Replace("{#hospital}", HospitalName).Replace("{#ProductNameString}", ProductNameString).Replace("{#CompanyName}", CompanyName);
                        mail.Status = "Waiting";
                        mail.CreateDate = DateTime.Now;
                        messageBll.AddToMailMessageQueue(mail);
                    }
                }
            }
        }

        public void Verification(ContractThirdPartyV2VO model, string hosid, string CompanyName, string productline, string ApprovalStatus, string rsm, out string resful, out string detailId)
        {

            Hashtable hs = new Hashtable();
            hs.Add("hosid", hosid);
            hs.Add("CompanyName", CompanyName);
            hs.Add("productline", productline);
            hs.Add("ApprovalStatus", ApprovalStatus);
            hs.Add("dmaid", model.HidDealerId.ToSafeString());
            hs.Add("rsm", rsm);
            DataTable dt = thirdPartyDisclosure.SelectThirdPartylist(hs).Tables[0];
            if (dt.Rows.Count > 0)
            {
                resful = "true";
                detailId = dt.Rows[0]["TDL_ID"].ToString();
            }
            else
            {
                resful = "false";
                detailId = model.DisclosureId;
            }

        }
        #endregion

    }
}
