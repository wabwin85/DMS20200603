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
    public class PolicyTemplateInfoService : BaseService
    {
        #region Ajax Method

        public PolicyTemplateInfoVO InitPage(PolicyTemplateInfoVO model)
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
                    if (!model.IptPolicyId.IsNullOrEmpty())
                    {
                        conditionMain.Add("PolicyId", model.IptPolicyId);
                    }
                    conditionMain.Add("IsTemplate", true);
                    conditionMain.Add("PolicyMode", null);
                    policyDao.UpdateProlicyInit(conditionMain);

                    //主信息
                    ProPolicy policyHeader = policyDao.GetUIPolicyHeader(UserInfo.Id);
                    if (model.IptPolicyId.IsNullOrEmpty())
                    {
                        model.IptPolicyId = policyHeader.PolicyId.ToSafeString();
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
                        model.IptProductLine = policyHeader.ProductLineId; //产品线
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

                        model.IptTemplateName = policyHeader.PolicyName;

                        model.IptPolicyDesc = policyHeader.Description;

                        model.IptTopValue = policyHeader.TopValue.ToSafeString();

                        //促销类型
                        model.IptPolicyStyle = policyHeader.PolicyStyle;
                        model.IptPolicyStyleSub = policyHeader.PolicySubStyle;

                        //积分
                        if (!this.CheckPointValidDateTypeForLp(model.IptPolicyStyle, policyHeader.PointValidDateType2, policyHeader.PointValidDateDuration2.ToSafeString()))
                        {
                            throw new Exception("平台积分有效期格式错误");
                        }

                        model.IptPointValidDateType = this.GetPointValidDateType(model.IptPolicyStyle, policyHeader.PointValidDateType, policyHeader.PointValidDateDuration.ToSafeString());

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

                    model.LstPolicyGeneralDesc = descritptionDao.SelectProDescriptioinList("PolicyGeneral");

                    model.IptPolicyPreview = policyDao.SelectPromotionSummary(model.IptPolicyId, "TemplatePreview");

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

        public PolicyTemplateInfoVO ChangePolicyType(PolicyTemplateInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

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

        public PolicyTemplateInfoVO Save(PolicyTemplateInfoVO model)
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

                    result = this.SaveSubmit(policy, out massage);

                    model.IptPolicyPreview = policyDao.SelectPromotionSummary(model.IptPolicyId, "TemplatePreview");

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

        public PolicyTemplateInfoVO ReloadFactor(PolicyTemplateInfoVO model)
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

        public PolicyTemplateInfoVO RemoveFactor(PolicyTemplateInfoVO model)
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

        public PolicyTemplateInfoVO ReloadRule(PolicyTemplateInfoVO model)
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

        public PolicyTemplateInfoVO RemoveRule(PolicyTemplateInfoVO model)
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

        private ProPolicy GetPolicyHeader(PolicyTemplateInfoVO model)
        {
            ProPolicyDao policyDao = new ProPolicyDao();

            ProPolicy policy = policyDao.GetUIPolicyHeader(UserInfo.Id);

            //产品线
            policy.ProductLineId = model.IptProductLine;
            //促销计算基数
            policy.PolicyType = model.IptPolicyStyle == "即时买赠（按单张订单计算）" ? "采购赠" : model.IptPolicyType;
            //结算对象
            policy.CalType = model.IptPolicyType == "植入赠" ? model.IptProTo : "ByDealer";
            //指定类型
            policy.ProDealerType = model.IptProToType;
            //政策名称
            policy.PolicyName = model.IptTemplateName;
            //政策描述
            policy.Description = model.IptPolicyDesc;
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
                policy.PointValidDateType2 = "AccountMonth";
                //跨度-平台
                policy.PointValidDateDuration2 = 3;
                //日期-平台
                policy.PointValidDateAbsolute2 = null;

                if (model.IptPointValidDateType == "Year")
                {
                    //一/二级积分效期
                    policy.PointValidDateType = "AbsoluteDate";
                    //跨度
                    policy.PointValidDateDuration = null;
                    //日期
                    policy.PointValidDateAbsolute = null;
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

        private bool SaveSubmit(ProPolicy policy, out String massage)
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
            condition.Add("Command", "SaveDraft");
            condition.Add("Result", string.Empty);

            if (policyDao.SubmintPolicy(condition) == "Failed")
            {
                massage = "保存促销政策模板失败";
                Rtn = false;
            }

            return Rtn;
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
            }
            else
            {
                return true;
            }
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
