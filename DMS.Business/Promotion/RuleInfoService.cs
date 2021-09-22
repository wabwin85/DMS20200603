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

namespace DMS.Business.Promotion
{
    public class RuleInfoService : BaseService
    {
        #region Ajax Method

        public RuleInfoVO InitPage(RuleInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();
                    ProDescriptionDao descritptionDao = new ProDescriptionDao();

                    Hashtable factorXCondition = new Hashtable();
                    factorXCondition.Add("PolicyId", model.IptPolicyId);
                    factorXCondition.Add("CurrUser", UserInfo.Id);
                    factorXCondition.Add("PolicyStyleSub", model.IptPolicyStyleSub);
                    model.LstPolicyFactorX = JsonHelper.DataTableToArrayList(policyDao.GetComputePolicyFactorUi(factorXCondition).Tables[0]);

                    Hashtable factorYCondition = new Hashtable();
                    factorYCondition.Add("CurrUser", UserInfo.Id);
                    model.LstPolicyFactorY = JsonHelper.DataTableToArrayList(policyDao.GetIsGift(factorYCondition).Tables[0]);

                    if (model.LstPolicyFactorY.Count > 0)
                    {
                        Dictionary<string, object> y = model.LstPolicyFactorY[0] as Dictionary<string, object>;
                        model.IptPolicyFactorY = y["GiftPolicyFactorId"].ToSafeString();
                        model.IptFactorRemarkY = y["FactDesc"].ToSafeString();
                    }

                    if (!model.IsPageNew.ToSafeBool())
                    {
                        Hashtable condition = new Hashtable();
                        condition.Add("RuleId", model.IptPolicyRuleId);
                        condition.Add("PolicyId", model.IptPolicyId);
                        condition.Add("CurrUser", UserInfo.Id);

                        DataTable rule = policyDao.GetPolicyRuleUi(condition).Tables[0];

                        if (rule != null && rule.Rows.Count > 0)
                        {
                            DataRow row = rule.Rows[0];

                            model.IptPolicyFactorX = row.GetSafeStringValue("JudgePolicyFactorId");
                            model.IptFactorRemarkX = row.GetSafeStringValue("FactDesc");
                            model.IptFactorValueX = row.GetSafeStringValue("JudgeValue");
                            model.IptFactorValueY = row.GetSafeStringValue("GiftValue");
                            model.IptDesc = row.GetSafeStringValue("RuleDesc");
                            model.IptPointValue = row.GetSafeStringValue("PointsValue");
                            model.IptPointType = row.GetSafeStringValue("PointsType");
                        }

                        if (model.IsTemplate.ToSafeBool() || (model.IptPageType == "Modify" && model.IptPromotionState == SR.PRO_Status_Draft))
                        {
                            model.IsCanEdit = true;
                        }
                        else
                        {
                            model.IsCanEdit = false;
                        }
                    } else
                    {
                        model.IsCanEdit = true;
                    }

                    //规则条件
                    Hashtable facterCondition = new Hashtable();
                    facterCondition.Add("PolicyId", model.IptPolicyId);
                    facterCondition.Add("CurrUser", UserInfo.Id);
                    model.LstPolicyConditionFacter = JsonHelper.DataTableToArrayList(policyDao.GetSillPolicyFactorUi(facterCondition).Tables[0]);

                    model.LstSymbol = DictionaryHelper.GetKeyValueList(SR.PRO_ProRoleSymbol);
                    model.LstValueType = DictionaryHelper.GetKeyValueList(SR.PRO_LogicType);
                    model.LstRefValue1 = DictionaryHelper.GetKeyValueList(SR.PRO_TargetType);
                    model.LstRefValue2 = DictionaryHelper.GetKeyValueList(SR.PRO_TargetType);

                    Hashtable compareFacterCondition = new Hashtable();
                    compareFacterCondition.Add("PolicyId", model.IptPolicyId);
                    compareFacterCondition.Add("CurrUser", UserInfo.Id);
                    model.LstCompareFacter = JsonHelper.DataTableToArrayList(policyDao.GetSillPolicyFactorUi(compareFacterCondition).Tables[0]);

                    Hashtable conditionDetail = new Hashtable();
                    conditionDetail.Add("RuleId", model.IptPolicyRuleId);
                    conditionDetail.Add("CurrUser", UserInfo.Id);
                    DataTable ruleDetail = policyDao.QueryUIFactorRuleCondition(conditionDetail).Tables[0];
                    object maxId = ruleDetail.Compute("Max(RuleFactorId)","");
                    model.IptConditionMaxId = maxId == null ? "1" : maxId.ToSafeString();
                    model.RstRuleDetail = JsonHelper.DataTableToArrayList(ruleDetail);

                    model.LstRuleDesc = descritptionDao.SelectProDescriptioinList("PolicyRule");

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

        public RuleInfoVO Save(RuleInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    ProPolicyRuleUi rule = new ProPolicyRuleUi();
                    rule.JudgePolicyFactorId = model.IptPolicyFactorX.ToInt();
                    rule.JudgeValue = model.IptFactorValueX.ToDecimal();
                    rule.GiftValue = model.IptFactorValueY.ToDecimal();
                    rule.RuleId = model.IptPolicyRuleId.ToInt();
                    rule.PolicyId = model.IptPolicyId.ToInt();
                    rule.CurrUser = UserInfo.Id;
                    rule.CreateBy = UserInfo.Id;
                    rule.CreateTime = DateTime.Now;
                    rule.ModifyBy = UserInfo.Id;
                    rule.ModifyDate = DateTime.Now;
                    rule.RuleDesc = model.IptDesc;
                    rule.PointsValue = model.IptPointValue.ToDecimal();
                    if (model.IptPolicyStyleSub == "满额送固定积分")
                    {
                        rule.PointsType = "固定积分";
                    }
                    else if (model.IptPolicyStyleSub == "促销赠品转积分")
                    {
                        rule.PointsType = model.IptPointType;
                    }

                    if (model.IsPageNew.ToSafeBool())
                    {
                        policyDao.InsertPolicyRuleUi(rule);
                    }
                    else
                    {
                        policyDao.UpdatePolicyRuleUi(rule);
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

        public RuleInfoVO ShowCondition(RuleInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    Hashtable condition = new Hashtable();
                    condition.Add("RuleFactorId", model.IptConditionId);
                    condition.Add("RuleId", model.IptPolicyRuleId);
                    condition.Add("CurrUser", UserInfo.Id);
                    DataTable dt = policyDao.GetPolicyRuleConditionUi(condition).Tables[0];

                    if (dt.Rows.Count > 0)
                    {
                        DataRow row = dt.Rows[0];

                        model.IptPolicyConditionFacter = row.GetSafeStringValue("PolicyFactorId");
                        model.IptSymbol = row.GetSafeStringValue("LogicSymbol");
                        model.IptValueType = row.GetSafeStringValue("LogicType");
                        model.IptRefValue1 = row.GetSafeStringValue("RelativeValue1");
                        model.IptRefValue2 = row.GetSafeStringValue("RelativeValue2");
                        model.IptValue1 = row.GetSafeStringValue("AbsoluteValue1");
                        model.IptValue2 = row.GetSafeStringValue("AbsoluteValue2");
                        model.IptCompareFacter = row.GetSafeStringValue("OtherPolicyFactorId");
                        model.IptCompareFacterRatio = row.GetSafeStringValue("OtherPolicyFactorIdRatio");
                    }
                    else
                    {
                        model.IptPolicyConditionFacter = "";
                        model.IptSymbol = "";
                        model.IptValueType = "";
                        model.IptRefValue1 = "";
                        model.IptRefValue2 = "";
                        model.IptValue1 = "";
                        model.IptValue2 = "";
                        model.IptCompareFacter = "";
                        model.IptCompareFacterRatio = "";
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

        public RuleInfoVO SaveDetail(RuleInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    ProPolicyRuleFactorUi RuleFactor = new ProPolicyRuleFactorUi();
                    RuleFactor.RuleFactorId = model.IptConditionId.ToSafeInt();
                    RuleFactor.RuleId = model.IptPolicyRuleId.ToInt();
                    RuleFactor.PolicyFactorId = model.IptPolicyConditionFacter.ToInt();
                    RuleFactor.LogicType = model.IptValueType;
                    RuleFactor.LogicSymbol = model.IptSymbol;
                    RuleFactor.AbsoluteValue1 = model.IptValue1.ToDecimal();
                    RuleFactor.AbsoluteValue2 = model.IptValue2.ToDecimal();
                    RuleFactor.RelativeValue1 = model.IptRefValue1;
                    RuleFactor.RelativeValue2 = model.IptRefValue2;
                    RuleFactor.OtherPolicyFactorId = model.IptCompareFacter.ToInt();
                    RuleFactor.OtherPolicyFactorIdRatio = model.IptCompareFacterRatio.ToDecimal();
                    RuleFactor.CreateBy = UserInfo.Id;
                    RuleFactor.CreateTime = DateTime.Now;
                    RuleFactor.ModifyBy = UserInfo.Id;
                    RuleFactor.ModifyDate = DateTime.Now;
                    RuleFactor.CurrUser = UserInfo.Id;

                    Hashtable checkCondition = new Hashtable();
                    checkCondition.Add("RuleFactorId", model.IptConditionId);
                    checkCondition.Add("RuleId", model.IptPolicyRuleId);
                    checkCondition.Add("CurrUser", UserInfo.Id);
                    DataTable dt = policyDao.GetPolicyRuleConditionUi(checkCondition).Tables[0];

                    if (dt.Rows.Count == 0)
                    {
                        policyDao.InsertPolicyRuleConditionUi(RuleFactor);
                    }
                    else
                    {
                        policyDao.UpdatePolicyRuleConditionUi(RuleFactor);
                    }

                    Hashtable condition = new Hashtable();
                    condition.Add("RuleId", model.IptPolicyRuleId);
                    condition.Add("CurrUser", UserInfo.Id);
                    model.RstRuleDetail = JsonHelper.DataTableToArrayList(policyDao.QueryUIFactorRuleCondition(condition).Tables[0]);

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

        public RuleInfoVO RemoveCondition(RuleInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    Hashtable removeCondition = new Hashtable();
                    removeCondition.Add("RuleFactorId", model.IptConditionId);
                    removeCondition.Add("RuleId", model.IptPolicyRuleId);
                    removeCondition.Add("CurrUser",UserInfo.Id);
                    policyDao.DeleteFactorRuleConditionUi(removeCondition);

                    Hashtable condition = new Hashtable();
                    condition.Add("RuleId", model.IptPolicyRuleId);
                    condition.Add("CurrUser", UserInfo.Id);
                    model.RstRuleDetail = JsonHelper.DataTableToArrayList(policyDao.QueryUIFactorRuleCondition(condition).Tables[0]);

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

        #endregion
    }
}
