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
    public class PolicyTemplateInitService : BaseService
    {
        public String Init(String templateId)
        {
            try
            {
                ProPolicyDao policyDao = new ProPolicyDao();
                String newId = "";
                if (!policyDao.PolicyCopy(templateId, UserInfo.Id, "Create", ref newId))
                {
                    throw new Exception("创建模板政策出错");
                }
                return newId;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                throw ex;
            }
        }
    }
}
