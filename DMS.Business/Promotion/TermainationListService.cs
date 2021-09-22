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
using System.Data;
using DMS.Business.EKPWorkflow;
using DMS.Model.EKPWorkflow;
using Grapecity.DataAccess.Transaction;

namespace DMS.Business.Promotion
{
    public class TermainationListService : BaseService
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();
        #endregion
        public TermainationList InitPage(TermainationList model)
        {
            try
            {
                ProPolicyDao policyDao = new ProPolicyDao();
                if (!string.IsNullOrEmpty(model.TermainationId))
                {

                    if (model.View == "View")
                    {
                        model.LstPolicyNo = JsonHelper.DataTableToArrayList(policyDao.QuerySelectPolicyNoView(this.GetCondition(model)));
                    }
                    else {
                        model.LstPolicyNo = JsonHelper.DataTableToArrayList(policyDao.QuerySelectPolicyNo(this.GetCondition(model)));
                    }
                   
                    DataTable tb = policyDao.SelectPromotion_PRO_POLICY_Termaination(model.TermainationId);
                    if (tb.Rows.Count > 0) {

                        model.QryPolicyNo = tb.Rows[0]["id"].ToString();
                        model.QryPolicy = tb.Rows[0]["Policy"].ToString();
                        model.QryPolicyName = tb.Rows[0]["PolicyName"].ToString();
                        model.QryPolicyGroupName = tb.Rows[0]["PolicyGroupName"].ToString();
                        model.QryProductLine = tb.Rows[0]["BU"].ToString();
                        model.QryStartDate = tb.Rows[0]["StartDate"].ToString();
                        model.QryEndDate = tb.Rows[0]["EndDate"].ToString();
                        model.QrySubBu = tb.Rows[0]["SubBu"].ToString();
                        model.QryTemainationSDate = tb.Rows[0]["BeginDate"].ToString();
                        model.QryTemainationType = tb.Rows[0]["TemainationType"].ToString();
                        model.QryRemark = tb.Rows[0]["Remark"].ToString();
                    }
                   
                }
                else {
                   
                    ProDescriptionDao descritptionDao = new ProDescriptionDao();

                    model.IptUserId = UserInfo.Id;
                    model.ProductLineList= JsonHelper.DataTableToArrayList(policyDao.QuerySelectProductLine(this.GetCondition(model)));
                    model.LstPolicyNo = JsonHelper.DataTableToArrayList(policyDao.QuerySelectPolicyNo(this.GetCondition(model)));
                    model.RstTemainationList = JsonHelper.DataTableToArrayList(policyDao.QueryTermainationList(this.GetCondition(model)));
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



        public TermainationList PolicyNo(TermainationList model)
        {
            try
            {
                ProPolicyDao policyDao = new ProPolicyDao();
                ProDescriptionDao descritptionDao = new ProDescriptionDao();

                DataTable Info = policyDao.QueryPolicyInfo(model.QryPolicyNo);

                if (Info.Rows.Count > 0)
                {
                    model.QryPolicyName = Info.Rows[0]["PolicyName"].ToString();
                    model.QryProductLine = Info.Rows[0]["BU"].ToString();
                    model.QryStartDate = Info.Rows[0]["StartDate"].ToString();
                    model.QryEndDate = Info.Rows[0]["EndDate"].ToString();
                    model.QrySubBu = Info.Rows[0]["SubBu"].ToString();
                    model.QryPolicyGroupName = Info.Rows[0]["PolicyGroupName"].ToString();
                }

                model.IptUserId = UserInfo.Id;
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

        public void TerminationSubmit(TermainationList model, string Status)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    string Id = Guid.NewGuid().ToString();

                    ProPolicyDao policyDao = new ProPolicyDao();

                    Hashtable TerminationInfo = new Hashtable();
                    TerminationInfo.Add("Id", Id);
                    TerminationInfo.Add("PolicyId", model.QryPolicyNo);
                    TerminationInfo.Add("BeginDate", model.QryTemainationSDate);
                    TerminationInfo.Add("Status", Status);
                    TerminationInfo.Add("CreateUser", UserInfo.Id);
                    TerminationInfo.Add("CreateDate", DateTime.Now);
                    TerminationInfo.Add("BU", model.QryProductLine);
                    TerminationInfo.Add("TemainationType", model.QryTemainationType);
                    TerminationInfo.Add("Remark", model.QryRemark);

                    if (Status.Equals("审批中"))
                        model.TermainationNo = this.GetNextAutoNumberForPromotion(model.QryProductLine, "PT", "PromotionTermination");

                    TerminationInfo.Add("TermainationNo", model.TermainationNo);

                if (!string.IsNullOrEmpty(model.TermainationId))
                {
                    TerminationInfo.Add("TermainationId", model.TermainationId);
                    policyDao.UpdateTermainationInfo(TerminationInfo);
                }
                else
                {
                    policyDao.insertTermainationInfo(TerminationInfo);
                }
                
                    if (Status.Equals("审批中"))
                    {
                      //发起流程
                        ekpBll.DoSubmit(_context.User.LoginId,(string.IsNullOrEmpty(model.TermainationId)?Id: model.TermainationId), model.TermainationNo, "PromotionPolicyClose", string.Format("{0}促销终止申请", model.TermainationNo)
                            , EkpModelId.PromotionPolicyClose.ToString(), EkpTemplateFormId.PromotionPolicyCloseTemplate.ToString());
                    }
                    
                    trans.Complete();
                }
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                string strEx = ex.Message.ToString();
            }
        }
        public string GetNextAutoNumberForPromotion(string deptcode, string clientid, string strSettings)
        {
            using (ProPolicyDao policyDao = new ProPolicyDao())
            {
                return policyDao.GetNextAutoNumberForPromotion(deptcode, clientid, strSettings);
            }
        }

        public TermainationList Query(TermainationList model)
        {
            try
            {
                ProPolicyDao policyDao = new ProPolicyDao();

                model.RstTemainationList = JsonHelper.DataTableToArrayList(policyDao.QueryTermainationList(this.GetCondition(model)));

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

        private Hashtable GetCondition(TermainationList model)
        {
            Hashtable condition = new Hashtable();

            condition.Add("Status", model.QryStatus);
            condition.Add("PromotionNo", model.QryPromotionNo);
            condition.Add("TermainationNo", model.QryTermainationNo);
            condition.Add("PromotionType", model.QryPromotionType);
            condition.Add("CP", model.QryCP);
            condition.Add("ZZ", model.QryZZ);

            condition.Add("UserId", UserInfo.Id);
            condition.Add("OwnerIdentityType", UserInfo.IdentityType);
            condition.Add("OwnerOrganizationUnits", UserInfo.GetOrganizationUnits());
            condition.Add("OwnerId", new Guid(UserInfo.Id));

            return condition;
        }


    }
}
