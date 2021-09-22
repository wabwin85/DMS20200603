
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ProPolicy
 * Created Time: 2015/11/10 16:59:13
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// ProPolicy的Dao
    /// </summary>
    public class ProPolicyDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public ProPolicyDao()
            : base()
        {
        }

        public void InsertPolicyOperationLog(string XML)
        {
            this.ExecuteInsert("InsertPolicyOperationLog", XML);
        }



        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ProPolicy GetObject(int objKey)
        {
            ProPolicy obj = this.ExecuteQueryForObject<ProPolicy>("SelectProPolicy", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ProPolicy> GetAll()
        {
            IList<ProPolicy> list = this.ExecuteQueryForList<ProPolicy>("SelectProPolicy", null);
            return list;
        }


        /// <summary>
        /// 查询ProPolicy
        /// </summary>
        /// <returns>返回ProPolicy集合</returns>
        public IList<ProPolicy> SelectByFilter(ProPolicy obj)
        {
            IList<ProPolicy> list = this.ExecuteQueryForList<ProPolicy>("SelectByFilterProPolicy", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdatePolicyUi(ProPolicy obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateProPolicyUi", obj);
            return cnt;
        }

        public DataSet GetProPolicyByHash(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProPolicyByHash", obj);
            return ds;
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(int objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteProPolicy", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ProPolicy obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteProPolicy", obj);
            return cnt;
        }

        public DataSet GetPolicy(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyFormal", obj);
            return ds;
        }

        public DataSet GetPolicyhtml(string PolicyId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyhtml", PolicyId);
            return ds;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ProPolicy obj)
        {
            this.ExecuteInsert("InsertProPolicy", obj);
        }

        public DataSet GetSubBU(string productLineId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSubBU", productLineId);
            return ds;
        }

        public DataTable QueryPolicyList(Hashtable obj)
        {
            DataTable ds = this.ExecuteQueryForDataSet("SelectPolicyList", obj).Tables[0];
            return ds;
        }

        public DataTable QueryTermainationList(Hashtable obj)
        {
            DataTable ds = this.ExecuteQueryForDataSet("SelectTermainationList", obj).Tables[0];
            return ds;
        }

        public DataTable QuerySelectPolicyNo(Hashtable obj)
        {
            DataTable ds = this.ExecuteQueryForDataSet("SelectPolicyNo", obj).Tables[0];
            return ds;
        }
        public DataTable QuerySelectPolicyNoView(Hashtable obj)
        {
            DataTable ds = this.ExecuteQueryForDataSet("SelectPolicyNoView", obj).Tables[0];
            return ds;
        }
        public DataTable QuerySelectProductLine(Hashtable obj)
        {
            DataTable ds = this.ExecuteQueryForDataSet("SelectProductLine", obj).Tables[0];
            return ds;
        }
        public DataTable SelectPromotion_PRO_POLICY_Termaination(string id)
        {
            DataTable ds = this.ExecuteQueryForDataSet("SelectPromotion_PRO_POLICY_Termaination", id).Tables[0];
            return ds;
        }



        public DataTable SelectConsignApplyList(Hashtable obj)
        {
            DataTable ds = this.ExecuteQueryForDataSet("SelectConsignApplyList", obj).Tables[0];
            return ds;
        }


        public DataTable QueryPolicyInfo(string PolicyNo)
        {
            DataTable ds = this.ExecuteQueryForDataSet("SelectPolicyInfo", PolicyNo).Tables[0];
            return ds;
        }
        public DataSet QueryPolicyList(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyList", obj, start, limit, out totalCount);
            return ds;
        }

        public void insertTermainationInfo(Hashtable tb)
        {
           this.ExecuteInsert("InsertTermainationInfo", tb);
           
        }
        public void UpdateTermainationInfo(Hashtable tb)
        {
            this.ExecuteInsert("UpdateTermainationInfo", tb);

        }
        public string GetNextAutoNumberForPromotion(string deptcode, string clientid, string strSettings)
        {
            string strNextAutoNumber = "";
            Hashtable ht = new Hashtable();
            ht.Add("DeptCode", deptcode);
            ht.Add("ClientID", clientid);
            ht.Add("Settings", strSettings);
            ht.Add("nextnbr", strNextAutoNumber);
            this.ExecuteInsert("SelectNextAutoNumberForPromotion", ht);
            strNextAutoNumber = ht["nextnbr"].ToString();
            return strNextAutoNumber;
        }
        public DataTable SelectPolicyTemplateList(String policyName, String bu, String policyStyle, String userId, String identityType, String[] units)
        {
            Hashtable condition = new Hashtable();
            condition.Add("PolicyName", policyName);
            condition.Add("BU", bu);
            condition.Add("PolicyStyle", policyStyle);
            condition.Add("UserId", userId);
            condition.Add("OwnerIdentityType", identityType);
            condition.Add("OwnerOrganizationUnits", units);
            DataTable ds = this.ExecuteQueryForDataSet("SelectPolicyTemplateList", condition).Tables[0];
            return ds;
        }

        public DataTable SelectPolicyTemplateListByProductLine(String bu)
        {
            DataTable ds = this.ExecuteQueryForDataSet("SelectPolicyTemplateListByProductLine", bu).Tables[0];
            return ds;
        }

        /// <summary>
        /// 保存临时表政策数据
        /// </summary>
        public void SavePolicyUi(ProPolicy policy)
        {
            this.ExecuteInsert("InsertProPolicy", policy);
        }

        /// <summary>
        /// 删除正式表政策数据
        /// </summary>
        public int DeletePolicy(string policyId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteProPolicy", policyId);
            return cnt;
        }

        /// <summary>
        /// 同步临时表数据到正式表
        /// </summary>
        public string SubmintPolicy(Hashtable obj)
        {
            this.ExecuteInsert("GC_PolicySave", obj);

            string Result = obj["Result"].ToString();

            return Result;
        }

        /// <summary>
        /// 同步临时表数据到正式表
        /// </summary>
        public string SubmintPolicyCheck(Hashtable obj)
        {
            this.ExecuteInsert("GC_PolicySubmitCheck", obj);

            string Result = obj["Result"].ToString();

            return Result;
        }

        /// <summary>
        /// 拷贝政策
        /// </summary>
        public bool PolicyCopy(string policyId, string userId, string mode,ref string newId)
        {
            string Result = "";
            Hashtable obj = new Hashtable();
            obj.Add("PolicyId", policyId);
            obj.Add("UserId", userId);
            obj.Add("Mode", mode);
            obj.Add("NewId", 0);
            obj.Add("Result", Result);

            this.ExecuteInsert("GC_PolicyTempCopy", obj);

            Result = obj["Result"].ToString();
            newId = obj["NewId"].ToString();
            if (Result.Equals("Success"))
            {
                return true;
            }
            else
            {
                return false;
            }
        }


        public DataSet QueryPolicyFactorList(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyFactorList", obj);
            return ds;
        }

        public void UpdateProlicyInit(Hashtable obj)
        {
            this.ExecuteQueryForDataSet("UpdateProlicyInit", obj);
        }

        public ProPolicy GetUIPolicyHeader(string UserId)
        {
            ProPolicy obj = this.ExecuteQueryForObject<ProPolicy>("SelectUIPolicyHeader", UserId);
            return obj;
        }

        public IList<ProPolicyFactorUi> QueryUIPolicyFactorList(ProPolicyFactorUi obj)
        {
            IList<ProPolicyFactorUi> list = this.ExecuteQueryForList<ProPolicyFactorUi>("SelectByFilterProPolicyFactorUi", obj);
            return list;
        }

        public ProPolicyFactorUi QueryUIPolicyFactor(ProPolicyFactorUi obj)
        {
            ProPolicyFactorUi PolicyFactorUi = this.ExecuteQueryForObject<ProPolicyFactorUi>("SelectByFilterProPolicyFactorUi", obj);
            return PolicyFactorUi;
        }

        public DataSet QueryUIPolicyFactorAndGift(ProPolicyFactorUi obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyFactorUi", obj);
            return ds;
        }


        public DataSet QueryUIPolicyFactorAndGift(ProPolicyFactorUi obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyFactorUi", obj, start, limit, out totalCount);
            return ds;
        }

        public void InsertProPolicyFactorUi(ProPolicyFactorUi obj)
        {
            this.ExecuteInsert("InsertProPolicyFactorUi", obj);
        }

        public int UpdateProPolicyFactorUi(ProPolicyFactorUi obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateProPolicyFactorUi", obj);
            return cnt;
        }

        /// <summary>
        /// 获取赠品表数据
        /// </summary>
        public DataSet GetPolicyLargessUi(string userId, string policyId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("CurrUser", userId);
            obj.Add("PolicyId", policyId);

            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyLargessUi", obj);
            return ds;
        }
        /// <summary>
        /// 维护赠品表
        /// </summary>
        public void InsertProPolicyFactorGiftUi(Hashtable obj)
        {
            this.ExecuteInsert("InsertProPolicyFactorGiftUi", obj);
        }
        ///<summary>
        ///修改是赠品
        ///</summary>
        public void UpdateIsGiftUi(Hashtable obj)
        {
            this.ExecuteQueryForDataSet("UpdateIsGiftUi", obj);
        }

        ///<summary>
        ///修改是积分使用产品
        ///</summary>
        public void UpdateIsUsePointUi(Hashtable obj)
        {
            this.ExecuteQueryForDataSet("UpdateIsUsePointUi", obj);
        }



        public int DeletePolicyFactorUi(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("DeleteProPolicyFactorUi", obj);
            return cnt;
        }

        public int DeletePolicyFactorGiftUi(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("DeletePolicyFactorGiftUi", obj);
            return cnt;
        }

        public DataSet GetIsGift(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectIsGift", obj);
            return ds;
        }

        public DataSet CheckIsGift(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectIsGift", obj);
            return ds;
        }

        public DataSet GetFactorConditionByFactorId(string FactorId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFactorConditionByFactorId", FactorId);
            return ds;
        }

        public DataSet GetFactorConditionType(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFactorConditionType", obj);
            return ds;
        }

        public void InsertPolicyFactorConditionUi(Hashtable obj)
        {
            this.ExecuteInsert("InsertPolicyFactorConditionUi", obj);
        }

        public DataSet QueryUIPolicyFactorCondition(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectUIPolicyFactorCondition", obj);
            return ds;
        }

        public int DeleteUIPolicyFactorCondition(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("DeleteUIPolicyFactorCondition", obj);
            return cnt;
        }

        /// <summary>
        /// 获取政策因素可选限定规则
        /// </summary>
        public DataSet QueryFactorConditionRuleUiCanNew(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFactorConditionRuleUiCanNew", obj);
            return ds;
        }

        /// <summary>
        /// 获取政策因素可选限定规则
        /// </summary>
        public DataSet QueryFactorConditionRuleUiCan(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFactorConditionRuleUiCan", obj, start, limit, out totalCount);
            return ds;
        }

        /// <summary>
        /// 清空政策因素规则
        /// </summary>
        public int FactorConditionRuleUiSetClear(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("FactorConditionRuleUiSetClear", obj);
            return cnt;
        }

        /// <summary>
        /// 政策因素设定限定规则
        /// </summary>
        public int FactorConditionRuleUiSet(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("FactorConditionRuleUiSet", obj);
            return cnt;
        }

        /// <summary>
        /// 获取政策因素已选限定规则
        /// </summary>
        public DataSet SelectFactorConditionRuleUiSeletedString(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFactorConditionRuleUiSeletedString", obj);
            return ds;
        }

        /// <summary>
        /// 获取政策因素已选限定规则
        /// </summary>
        public DataSet QueryFactorConditionRuleUiSeleted(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFactorConditionRuleUiSeleted", obj, start, limit, out totalCount);
            return ds;
        }

        /// <summary>
        /// 删除政策因素已选限定规则
        /// </summary>
        public void FactorConditionRuleUiDelete(Hashtable obj)
        {
            this.ExecuteQueryForDataSet("FactorConditionRuleUiDelete", obj);
        }

        /// <summary>
        /// 查询政策因素规则
        /// </summary>
        public DataSet QueryConditionRuleUi(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectConditionRuleUi", obj);
            return ds;
        }

        /// <summary>
        /// 查询政策因素规则
        /// </summary>
        public DataSet QueryConditionRuleUi(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectConditionRuleUi", obj, start, limit, out totalCount);
            return ds;
        }

        /// <summary>
        /// 查询政策可选经销商列表
        /// </summary>
        public DataSet QueryDealerCan(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerCan", obj, start, limit, out totalCount);
            return ds;
        }

        /// <summary>
        /// 查询政策已选经销商列表
        /// </summary>
        public DataSet QueryPolicyDealerSelected(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerSelected", obj);
            return ds;
        }

        /// <summary>
        /// 查询政策已选经销商列表
        /// </summary>
        public DataSet QueryPolicyDealerSelected(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerSelected", obj, start, limit, out totalCount);
            return ds;
        }

        /// <summary>
        /// 维护政策经销商(根据授权)
        /// </summary>
        public void InsertPolicyDealerByAuth(Hashtable obj)
        {
            this.ExecuteInsert("InsertPolicyDealerByAuth", obj);
        }

        /// <summary>
        /// 删除临时表中根据授权关联经销商
        /// </summary>
        public int DeletePolicyDealerByAuth(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeletePolicyDealerByAuth", obj);
            return cnt;
        }

        /// <summary>
        /// 维护政策经销商
        /// </summary>
        public void InsertPolicyDealer(Hashtable obj)
        {
            this.ExecuteInsert("InsertPolicyDealer", obj);
        }

        /// <summary>
        /// 删除临时表中已维护使用经销商信息
        /// </summary>
        public int DeleteSelectedDealer(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteSelectedDealer", obj);
            return cnt;
        }

        /// <summary>
        /// 删除临时表中维护人已经上传数据
        /// </summary>
        public int DeleteTopValueByUserId(string UserId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTopValueByUserId", UserId);
            return cnt;
        }

        /// <summary>
        /// 批量插入TopValue数据
        /// </summary>
        /// <param name="list"></param>
        public void BatchTopValueInsert(IList<ProPolicyTopvalueUi> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("PolicyId", typeof(int));
            dt.Columns.Add("DealerId");
            dt.Columns.Add("HospitalId");
            dt.Columns.Add("Period");
            dt.Columns.Add("TopValue");
            dt.Columns.Add("CreateBy");
            dt.Columns.Add("CreateTime", typeof(DateTime));
            dt.Columns.Add("CurrUser");
            dt.Columns.Add("SAPCode");
            dt.Columns.Add("ErrMsg");
            foreach (ProPolicyTopvalueUi data in list)
            {
                DataRow row = dt.NewRow();
                row["PolicyId"] = data.PolicyId;
                row["DealerId"] = data.DealerId;
                row["HospitalId"] = data.HospitalId;
                row["Period"] = data.Period;
                row["TopValue"] = data.TopValue;
                row["CreateBy"] = data.CreateBy;
                row["CreateTime"] = data.CreateTime;
                row["CurrUser"] = data.CurrUser;
                row["SAPCode"] = data.SAPCode;
                row["ErrMsg"] = data.ErrMsg;
                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("Promotion.PRO_POLICY_TOPVALUE_UI", dt);
        }

        /// <summary>
        ///获取政策封顶值 
        /// </summary>
        public DataSet QueryTopValue(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTopValue", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet QueryTopValue(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTopValue", obj);
            return ds;
        }
        public string TopValueInitialize(Guid UserId, string TopValueType)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("TopValueType", TopValueType);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_TopValueInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        /// <summary>
        ///获取已经导入的经销商商业采购指标
        /// </summary>
        public DataSet QueryBSCSalesProductIndxUi(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectBSCSalesProductIndxUi", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet QueryBSCSalesProductIndxUi(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectBSCSalesProductIndxUi", obj);
            return ds;
        }

        /// <summary>
        ///获取已经导入的医院植入指标
        /// </summary>
        public DataSet QueryInHospitalProductIndxUi(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInHospitalProductIndxUi", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet QueryInHospitalProductIndxUi(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInHospitalProductIndxUi", obj);
            return ds;
        }

        /// <summary>
        /// 删除临时表中经销商采购指标
        /// </summary>
        public int DeleteBSCSalesProductIndxUi(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteBSCSalesProductIndxUi", obj);
            return cnt;
        }

        /// <summary>
        /// 删除临时表中经销商植入指标
        /// </summary>
        public int DeleteInHospitalProductIndxUi(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInHospitalProductIndxUi", obj);
            return cnt;
        }

        /// <summary>
        /// 批量插入经销商采购数据
        /// </summary>
        /// <param name="list"></param>
        public void BatchBSCSalesIndexInsert(IList<ProProductIndexUi> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("PolicyFactorId", typeof(int));
            dt.Columns.Add("DealerId");
            dt.Columns.Add("Period");
            dt.Columns.Add("TargetLevel");
            dt.Columns.Add("TargetValue");
            dt.Columns.Add("CreateBy");
            dt.Columns.Add("CreateTime", typeof(DateTime));
            dt.Columns.Add("CurrUser");
            dt.Columns.Add("SAPCode");
            dt.Columns.Add("ErrMsg");
            foreach (ProProductIndexUi data in list)
            {
                DataRow row = dt.NewRow();
                row["PolicyFactorId"] = data.PolicyFactorId;
                row["DealerId"] = data.DealerId;
                row["Period"] = data.Period;
                row["TargetLevel"] = data.TargetLevel;
                row["TargetValue"] = data.TargetValue;
                row["CreateBy"] = data.CreateBy;
                row["CreateTime"] = data.CreateTime;
                row["CurrUser"] = data.CurrUser;
                row["SAPCode"] = data.SapCode;
                row["ErrMsg"] = data.ErrMsg;
                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("Promotion.Pro_Dealer_PrdPurchase_Taget_UI", dt);
        }

        /// <summary>
        /// 批量插入医院植入指标数据
        /// </summary>
        /// <param name="list"></param>
        public void BatchInHospitalSalesIndexInsert(IList<ProProductIndexUi> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("PolicyFactorId", typeof(int));
            dt.Columns.Add("DealerId");
            dt.Columns.Add("HospitalId");
            dt.Columns.Add("Period");
            dt.Columns.Add("TargetLevel");
            dt.Columns.Add("TargetValue");
            dt.Columns.Add("CreateBy");
            dt.Columns.Add("CreateTime", typeof(DateTime));
            dt.Columns.Add("CurrUser");
            dt.Columns.Add("SAPCode");
            dt.Columns.Add("ErrMsg");
            foreach (ProProductIndexUi data in list)
            {
                DataRow row = dt.NewRow();
                row["PolicyFactorId"] = data.PolicyFactorId;
                row["DealerId"] = data.DealerId;
                row["HospitalId"] = data.HospitalId;
                row["Period"] = data.Period;
                row["TargetLevel"] = data.TargetLevel;
                row["TargetValue"] = data.TargetValue;
                row["CreateBy"] = data.CreateBy;
                row["CreateTime"] = data.CreateTime;
                row["CurrUser"] = data.CurrUser;
                row["SAPCode"] = data.SapCode;
                row["ErrMsg"] = data.ErrMsg;
                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("Promotion.Pro_Hospital_PrdSalesTaget_UI", dt);
        }

        public string ProductIndexInitialize(Guid UserId, string factType)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("FactType", factType);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_ProductIndexInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        /// <summary>
        /// 获取对应因素所能选择的关联因素
        /// </summary>
        public DataSet GetFactorRelationeUiCan(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFactorRelationeUiCan", obj);
            return ds;
        }

        /// <summary>
        /// 新增因素关联关系
        /// </summary>
        public void InsertPolicyFactorRelation(Hashtable obj)
        {
            this.ExecuteInsert("InsertPolicyFactorRelation", obj);
        }

        /// <summary>
        /// 删除因素关联关系
        /// </summary>
        public int DeletePolicyFactorRelation(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeletePolicyFactorRelation", obj);
            return cnt;
        }

        /// <summary>
        /// 获取已经设定的因素关联关系
        /// </summary>
        public DataSet QueryFactorRelationUi(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFactorRelationUi", obj);
            return ds;
        }

        /// <summary>
        /// 获取已经设定的因素关联关系
        /// </summary>
        public DataSet QueryFactorRelationUi(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFactorRelationUi", obj, start, limit, out totalCount);
            return ds;
        }

        /// <summary>
        /// 获取已经设定的因素关联关系
        /// </summary>
        public DataSet GetFactorHasRelation(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFactorHasRelationUi", obj);
            return ds;
        }

        /// <summary>
        /// 获取已设定促销规制
        /// </summary>
        public DataSet GetPolicyRuleUi(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyRuleUi", obj);
            return ds;
        }

        public DataSet QueryFactorRuleUi(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyRuleUi", obj, start, limit, out totalCount);
            return ds;
        }

        /// <summary>
        /// 新增促销赠送规则
        /// </summary>
        public void InsertPolicyRuleUi(ProPolicyRuleUi policyRule)
        {
            this.ExecuteInsert("InsertProPolicyRuleUi", policyRule);
        }

        /// <summary>
        /// 删除促销赠送规则
        /// </summary>
        public int DeletePolicyRuleUi(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteProPolicyRuleUi", obj);
            return cnt;
        }

        /// <summary>
        /// 修改促销赠送规则
        /// </summary>
        public int UpdatePolicyRuleUi(ProPolicyRuleUi policyRule)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateProPolicyRuleUi", policyRule);
            return cnt;
        }

        /// <summary>
        /// 获取促销规则条件
        /// </summary>
        public DataSet GetPolicyRuleConditionUi(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyRuleConditionUi", obj);
            return ds;
        }

        /// <summary>
        /// 获取因素规则条件
        /// </summary>
        public DataSet QueryUIFactorRuleCondition(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectUIFactorRuleCondition", obj);
            return ds;
        }

        /// <summary>
        /// 获取因素规则条件
        /// </summary>
        public DataSet QueryUIFactorRuleCondition(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectUIFactorRuleCondition", obj, start, limit, out totalCount);
            return ds;
        }

        /// <summary>
        /// 新增促销赠送规则限定条件
        /// </summary>
        public void InsertPolicyRuleConditionUi(ProPolicyRuleFactorUi ruleCondition)
        {
            this.ExecuteInsert("InsertPolicyRuleConditionUi", ruleCondition);
        }

        /// <summary>
        /// 修改促销赠送规则限定条件
        /// </summary>
        public int UpdatePolicyRuleConditionUi(ProPolicyRuleFactorUi ruleCondition)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePolicyRuleConditionUi", ruleCondition);
            return cnt;
        }

        /// <summary>
        /// 删除促销赠送规则限定条件
        /// </summary>
        public int DeleteFactorRuleConditionUi(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteFactorRuleConditionUi", obj);
            return cnt;
        }

        /// <summary>
        /// 批量插入Dealers数据
        /// </summary>
        /// <param name="list"></param>
        public void BatchDealersInsert(IList<ProDealerInputUi> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("PolicyId", typeof(int));
            dt.Columns.Add("SAPCode");
            dt.Columns.Add("DealerName");
            dt.Columns.Add("ErrMsg");
            dt.Columns.Add("CurrUser");

            foreach (ProDealerInputUi data in list)
            {
                DataRow row = dt.NewRow();
                row["PolicyId"] = data.PolicyId;
                row["SAPCode"] = data.SapCode;
                row["DealerName"] = data.DealerName;
                row["ErrMsg"] = data.ErrMsg;
                row["CurrUser"] = data.CurrUser;
                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("Promotion.PRO_DEALER_Input_UI", dt);
        }

        public string VerifyDealers(Guid UserId, string ProductLinId, string SubBU)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("ProductLinId", ProductLinId);
            ht.Add("SubBU", SubBU);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_ProDealersInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }


        /// <summary>
        /// 删除已经上传的经销商
        /// </summary>
        public int DeleteDealersByUserId(string userId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealersUiByUserId", userId);
            return cnt;
        }

        /// <summary>
        /// 提交包含经销商
        /// </summary>
        public void DealersUiSubmintSuccess(string userId, string operType)
        {
            Hashtable condition = new Hashtable();
            condition.Add("UserId", userId);
            condition.Add("OperType", operType);
            this.ExecuteInsert("InsertDealersUiSuccess", condition);
        }

        /// <summary>
        /// 提交包含经销商
        /// </summary>
        public void DealersUiSubmint(string userId)
        {
            this.ExecuteInsert("InsertDealersUi", userId);
        }

        /// <summary>
        /// 返回上传信息
        /// </summary>
        public DataSet QueryPolicyDealerUpload(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyDealerUpload", obj);
            return ds;
        }

        /// <summary>
        /// 返回上传信息
        /// </summary>
        public DataSet QueryPolicyDealerUpload(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyDealerUpload", obj, start, limit, out totalCount);
            return ds;
        }

        /// <summary>
        /// 后去登录人E-workflow Account
        /// </summary>
        public string QueryEWorkflowAccount(string userId)
        {
            string account = "";
            DataSet ds = this.ExecuteQueryForDataSet("SelectEWorkflowAccount", userId);
            if (ds.Tables[0].Rows.Count > 0)
            {
                account = ds.Tables[0].Rows[0]["UserAccount"].ToString();
            }
            return account;
        }

        /// <summary>
        /// 获取政策附件信息
        /// </summary>
        public DataSet QueryPolicyAttachment(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPromotionPolicyAttachment", obj);
            return ds;
        }

        /// <summary>
        /// 获取政策附件信息
        /// </summary>
        public DataSet QueryPolicyAttachment(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPromotionPolicyAttachment", obj, start, limit, out totalCount);
            return ds;
        }

        /// <summary>
        /// 新增政策附件信息
        /// </summary>
        public void InsertPolicyAttachment(Hashtable obj)
        {
            this.ExecuteInsert("InsertPolicyAttachment", obj);
        }

        public int DeletePolicyAttachment(string Id)
        {
            int cnt = (int)this.ExecuteDelete("DeletePolicyAttachment", Id);
            return cnt;
        }

        public int DeletePolicyHospitalUIByConditionId(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeletePolicyHospitalUIByConditionId", obj);
            return cnt;
        }

        /// <summary>
        /// 判断医院Code 是否填写正确
        /// </summary>
        public string CheckPolicyHospitalCode(string valueHospital)
        {
            string IsValid = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("HospitalHas", valueHospital);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("CheckPolicyHospitalCode", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        /// <summary>
        /// 判断医院Code 是否填写正确
        /// </summary>

        public int UpdatePolicyHospitalUi(ProPolicyFactorConditionUi data)
        {
            Hashtable obj = new Hashtable();
            obj.Add("PolicyFactorConditionId", data.PolicyFactorConditionId);
            obj.Add("ConditionValue", data.ConditionValue);
            obj.Add("CurrUser", data.CurrUser);
            int cnt = (int)this.ExecuteUpdate("UpdatePolicyHospitalUi", obj);
            return cnt;
        }


        /// <summary>
        /// 批量插入加价率数据
        /// </summary>
        /// <param name="list"></param>
        public void BatchPointRatioInsert(IList<ProPolicyPointratioUi> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("PolicyId", typeof(int));
            dt.Columns.Add("AccountMonth");
            dt.Columns.Add("DealerId");
            dt.Columns.Add("Ratio");
            dt.Columns.Add("CreateBy");
            dt.Columns.Add("CreateTime", typeof(DateTime));
            dt.Columns.Add("ModifyBy");
            dt.Columns.Add("ModifyDate", typeof(DateTime));
            dt.Columns.Add("Remark1");
            dt.Columns.Add("CurrUser");
            dt.Columns.Add("SAPCode");
            dt.Columns.Add("ErrMsg");
            foreach (ProPolicyPointratioUi data in list)
            {
                DataRow row = dt.NewRow();
                row["PolicyId"] = data.PolicyId;
                row["AccountMonth"] = data.AccountMonth;
                row["DealerId"] = data.DealerId;
                row["Ratio"] = data.Ratio;

                row["CreateBy"] = data.CreateBy;
                row["CreateTime"] = data.CreateTime;
                row["ModifyBy"] = data.ModifyDate;
                row["ModifyDate"] = data.CreateTime;
                row["Remark1"] = data.Remark1;
                row["CurrUser"] = data.CurrUser;
                row["SapCode"] = data.SapCode;
                row["ErrMsg"] = data.ErrMsg;
                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("Promotion.PRO_POLICY_POINTRATIO_UI", dt);
        }

        public string PointRatioInitialize(Guid UserId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId.ToString());
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_PointRatioInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        /// <summary>
        ///获取政策加价率
        /// </summary>
        public DataSet QueryPointRatio(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPointRatio", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet QueryPointRatio(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPointRatio", obj);
            return ds;
        }

        public int DeletePolicyPointRatioByUserId(string userId)
        {
            int cnt = (int)this.ExecuteDelete("DeletePolicyPointRatioByUserId", userId);
            return cnt;
        }

        public DataSet GetComputePolicyFactorUi(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectComputePolicyFactorUi", obj);
            return ds;
        }

        public DataSet GetSillPolicyFactorUi(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSillPolicyFactorUi", obj);
            return ds;
        }

        /// <summary>
        /// 删除积分政策产品标准价
        /// </summary>
        public int DeleteProductStandardPriceByUserId(string userId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteProductStandardPriceByUserId", userId);
            return cnt;
        }


        /// <summary>
        /// 批量插入补偿产品积分
        /// </summary>
        /// <param name="list"></param>
        public void BatchStandardPriceInsert(IList<ProDealerStdPointUi> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("PolicyId", typeof(int));
            dt.Columns.Add("DealerId");
            dt.Columns.Add("Points");
            dt.Columns.Add("CreateBy");
            dt.Columns.Add("CreateTime", typeof(DateTime));
            dt.Columns.Add("CurrUser");
            dt.Columns.Add("SAPCode");
            dt.Columns.Add("ErrMsg");
            foreach (ProDealerStdPointUi data in list)
            {
                DataRow row = dt.NewRow();
                row["PolicyId"] = data.PolicyId;
                row["DealerId"] = data.DealerId;
                row["Points"] = data.Points;
                row["CreateBy"] = data.CreateBy;
                row["CreateTime"] = data.CreateTime;
                row["CurrUser"] = data.CurrUser;
                row["SapCode"] = data.SapCode;
                row["ErrMsg"] = data.ErrMsg;
                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("Promotion.Pro_Dealer_Std_Point_UI", dt);
        }

        public string StandardPriceInitialize(Guid UserId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId.ToString());
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_StandardPriceInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        /// <summary>
        ///获取补偿价
        /// </summary>
        public DataSet QueryStandardPrice(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectStandardPrice", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet QueryStandardPrice(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectStandardPrice", obj);
            return ds;
        }
        public DataSet SelectLargesslotType()
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectLargesslotType", "");
            return ds;
        }
        public DataSet SelectPointlogType()
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPointlogType", "");
            return ds;
        }
        public DataSet QueryLargesslogByDmabu(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryLargesslogByDmabu", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet QueryPointlogByDmabu(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryPointlogByDmabu", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet SelectPointlogByDmabuExportExcel(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPointlogByDmabuExportExcel", ht);
            return ds;
        }
        public DataSet SelectargesslogByExportExcel(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectargesslogByExportExcel", ht);
            return ds;
        }

        public int UpdatePromotionPolicyInstanceID(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePromotionPolicyInstanceID", obj);
            return cnt;
        }
        public DataSet GetPromotionPolicyNo(string PolicyId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPromotionPolicyNo", PolicyId);
            return ds;
        }

        public void ConvertAdvance(String policyId)
        {
            this.ExecuteUpdate("ConvertAdvance", policyId);
        }

        public String SelectPromotionSummary(String PolicyId, String HtmlType)
        {
            Hashtable condition = new Hashtable();
            condition.Add("PolicyId", PolicyId);
            condition.Add("HtmlType", HtmlType);
            DataSet ds = this.ExecuteQueryForDataSet("SelectPromotionSummary", condition);
            return ds.Tables[0].Rows[0]["SummaryStr"].ToString();
        }

        public String GetPolicyHtmlStr(String PolicyId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyhtml", PolicyId);
            return ds.Tables[0].Rows[0]["PolicyXML"].ToString();
        }
        public DataSet SelectPromotion(string PolicyNo) {

            DataSet ds = this.ExecuteQueryForDataSet("SelectPromotion", PolicyNo);
            return ds;


        }
        public DataSet SelectPromotionPOLICY_RULE(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPromotionPOLICY_RULE", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet GetPromotionPOLICY_RULE(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetPromotionPOLICY_RULE", obj);
            return ds;
        }
        public void UpdatePolicy(Hashtable ht)
        {
             this.ExecuteUpdate("UpdatePolicy", ht);
            
        }
        public DataSet SelectPolicyFactor(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyFactor", obj);
            return ds;
        }
        public void StatusUpdate(Hashtable ht)
        {
            this.ExecuteUpdate("StatusUpdate", ht);
        }

        public DataSet SelectPolicyFactorall(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyFactorall", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet SelectOrderOperationLog(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectOrderOperationLog", obj);
            return ds;
        }
        public DataSet SelectAttachment(string mainid)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetAttachment", mainid);
            return ds;
        }
        public DataSet SelectConditionRule(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectConditionRule", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet SelectPolicyFactorCondition(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyFactorCondition", obj);
            return ds;
        }

        public int FactorConditionRuleSet(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("FactorConditionRuleSet", obj);
            return cnt;
        }
        public void FactorConditionRuleDeleteAll(Hashtable obj)
        {
            this.ExecuteQueryForDataSet("FactorConditionRuleDelete", obj);
        }
        public DataSet SelectFactorConditionRuleCanAll(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFactorConditionRuleCanAll", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet SelectFactorConditionRuleSeletedALL(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFactorConditionRuleSeletedALL", obj, start, limit, out totalCount);
            return ds;
        }
    }
}