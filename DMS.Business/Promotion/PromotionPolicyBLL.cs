using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using Grapecity.Logging.CallHandlers;

using DMS.DataAccess;
using DMS.Model;
using System.Net;
using DMS.Common;

namespace DMS.Business
{
    public class PromotionPolicyBLL : IPromotionPolicyBLL
    {
        #region IPromotionPolicyBLL 成员
        IRoleModelContext _context = RoleModelContext.Current;
        public DataSet GetSubBU(string productLineId)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.GetSubBU(productLineId);
            }
        }

        public DataSet QueryPolicyList(Hashtable obj, int start, int limit, out int totalCount)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryPolicyList(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetProPolicyByHash(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.GetProPolicyByHash(obj);
            }
        }

        public bool SavePolicyUi(ProPolicy policy)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                ProPolicyDao dao = new ProPolicyDao();
                try
                {
                    //1. 保存临时表
                    UpdatePolicyUi(policy);
                    //2. 保存授权类型
                    InsertPolicyDealerByAuth(policy);
                    result = true;
                    trans.Complete();
                }
                catch { }
            }
            return result;
        }

        public int DeletePolicy(string policyId)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.DeletePolicy(policyId);
            }
        }

        public string SubmintPolicy(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.SubmintPolicy(obj);
            }
        }

        public void SendEWorkflow(int policyId)
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
                string subBu = "";

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
                        subBu = (dt.Rows[0]["SubBu"] != null ? dt.Rows[0]["SubBu"].ToString() : "");
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
                    userAccount = dao2.QueryEWorkflowAccount(_context.User.LoginId);
                }

                if (policyXML != "")
                {
                    template = string.Format(template, SR.CONST_PROMOTION_POLICY_NO, userAccount, userAccount, "", policyNo, policyXML, "<a target='_blank' href='https://bscdealer.cn/API.aspx?PageId=60&InstanceID=" + policyNo + "'>上传附件</a>", subBu);
                    using (ProPolicyDao dao2 = new ProPolicyDao())
                    {
                        dao2.InsertPolicyOperationLog(template);
                    }
                    wfAction.StartInstanceXml(template, SR.CONST_EWF_WEB_PWD);
                }
            }
        }

        public string SubmintPolicyCheck(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.SubmintPolicyCheck(obj);
            }
        }

        public int UpdatePolicyUi(ProPolicy policy)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.UpdatePolicyUi(policy);
            }
        }

        public void InsertPolicyDealerByAuth(ProPolicy policy)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("PolicyId", policy.PolicyId);
                obj.Add("OperType", "包含");
                obj.Add("CreateBy", _context.User.Id);
                obj.Add("CreateTime", DateTime.Now);
                obj.Add("ModifyBy", _context.User.Id);
                obj.Add("ModifyDate", DateTime.Now);
                obj.Add("CurrUser", _context.User.Id);

                if (policy.ProDealerType != null && policy.ProDealerType == "ByAuth")
                {
                    obj.Add("WithType", "ByAuth");
                    dao.InsertPolicyDealerByAuth(obj);
                }
                else
                {
                    obj.Add("WithType", "ByAuth");
                    dao.DeletePolicyDealerByAuth(obj);
                }

                //if (policy.ProDealerType != null && policy.ProDealerType == "ByAuthRed")
                //{
                //    obj.Add("WithType", "ByAuthRed");
                //    dao.InsertPolicyDealerByAuth(obj);
                //}
                //else
                //{
                //    obj.Add("WithType", "ByAuthRed");
                //    dao.DeletePolicyDealerByAuth(obj);
                //}

                //if (policy.ProDealerType != null && policy.ProDealerType == "ByAuthBlue")
                //{
                //    obj.Add("WithType", "ByAuthBlue");
                //    dao.InsertPolicyDealerByAuth(obj);
                //}
                //else
                //{
                //    obj.Add("WithType", "ByAuthBlue");
                //    dao.DeletePolicyDealerByAuth(obj);
                //}
            }
        }

        public bool PolicyCopy(string policyId, string userId)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                String newId = "";
                return dao.PolicyCopy(policyId, userId, "Copy", ref newId);
            }
        }

        public DataSet QueryPolicyFactorList(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryPolicyFactorList(obj);
            }
        }

        public void UpdateProlicyInit(string UserId, string PolicyId, string PolicyStyle, string PolicyStyleSub)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("UserId", UserId);
                obj.Add("PolicyStyle", PolicyStyle);
                obj.Add("PolicyStyleSub", PolicyStyleSub);
                if (!PolicyId.Equals(""))
                {
                    obj.Add("PolicyId", PolicyId);
                }
                obj.Add("IsTemplate", false);
                obj.Add("PolicyMode", "Advance");
                dao.UpdateProlicyInit(obj);
            }
        }

        public ProPolicy GetUIPolicyHeader(string UserId)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.GetUIPolicyHeader(UserId);
            }
        }

        public IList<ProPolicyFactorUi> QueryUIPolicyFactorList(ProPolicyFactorUi obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryUIPolicyFactorList(obj);
            }
        }

        public DataSet QueryUIPolicyFactorAndGift(ProPolicyFactorUi factorUi)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryUIPolicyFactorAndGift(factorUi);
            }
        }

        public DataSet QueryUIPolicyFactorAndGift(ProPolicyFactorUi factorUi, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryUIPolicyFactorAndGift(factorUi, start, limit, out totalCount);
            }
        }


        public bool InsertProPolicyFactorUi(ProPolicyFactorUi policyFactor, string IsGift, string IsNoPoint)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                ProPolicyDao dao = new ProPolicyDao();
                ProPolicyFactorUi proPolicyFactorUi = new ProPolicyFactorUi();
                //添加因素表信息
                try
                {
                    dao.InsertProPolicyFactorUi(policyFactor);
                    if (IsGift.Equals("Y") || IsNoPoint.Equals("Y"))
                    {
                        //1. 判断列表中是否已经有数据
                        bool checkVlue = (dao.GetPolicyLargessUi(_context.User.Id, policyFactor.PolicyId.ToString()).Tables[0].Rows.Count > 0 ? true : false);

                        //添加赠品表信息
                        Hashtable obj = new Hashtable();
                        //PolicyId,GiftType,GiftPolicyFactorId,PointsValue,UseRangePolicyFactorId,CreateBy,CreateTime,ModifyBy,ModifyDate,Remark1,CurrUser
                        obj.Add("PolicyId", policyFactor.PolicyId);
                        //赠品、或者积分类“赠品转积分” GiftType 为 FreeGoods
                        obj.Add("GiftType", (IsGift == "Y" ? "FreeGoods" : "Point"));
                        obj.Add("GiftPolicyFactorId", IsGift.Equals("Y") ? policyFactor.PolicyFactorId.ToString() : null);
                        obj.Add("UseRangePolicyFactorId", IsNoPoint.Equals("Y") ? policyFactor.PolicyFactorId.ToString() : null);
                        obj.Add("CreateBy", _context.User.Id);
                        obj.Add("CreateTime", DateTime.Now);
                        obj.Add("ModifyBy", DBNull.Value);
                        obj.Add("ModifyDate", DBNull.Value);
                        obj.Add("CurrUser", _context.User.Id);
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
                    result = true;
                    trans.Complete();
                }
                catch { }
            }
            return result;
        }

        public int UpdateProPolicyFactorUi(ProPolicyFactorUi policyFactor)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.UpdateProPolicyFactorUi(policyFactor);
            }
        }

        public bool DeleteProPolicyFactorUi(Hashtable obj, string isGift, string isPoint)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                ProPolicyDao dao = new ProPolicyDao();
                try
                {
                    if (isGift.Equals("Y") || isPoint.Equals("Y"))
                    {
                        //如实是赠品因素，删除赠品
                        dao.DeletePolicyFactorGiftUi(obj);
                    }
                    //删除政策因素主表
                    dao.DeletePolicyFactorUi(obj);

                    //删除因素规则限制表
                    dao.DeleteUIPolicyFactorCondition(obj);

                    //删除临时表中经销商采购指标
                    dao.DeleteBSCSalesProductIndxUi(obj);

                    //删除临时表中经销商植入指标
                    dao.DeleteInHospitalProductIndxUi(obj);

                    //删除关联因素
                    dao.DeletePolicyFactorRelation(obj);
                }
                catch
                {

                }
                result = true;

                trans.Complete();
            }
            return result;
        }

        public DataSet GetIsGift(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.GetIsGift(obj);
            }
        }

        public string CheckIsGift(Hashtable obj)
        {
            string ck = "0";
            DataSet dsGift = new DataSet();
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                dsGift = dao.CheckIsGift(obj);
            }
            if (dsGift != null && dsGift.Tables[0].Rows.Count > 0)
            {
                DataRow drGift = dsGift.Tables[0].Rows[0];
                if (!drGift["GiftPolicyFactorId"].ToString().Equals("") && !drGift["UseRangePolicyFactorId"].ToString().Equals(""))
                {
                    ck = "3";
                }
                else if (!drGift["GiftPolicyFactorId"].ToString().Equals("") && drGift["UseRangePolicyFactorId"].ToString().Equals(""))
                {
                    ck = "1";
                }
                else if (drGift["GiftPolicyFactorId"].ToString().Equals("") && !drGift["UseRangePolicyFactorId"].ToString().Equals(""))
                {
                    ck = "2";
                }
            }
            return ck;

        }

        public DataSet GetFactorConditionByFactorId(string FactorId)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.GetFactorConditionByFactorId(FactorId);
            }
        }

        public DataSet GetFactorConditionType(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.GetFactorConditionType(obj);
            }
        }

        public void InsertUIPolicyFactorCondition(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                dao.InsertPolicyFactorConditionUi(obj);
            }
        }

        public DataSet QueryUIPolicyFactorCondition(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryUIPolicyFactorCondition(obj);
            }
        }

        public void DeleteUIPolicyFactorCondition(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                dao.DeleteUIPolicyFactorCondition(obj);
            }
        }

        public DataSet QueryFactorConditionRuleUiCan(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryFactorConditionRuleUiCan(obj, start, limit, out totalCount);
            }
        }

        public int FactorConditionRuleUiSet(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.FactorConditionRuleUiSet(obj);
            }
        }

        public DataSet QueryFactorConditionRuleUiSeleted(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryFactorConditionRuleUiSeleted(obj, start, limit, out totalCount);
            }
        }

        public void FactorConditionRuleUiDelete(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                dao.FactorConditionRuleUiDelete(obj);
            }
        }

        public DataSet QueryConditionRuleUi(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryConditionRuleUi(obj, start, limit, out totalCount);
            }
        }

        /// <summary>
        /// 获取可用于作为计算基数的因素
        /// </summary>
        public DataSet GetComputePolicyFactorUi(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.GetComputePolicyFactorUi(obj);
            }
        }

        /// <summary>
        /// 获取可用于作为门槛的因素
        /// </summary>
        public DataSet GetSillPolicyFactorUi(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.GetSillPolicyFactorUi(obj);
            }
        }

        public DataSet QueryDealerCan(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryDealerCan(obj, start, limit, out totalCount);
            }
        }

        public DataSet QueryPolicyDealerSelected(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryPolicyDealerSelected(obj, start, limit, out totalCount);
            }
        }

        public void InsertPolicyDealer(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                dao.InsertPolicyDealer(obj);
            }
        }

        public int DeleteSelectedDealer(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.DeleteSelectedDealer(obj);
            }
        }

        public int DeleteTopValueByUserId()
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.DeleteTopValueByUserId(_context.User.Id);
            }
        }

        public bool TopValueImport(DataTable dt, string policyId, string topValueType)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao dao = new ProPolicyDao();
                    int lineNbr = 1;
                    string errmsg = "";
                    IList<ProPolicyTopvalueUi> list = new List<ProPolicyTopvalueUi>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        errmsg = "";
                        //string errString = string.Empty;
                        ProPolicyTopvalueUi data = new ProPolicyTopvalueUi();
                        data.CurrUser = _context.User.Id;
                        data.CreateTime = DateTime.Now;
                        data.CreateBy = _context.User.Id;

                        //医院名称

                        if (String.IsNullOrEmpty(policyId))
                        {
                            errmsg = "缺少政策编码、";
                        }
                        else
                        {
                            data.PolicyId = Convert.ToInt32(policyId);
                        }

                        data.SAPCode = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        data.HospitalId = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        //TopValueImportdata.Period = dr[4] == DBNull.Value ? null : dr[4].ToString();
                        if (!string.IsNullOrEmpty(dr[4].ToString()))
                        {
                            decimal price;
                            if (!Decimal.TryParse(dr[4].ToString(), out price))
                                errmsg = "封顶值格式不正确、";
                            else if (Decimal.Parse(dr[4].ToString()) < 0)
                                errmsg = "封顶值不能小于0、";
                            else
                                data.TopValue = Convert.ToDecimal(dr[4].ToString());
                        }
                        else
                        {
                            errmsg = "封顶值为空、";
                        }

                        data.ErrMsg = errmsg == "" ? "" : errmsg.Substring(0, errmsg.Length - 1);
                        if (lineNbr != 1)
                        {
                            list.Add(data);
                        }
                        lineNbr += 1;
                    }
                    dao.BatchTopValueInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public DataSet QueryTopValue(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryTopValue(obj, start, limit, out totalCount);
            }
        }
        public DataSet QueryTopValue(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryTopValue(obj);
            }
        }
        public bool VerifyTopValue(out string IsValid, string TopValueType)
        {
            System.Diagnostics.Debug.WriteLine("VerifyTopValue Start : " + DateTime.Now.ToString());
            bool result = false;
            //调用存储过程验证数据
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                IsValid = dao.TopValueInitialize(new Guid(_context.User.Id), TopValueType);
                result = true;
            }
            System.Diagnostics.Debug.WriteLine("VerifyTopValue Finish : " + DateTime.Now.ToString());
            return result;
        }

        public DataSet QueryPolicyProductIndxUi(Hashtable obj, string FactId, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                if (FactId == "6") { return dao.QueryBSCSalesProductIndxUi(obj, start, limit, out totalCount); }
                else { return dao.QueryInHospitalProductIndxUi(obj, start, limit, out totalCount); }
            }
        }
        public DataSet QueryPolicyProductIndxUi(Hashtable obj, string FactId)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                if (FactId == "6") { return dao.QueryBSCSalesProductIndxUi(obj); }
                else { return dao.QueryInHospitalProductIndxUi(obj); }
            }
        }

        public void DeleteProductIndexByUserId(string FactId, string PolicyFactorId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("CurrUser", _context.User.Id);
            obj.Add("PolicyFactorId", PolicyFactorId);

            using (ProPolicyDao dao = new ProPolicyDao())
            {
                if (FactId == "6") { dao.DeleteBSCSalesProductIndxUi(obj); }
                else { dao.DeleteInHospitalProductIndxUi(obj); }
            }
        }

        public bool ProductIndexImport(DataTable dt, string policyFactorId, string factType)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao dao = new ProPolicyDao();
                    int lineNbr = 1;
                    string errmsg = "";
                    IList<ProProductIndexUi> list = new List<ProProductIndexUi>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        errmsg = "";
                        //string errString = string.Empty;
                        ProProductIndexUi data = new ProProductIndexUi();
                        data.CurrUser = _context.User.Id;
                        data.CreateTime = DateTime.Now;
                        data.CreateBy = _context.User.Id;

                        //医院名称

                        if (String.IsNullOrEmpty(policyFactorId))
                        {
                            errmsg = "缺少政策因素编码、";
                        }
                        else
                        {
                            data.PolicyFactorId = Convert.ToInt32(policyFactorId);
                        }

                        data.SapCode = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        data.HospitalId = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        data.Period = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        data.TargetLevel = dr[4] == DBNull.Value ? null : dr[4].ToString();
                        if (!string.IsNullOrEmpty(dr[5].ToString()))
                        {
                            decimal price;
                            if (!Decimal.TryParse(dr[5].ToString(), out price))
                                errmsg = "指标格式不正确、";
                            else if (Decimal.Parse(dr[5].ToString()) < 0)
                                errmsg = "指标不能小于0、";
                            else
                                data.TargetValue = Convert.ToDecimal(dr[5].ToString());
                        }
                        else
                        {
                            errmsg = "指标为空、";
                        }

                        data.ErrMsg = errmsg == "" ? "" : errmsg.Substring(0, errmsg.Length - 1);
                        if (lineNbr != 1)
                        {
                            list.Add(data);
                        }
                        lineNbr += 1;
                    }
                    if (factType == "6" || factType == "14")
                    {
                        dao.BatchBSCSalesIndexInsert(list);
                    }
                    if (factType == "7" || factType == "15")
                    {
                        dao.BatchInHospitalSalesIndexInsert(list);
                    }
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyProductIndex(out string IsValid, string factType)
        {
            System.Diagnostics.Debug.WriteLine("VerifyProductIndex Start : " + DateTime.Now.ToString());
            bool result = false;
            //调用存储过程验证数据
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                IsValid = dao.ProductIndexInitialize(new Guid(_context.User.Id), factType);
                result = true;
            }
            System.Diagnostics.Debug.WriteLine("VerifyProductIndex Finish : " + DateTime.Now.ToString());
            return result;
        }

        public DataSet QueryFactorRelationUi(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryFactorRelationUi(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetFactorRelationeUiCan(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.GetFactorRelationeUiCan(obj);
            }
        }

        public void InsertPolicyFactorRelation(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                dao.InsertPolicyFactorRelation(obj);
            }
        }

        public void DeletePolicyFactorRelation(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                dao.DeletePolicyFactorRelation(obj);
            }
        }

        public bool CheckFactorHasRelation(string ConditionPolicyFactorId, string userId)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("ConditionPolicyFactorId", ConditionPolicyFactorId);
                obj.Add("CurrUser", userId);
                DataTable dt = dao.GetFactorHasRelation(obj).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
        }

        public DataSet GetPolicyRuleUi(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.GetPolicyRuleUi(obj);
            }
        }

        public void InsertPolicyRuleUi(ProPolicyRuleUi policyRule, bool PageType)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                if (PageType)
                {
                    dao.InsertPolicyRuleUi(policyRule);
                }
                else
                {
                    dao.UpdatePolicyRuleUi(policyRule);
                }
            }
        }

        public DataSet QueryFactorRuleUi(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryFactorRuleUi(obj, start, limit, out totalCount);
            }
        }

        public bool CheckPolicyRuleUiHasFactor(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataTable dt = dao.GetPolicyRuleUi(obj).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
        }

        public bool DeletePolicyRuleUi(Hashtable obj)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                ProPolicyDao dao = new ProPolicyDao();
                try
                {
                    //删除赠送规则主表
                    dao.DeletePolicyRuleUi(obj);

                    //删除赠送规则明细表
                    dao.DeleteFactorRuleConditionUi(obj);
                }
                catch
                {

                }
                result = true;

                trans.Complete();
            }
            return result;
        }

        public DataSet GetPolicyRuleConditionUi(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.GetPolicyRuleConditionUi(obj);
            }
        }

        public DataSet QueryUIFactorRuleCondition(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryUIFactorRuleCondition(obj, start, limit, out totalCount);
            }
        }

        public void InsertPolicyRuleConditionUi(ProPolicyRuleFactorUi ruleCondition, bool PageType)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                if (PageType)
                {
                    dao.InsertPolicyRuleConditionUi(ruleCondition);
                }
                else
                {
                    dao.UpdatePolicyRuleConditionUi(ruleCondition);
                }
            }
        }

        public void DeleteFactorRuleConditionUi(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                dao.DeleteFactorRuleConditionUi(obj);
            }
        }


        public bool DealersImport(DataTable dt, string policyId)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao dao = new ProPolicyDao();
                    int lineNbr = 1;
                    string errmsg = "";
                    IList<ProDealerInputUi> list = new List<ProDealerInputUi>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        errmsg = "";
                        //string errString = string.Empty;
                        ProDealerInputUi data = new ProDealerInputUi();
                        data.CurrUser = _context.User.Id;

                        //医院名称

                        if (String.IsNullOrEmpty(policyId))
                        {
                            errmsg = "缺少政策编码、";
                        }
                        else
                        {
                            data.PolicyId = Convert.ToInt32(policyId);
                        }

                        data.SapCode = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        data.DealerName = dr[1] == DBNull.Value ? null : dr[1].ToString();

                        data.ErrMsg = errmsg == "" ? "" : errmsg.Substring(0, errmsg.Length - 1);
                        if (lineNbr != 1)
                        {
                            list.Add(data);
                        }
                        lineNbr += 1;
                    }
                    dao.BatchDealersInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyDealers(out string IsValid, string ProductLinId, string SubBU)
        {
            System.Diagnostics.Debug.WriteLine("VerifyDealers Start : " + DateTime.Now.ToString());
            bool result = false;
            //调用存储过程验证数据
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                IsValid = dao.VerifyDealers(new Guid(_context.User.Id), ProductLinId, SubBU);
                result = true;
            }
            System.Diagnostics.Debug.WriteLine("VerifyDealers Finish : " + DateTime.Now.ToString());
            return result;
        }

        public int DeleteDealersByUserId()
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.DeleteDealersByUserId(_context.User.Id);
            }
        }

        public void DealersUiSubmint()
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                dao.DealersUiSubmint(_context.User.Id);
            }
        }

        public DataSet QueryPolicyDealerUpload(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryPolicyDealerUpload(obj, start, limit, out totalCount);
            }
        }

        /// <summary>
        /// 获取政策Html页面
        /// </summary>
        public string GetPolicyHtml(string policyId)
        {
            string htmlValue = "";
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataTable dthtml = dao.GetPolicyhtml(policyId).Tables[0];
                if (dthtml != null && dthtml.Rows.Count > 0)
                {
                    htmlValue = dthtml.Rows[0]["PolicyXML"].ToString();
                }
            }
            return htmlValue;
        }

        /// <summary>
        /// 获取政策附件
        /// </summary>
        public DataSet QueryPolicyAttachment(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryPolicyAttachment(obj, start, limit, out totalCount);
            }
        }

        /// <summary>
        /// 新增政策附件信息
        /// </summary>
        public void InsertPolicyAttachment(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                dao.InsertPolicyAttachment(obj);
            }
        }

        public int DeletePolicyAttachment(string Id)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.DeletePolicyAttachment(Id);
            }
        }

        /// <summary>
        /// 删除政策医院信息
        /// </summary>
        public int DeletePolicyHospitalUIByConditionId(string userId, string FactConditionId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("PolicyFactorConditionId", FactConditionId);
            obj.Add("CurrUser", userId);
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.DeletePolicyHospitalUIByConditionId(obj);
            }
        }

        public bool HospitalImport(DataTable dt, string FactConditionId, string PolicyFactorId, string ConditionType, out string errmsg)
        {
            System.Diagnostics.Debug.WriteLine("Import Hospital Start : " + DateTime.Now.ToString());
            bool result = false;
            errmsg = "";
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao dao = new ProPolicyDao();
                    int lineNbr = 1;
                    string valueHospital = "";
                    ProPolicyFactorConditionUi data = new ProPolicyFactorConditionUi();
                    if (String.IsNullOrEmpty(FactConditionId))
                    {
                        errmsg = "缺少主键、";
                    }
                    else
                    {
                        data.PolicyFactorConditionId = Convert.ToInt32(FactConditionId);
                    }

                    if (String.IsNullOrEmpty(PolicyFactorId))
                    {
                        errmsg = "缺少指定因素、";
                    }
                    else
                    {
                        data.PolicyFactorId = Convert.ToInt32(PolicyFactorId);
                    }
                    data.ConditionId = 4;
                    data.CurrUser = _context.User.Id;
                    data.OperTag = ConditionType;

                    foreach (DataRow dr in dt.Rows)
                    {
                        if (lineNbr != 1)
                        {
                            if (dr[0] != DBNull.Value)
                            {
                                valueHospital += (dr[0].ToString() + "|");
                            }
                        }
                        lineNbr += 1;
                    }
                    //判断医院Code填写是否正确
                    string IsValid = dao.CheckPolicyHospitalCode(valueHospital);

                    if (IsValid.Equals(""))
                    {
                        if (!valueHospital.Equals(""))
                        {
                            data.ConditionValue = valueHospital;
                            dao.UpdatePolicyHospitalUi(data);
                        }
                        else
                        {
                            errmsg += (" 请填写医院信息");
                        }
                    }
                    else
                    {
                        errmsg += (" 医院填写有以下错误：" + IsValid);
                    }

                    result = true;
                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Hospital Finish : " + DateTime.Now.ToString());

            return result;
        }

        /// <summary>
        /// 积分政策加价率
        /// </summary>
        public bool PointRatioImport(DataTable dt, string policyId)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao dao = new ProPolicyDao();
                    int lineNbr = 1;
                    string errmsg = "";
                    IList<ProPolicyPointratioUi> list = new List<ProPolicyPointratioUi>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        errmsg = "";
                        //string errString = string.Empty;
                        ProPolicyPointratioUi data = new ProPolicyPointratioUi();
                        data.CurrUser = _context.User.Id;
                        data.CreateTime = DateTime.Now;
                        data.CreateBy = _context.User.Id;

                        //医院名称

                        if (String.IsNullOrEmpty(policyId))
                        {
                            errmsg = "缺少政策编码、";
                        }
                        else
                        {
                            data.PolicyId = Convert.ToInt32(policyId);
                        }

                        data.SapCode = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        data.AccountMonth = dr[1] == DBNull.Value ? null : dr[1].ToString();

                        if (!string.IsNullOrEmpty(dr[2].ToString()))
                        {
                            decimal price;
                            if (!Decimal.TryParse(dr[2].ToString(), out price))
                                errmsg = "加价率格式不正确、";
                            else
                                data.Ratio = Convert.ToDecimal(dr[2].ToString());
                        }
                        else
                        {
                            errmsg = "加价率为空、";
                        }
                        data.Remark1 = dr[3] == DBNull.Value ? null : dr[3].ToString();

                        data.ErrMsg = errmsg == "" ? "" : errmsg.Substring(0, errmsg.Length - 1);
                        if (lineNbr != 1)
                        {
                            list.Add(data);
                        }
                        lineNbr += 1;
                    }
                    dao.BatchPointRatioInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }


        /* public bool VerifyTopValue(out string IsValid, string TopValueType)
        {
            System.Diagnostics.Debug.WriteLine("VerifyTopValue Start : " + DateTime.Now.ToString());
            bool result = false;
            //调用存储过程验证数据
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                IsValid = dao.TopValueInitialize(new Guid(_context.User.Id), TopValueType);
                result = true;
            }
            System.Diagnostics.Debug.WriteLine("VerifyTopValue Finish : " + DateTime.Now.ToString());
            return result;
        }
         */
        public bool VerifyRatioImport(out string IsValid)
        {
            System.Diagnostics.Debug.WriteLine("VerifyPointRatio Start : " + DateTime.Now.ToString());
            bool result = false;
            //调用存储过程验证数据
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                IsValid = dao.PointRatioInitialize(new Guid(_context.User.Id));
                result = true;
            }
            System.Diagnostics.Debug.WriteLine("VerifyPointRatio Finish : " + DateTime.Now.ToString());
            return result;
        }

        public DataSet QueryPointRatio(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryPointRatio(obj, start, limit, out totalCount);
            }
        }
        public DataSet QueryPointRatio(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryPointRatio(obj);
            }
        }
        public int DeletePolicyPointRatioByUserId()
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.DeletePolicyPointRatioByUserId(_context.User.Id);
            }
        }

        public int DeleteProductStandardPriceByUserId()
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.DeleteProductStandardPriceByUserId(_context.User.Id);
            }
        }

        /// <summary>
        /// 补偿差价
        /// </summary>
        public bool ProductStandardPriceImport(DataTable dt, string policyId)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao dao = new ProPolicyDao();
                    int lineNbr = 1;
                    string errmsg = "";
                    IList<ProDealerStdPointUi> list = new List<ProDealerStdPointUi>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        errmsg = "";
                        //string errString = string.Empty;
                        ProDealerStdPointUi data = new ProDealerStdPointUi();
                        data.CurrUser = _context.User.Id;
                        data.CreateTime = DateTime.Now;
                        data.CreateBy = _context.User.Id;

                        //医院名称

                        if (String.IsNullOrEmpty(policyId))
                        {
                            errmsg = "缺少政策编码、";
                        }
                        else
                        {
                            data.PolicyId = Convert.ToInt32(policyId);
                        }

                        data.SapCode = dr[0] == DBNull.Value ? null : dr[0].ToString();

                        if (!string.IsNullOrEmpty(dr[1].ToString()))
                        {
                            decimal price;
                            if (!Decimal.TryParse(dr[1].ToString(), out price))
                                errmsg = "补偿金额格式填写不正确、";
                            else
                                data.Points = Convert.ToDecimal(dr[1].ToString());
                        }
                        else
                        {
                            errmsg = "补偿金额为空、";
                        }

                        data.ErrMsg = errmsg == "" ? "" : errmsg.Substring(0, errmsg.Length - 1);
                        if (lineNbr != 1)
                        {
                            list.Add(data);
                        }
                        lineNbr += 1;
                    }
                    dao.BatchStandardPriceInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyStandardPrice(out string IsValid)
        {
            System.Diagnostics.Debug.WriteLine("VerifyStandardPrice Start : " + DateTime.Now.ToString());
            bool result = false;
            //调用存储过程验证数据
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                IsValid = dao.StandardPriceInitialize(new Guid(_context.User.Id));
                result = true;
            }
            System.Diagnostics.Debug.WriteLine("VerifyStandardPrice Finish : " + DateTime.Now.ToString());
            return result;
        }

        public DataSet QueryStandardPrice(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryStandardPrice(obj, start, limit, out totalCount);
            }
        }
        public DataSet QueryStandardPrice(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.QueryStandardPrice(obj);
            }
        }
        #endregion
        #region
        public DataSet Query_ProPointRatio(Hashtable obj, int start, int limit, out int totalCount)
        {

            using (ProBuPointRatioDao dao = new ProBuPointRatioDao())
            {
                return dao.Query_ProPointRatio(obj, start, limit, out totalCount);
            }
        }
        public ProBuPointRatio GetProBuPointRatioObj(int Id)
        {
            using (ProBuPointRatioDao dao = new ProBuPointRatioDao())
            {
                return dao.GetObject(Id);
            }
        }
        public DataSet SelectDealerByproductline(string Id)
        {
            using (ProBuPointRatioDao dao = new ProBuPointRatioDao())
            {
                return dao.SelectDealerByproductline(Id);
            }
        }
        public bool AddProPointRatio(ProBuPointRatio Ratio)
        {
            bool relult = false;
            try
            {

                using (ProBuPointRatioDao dao = new ProBuPointRatioDao())
                {
                    dao.Insert(Ratio);
                    relult = true;
                }

            }
            catch (Exception ex)
            {
                relult = false;
            }
            return relult;
        }
        public bool UpdateProPointRatio(ProBuPointRatio Ratio)
        {
            bool relult = false;
            try
            {

                using (ProBuPointRatioDao dao = new ProBuPointRatioDao())
                {
                    dao.Update(Ratio);
                    relult = true;
                }

            }
            catch (Exception ex)
            {
                relult = false;
            }
            return relult;
        }
        public bool DeleteProPointRatio(int Id)
        {
            bool relult = false;
            try
            {

                using (ProBuPointRatioDao dao = new ProBuPointRatioDao())
                {
                    dao.Delete(Id);
                    relult = true;
                }

            }
            catch (Exception ex)
            {
                relult = false;
            }
            return relult;
        }
        public bool PointRatioImpor(DataTable dt)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());

            bool result = false;
            try
            {

                using (TransactionScope trans = new TransactionScope())
                {
                    int lineNbr = 1;
                    IList<ProBuPointRatioUi> ImporData = new List<ProBuPointRatioUi>();

                    foreach (DataRow row in dt.Rows)
                    {
                        string Messinge = string.Empty;
                        ProBuPointRatioUi Modle = new ProBuPointRatioUi();
                        if (!string.IsNullOrEmpty(row[0].ToString()))
                        {
                            Modle.SapCode = row[0].ToString();
                        }
                        else
                        {
                            Messinge = Messinge + "ERPCode未填写.行号:";
                        }
                        if (!string.IsNullOrEmpty(row[1].ToString()))
                        {
                            Modle.Bu = row[1].ToString();
                        }
                        else
                        {
                            Messinge = Messinge + "产品线未填写.行号";
                        }

                        if (!string.IsNullOrEmpty(row[2].ToString()))
                        {
                            decimal Dm;
                            if (decimal.TryParse(row[2].ToString(), out Dm))
                            {
                                Modle.Ratio = Dm;
                            }
                            else
                            {
                                Messinge = Messinge + "加价率格式不正确.行号";
                            }
                        }
                        else
                        {
                            Messinge = Messinge + "未填写加价率.行号";
                        }
                        Modle.CreateBy = _context.User.Id;
                        Modle.CreateTime = DateTime.Now;
                        Modle.CurrUser = _context.User.Id;
                        Modle.ErrMsg = Messinge == "" ? "" : Messinge.Substring(0, Messinge.Length - 1);
                        if (lineNbr != 1)
                        {
                            ImporData.Add(Modle);
                        }
                        lineNbr = lineNbr + 1;
                    }
                    ImportPointRatioUI(ImporData);
                    result = true;
                    trans.Complete();
                }
            }
            catch (Exception ex)
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;

        }
        /// <summary>
        /// 批量插入统一加价率
        /// </summary>
        /// <param name="List"></param>
        public void ImportPointRatioUI(IList<ProBuPointRatioUi> List)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (ProBuPointRatioUiDao dao = new ProBuPointRatioUiDao())
                {
                    foreach (ProBuPointRatioUi item in List)
                    {
                        dao.Insert(item);
                    }

                }
                trans.Complete();
            }
        }
        public bool DeletePointRatioUIByCurrUser(string CurrUser)
        {
            bool result = false;
            try
            {
                using (ProBuPointRatioUiDao dao = new ProBuPointRatioUiDao())
                {
                    dao.DeletePointRatioUIByCurrUser(CurrUser);
                    result = true;
                }
            }
            catch (Exception ex)
            {
                result = false;
            }
            return result;
        }
        public bool VerifyRatioUiInit(string UserId, int IsImport, out string IsValid)
        {
            bool result = false;
            IsValid = string.Empty;
            try
            {
                using (ProBuPointRatioUiDao dao = new ProBuPointRatioUiDao())
                {
                    dao.VerifyRatioUiInit(UserId, IsImport, out IsValid);
                    result = true;
                }
            }
            catch (Exception ex)
            {
                result = false;
            }
            return result;
        }
        public DataSet QueryPro_BU_PointRatio_UIByUserId(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProBuPointRatioUiDao dao = new ProBuPointRatioUiDao())
            {
                return dao.QueryPro_BU_PointRatio_UIByUserId(obj, start, limit, out totalCount);

            }
        }
        public DataSet ExistsByBuDmaId(Hashtable obj)
        {

            using (ProBuPointRatioUiDao dao = new ProBuPointRatioUiDao())
            {
                DataSet ds = dao.ExistsByBuDmaId(obj);
                return ds;
            }
            #endregion
        }
        public DataSet QueryPromotionQuotazp(Hashtable obj, int start, int limit, out int totalCount)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            obj.Add("OwnerCorpId", this._context.User.CorpId);
            BaseService.AddCommonFilterCondition(obj);
            using (ProBuPointRatioUiDao dao = new ProBuPointRatioUiDao())
            {
                DataSet ds = dao.QueryPromotionQuotazp(obj, start, limit, out totalCount);
                return ds;
            }
        }
        public DataSet QueryPromotionQuotajf(Hashtable obj, int start, int limit, out int totalCount)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            obj.Add("OwnerCorpId", this._context.User.CorpId);
            BaseService.AddCommonFilterCondition(obj);
            using (ProBuPointRatioUiDao dao = new ProBuPointRatioUiDao())
            {
                DataSet ds = dao.QueryPromotionQuotajf(obj, start, limit, out totalCount);
                return ds;
            }
        }
        public DataSet ExporPromotionQuotajf(Hashtable obj)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            obj.Add("OwnerCorpId", this._context.User.CorpId);
            BaseService.AddCommonFilterCondition(obj);
            using (ProBuPointRatioUiDao dao = new ProBuPointRatioUiDao())
            {
                DataSet ds = dao.ExporPromotionQuotajf(obj);
                return ds;
            }
        }
        public DataSet ExporPromotionQuotazp(Hashtable obj)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            obj.Add("OwnerCorpId", this._context.User.CorpId);
            BaseService.AddCommonFilterCondition(obj);
            using (ProBuPointRatioUiDao dao = new ProBuPointRatioUiDao())
            {
                DataSet ds = dao.ExporPromotionQuotazp(obj);
                return ds;
            }
        }
        public DataSet SelectLargesslogType()
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.SelectLargesslotType();
                return ds;
            }
        }
        public DataSet SelectPointlogType()
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.SelectPointlogType();
                return ds;
            }
        }
        public DataSet QueryLargesslogByDmabu(Hashtable obj, int start, int limit, out int totalCount)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            obj.Add("OwnerCorpId", this._context.User.CorpId);
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.QueryLargesslogByDmabu(obj, start, limit, out totalCount);
                return ds;
            }
        }
        public DataSet QueryPointlogByDmabu(Hashtable obj, int start, int limit, out int totalCount)
        {
            obj.Add("OwnerIdentityType", this._context.User.IdentityType);
            obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            obj.Add("OwnerId", new Guid(this._context.User.Id));
            obj.Add("OwnerCorpId", this._context.User.CorpId);
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.QueryPointlogByDmabu(obj, start, limit, out totalCount);
                return ds;
            }
        }
        public DataSet SelectPointlogByDmabuExportExcel(Hashtable ht)
        {
            ht.Add("OwnerIdentityType", this._context.User.IdentityType);
            ht.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            ht.Add("OwnerId", new Guid(this._context.User.Id));
            ht.Add("OwnerCorpId", this._context.User.CorpId);
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.SelectPointlogByDmabuExportExcel(ht);
                return ds;
            }
        }
        public DataSet SelectargesslogByExportExcel(Hashtable ht)
        {
            ht.Add("OwnerIdentityType", this._context.User.IdentityType);
            ht.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            ht.Add("OwnerId", new Guid(this._context.User.Id));
            ht.Add("OwnerCorpId", this._context.User.CorpId);
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.SelectargesslogByExportExcel(ht);
                return ds;
            }
        }

        public DataSet SelectPromotion(string PolicyNo)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.SelectPromotion(PolicyNo);
                return ds;
            }
        }

        public DataSet SelectPromotionPOLICY_RULE(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.SelectPromotionPOLICY_RULE(obj, start, limit, out totalCount);
                return ds;
            }
        }

        public DataSet GetPromotionPOLICY_RULE(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.GetPromotionPOLICY_RULE(obj);
                return ds;
            }
        }

        public void UpdatePolicy(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                dao.UpdatePolicy(obj);
            }
        }

        public DataSet SelectPolicyFactor(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.SelectPolicyFactor(obj);
                return ds;
            }
        }
        public bool StatusUpdate(Hashtable obj)
        {
            bool result = false;
            try
            {
                using (ProPolicyDao dao = new ProPolicyDao())
                {
                    dao.StatusUpdate(obj);
                    result = true;
                }
            }
            catch (Exception e)
            {
                e.Message.ToString();
                result = false;
            }
            return result;
        }

        public DataSet SelectPolicyFactorall(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.SelectPolicyFactorall(obj, start, limit, out totalCount);
                return ds;
            }
        }

        public DataSet SelectOrderOperationLog(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.SelectOrderOperationLog(obj);
                return ds;
            }
        }

        public DataSet SelectAttachment(string mainid)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.SelectAttachment(mainid);
                return ds;
            }
        }

        public DataSet SelectConditionRule(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.SelectConditionRule(obj, start, limit, out totalCount);
                return ds;
            }
        }

        public DataSet SelectPolicyFactorCondition(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.SelectPolicyFactorCondition(obj);
                return ds;
            }
        }

        public int FactorConditionRuleSet(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.FactorConditionRuleSet(obj);
            }
        }

        public void FactorConditionRuleDelete(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                dao.FactorConditionRuleDeleteAll(obj);
            }
        }

        public DataSet SelectFactorConditionRuleSeletedALL(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.SelectFactorConditionRuleSeletedALL(obj, start, limit, out totalCount);
                return ds;
            }
        }

        public DataSet SelectFactorConditionRuleCanAll(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                DataSet ds = dao.SelectFactorConditionRuleCanAll(obj, start, limit, out totalCount); ;
                return ds;
            }
        }

        public DataSet GetPromotionQuotajfById(string Id)
        {
            using (ProBuPointRatioUiDao dao = new ProBuPointRatioUiDao())
            {
                DataSet ds = dao.GetPromotionQuotajfById(Id);
                return ds;
            }
        }
        public DataSet GetPromotionQuotazpById(string Id)
        {
            using (ProBuPointRatioUiDao dao = new ProBuPointRatioUiDao())
            {
                DataSet ds = dao.GetPromotionQuotazpById(Id);
                return ds;
            }
        }
        public bool PromotionAdjustmentLimit(string Id, string PolicyType, double number,string Remark)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                ProBuPointRatioUiDao dao = new ProBuPointRatioUiDao();
                Hashtable obj = new Hashtable();
                obj.Add("Id", Id);
                obj.Add("number", number);
                obj.Add("userId", this._context.User.Id);
                obj.Add("remark", Remark);
                if (PolicyType.Equals("积分"))
                {
                    if (dao.CheckAdjustmentLimitForJF(obj))
                    {
                        dao.SubmitAdjustmentLimitForJF(obj);
                        dao.InsertAdjustmentLimitLogForJF(obj);
                    }
                }
                if (PolicyType.Equals("赠品"))
                {
                    if (dao.CheckAdjustmentLimitForZP(obj))
                    {
                        dao.SubmitAdjustmentLimitForZP(obj);
                        dao.InsertAdjustmentLimitLogForZP(obj);
                    }
                }

                result = true;
                trans.Complete();
            }

            return result;
        }
    }
}
