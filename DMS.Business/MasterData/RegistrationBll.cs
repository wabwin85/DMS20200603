using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Common;
using System.Data;
using System.Collections;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using Grapecity.Logging.CallHandlers;


namespace DMS.Business
{
    public class RegistrationBll : IRegistrationBll
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region Action Define
        public const string Action_Registration = "Registration";
        #endregion

        //[AuthenticateHandler(ActionName = Action_Registration, Description = "注册证查询", Permissoin = PermissionType.Read)]
        public DataSet SelectMainByFilter(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (RegistrationMainDao dao = new RegistrationMainDao())
            {
                return dao.SelectByFilter(obj, start, limit, out totalRowCount);
            }
        }

        //[AuthenticateHandler(ActionName = Action_Registration, Description = "注册证查询", Permissoin = PermissionType.Read)]
        public RegistrationMain SelectMainByFilter(Guid obj)
        {
            using (RegistrationMainDao dao = new RegistrationMainDao())
            {
                return dao.GetObject(obj);
            }
        }

        //[AuthenticateHandler(ActionName = Action_Registration, Description = "注册证查询", Permissoin = PermissionType.Read)]
        public DataSet SelectDetailByFilter(Guid obj, int start, int limit, out int totalRowCount)
        {
            using (RegistrationDetailDao dao = new RegistrationDetailDao())
            {
                return dao.SelectByFilter(obj, start, limit, out totalRowCount);
            }
        }
    }
}
