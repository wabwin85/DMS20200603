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
using System.Collections.Specialized;

namespace DMS.Business.Promotion
{
    public class FactorInfoService : BaseService
    {
        #region Ajax Method

        public FactorInfoVO InitPage(FactorInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();
                    ProDescriptionDao descritptionDao = new ProDescriptionDao();

                    //因素基本信息
                    DataTable factor = new DataTable();
                    if (!model.IsPageNew.ToSafeBool())
                    {
                        ProPolicyFactorUi factorUi = new ProPolicyFactorUi();
                        factorUi.PolicyFactorId = Convert.ToInt32(model.IptPolicyFactorId);
                        factorUi.CurrUser = UserInfo.Id;
                        factor = policyDao.QueryUIPolicyFactorAndGift(factorUi).Tables[0];
                    }
                    if (factor != null && factor.Rows.Count > 0)
                    {
                        DataRow row = factor.Rows[0];
                        //this.cbWd2Factor.SelectedItem.Value = drValues["FactId"].ToString();
                        model.IptFactor = row.GetStringValue("FactId");
                        model.IptRemark = row.GetStringValue("FactDesc");
                        model.IptIsGift = row.GetStringValue("IsGift") == "Y";
                        model.IptPointsValue = row.GetStringValue("IsPoint") == "Y";

                        Hashtable conditionGift = new Hashtable();
                        conditionGift.Add("CurrUser", UserInfo.Id);
                        DataSet result = policyDao.CheckIsGift(conditionGift);

                        model.IptCheckIsGift = 0;
                        if (result != null && result.Tables[0].Rows.Count > 0)
                        {
                            DataRow gift = result.Tables[0].Rows[0];
                            if (!gift.GetStringValue("GiftPolicyFactorId").IsNullOrEmpty() && !gift.GetStringValue("UseRangePolicyFactorId").IsNullOrEmpty())
                            {
                                model.IptCheckIsGift = 3;
                            }
                            else if (!gift.GetStringValue("GiftPolicyFactorId").IsNullOrEmpty() && gift.GetStringValue("UseRangePolicyFactorId").IsNullOrEmpty())
                            {
                                model.IptCheckIsGift = 1;
                            }
                            else if (gift.GetStringValue("GiftPolicyFactorId").IsNullOrEmpty() && !gift.GetStringValue("UseRangePolicyFactorId").IsNullOrEmpty())
                            {
                                model.IptCheckIsGift = 2;
                            }
                        }
                    }
                    else
                    {
                        model.IptIsGift = false;
                        model.IptPointsValue = false;
                    }

                    //因素限制条件列表
                    if (!model.IsPageNew.ToSafeBool())
                    {
                        model.IptFactorClass = this.GetFactorClass(model.IptFactor);

                        Hashtable ruleCondition = new Hashtable();
                        ruleCondition.Add("PolicyFactorId", model.IptPolicyFactorId);
                        ruleCondition.Add("CurrUser", UserInfo.Id);
                        if (model.IptFactorClass == "Rule")
                        {
                            DataTable factorRule = policyDao.QueryConditionRuleUi(ruleCondition).Tables[0];
                            object maxId = factorRule.Compute("Max(PolicyFactorConditionId)", "");
                            model.IptConditionMaxId = maxId == null ? "1" : maxId.ToSafeString();
                            model.RstFactorRule = JsonHelper.DataTableToArrayList(factorRule);
                        }
                        else if (model.IptFactorClass == "Relation")
                        {
                            DataTable factorRule = policyDao.QueryFactorRelationUi(ruleCondition).Tables[0];
                            object maxId = factorRule.Compute("Max(ConditionPolicyFactorId)", "");
                            model.IptConditionMaxId = maxId == null ? "1" : maxId.ToSafeString();
                            model.RstFactorRule = JsonHelper.DataTableToArrayList(factorRule);
                        }

                        model.LstRuleCondition = JsonHelper.DataTableToArrayList(policyDao.GetFactorConditionByFactorId(model.IptFactor).Tables[0]);

                        if (model.IsTemplate.ToSafeBool() || (model.IptPageType == "Modify" && model.IptPromotionState == SR.PRO_Status_Draft))
                        {
                            model.IsCanEdit = true;
                        }
                        else
                        {
                            model.IsCanEdit = false;
                        }
                    }
                    else
                    {
                        model.IptConditionMaxId = "1";

                        model.IsCanEdit = true;
                    }

                    Hashtable condition = new Hashtable();
                    if (model.IptIsPointSub == "送赠品" || model.IptIsPointSub == "送积分（价格折扣）")
                    {
                        condition.Add("IsJMJZ", "Y");
                    }
                    model.LstFactor = JsonHelper.DataTableToArrayList(policyDao.QueryPolicyFactorList(condition).Tables[0]);

                    model.LstFactorDesc = descritptionDao.SelectProDescriptioinList("PolicyFactor");

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

        public FactorInfoVO ChangeFactor(FactorInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    Hashtable condition = new Hashtable();
                    condition.Add("CurrUser", UserInfo.Id);
                    DataSet result = policyDao.CheckIsGift(condition);

                    model.IptCheckIsGift = 0;
                    model.IptIsGift = false;
                    model.IptPointsValue = false;

                    if (result != null && result.Tables[0].Rows.Count > 0)
                    {
                        DataRow gift = result.Tables[0].Rows[0];
                        if (!gift.GetStringValue("GiftPolicyFactorId").IsNullOrEmpty() && !gift.GetStringValue("UseRangePolicyFactorId").IsNullOrEmpty())
                        {
                            model.IptCheckIsGift = 3;
                        }
                        else if (!gift.GetStringValue("GiftPolicyFactorId").IsNullOrEmpty() && gift.GetStringValue("UseRangePolicyFactorId").IsNullOrEmpty())
                        {
                            model.IptCheckIsGift = 1;
                        }
                        else if (gift.GetStringValue("GiftPolicyFactorId").IsNullOrEmpty() && !gift.GetStringValue("UseRangePolicyFactorId").IsNullOrEmpty())
                        {
                            model.IptCheckIsGift = 2;
                        }
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

        public FactorInfoVO ChangeRuleCondition(FactorInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    Hashtable condition = new Hashtable();
                    condition.Add("FactId", model.IptFactor);
                    condition.Add("ConditionId", model.IptRuleCondition.IsNullOrEmpty() ? "-1" : model.IptRuleCondition);
                    model.LstRuleConditionType = JsonHelper.DataTableToArrayList(policyDao.GetFactorConditionType(condition).Tables[0]);

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

        public FactorInfoVO Save(FactorInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    if (model.IsPageNew.ToSafeBool())
                    {
                        ProPolicyFactorUi factor = new ProPolicyFactorUi();

                        factor.PolicyFactorId = model.IptPolicyFactorId.ToInt();
                        factor.PolicyId = model.IptPolicyId.ToInt();
                        factor.FactId = model.IptFactor.ToInt();
                        factor.FactDesc = model.IptRemark;
                        factor.CurrUser = UserInfo.Id;
                        policyDao.InsertProPolicyFactorUi(factor);

                        if (model.IptIsGift || model.IptPointsValue)
                        {
                            //1. 判断列表中是否已经有数据
                            bool checkVlue = (policyDao.GetPolicyLargessUi(UserInfo.Id, model.IptPolicyId).Tables[0].Rows.Count > 0 ? true : false);

                            //添加赠品表信息
                            Hashtable gift = new Hashtable();
                            gift.Add("PolicyId", model.IptPolicyId);
                            //赠品、或者积分类“赠品转积分” GiftType 为 FreeGoods
                            gift.Add("GiftType", (model.IptIsGift ? "FreeGoods" : "Point"));
                            gift.Add("GiftPolicyFactorId", model.IptIsGift ? model.IptPolicyFactorId : null);
                            gift.Add("UseRangePolicyFactorId", model.IptPointsValue ? model.IptPolicyFactorId : null);
                            gift.Add("CreateBy", UserInfo.Id);
                            gift.Add("CreateTime", DateTime.Now);
                            gift.Add("ModifyBy", DBNull.Value);
                            gift.Add("ModifyDate", DBNull.Value);
                            gift.Add("CurrUser", UserInfo.Id);
                            if (!checkVlue)
                            {
                                policyDao.InsertProPolicyFactorGiftUi(gift);
                            }
                            else
                            {
                                if (model.IptIsGift)
                                {
                                    //修改是赠品
                                    policyDao.UpdateIsGiftUi(gift);
                                }
                                if (model.IptPointsValue)
                                {
                                    //修改是积分使用范围
                                    policyDao.UpdateIsUsePointUi(gift);
                                }
                            }
                        }
                    }
                    else
                    {
                        ProPolicyFactorUi factor = new ProPolicyFactorUi();

                        factor.PolicyFactorId = model.IptPolicyFactorId.ToInt();
                        factor.FactDesc = model.IptRemark;
                        factor.CurrUser = UserInfo.Id;
                        policyDao.UpdateProPolicyFactorUi(factor);
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

        public FactorInfoVO ShowCondition(FactorInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    if (model.IptFactorClass == "Rule")
                    {
                        Hashtable ruleCondition = new Hashtable();
                        ruleCondition.Add("FactConditionId", model.IptConditionId);
                        ruleCondition.Add("CurrUser", UserInfo.Id);
                        DataTable rule = policyDao.QueryUIPolicyFactorCondition(ruleCondition).Tables[0];

                        model.IptRuleCondition = rule.Rows[0].GetSafeStringValue("ConditionId");
                        model.IptRuleConditionType = rule.Rows[0].GetSafeStringValue("OperTag");
                        model.RstRuleConditionValues = JsonHelper.DataTableToArrayList(policyDao.SelectFactorConditionRuleUiSeletedString(ruleCondition).Tables[0]);

                        Hashtable condition = new Hashtable();
                        condition.Add("FactId", model.IptFactor);
                        condition.Add("ConditionId", model.IptRuleCondition.IsNullOrEmpty() ? "-1" : model.IptRuleCondition);
                        model.LstRuleConditionType = JsonHelper.DataTableToArrayList(policyDao.GetFactorConditionType(condition).Tables[0]);
                    }
                    else if (model.IptFactorClass == "Relation")
                    {
                        Hashtable relationCondition = new Hashtable();
                        relationCondition.Add("PolicyFactorId", model.IptPolicyFactorId);
                        relationCondition.Add("CurrUser", UserInfo.Id);
                        model.LstRelationCondition = JsonHelper.DataTableToArrayList(policyDao.GetFactorRelationeUiCan(relationCondition).Tables[0]);
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

        public FactorInfoVO SaveCondition(FactorInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    Hashtable ruleCondition = new Hashtable();
                    ruleCondition.Add("PolicyFactorId", model.IptPolicyFactorId);
                    ruleCondition.Add("CurrUser", UserInfo.Id);
                    if (model.IptFactorClass == "Rule")
                    {
                        //TODO 解析伪代码并校验
                        String[] values = model.IptRuleConditionValues.Split(new String[] { "\n" }, StringSplitOptions.RemoveEmptyEntries);
                        //String inValue = "";
                        //for (int i = 0; i < values.Length; i++)
                        //{
                        //    inValue += "'" + values[i].Replace("'", "''") + "'";
                        //    if (i != values.Length - 1)
                        //    {
                        //        inValue += ",";
                        //    }
                        //}

                        ProPolicy policyHeader = policyDao.GetUIPolicyHeader(UserInfo.Id);
                        Hashtable checkCondition = new Hashtable();
                        checkCondition.Add("ProductLineId", policyHeader.ProductLineId);
                        checkCondition.Add("SubBU", policyHeader.SubBu);
                        checkCondition.Add("ConditionId", model.IptRuleCondition);
                        checkCondition.Add("CurrUser", UserInfo.Id);

                        DataTable checkList = policyDao.QueryFactorConditionRuleUiCanNew(checkCondition).Tables[0];

                        bool checkResult = true;
                        StringCollection checkedList = new StringCollection();
                        foreach (String value in values)
                        {
                            DataRow[] list = checkList.Select("Code = '" + value.Replace("'", "''") + "'");
                            if (list.Length == 0)
                            {
                                checkResult = false;

                                Dictionary<string, object> dictionary = new Dictionary<string, object>();  //实例化一个参数集合
                                dictionary.Add("Code", value);
                                dictionary.Add("ErrMsg", "无效编号");
                                model.RstCheckFailList.Add(dictionary);
                            } else
                            {
                                checkedList.Add(list[0].GetSafeStringValue("Id"));
                            }
                        }

                        if (checkResult)
                        {
                            Hashtable existsCondition = new Hashtable();
                            existsCondition.Add("FactConditionId", model.IptConditionId);
                            existsCondition.Add("PolicyFactorId", model.IptPolicyFactorId);
                            existsCondition.Add("CurrUser", UserInfo.Id);
                            DataTable exists = policyDao.QueryUIPolicyFactorCondition(existsCondition).Tables[0];

                            if (exists.Rows.Count == 0)
                            {
                                Hashtable rule = new Hashtable();
                                rule.Add("FactConditionId", model.IptConditionId);
                                rule.Add("PolicyFactorId", model.IptPolicyFactorId);
                                rule.Add("ConditionId", model.IptRuleCondition);
                                rule.Add("ConditionType", model.IptRuleConditionType);
                                rule.Add("CurrUser", UserInfo.Id);

                                policyDao.InsertPolicyFactorConditionUi(rule);
                            }

                            //TODO 解析伪代码并保存
                            Hashtable clear = new Hashtable();
                            clear.Add("FactConditionId", model.IptConditionId);
                            clear.Add("PolicyFactorId", model.IptPolicyFactorId);
                            clear.Add("CurrUser", UserInfo.Id);

                            policyDao.FactorConditionRuleUiSetClear(clear);

                            foreach (String value in checkedList)
                            {
                                Hashtable ruleItem = new Hashtable();
                                ruleItem.Add("FactConditionId", model.IptConditionId);
                                ruleItem.Add("PolicyFactorId", model.IptPolicyFactorId);
                                ruleItem.Add("ConditionValueAdd", value);
                                ruleItem.Add("CurrUser", UserInfo.Id);

                                policyDao.FactorConditionRuleUiSet(ruleItem);
                            }

                            model.RstFactorRule = JsonHelper.DataTableToArrayList(policyDao.QueryConditionRuleUi(ruleCondition).Tables[0]);
                        }
                    }
                    else if (model.IptFactorClass == "Relation")
                    {
                        Hashtable relation = new Hashtable();
                        relation.Add("PolicyFactorId", model.IptPolicyFactorId);
                        relation.Add("ConditionPolicyFactorId", model.IptRelationCondition);
                        relation.Add("CurrUser", UserInfo.Id);

                        policyDao.InsertPolicyFactorRelation(relation);

                        model.RstFactorRule = JsonHelper.DataTableToArrayList(policyDao.QueryFactorRelationUi(ruleCondition).Tables[0]);
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

        public FactorInfoVO RemoveCondition(FactorInfoVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    Hashtable ruleCondition = new Hashtable();
                    ruleCondition.Add("PolicyFactorId", model.IptPolicyFactorId);
                    ruleCondition.Add("CurrUser", UserInfo.Id);
                    if (model.IptFactorClass == "Rule")
                    {
                        Hashtable condition = new Hashtable();
                        condition.Add("CurrUser", UserInfo.Id);
                        condition.Add("PolicyFactorConditionId", model.IptConditionId);
                        condition.Add("PolicyFactorId", model.IptPolicyFactorId);
                        policyDao.DeleteUIPolicyFactorCondition(condition);

                        model.RstFactorRule = JsonHelper.DataTableToArrayList(policyDao.QueryConditionRuleUi(ruleCondition).Tables[0]);
                    }
                    else if (model.IptFactorClass == "Relation")
                    {
                        Hashtable condition = new Hashtable();
                        condition.Add("CurrUser", UserInfo.Id);
                        condition.Add("PolicyFactorId", model.IptPolicyFactorId);
                        condition.Add("ConditionPolicyFactorId", model.IptConditionId);
                        policyDao.DeletePolicyFactorRelation(condition);

                        model.RstFactorRule = JsonHelper.DataTableToArrayList(policyDao.QueryFactorRelationUi(ruleCondition).Tables[0]);
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

        #endregion

        #region Internal Function

        private String GetFactorClass(String factor)
        {
            String factorClass = "";

            if (factor.Equals("1") || factor.Equals("2") || factor.Equals("3"))
            {
                factorClass = "Rule";
            }
            else if (factor.Equals("6") || factor.Equals("7") || factor.Equals("8") || factor.Equals("9") || factor.Equals("12") || factor.Equals("13") || factor.Equals("14") || factor.Equals("15"))
            {
                factorClass = "Relation";
            }

            return factorClass;
        }

        #endregion
    }
}
