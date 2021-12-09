using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;

namespace DMS.DataAccess.MasterData
{
    public class InvHospitalDao: BaseSqlMapDao
    {
        public DataSet SelectByFilter(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectByFilterInvHospitalCfg", obj, start, limit, out totalRowCount);
            return ds;
        }

        public int Delete(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInvHospitalCfg", id);
            return cnt;
        }

        public DataSet SelectByFilterForExport(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInvHospitalCfg", obj);
            return ds;
        }
    }
}
