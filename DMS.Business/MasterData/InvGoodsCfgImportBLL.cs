using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DMS.DataAccess.MasterData;
using System.Collections;
using Lafite.RoleModel.Security;

namespace DMS.Business.MasterData
{
    public class InvGoodsCfgImportBLL:IInvGoodsCfgImportBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;
         
        public DataSet QueryErrorData(int start, int limit, out int totalCount)
        {
            using (InvGoodsCfgImportDao dao = new InvGoodsCfgImportDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("UserId", _context.User.Id.ToString());
                return dao.QueryErrorData(obj, start, limit, out totalCount);
            }
        }
    }
}
