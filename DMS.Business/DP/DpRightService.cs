using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.Common;
using System.Data;
using System.Collections;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;


namespace DMS.Business.DP
{
    public class DpRightService : IDpRightService
    {
        #region IDpRightService 成员

        public DataSet GetAllModularAndPermissions(string roleId)
        {
            using (DpRightDao dao = new DpRightDao())
            {
                return dao.GetAllModularAndPermissions(roleId);
            }
        }

        public DataSet GetFristClassPermissions(Hashtable roleId)
        {
            using (DpRightDao dao = new DpRightDao())
            {
                return dao.GetFristClassPermissions(roleId);
            }
        }

        public DataSet GetSecondClassPermissions(Hashtable obj)
        {
            using (DpRightDao dao = new DpRightDao())
            {
                return dao.GetSecondClassPermissions(obj);
            }
        }

        public int DeletePermissionsByRoleId(string roleId) 
        {
            using (DpRightDao dao = new DpRightDao())
            {
                return dao.DeletePermissionsByRoleId(roleId);
            }
        }


        public void InsertDpRight(DpRight obj)
        {
            using (DpRightDao dao = new DpRightDao())
            {
                dao.InsertDpRight(obj);
            }
        }
        #endregion
    }
}
