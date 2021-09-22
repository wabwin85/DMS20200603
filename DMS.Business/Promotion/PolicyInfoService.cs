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
    public class PolicyInfoService : BaseService
    {
        #region Ajax Method
        private EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();
        IRoleModelContext _context = RoleModelContext.Current;

        public PolicyInfoVO InitPage(PolicyInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();
                    ProDescriptionDao descritptionDao = new ProDescriptionDao();

                    model.IsPageNew = model.IptPolicyId.IsNullOrEmpty().ToSafeString();

                    //初始化
                    Hashtable conditionMain = new Hashtable();
                    conditionMain.Add("UserId", UserInfo.Id);
                    conditionMain.Add("PolicyStyle", model.IptPolicyStyle);
                    conditionMain.Add("PolicyStyleSub", model.IptPolicyStyleSub);
                    if (!model.IptPolicyId.IsNullOrEmpty())
                    {
                        conditionMain.Add("PolicyId", model.IptPolicyId);
                    }
                    conditionMain.Add("IsTemplate", false);
                    conditionMain.Add("PolicyMode", "Advance");
                    policyDao.UpdateProlicyInit(conditionMain);

                    //主信息
                    ProPolicy policyHeader = policyDao.GetUIPolicyHeader(UserInfo.Id);
                    if (model.IsPageNew.ToSafeBool())
                    {
                        model.IptPolicyId = policyHeader.PolicyId.ToSafeString();
                        model.IptPolicyNo = "系统自动生成";
                        model.IptPromotionState = SR.PRO_Status_Draft;
                        model.IptPeriod = "季度";
                        model.IptProTo = "ByDealer";
                        model.IptMinusLastGift = true;
                        model.IptIncrement = false;
                        model.IptAcquisition = false;
                        if (model.IptPolicyStyle == "即时买赠")
                        {
                            model.IptPolicyType = "采购赠";
                        }
                        else
                        {
                            model.IptPolicyType = "植入赠";
                        }
                        model.IptAddLastLeft = false;

                        model.IptCarryType = "KeepValue";
                        //this.cbWdRebate.SelectedItem.Value = "N";
                        if (model.IptPolicyStyle == "积分")
                        {
                            //model.IptPointValidDateTypeForLp = "Always";
                            //model.IptPointValidDateType = "Always";
                            model.IptUseProductForLp = false;
                        }
                        model.IptYtdOption = "N";

                        //添加产品因素（默认是赠品）
                        ProPolicyFactorUi factor1 = new ProPolicyFactorUi();
                        factor1.PolicyFactorId = 1;
                        factor1.PolicyId = Convert.ToInt32(model.IptPolicyId);
                        factor1.FactId = 1;
                        if (model.IptPolicyStyle == "赠品")
                        {
                            factor1.FactDesc = "政策所包含产品";
                        }
                        else if (model.IptPolicyStyle == "积分")
                        {
                            factor1.FactDesc = "政策所包含产品";
                        }
                        else
                        {
                            factor1.FactDesc = "政策所包含产品";
                        }
                        factor1.CurrUser = UserInfo.Id;

                        string isGift = "N";
                        string isPoint = "N";
                        if (model.IptPolicyStyle == "赠品")
                        {
                            isGift = "Y";
                            isPoint = "N";
                        }
                        else if (model.IptPolicyStyle == "即时买赠")
                        {
                            isGift = "Y";
                            isPoint = "N";
                        }
                        else if (model.IptPolicyStyle == "积分" && model.IptPolicyStyleSub == "可变量积分")
                        {
                            isGift = "Y";
                            isPoint = "Y";
                        }
                        else
                        {
                            isGift = "N";
                            isPoint = "Y";
                        }

                        CreateProPolicyFactorUi(factor1, isGift, isPoint);

                        //添加植入量因素（默认与指定产品关系产品）
                        ProPolicyFactorUi factor2 = new ProPolicyFactorUi();
                        factor2.PolicyFactorId = 2;
                        factor2.PolicyId = Convert.ToInt32(model.IptPolicyId);
                        if (model.IptPolicyStyleSub == "按百分比赠送积分")
                        {
                            factor2.FactId = 12;
                            factor2.FactDesc = "指定产品医院植入金额";
                        }
                        else
                        {
                            if (model.IptPolicyStyle == "即时买赠")
                            {
                                factor2.FactId = 13;
                                factor2.FactDesc = "指定产品商业采购金额";
                            }
                            else
                            {
                                factor2.FactId = 8;
                                factor2.FactDesc = "指定产品医院植入量";
                            }
                        }
                        factor2.CurrUser = UserInfo.Id;

                        CreateProPolicyFactorUi(factor2, "N", "N");

                        model.IsCanEdit = true;
                    }
                    else
                    {
                        model.IptPromotionState = policyHeader.Status;
                        model.IptProductLine = policyHeader.ProductLineId; //产品线
                        model.IptSubBu = policyHeader.SubBu;  //SubBU
                        model.IptPeriod = policyHeader.Period; //结算周期

                        //促销类型
                        model.IptPolicyType = policyHeader.PolicyType;

                        //选择结算对象
                        model.IptProTo = policyHeader.CalType;

                        //扣除上期赠品
                        model.IptMinusLastGift = policyHeader.ifMinusLastGift == "Y";

                        //增量计算
                        model.IptIncrement = policyHeader.ifIncrement == "Y";

                        //累计上期余量
                        model.IptAddLastLeft = policyHeader.ifAddLastLeft == "Y";

                        //进位方式
                        model.IptCarryType = policyHeader.CarryType;

                        model.IptAcquisition = policyHeader.ifCalPurchaseAR == "Y";

                        //指定类型
                        if (policyHeader.CalType != null && policyHeader.CalType.Equals("ByDealer"))
                        {
                            model.IptProToType = policyHeader.ProDealerType;
                        }

                        //封顶类型
                        model.IptTopType = policyHeader.TopType;

                        model.IptPolicyNo = policyHeader.PolicyNo;
                        model.IptPolicyName = policyHeader.PolicyName;

                        model.IptBeginDate = policyHeader.StartDateTime;

                        model.IptEndDate = policyHeader.EndDateTime;

                        model.IptPolicyGroupName = policyHeader.PolicyGroupName;

                        model.IptTopValue = policyHeader.TopValue.ToSafeString();

                        //促销类型
                        model.IptPolicyStyle = policyHeader.PolicyStyle;
                        model.IptPolicyStyleSub = policyHeader.PolicySubStyle;

                        //积分
                        if (!this.CheckPointValidDateTypeForLp(model.IptPolicyStyle, policyHeader.PointValidDateType2, policyHeader.PointValidDateDuration2.ToSafeString()))
                        {
                            throw new Exception("平台积分有效期格式错误");
                        }
                        //model.IptPointValidDateTypeForLp = policyHeader.PointValidDateType2;
                        //model.IptPointValidDateDurationForLp = policyHeader.PointValidDateDuration2.ToSafeString();
                        //model.IptPointValidDateAbsoluteForLp = policyHeader.PointValidDateAbsolute2.ToSafeString();

                        model.IptPointValidDateType = this.GetPointValidDateType(model.IptPolicyStyle, policyHeader.PointValidDateType, policyHeader.PointValidDateDuration.ToSafeString(), policyHeader.PointValidDateAbsolute, policyHeader.EndDateTime);
                        //model.IptPointValidDateType = policyHeader.PointValidDateType;
                        //model.IptPointValidDateDuration = policyHeader.PointValidDateDuration.ToSafeString();
                        //model.IptPointValidDateAbsolute = policyHeader.PointValidDateAbsolute.ToSafeString();

                        if (policyHeader.PointUseRange != null && policyHeader.PointUseRange.Equals("BU"))
                        {
                            model.IptUseProductForLp = true;
                        }
                        else
                        {
                            model.IptUseProductForLp = false;
                        }

                        if (policyHeader.YTDOption != null)
                        {
                            model.IptYtdOption = policyHeader.YTDOption;
                        }
                        else
                        {
                            model.IptYtdOption = "N";
                        }

                        model.IptMjRatio = policyHeader.MjRatio.ToSafeString();

                        if (model.IptPageType == "Modify" && model.IptPromotionState == SR.PRO_Status_Draft)
                        {
                            model.IsCanEdit = true;
                        }
                        else
                        {
                            model.IptPolicyPreview = policyDao.GetPolicyHtmlStr(model.IptPolicyId);
                            model.IsCanEdit = false;
                        }
                    }

                    //控件数据
                    model.LstProductLine = this.GetProductLineDataSource();
                    if (!model.IptProductLine.IsNullOrEmpty())
                    {
                        model.LstSubBu = JsonHelper.DataTableToArrayList(policyDao.GetSubBU(model.IptProductLine).Tables[0]);
                    }

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

        public PolicyInfoVO ChangeProductLine(PolicyInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    if (!model.IptProductLine.IsNullOrEmpty())
                    {
                        model.LstSubBu = JsonHelper.DataTableToArrayList(policyDao.GetSubBU(model.IptProductLine).Tables[0]);
                    }
                    else
                    {
                        model.LstSubBu = new ArrayList();
                    }

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

        public PolicyInfoVO ChangePolicyType(PolicyInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    if (model.IsPageNew.ToSafeBool())
                    {
                        Hashtable deleteCondition = new Hashtable();
                        deleteCondition.Add("PolicyFactorId", 2);
                        deleteCondition.Add("PolicyId", model.IptPolicyId);
                        deleteCondition.Add("CurrUser", UserInfo.Id);

                        //该因素是否被规则引用
                        Hashtable checkCondition = new Hashtable();
                        checkCondition.Add("JudgePolicyFactorId", 2);
                        checkCondition.Add("CurrUser", UserInfo.Id);
                        if (policyDao.GetPolicyRuleUi(checkCondition).Tables[0].Rows.Count == 0)
                        {
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
                        }

                        ProPolicyFactorUi factor = new ProPolicyFactorUi();
                        factor.PolicyFactorId = 2;
                        factor.PolicyId = Convert.ToInt32(model.IptPolicyId);
                        factor.CurrUser = UserInfo.Id;

                        if (model.IptPolicyType.Equals("采购赠"))
                        {
                            if (model.IptPolicyStyleSub == "按百分比赠送积分")
                            {
                                factor.FactId = 13;
                                factor.FactDesc = "指定产品商业采购金额";
                            }
                            else
                            {
                                factor.FactId = 9;
                                factor.FactDesc = "指定产品商业采购量";
                            }

                            this.CreateProPolicyFactorUi(factor, "N", "N");
                        }
                        else if (model.IptPolicyType.Equals("植入赠"))
                        {
                            if (model.IptPolicyStyleSub == "按百分比赠送积分")
                            {
                                factor.FactId = 12;
                                factor.FactDesc = "指定产品医院植入金额";
                            }
                            else
                            {
                                factor.FactId = 8;
                                factor.FactDesc = "指定产品医院植入量";
                            }

                            this.CreateProPolicyFactorUi(factor, "N", "N");
                        }
                    }

                    //因素列表
                    ProPolicyFactorUi conditionFactor = new ProPolicyFactorUi();
                    conditionFactor.PolicyId = Convert.ToInt32(model.IptPolicyId);
                    conditionFactor.CurrUser = UserInfo.Id;
                    model.RstFactorList = JsonHelper.DataTableToArrayList(policyDao.QueryUIPolicyFactorAndGift(conditionFactor).Tables[0]);

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

        public PolicyInfoVO ChangeTopType(PolicyInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    policyDao.DeleteTopValueByUserId(UserInfo.Id);

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

        public PolicyInfoVO Save(PolicyInfoVO model)
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

        public PolicyInfoVO Submit(PolicyInfoVO model)
        {
            try
            {
                bool result = true;
                String massage = "";
                ProPolicy policy = this.GetPolicyHeader(model);
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    policy.Status = "有效";

                    result = this.SaveSubmit(policy, "Submit", out massage);

                    model.IptPolicyPreview = policyDao.GetPolicyHtmlStr(model.IptPolicyId);

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
        public PolicyInfoVO ReloadAttachment(PolicyInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    Hashtable obj = new Hashtable();
                    obj.Add("CurrUser", UserInfo.Id);
                    obj.Add("PolicyId", model.IptPolicyId);

                    DataSet ds = policyDao.QueryPolicyAttachment(obj);
                    model.RstAttachmentList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
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
        public PolicyInfoVO ReloadFactor(PolicyInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    //因素列表
                    ProPolicyFactorUi conditionFactor = new ProPolicyFactorUi();
                    conditionFactor.PolicyId = Convert.ToInt32(model.IptPolicyId);
                    conditionFactor.CurrUser = UserInfo.Id;
                    model.RstFactorList = JsonHelper.DataTableToArrayList(policyDao.QueryUIPolicyFactorAndGift(conditionFactor).Tables[0]);

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

        public PolicyInfoVO RemoveFactor(PolicyInfoVO model)
        {
            try
            {
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

                            //因素列表
                            ProPolicyFactorUi conditionFactor = new ProPolicyFactorUi();
                            conditionFactor.PolicyId = Convert.ToInt32(model.IptPolicyId);
                            conditionFactor.CurrUser = UserInfo.Id;
                            model.RstFactorList = JsonHelper.DataTableToArrayList(policyDao.QueryUIPolicyFactorAndGift(conditionFactor).Tables[0]);

                            model.IsSuccess = true;
                        }
                        else
                        {
                            model.ExecuteMessage.Add("该参数已被促销规则使用，不能删除");
                            model.IsSuccess = false;
                        }
                    }
                    else
                    {
                        model.ExecuteMessage.Add("已被其他参数设置为关系参数，不能删除");
                        model.IsSuccess = false;
                    }

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

        public PolicyInfoVO ReloadRule(PolicyInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    //规则列表
                    Hashtable conditionRule = new Hashtable();
                    conditionRule.Add("CurrUser", UserInfo.Id);
                    conditionRule.Add("PolicyId", model.IptPolicyId);
                    model.RstRuleList = JsonHelper.DataTableToArrayList(policyDao.GetPolicyRuleUi(conditionRule).Tables[0]);

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

        public PolicyInfoVO RemoveRule(PolicyInfoVO model)
        {
            try
            {
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

                    //规则列表
                    Hashtable conditionRule = new Hashtable();
                    conditionRule.Add("CurrUser", UserInfo.Id);
                    conditionRule.Add("PolicyId", model.IptPolicyId);
                    model.RstRuleList = JsonHelper.DataTableToArrayList(policyDao.GetPolicyRuleUi(conditionRule).Tables[0]);

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

        public PolicyInfoVO RemoveAttachment(PolicyInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    policyDao.DeletePolicyAttachment(model.IptAttachmentId);
                    //物理删除
                    string uploadFile = HttpContext.Current.Request.PhysicalApplicationPath + "/Upload/UploadFile/Promotion";
                    File.Delete(uploadFile + "/" + model.IptAttachmentName);

                    //附件
                    Hashtable conditionAttachment = new Hashtable();
                    conditionAttachment.Add("PolicyId", model.IptPolicyId);
                    conditionAttachment.Add("Type", "Policy");
                    model.RstAttachmentList = JsonHelper.DataTableToArrayList(policyDao.QueryPolicyAttachment(conditionAttachment).Tables[0]);

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

        #endregion

        #region Internal Function

        private void CreateProPolicyFactorUi(ProPolicyFactorUi policyFactor, String IsGift, String IsNoPoint)
        {
            ProPolicyDao dao = new ProPolicyDao();
            ProPolicyFactorUi proPolicyFactorUi = new ProPolicyFactorUi();

            //添加因素表信息
            dao.InsertProPolicyFactorUi(policyFactor);
            if (IsGift.Equals("Y") || IsNoPoint.Equals("Y"))
            {
                //1. 判断列表中是否已经有数据
                bool checkVlue = (dao.GetPolicyLargessUi(UserInfo.Id, policyFactor.PolicyId.ToString()).Tables[0].Rows.Count > 0 ? true : false);

                //添加赠品表信息
                Hashtable obj = new Hashtable();
                //PolicyId,GiftType,GiftPolicyFactorId,PointsValue,UseRangePolicyFactorId,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,CurrUser
                obj.Add("PolicyId", policyFactor.PolicyId);
                //赠品、或者积分类“赠品转积分” GiftType 为 FreeGoods
                obj.Add("GiftType", (IsGift == "Y" ? "FreeGoods" : "Point"));
                obj.Add("GiftPolicyFactorId", IsGift.Equals("Y") ? policyFactor.PolicyFactorId.ToString() : null);
                obj.Add("UseRangePolicyFactorId", IsNoPoint.Equals("Y") ? policyFactor.PolicyFactorId.ToString() : null);
                obj.Add("CreateBy", UserInfo.Id);
                obj.Add("CreateTime", DateTime.Now);
                obj.Add("ModifyBy", DBNull.Value);
                obj.Add("ModifyDate", DBNull.Value);
                obj.Add("CurrUser", UserInfo.Id);
                if (!checkVlue)
                {
                    dao.InsertProPolicyFactorGiftUi(obj);
                }
                else
                {
                    if (IsGift.Equals("Y"))
                    {
                        //修改是赠品
                        dao.UpdateIsGiftUi(obj);
                    }
                    if (IsNoPoint.Equals("Y"))
                    {
                        //修改是积分使用范围
                        dao.UpdateIsUsePointUi(obj);
                    }
                }
            }
        }

        private ProPolicy GetPolicyHeader(PolicyInfoVO model)
        {
            ProPolicyDao policyDao = new ProPolicyDao();

            ProPolicy policy = policyDao.GetUIPolicyHeader(UserInfo.Id);

            //产品线
            policy.ProductLineId = model.IptProductLine;
            //SubBU
            policy.SubBu = model.IptSubBu;
            //促销计算基数
            policy.PolicyType = model.IptPolicyStyle == "即时买赠（按单张订单计算）" ? "采购赠" : model.IptPolicyType;
            //结算对象
            policy.CalType = model.IptPolicyType == "植入赠" ? model.IptProTo : "ByDealer";
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
            //封顶值
            policy.TopValue = model.IptTopValue.ToDecimal();
            //政策ID
            policy.PolicyId = model.IptPolicyId.ToSafeInt();
            policy.ModifyBy = UserInfo.Id;
            policy.ModifyDate = DateTime.Now;
            //封顶类型
            policy.TopType = model.IptTopType;
            //经销商结算周期
            policy.Period = model.IptPeriod;
            //扣除上期赠品
            policy.ifMinusLastGift = model.IptMinusLastGift ? "Y" : "N";
            //增量计算
            policy.ifIncrement = model.IptIncrement ? "Y" : "N";
            //累计上期余量
            policy.ifAddLastLeft = model.IptAddLastLeft ? "Y" : "N";
            //进位方式
            policy.CarryType = model.IptCarryType;
            //计入返利与达成
            policy.ifCalPurchaseAR = model.IptAcquisition ? "Y" : "N";

            if (policy.PolicyStyle != null && model.IptPolicyStyle == "积分")
            {
                //平台积分有效期
                //policy.PointValidDateType2 = model.IptPointValidDateTypeForLp;
                policy.PointValidDateType2 = "AccountMonth";
                //跨度-平台
                //policy.PointValidDateDuration2 = model.IptPointValidDateDurationForLp.ToInt();
                policy.PointValidDateDuration2 = 3;
                //日期-平台
                //policy.PointValidDateAbsolute2 = model.IptPointValidDateAbsoluteForLp.ToDateTime();
                policy.PointValidDateAbsolute2 = null;

                if (model.IptPointValidDateType == "Year")
                {
                    //一/二级积分效期
                    policy.PointValidDateType = "AbsoluteDate";
                    //跨度
                    policy.PointValidDateDuration = null;
                    //日期
                    policy.PointValidDateAbsolute = new DateTime(model.IptEndDate.ToSafeDateTime().AddYears(1).Year, 3, 31);
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
                //一/二级积分效期
                //policy.PointValidDateType = model.IptPointValidDateType;
                //跨度
                //policy.PointValidDateDuration = model.IptPointValidDateDuration.ToInt();
                //日期
                //policy.PointValidDateAbsolute = model.IptPointValidDateAbsolute.ToDateTime();
            } else
            {
                //一/二级积分效期
                policy.PointValidDateType = null;
                //跨度
                policy.PointValidDateDuration = null;
                //日期
                policy.PointValidDateAbsolute = null;
                //平台积分有效期
                policy.PointValidDateType2 = null;
                //跨度-平台
                policy.PointValidDateDuration2 = null;
                //日期-平台
                policy.PointValidDateAbsolute2 = null;
            }
            //平台积分可用于全产品
            if (policy.PolicyStyle != null && policy.PolicyStyle.Equals("积分"))
            {
                policy.PointUseRange = model.IptUseProductForLp ? "BU" : "PRODUCT";
            }
            else
            {
                policy.PointUseRange = null;
            }
            //YTD奖励追溯
            policy.YTDOption = model.IptYtdOption.IsNullOrEmpty() ? "N" : model.IptYtdOption;
            //买减折价率
            policy.MjRatio = model.IptMjRatio.IsNullOrEmpty() ? null : model.IptMjRatio.ToDecimal();

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

        private void SendEWorkflow(int policyId)
        {
            if ("1" != SR.CONST_DMS_Promotion_DEVELOP)
            {
                EwfService.WfAction wfAction = new EwfService.WfAction();
                wfAction.Credentials = new NetworkCredential(SR.CONST_EWF_USER_NAME, SR.CONST_EWF_USER_PWD, SR.CONST_EWF_DOMAIN);

                string template = WorkflowTemplate.PromotionPolicyTemplate.Clone().ToString();
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                //string userAccount = "1105203";
                string userAccount = "";
                string policyNo = "";
                string policyXML = "";

                //1.0 获取申请单编号
                using (ProPolicyDao dao = new ProPolicyDao())
                {
                    Hashtable obj = new Hashtable();
                    obj.Add("PolicyId", policyId);
                    DataTable dt = dao.GetPolicy(obj).Tables[0];
                    DataTable dtHtml = new DataTable();
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        policyNo = dt.Rows[0]["PolicyNo"].ToString();
                        dtHtml = dao.GetPolicyhtml(policyId.ToString()).Tables[0];
                    }
                    //2.0 获取HTML文件
                    if (dtHtml.Rows.Count > 0 && dtHtml.Rows[0]["PolicyXML"] != null)
                    {
                        policyXML = dtHtml.Rows[0]["PolicyXML"].ToString();
                    }
                }

                //3.0 获取 userAccount
                //userAccount = _context.User.LoginId;
                using (ProPolicyDao dao2 = new ProPolicyDao())
                {
                    userAccount = dao2.QueryEWorkflowAccount(UserInfo.LoginId);
                }

                if (policyXML != "")
                {
                    template = string.Format(template, SR.CONST_PROMOTION_POLICY_NO, userAccount, userAccount, "", policyNo, policyXML, "<a target='_blank' href='https://bscdealer.cn/API.aspx?PageId=60&InstanceID=" + policyNo + "'>上传附件</a>");
                    using (ProPolicyDao dao2 = new ProPolicyDao())
                    {
                        dao2.InsertPolicyOperationLog(template);
                    }
                    wfAction.StartInstanceXml(template, SR.CONST_EWF_WEB_PWD);
                }
            }
        }

        private void SendEKPEWorkflow(ProPolicy policy)
        {
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
            ekpBll.DoSubmit(_context.User.LoginId, InstanceID, PolicyNo, "PromotionPolicy", string.Format("{0} 促销政策({1})", PolicyNo, BU), EkpModelId.PromotionPolicy.ToString(), EkpTemplateFormId.PromotionPolicyTemplate.ToString());
        }


        private bool CheckPointValidDateTypeForLp(String policyStyle, String type, String duration)
        {
            if (policyStyle == "积分")
            {
                if (type == "AccountMonth" && duration == "3")
                {
                    return true;
                }
                else
                {
                    return false;
                }
            } else
            {
                return true;
            }
        }

        private String GetPointValidDateType(String policyStyle, String type, String duration, DateTime? absolute, DateTime? endDate)
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
                //else if (endDate == null || (type == "AbsoluteDate" && absolute != null && endDate.Value.AddYears(1).Year == absolute.Value.Year))
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

        public PolicyInfoVO ReloadLook(PolicyInfoVO model)
        {
            var policyId = model.IptPolicyId;
            var policyXML = "";
            //1.0 获取申请单编号
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("PolicyId", policyId);
                DataTable dt = dao.GetPolicy(obj).Tables[0];
                DataTable dtHtml = new DataTable();
                if (dt != null && dt.Rows.Count > 0)
                {
                    dtHtml = dao.GetPolicyhtml(policyId.ToString()).Tables[0];
                }
                //2.0 获取HTML文件
                if (dtHtml.Rows.Count > 0 && dtHtml.Rows[0]["PolicyXML"] != null)
                {
                    policyXML = dtHtml.Rows[0]["PolicyXML"].ToString();
                }
            }
            model.IptReloadLook = policyXML;
            return model;
        }
    }
}
