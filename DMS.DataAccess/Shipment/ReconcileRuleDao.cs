using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DMS.Model;

namespace DMS.DataAccess
{
    public class ReconcileRuleDao: BaseSqlMapDao
    {
        public DataSet SelectReconcileRuleBySubCompany(Hashtable table,int start, int limit, out int rowscount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectReconcileRuleBySubCompany", table,start,limit,out rowscount);
            return ds;
        }

        public DataSet SelectReconcileRuleAll()
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectReconcileRuleAll",null);
            return ds;
        }

        public DataSet SelectSubCompanyAll()
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSubCompanyAll", null); 
            
            return ds;
        }

        public int UpdateReconcileRule(ReconcileRule obj)
        {
            int cnt = this.ExecuteUpdate("UpdateReconcileRule", obj);
            return cnt;
        }
    }
}
