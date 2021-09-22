using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess;
using DMS.Model.ViewModel.Promotion;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Lafite.RoleModel.Security;
using DMS.Model;
using DMS.Common.Extention;
using Grapecity.DataAccess.Transaction;
using System.Net;
using System.Data;
using System.IO;
using System.Web;
using DMS.Business.EKPWorkflow;
using DMS.Model.EKPWorkflow;

namespace DMS.Business.Promotion
{
    public class PolicyTemplateService : BaseService
    {
        #region Ajax Method

        public PolicyTemplateVO InitPage(PolicyTemplateVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();
                    ProDescriptionDao descritptionDao = new ProDescriptionDao();

                    //初始化
                    Hashtable conditionMain = new Hashtable();
                    conditionMain.Add("UserId", UserInfo.Id);
                    conditionMain.Add("PolicyStyle", model.IptPolicyStyle);
                    conditionMain.Add("PolicyStyleSub", model.IptPolicyStyleSub);
                    conditionMain.Add("PolicyId", model.IptPolicyId);
                    conditionMain.Add("IsTemplate", true);
                    conditionMain.Add("PolicyMode", "Template");
                    policyDao.UpdateProlicyInit(conditionMain);

                    //主信息
                    ProPolicy policyHeader = policyDao.GetUIPolicyHeader(UserInfo.Id);

                    model.IptPromotionState = policyHeader.Status;
                    //促销类型
                    model.IptPolicyStyle = policyHeader.PolicyStyle;
                    model.IptPolicyStyleSub = policyHeader.PolicySubStyle;
                    model.IptProductLine = policyHeader.ProductLineId; //产品线
                    model.IptPeriod = policyHeader.Period; //结算周期
                    model.IptAcquisition = policyHeader.ifCalPurchaseAR == "Y";

                    //选择结算对象
                    model.IptProTo = policyHeader.CalType;

                    //指定类型
                    if (policyHeader.CalType != null && policyHeader.CalType.Equals("ByDealer"))
                    {
                        model.IptProToType = policyHeader.ProDealerType;
                    }

                    model.IptPolicyNo = policyHeader.PolicyNo;
                    model.IptPolicyName = policyHeader.PolicyName;

                    model.IptBeginDate = policyHeader.StartDateTime;

                    model.IptEndDate = policyHeader.EndDateTime;

                    model.IptPolicyGroupName = policyHeader.PolicyGroupName;

                    //促销类型
                    model.IptPolicyStyle = policyHeader.PolicyStyle;
                    model.IptPolicyStyleSub = policyHeader.PolicySubStyle;

                    model.IptPointValidDateType = this.GetPointValidDateType(model.IptPolicyStyle, policyHeader.PointValidDateType, policyHeader.PointValidDateDuration.ToSafeString());

                    model.IptPolicySummary = policyDao.SelectPromotionSummary(model.IptPolicyId, "TemplateSummary");

                    if (model.IptPageType == "Modify" && model.IptPromotionState == SR.PRO_Status_Draft)
                    {
                        model.IsCanEdit = true;
                    }
                    else
                    {
                        model.IsCanEdit = false;
                    }

                    //控件数据
                    model.LstProductLine = this.GetProductLineDataSource();

                    //因素列表
                    ProPolicyFactorUi conditionFactor = new ProPolicyFactorUi();
                    conditionFactor.PolicyId = Convert.ToInt32(model.IptPolicyId);
                    conditionFactor.CurrUser = UserInfo.Id;
                    model.RstFactorList = JsonHelper.DataTableToArrayList(policyDao.QueryUIPolicyFactorAndGift(conditionFactor).Tables[0]);

                    //规则列表
                    Hashtable conditionRule = new Hashtable();
                    conditionRule.Add("CurrUser", UserInfo.Id);
                    conditionRule.Add("PolicyId", model.IptPolicyId);
                    model.RstRuleList = JsonHelper.DataTableToArrayList(policyDao.GetPolicyRuleUi(conditionRule).Tables[0]);

                    //附件
                    Hashtable conditionAttachment = new Hashtable();
                    conditionAttachment.Add("PolicyId", model.IptPolicyId);
                    conditionAttachment.Add("Type", "Policy");
                    model.RstAttachmentList = JsonHelper.DataTableToArrayList(policyDao.QueryPolicyAttachment(conditionAttachment).Tables[0]);

                    model.LstPolicyGeneralDesc = descritptionDao.SelectProDescriptioinList("PolicyGeneral");

                    trans.Complete();
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

        public PolicyTemplateVO ConvertAdvance(PolicyTemplateVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();
                    policyDao.ConvertAdvance(model.IptPolicyId);

                    trans.Complete();
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

        public PolicyTemplateVO Save(PolicyTemplateVO model)
        {
            try
            {
                bool result = true;
                String massage = "";

                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    ProPolicy policy = this.GetPolicyHeader(model);
                    policy.Status = "草稿";

                    result = this.SaveSubmit(policy, "SaveDraft", out massage);

                    model.IptPolicySummary = policyDao.SelectPromotionSummary(model.IptPolicyId, "TemplateSummary");

                    trans.Complete();
                }

                if (result)
                {
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(massage);
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

        public PolicyTemplateVO Preview(PolicyTemplateVO model)
        {
            try
            {
                bool result = true;
                String massage = "";

                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    ProPolicy policy = this.GetPolicyHeader(model);
                    policy.Status = "草稿";

                    result = this.SaveSubmit(policy, "SaveDraft", out massage);

                    model.IptPolicySummary = policyDao.SelectPromotionSummary(model.IptPolicyId, "TemplateSummary");
                    model.IptPolicyPreview = policyDao.GetPolicyHtmlStr(model.IptPolicyId);

                    trans.Complete();
                }

                if (result)
                {
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(massage);
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

        public PolicyTemplateVO Submit(PolicyTemplateVO model)
        {
            try
            {
                bool result = true;
                String massage = "";
                ProPolicy policy = this.GetPolicyHeader(model);
                using (TransactionScope trans = new TransactionScope())
                {
                    policy.Status = "有效";

                    result = this.SaveSubmit(policy, "Submit", out massage);

                    trans.Complete();
                }

                if (result)
                {
                    this.SendEKPEWorkflow(policy);
                    model.IsSuccess = true;

                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(massage);
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

        public PolicyTemplateVO ReloadFactor(PolicyTemplateVO model)
        {
            try
            {
                bool result = true;
                String massage = "";

                using (TransactionScope trans = new TransactionScope())
                {
                    //保存政策
                    if (model.IptPromotionState == "草稿")
                    {
                        ProPolicy policy = this.GetPolicyHeader(model);
                        policy.Status = "草稿";

                        result = this.SaveSubmit(policy, "SaveDraft", out massage);
                    }

                    ProPolicyDao policyDao = new ProPolicyDao();

                    //因素列表
                    ProPolicyFactorUi conditionFactor = new ProPolicyFactorUi();
                    conditionFactor.PolicyId = Convert.ToInt32(model.IptPolicyId);
                    conditionFactor.CurrUser = UserInfo.Id;
                    model.RstFactorList = JsonHelper.DataTableToArrayList(policyDao.QueryUIPolicyFactorAndGift(conditionFactor).Tables[0]);

                    model.IptPolicySummary = policyDao.SelectPromotionSummary(model.IptPolicyId, "TemplateSummary");

                    trans.Complete();

                    result = true;
                }

                if (result)
                {
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(massage);
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

        public PolicyTemplateVO RemoveFactor(PolicyTemplateVO model)
        {
            try
            {
                bool result = true;
                String massage = "";

                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    Hashtable checkCondition = new Hashtable();
                    checkCondition.Add("ConditionPolicyFactorId", model.IptPolicyFactorId);
                    checkCondition.Add("CurrUser", UserInfo.Id);
                    DataTable checkResult = policyDao.GetFactorHasRelation(checkCondition).Tables[0];

                    //判断是否被其他因素关联
                    if (checkResult.Rows.Count == 0)
                    {
                        //该因素是否被规则引用+++++（还没有加）
                        Hashtable checkRuleCondition = new Hashtable();
                        checkRuleCondition.Add("JudgePolicyFactorId", model.IptPolicyFactorId);
                        checkRuleCondition.Add("CurrUser", UserInfo.Id);
                        DataTable checkRuleResult = policyDao.GetPolicyRuleUi(checkRuleCondition).Tables[0];

                        if (checkRuleResult.Rows.Count == 0)
                        {
                            Hashtable deleteCondition = new Hashtable();
                            deleteCondition.Add("PolicyFactorId", model.IptPolicyFactorId);
                            deleteCondition.Add("PolicyId", model.IptPolicyId);
                            deleteCondition.Add("CurrUser", UserInfo.Id);

                            if (model.IptPolicyFactorIsGift == "Y" || model.IptPolicyFactorIsPoint == "Y")
                            {
                                //如实是赠品因素，删除赠品
                                policyDao.DeletePolicyFactorGiftUi(deleteCondition);
                            }
                            //删除政策因素主表
                            policyDao.DeletePolicyFactorUi(deleteCondition);

                            //删除因素规则限制表
                            policyDao.DeleteUIPolicyFactorCondition(deleteCondition);

                            //删除临时表中经销商采购指标
                            policyDao.DeleteBSCSalesProductIndxUi(deleteCondition);

                            //删除临时表中经销商植入指标
                            policyDao.DeleteInHospitalProductIndxUi(deleteCondition);

                            //删除关联因素
                            policyDao.DeletePolicyFactorRelation(deleteCondition);

                            //保存政策
                            if (model.IptPromotionState == "草稿")
                            {
                                ProPolicy policy = this.GetPolicyHeader(model);
                                policy.Status = "草稿";

                                result = this.SaveSubmit(policy, "SaveDraft", out massage);
                            }

                            //因素列表
                            ProPolicyFactorUi conditionFactor = new ProPolicyFactorUi();
                            conditionFactor.PolicyId = Convert.ToInt32(model.IptPolicyId);
                            conditionFactor.CurrUser = UserInfo.Id;
                            model.RstFactorList = JsonHelper.DataTableToArrayList(policyDao.QueryUIPolicyFactorAndGift(conditionFactor).Tables[0]);

                            model.IptPolicySummary = policyDao.SelectPromotionSummary(model.IptPolicyId, "TemplateSummary");

                            result = true;
                        }
                        else
                        {
                            massage = "该参数已被促销规则使用，不能删除";
                            result = false;
                        }
                    }
                    else
                    {
                        massage = "已被其他参数设置为关系参数，不能删除";
                        result = false;
                    }

                    trans.Complete();
                }

                if (result)
                {
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(massage);
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

        public PolicyTemplateVO ReloadRule(PolicyTemplateVO model)
        {
            try
            {
                bool result = true;
                String massage = "";

                using (TransactionScope trans = new TransactionScope())
                {
                    //保存政策
                    if (model.IptPromotionState == "草稿")
                    {
                        ProPolicy policy = this.GetPolicyHeader(model);
                        policy.Status = "草稿";

                        result = this.SaveSubmit(policy, "SaveDraft", out massage);
                    }

                    ProPolicyDao policyDao = new ProPolicyDao();

                    //规则列表
                    Hashtable conditionRule = new Hashtable();
                    conditionRule.Add("CurrUser", UserInfo.Id);
                    conditionRule.Add("PolicyId", model.IptPolicyId);
                    model.RstRuleList = JsonHelper.DataTableToArrayList(policyDao.GetPolicyRuleUi(conditionRule).Tables[0]);

                    model.IptPolicySummary = policyDao.SelectPromotionSummary(model.IptPolicyId, "TemplateSummary");

                    trans.Complete();

                    result = true;
                }

                if (result)
                {
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(massage);
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

        public PolicyTemplateVO RemoveRule(PolicyTemplateVO model)
        {
            try
            {
                bool result = true;
                String massage = "";

                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    Hashtable condition = new Hashtable();
                    condition.Add("RuleId", model.IptPolicyRuleId);
                    condition.Add("PolicyId", model.IptPolicyId);
                    condition.Add("CurrUser", UserInfo.Id);

                    //删除赠送规则主表
                    policyDao.DeletePolicyRuleUi(condition);

                    //删除赠送规则明细表
                    policyDao.DeleteFactorRuleConditionUi(condition);

                    //保存政策
                    if (model.IptPromotionState == "草稿")
                    {
                        ProPolicy policy = this.GetPolicyHeader(model);
                        policy.Status = "草稿";

                        result = this.SaveSubmit(policy, "SaveDraft", out massage);
                    }

                    //规则列表
                    Hashtable conditionRule = new Hashtable();
                    conditionRule.Add("CurrUser", UserInfo.Id);
                    conditionRule.Add("PolicyId", model.IptPolicyId);
                    model.RstRuleList = JsonHelper.DataTableToArrayList(policyDao.GetPolicyRuleUi(conditionRule).Tables[0]);

                    model.IptPolicySummary = policyDao.SelectPromotionSummary(model.IptPolicyId, "TemplateSummary");

                    result = true;

                    trans.Complete();
                }

                if (result)
                {
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(massage);
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

        public PolicyTemplateVO ReloadAttachment(PolicyTemplateVO model)
        {
            try
            {
                bool result = true;
                String massage = "";

                using (TransactionScope trans = new TransactionScope())
                {
                    //保存政策
                    if (model.IptPromotionState == "草稿")
                    {
                        ProPolicy policy = this.GetPolicyHeader(model);
                        policy.Status = "草稿";

                        result = this.SaveSubmit(policy, "SaveDraft", out massage);
                    }

                    ProPolicyDao policyDao = new ProPolicyDao();

                    Hashtable obj = new Hashtable();
                    obj.Add("CurrUser", UserInfo.Id);
                    obj.Add("PolicyId", model.IptPolicyId);

                    DataSet ds = policyDao.QueryPolicyAttachment(obj);
                    model.RstAttachmentList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                    model.IptPolicySummary = policyDao.SelectPromotionSummary(model.IptPolicyId, "TemplateSummary");

                    result = true;

                    trans.Complete();
                }

                if (result)
                {
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(massage);
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

        public PolicyTemplateVO RemoveAttachment(PolicyTemplateVO model)
        {
            try
            {
                bool result = true;
                String massage = "";

                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    policyDao.DeletePolicyAttachment(model.IptAttachmentId);
                    //物理删除
                    string uploadFile = HttpContext.Current.Request.PhysicalApplicationPath + "/Upload/UploadFile/Promotion";
                    File.Delete(uploadFile + "/" + model.IptAttachmentName);

                    //保存政策
                    if (model.IptPromotionState == "草稿")
                    {
                        ProPolicy policy = this.GetPolicyHeader(model);
                        policy.Status = "草稿";

                        result = this.SaveSubmit(policy, "SaveDraft", out massage);
                    }

                    //附件
                    Hashtable conditionAttachment = new Hashtable();
                    conditionAttachment.Add("PolicyId", model.IptPolicyId);
                    conditionAttachment.Add("Type", "Policy");
                    model.RstAttachmentList = JsonHelper.DataTableToArrayList(policyDao.QueryPolicyAttachment(conditionAttachment).Tables[0]);

                    model.IptPolicySummary = policyDao.SelectPromotionSummary(model.IptPolicyId, "TemplateSummary");

                    result = true;

                    trans.Complete();
                }

                if (result)
                {
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(massage);
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

        public PolicyTemplateVO ReloadSummary(PolicyTemplateVO model)
        {
            try
            {
                bool result = true;
                String massage = "";

                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    ProPolicy policy = this.GetPolicyHeader(model);
                    policy.Status = "草稿";

                    result = this.SaveSubmit(policy, "SaveDraft", out massage);

                    model.IptPolicySummary = policyDao.SelectPromotionSummary(model.IptPolicyId, "TemplateSummary");

                    trans.Complete();
                }

                if (result)
                {
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(massage);
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

        #region Internal Function

        private ProPolicy GetPolicyHeader(PolicyTemplateVO model)
        {
            ProPolicyDao policyDao = new ProPolicyDao();

            ProPolicy policy = policyDao.GetUIPolicyHeader(UserInfo.Id);

            //产品线
            policy.ProductLineId = model.IptProductLine;
            //结算对象
            policy.CalType = policy.PolicyType == "植入赠" ? model.IptProTo : "ByDealer";
            //指定类型
            policy.ProDealerType = model.IptProToType;
            //政策编号
            policy.PolicyNo = model.IptPolicyNo;
            //政策名称
            policy.PolicyName = model.IptPolicyName;
            //开始时间
            policy.StartDate = model.IptBeginDate == null ? null : model.IptBeginDate.ToSafeDateTime().To_yyyyMM();
            //终止时间
            policy.EndDate = model.IptEndDate == null ? null : model.IptEndDate.ToSafeDateTime().To_yyyyMM();
            //分组名称
            policy.PolicyGroupName = model.IptPolicyGroupName;
            //政策ID
            policy.PolicyId = model.IptPolicyId.ToSafeInt();
            policy.ModifyBy = UserInfo.Id;
            policy.ModifyDate = DateTime.Now;
            //经销商结算周期
            policy.Period = model.IptPeriod;
            //计入返利与达成
            policy.ifCalPurchaseAR = model.IptAcquisition ? "Y" : "N";

            if (policy.PolicyStyle != null && model.IptPolicyStyle == "积分")
            {
                if (model.IptPointValidDateType == "Year")
                {
                    //一/二级积分效期
                    policy.PointValidDateType = "AbsoluteDate";
                    //跨度
                    policy.PointValidDateDuration = null;
                    //日期
                    if (model.IptBeginDate == null)
                    {
                        policy.PointValidDateAbsolute = null;
                    } else
                    {
                        policy.PointValidDateAbsolute = new DateTime(model.IptEndDate.ToSafeDateTime().AddYears(1).Year, 3, 31);
                    }
                }
                else if (model.IptPointValidDateType == "HalfYear")
                {
                    //一/二级积分效期
                    policy.PointValidDateType = "AccountMonth";
                    //跨度
                    policy.PointValidDateDuration = 6;
                    //日期
                    policy.PointValidDateAbsolute = null;
                }
                else if (model.IptPointValidDateType == "Quarter")
                {
                    //一/二级积分效期
                    policy.PointValidDateType = "AccountMonth";
                    //跨度
                    policy.PointValidDateDuration = 3;
                    //日期
                    policy.PointValidDateAbsolute = null;
                }
            }
            else
            {
                //一/二级积分效期
                policy.PointValidDateType = null;
                //跨度
                policy.PointValidDateDuration = null;
                //日期
                policy.PointValidDateAbsolute = null;
            }

            return policy;
        }

        private bool SaveSubmit(ProPolicy policy, String Type, out String massage)
        {
            ProPolicyDao policyDao = new ProPolicyDao();

            bool Rtn = true;
            massage = "";

            //保存临时表
            //1. 保存临时表
            policyDao.UpdatePolicyUi(policy);
            //2. 保存授权类型
            Hashtable policyDealer = new Hashtable();
            policyDealer.Add("PolicyId", policy.PolicyId);
            policyDealer.Add("OperType", "包含");
            policyDealer.Add("CreateBy", UserInfo.Id);
            policyDealer.Add("CreateTime", DateTime.Now);
            policyDealer.Add("ModifyBy", UserInfo.Id);
            policyDealer.Add("ModifyDate", DateTime.Now);
            policyDealer.Add("CurrUser", UserInfo.Id);
            if (policy.ProDealerType != null && policy.ProDealerType == "ByAuth")
            {
                policyDealer.Add("WithType", "ByAuth");
                policyDao.InsertPolicyDealerByAuth(policyDealer);
            }
            else
            {
                policyDealer.Add("WithType", "ByAuth");
                policyDao.DeletePolicyDealerByAuth(policyDealer);
            }

            //保存临时表到正式表
            Hashtable condition = new Hashtable();
            condition.Add("UserId", UserInfo.Id);
            condition.Add("Command", Type);
            condition.Add("Result", string.Empty);
            if (Type == "SaveDraft")
            {
                if (policyDao.SubmintPolicy(condition) == "Failed")
                {
                    massage = "保存草稿失败";
                    Rtn = false;
                }
            }
            if (Type == "Submit")
            {
                //1. 校验
                String result = policyDao.SubmintPolicyCheck(condition);
                if (!result.Equals("Success") && !result.Equals("Half")) //Half 表示是没有规制的政策,不计算到最终结果
                {
                    massage = result;
                    Rtn = false;
                }
                else
                {
                    //2. 保存
                    if (policyDao.SubmintPolicy(condition) == "Failed")
                    {
                        massage = "提交审批失败";
                        Rtn = false;
                    }
                }
            }
            return Rtn;
        }

        private void SendEKPEWorkflow(ProPolicy policy)
        {
            EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();
            ProPolicyDao policyDao = new ProPolicyDao();
            string InstanceID = Guid.NewGuid().ToString();
            Hashtable obj = new Hashtable();
            obj.Add("InstanceID", InstanceID);
            obj.Add("PolicyId", policy.PolicyId);
            policyDao.UpdatePromotionPolicyInstanceID(obj);

            DataTable dt = policyDao.GetPromotionPolicyNo(policy.PolicyId.ToString()).Tables[0];
            string PolicyNo = "";
            string BU = "";
            if (dt.Rows.Count > 0)
            {
                PolicyNo = (dt.Rows[0]["PolicyNo"] == null ? "" : dt.Rows[0]["PolicyNo"].ToString());
                BU = (dt.Rows[0]["BU"] == null ? "" : dt.Rows[0]["BU"].ToString());
            }
            ekpBll.DoSubmit(this.UserInfo.LoginId, InstanceID, PolicyNo, "PromotionPolicy", string.Format("{0} 促销政策({1})", PolicyNo, BU), EkpModelId.PromotionPolicy.ToString(), EkpTemplateFormId.PromotionPolicyTemplate.ToString());
        }

        private String GetPointValidDateType(String policyStyle, String type, String duration)
        {
            String dateType = "";

            if (policyStyle == "积分")
            {
                if (type == "AccountMonth" && duration == "6")
                {
                    dateType = "HalfYear";
                }
                else if (type == "AccountMonth" && duration == "3")
                {
                    dateType = "Quarter";
                }
                else if (type == "AbsoluteDate")
                {
                    dateType = "Year";
                }
                else
                {
                    throw new Exception("经销商积分效期格式错误");
                }
            }

            return dateType;
        }

        #endregion
    }
}
