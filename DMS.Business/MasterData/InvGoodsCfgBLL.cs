using System;
using System.Collections.Generic;
using System.Collections;
using System.Data;
using System.Linq;
using System.Text;
using DMS.DataAccess.MasterData;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;

namespace DMS.Business.MasterData
{
    public class InvGoodsCfgBLL:IInvGoodsCfgBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        public DataSet QueryInvGoodsCfg(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = new DataSet();
            using (InvGoodsCfgDao dao = new InvGoodsCfgDao())
            {
                ds = dao.SelectByFilter(table, start, limit, out totalRowCount);
            } 
            return ds;
        }

        public bool Delete(Guid id)
        {
            bool result = false;
            int num = 0;
            using (TransactionScope trans = new TransactionScope())
            {
                using (InvGoodsCfgDao dao = new InvGoodsCfgDao())
                {
                    num = dao.Delete(id);
                }
                trans.Complete();
                result = true;
            }
            return result;
        }

        public DataSet QueryInvGoodsCfgForExport(Hashtable table)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(table);
            using (InvGoodsCfgDao dao = new InvGoodsCfgDao())
            {
                return dao.SelectByFilterForExport(table);
            }
        }
         
    }
}
