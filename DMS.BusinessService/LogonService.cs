using DMS.Common.Common;
using DMS.DataAccess.Lafite;
using DMS.ViewModel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using DMS.Common.Extention;
using DMS.Common;
using DMS.Model.Data;
using DMS.Business;
using Lafite.RoleModel.Provider;
using Lafite.RoleModel.Security;
using System.Web.Security;

namespace DMS.BusinessService
{
    public class LogonService : ABaseService
    {
        #region Ajax Method

        public void Logon(String mobile)
        {
            try
            {
                IdentityDao identityDao = new IdentityDao();

                IList<Hashtable> dealerList = identityDao.SelectByMobile(mobile);
                if (dealerList.Count == 0)
                {
                    throw new Exception("找不到关联用户");
                }
                else
                {
                    FormsAuthentication.SetAuthCookie(dealerList[0].GetSafeStringValue("Account"), false);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
        }

        #endregion

        #region Internal Function

        #endregion
    }
}
