using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;
using DMS.Model;

namespace DMS.Business
{
    public interface IPromotionPolicyBLL
    {
        //获取产品线对应合同分类
        DataSet GetSubBU(string productLineId);

        //促销
        DataSet QueryPolicyList(Hashtable obj, int start, int limit, out int totalCount);
        string SubmintPolicy(Hashtable obj);
        string SubmintPolicyCheck(Hashtable obj);
        int DeletePolicy(string policyId);
        bool SavePolicyUi(ProPolicy policyui);
        bool PolicyCopy(string policyId, string userId);
        void SendEWorkflow(int policyId);

        DataSet GetProPolicyByHash(Hashtable obj);
        DataSet QueryPolicyFactorList(Hashtable obj);
        void UpdateProlicyInit(string UserId, string PolicyId, string PolicyStyle, string PolicyStyleSub);
        ProPolicy GetUIPolicyHeader(string UserId);
        IList<ProPolicyFactorUi> QueryUIPolicyFactorList(ProPolicyFactorUi obj);
        DataSet QueryUIPolicyFactorAndGift(ProPolicyFactorUi policyFactor);
        DataSet QueryUIPolicyFactorAndGift(ProPolicyFactorUi policyFactor, int start, int limit, out int totalCount);
        bool InsertProPolicyFactorUi(ProPolicyFactorUi policyFactor, string isGift, string IsNoPoint);
        int UpdateProPolicyFactorUi(ProPolicyFactorUi policyFactor);
        bool DeleteProPolicyFactorUi(Hashtable obj, string isGift, string isPoint);
        DataSet GetIsGift(Hashtable obj);
        string CheckIsGift(Hashtable obj);

        DataSet GetFactorConditionByFactorId(string FactorId);
        DataSet GetFactorConditionType(Hashtable obj);
        void InsertUIPolicyFactorCondition(Hashtable obj);
        DataSet QueryUIPolicyFactorCondition(Hashtable obj);
        void DeleteUIPolicyFactorCondition(Hashtable obj);

        DataSet QueryFactorConditionRuleUiCan(Hashtable obj, int start, int limit, out int totalCount);
        int FactorConditionRuleUiSet(Hashtable obj);
        DataSet QueryFactorConditionRuleUiSeleted(Hashtable obj, int start, int limit, out int totalCount);
        void FactorConditionRuleUiDelete(Hashtable obj);
        DataSet QueryConditionRuleUi(Hashtable obj, int start, int limit, out int totalCount);

        //获取用于计算的政策因素
        DataSet GetComputePolicyFactorUi(Hashtable obj);
        //后去可用于门槛的因素
        DataSet GetSillPolicyFactorUi(Hashtable obj);

        //维护政策包含经销商
        DataSet QueryDealerCan(Hashtable obj, int start, int limit, out int totalCount);
        DataSet QueryPolicyDealerSelected(Hashtable obj, int start, int limit, out int totalCount);
        void InsertPolicyDealer(Hashtable obj);
        int DeleteSelectedDealer(Hashtable obj);

        //维护赠品封顶值
        int DeleteTopValueByUserId();
        bool TopValueImport(DataTable dt, string policyId, string topValueType);
        DataSet QueryTopValue(Hashtable obj, int start, int limit, out int totalCount);
        DataSet QueryTopValue(Hashtable obj);
        bool VerifyTopValue(out string IsValid, string TopValueType);

        //指定产品指标
        DataSet QueryPolicyProductIndxUi(Hashtable obj, string FactId);
        DataSet QueryPolicyProductIndxUi(Hashtable obj, string FactId, int start, int limit, out int totalCount);
        void DeleteProductIndexByUserId(string FactId,string PolicyFactorId);
        bool ProductIndexImport(DataTable dt, string policyFactorId, string factType);
        bool VerifyProductIndex(out string IsValid, string factType);

        //获取可设定的关联因素
        DataSet QueryFactorRelationUi(Hashtable obj, int start, int limit, out int totalCount);
        DataSet GetFactorRelationeUiCan(Hashtable obj);
        void InsertPolicyFactorRelation(Hashtable obj);
        void DeletePolicyFactorRelation(Hashtable obj);
        bool CheckFactorHasRelation(string ConditionPolicyFactorId, string userId);

        //促销规制维护
        DataSet QueryFactorRuleUi(Hashtable obj, int start, int limit, out int totalCount);
        DataSet GetPolicyRuleUi(Hashtable obj);
        bool CheckPolicyRuleUiHasFactor(Hashtable obj);
        void InsertPolicyRuleUi(ProPolicyRuleUi policyRule, bool PageType);
        bool DeletePolicyRuleUi(Hashtable obj);

