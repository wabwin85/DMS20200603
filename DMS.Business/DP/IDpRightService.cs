using System;
using DMS.Model;
using System.Data;
using System.Collections;
using System.Collections.Generic;


namespace DMS.Business.DP
{
    public interface IDpRightService
    {
        DataSet GetAllModularAndPermissions(string roleId);
        DataSet GetFristClassPermissions(Hashtable roleId);
        DataSet GetSecondClassPermissions(Hashtable obj);

        int DeletePermissionsByRoleId(string roleId);
        void InsertDpRight(DpRight obj);
    }
}
