using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Lafite.RoleModel.Security;
using DMS.DataAccess.MasterData;
using System.Collections;

namespace DMS.Business.MasterData
{
    public class InvHospitalCfgImportBLL:IInvHospitalCfgImportBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        public DataSet QueryErrorData(int start, int limit, out int totalCount)
        {
            using (InvHospitalCfgImportDao dao = new InvHospitalCfgImportDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("UserId", _context.User.Id.ToString());
                return dao.QueryErrorData(obj, start, limit, out totalCount);
            }
        }
    }
}
