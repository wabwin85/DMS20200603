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
    public class PolicyTemplateListService : BaseService
    {
        public PolicyTemplateListVO InitPage(PolicyTemplateListVO model)
        {
            try
            {
                ProPolicyDao policyDao = new ProPolicyDao();
                ProDescriptionDao descritptionDao = new ProDescriptionDao();

                model.IptUserId = UserInfo.Id;

                model.LstProductLine = this.GetProductLineDataSource();

                model.RstPolicyList = JsonHelper.DataTableToArrayList(policyDao.SelectPolicyTemplateList(model.QryPolicyName, model.QryProductLine, model.QryPromotionType, UserInfo.Id, UserInfo.IdentityType, UserInfo.GetOrganizationUnits()));

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

        public PolicyTemplateListVO Query(PolicyTemplateListVO model)
        {
            try
            {
                ProPolicyDao policyDao = new ProPolicyDao();

                model.RstPolicyList = JsonHelper.DataTableToArrayList(policyDao.SelectPolicyTemplateList(model.QryPolicyName, model.QryProductLine, model.QryPromotionType, UserInfo.Id, UserInfo.IdentityType, UserInfo.GetOrganizationUnits()));

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

        public PolicyTemplateListVO RemovePolicy(PolicyTemplateListVO model)
        {
            try
            {
                ProPolicyDao policyDao = new ProPolicyDao();

                policyDao.DeletePolicy(model.IptPolicyId);

                model.RstPolicyList = JsonHelper.DataTableToArrayList(policyDao.SelectPolicyTemplateList(model.QryPolicyName, model.QryProductLine, model.QryPromotionType, UserInfo.Id, UserInfo.IdentityType, UserInfo.GetOrganizationUnits()));

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

        public PolicyTemplateListVO CopyPolicy(PolicyTemplateListVO model)
        {
            try
            {
                ProPolicyDao policyDao = new ProPolicyDao();

                String newId = "";
                policyDao.PolicyCopy(model.IptPolicyId, UserInfo.Id, "Copy", ref newId);

                model.RstPolicyList = JsonHelper.DataTableToArrayList(policyDao.SelectPolicyTemplateList(model.QryPolicyName, model.QryProductLine, model.QryPromotionType, UserInfo.Id, UserInfo.IdentityType, UserInfo.GetOrganizationUnits()));

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
    }
}