        //促销规则条件
        DataSet GetPolicyRuleConditionUi(Hashtable obj);
        DataSet QueryUIFactorRuleCondition(Hashtable obj, int start, int limit, out int totalCount);
        void InsertPolicyRuleConditionUi(ProPolicyRuleFactorUi ruleCondition, bool PageType);
        void DeleteFactorRuleConditionUi(Hashtable obj);

        //指定经销商批量导入

        DataSet QueryPolicyDealerUpload(Hashtable obj, int start, int limit, out int totalCount);
        bool DealersImport(DataTable dt, string policyId);
        bool VerifyDealers(out string IsValid, string ProductLineId, string SubBU);
        int DeleteDealersByUserId();
        void DealersUiSubmint();

        //获取政策HTMl文件
        string GetPolicyHtml(string policyId);

        //政策附件
        DataSet QueryPolicyAttachment(Hashtable obj, int start, int limit, out int totalCount);
        void InsertPolicyAttachment(Hashtable obj);
        int DeletePolicyAttachment(string Id);

        //政策医院信息批量维护
        int DeletePolicyHospitalUIByConditionId(string userId, string FactConditionId);
        bool HospitalImport(DataTable dt, string FactConditionId, string PolicyFactorId, string ConditionType, out string errmsg);

        //积分政策加价率
        bool PointRatioImport(DataTable dt, string policyId);
        bool VerifyRatioImport(out string IsValid);
        DataSet QueryPointRatio(Hashtable obj, int start, int limit, out int totalCount);
        DataSet QueryPointRatio(Hashtable obj);
        int DeletePolicyPointRatioByUserId();

        //积分政策产品标准价
        int DeleteProductStandardPriceByUserId();
        bool ProductStandardPriceImport(DataTable dt, string policyId);
        bool VerifyStandardPrice(out string IsValid);
        DataSet QueryStandardPrice(Hashtable obj, int start, int limit, out int totalCount);
        DataSet QueryStandardPrice(Hashtable obj);
        //统一加价率维护 lijie add 2016_06_06
        DataSet Query_ProPointRatio(Hashtable obj, int start, int limit, out int totalCount);
        ProBuPointRatio GetProBuPointRatioObj(int Id);
        DataSet SelectDealerByproductline(string Id);
        bool AddProPointRatio(ProBuPointRatio Ratio);
        bool UpdateProPointRatio(ProBuPointRatio Ratio);
        bool DeleteProPointRatio(int Id);
        bool PointRatioImpor(DataTable dt);
        bool DeletePointRatioUIByCurrUser(string CurrUser);
        bool VerifyRatioUiInit(string UserId, int IsImport, out string IsValid);
        DataSet QueryPro_BU_PointRatio_UIByUserId(Hashtable obj, int start, int limit, out int totalCount);
        DataSet ExistsByBuDmaId(Hashtable obj);
        //查询赠品 lijie add 20160914
        DataSet QueryPromotionQuotazp(Hashtable obj, int start, int limit, out int totalCount);
        DataSet QueryPromotionQuotajf(Hashtable obj, int start, int limit, out int totalCount);
        DataSet ExporPromotionQuotajf(Hashtable obj);
        DataSet ExporPromotionQuotazp(Hashtable obj);
        //赠品和积分日志查询
        DataSet SelectLargesslogType();
        DataSet SelectPointlogType();
        DataSet QueryLargesslogByDmabu(Hashtable obj, int start, int limit, out int totalCount);
        DataSet QueryPointlogByDmabu(Hashtable obj, int start, int limit, out int totalCount);
        DataSet SelectPointlogByDmabuExportExcel(Hashtable ht);
        DataSet SelectargesslogByExportExcel(Hashtable obj);

        DataSet SelectPromotion(string PolicyNo);

        DataSet SelectPromotionPOLICY_RULE(Hashtable obj, int start, int limit, out int totalCount);

        DataSet GetPromotionPOLICY_RULE(Hashtable obj);

        void UpdatePolicy(Hashtable obj);
        DataSet SelectPolicyFactor(Hashtable obj);
        bool StatusUpdate(Hashtable obj);
        DataSet SelectPolicyFactorall(Hashtable obj, int start, int limit, out int totalCount);
        DataSet SelectOrderOperationLog(Hashtable obj);
        DataSet SelectAttachment(string mainid);
        DataSet SelectConditionRule(Hashtable obj, int start, int limit, out int totalCount);
        DataSet SelectPolicyFactorCondition(Hashtable obj);
        int FactorConditionRuleSet(Hashtable obj);
        void FactorConditionRuleDelete(Hashtable obj);
        DataSet SelectFactorConditionRuleSeletedALL(Hashtable obj, int start, int limit, out int totalCount);
        DataSet SelectFactorConditionRuleCanAll(Hashtable obj, int start, int limit, out int totalCount);
        DataSet GetPromotionQuotajfById(string Id);
        DataSet GetPromotionQuotazpById(string Id);
        bool PromotionAdjustmentLimit(string Id,string PolicyType,double number, string Remark);

    }
}
