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

namespace DMS.Business.Promotion
{
    public class PolicyListService : BaseService
    {
        public PolicyListVO InitPage(PolicyListVO model)
        {
            try
            {
                ProPolicyDao policyDao = new ProPolicyDao();
                ProDescriptionDao descritptionDao = new ProDescriptionDao();

                model.IptUserId = UserInfo.Id;

                model.LstProductLine = this.GetProductLineDataSource();
                model.LstPolicyStatus = DictionaryHelper.GetKeyValueList(SR.PRO_Status);
                model.LstTimeStatus = DictionaryHelper.GetKeyValueList(SR.PRO_TimeStatus);

                model.RstPolicyList = JsonHelper.DataTableToArrayList(policyDao.QueryPolicyList(this.GetCondition(model)));

                model.LstPolicyTypeDesc = descritptionDao.SelectProDescriptioinList("PolicyType");

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

        public PolicyListVO Query(PolicyListVO model)
        {
            try
            {
                ProPolicyDao policyDao = new ProPolicyDao();

                model.RstPolicyList = JsonHelper.DataTableToArrayList(policyDao.QueryPolicyList(this.GetCondition(model)));

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

        public PolicyListVO RemovePolicy(PolicyListVO model)
        {
            try
            {
                ProPolicyDao policyDao = new ProPolicyDao();

                policyDao.DeletePolicy(model.IptPolicyId);

                model.RstPolicyList = JsonHelper.DataTableToArrayList(policyDao.QueryPolicyList(this.GetCondition(model)));

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

        public PolicyListVO CopyPolicy(PolicyListVO model)
        {
            try
            {
                ProPolicyDao policyDao = new ProPolicyDao();

                String newId = "";
                policyDao.PolicyCopy(model.IptPolicyId, UserInfo.Id, "Copy", ref newId);

                model.RstPolicyList = JsonHelper.DataTableToArrayList(policyDao.QueryPolicyList(this.GetCondition(model)));

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

        public PolicyListVO ChangeProductLine(PolicyListVO model)
        {
            try
            {
                ProPolicyDao policyDao = new ProPolicyDao();

                if (String.IsNullOrEmpty(model.IptProductLine))
                {
                    model.RstTemplateList = new ArrayList();
                }
                else
                {
                    model.RstTemplateList = JsonHelper.DataTableToArrayList(policyDao.SelectPolicyTemplateListByProductLine(model.IptProductLine));
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

        private Hashtable GetCondition(PolicyListVO model)
        {
            Hashtable condition = new Hashtable();
            condition.Add("BU", model.QryProductLine);
            condition.Add("Status", model.QryPolicyStatus);
            condition.Add("TimeStatus", model.QryTimeStatus);
            condition.Add("PolicyNo", model.QryPolicyNo);
            condition.Add("PolicyName", model.QryPolicyName);
            condition.Add("Year", model.QryYear);
            condition.Add("PolicyStyle", model.QryPromotionType);
            condition.Add("UserId", UserInfo.Id);
            condition.Add("OwnerIdentityType", UserInfo.IdentityType);
            condition.Add("OwnerOrganizationUnits", UserInfo.GetOrganizationUnits());
            condition.Add("OwnerId", new Guid(UserInfo.Id));

            return condition;
        }
    }
}
