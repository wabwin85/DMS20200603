using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.DataAccess
{
   public class ReturnPositionSearchDao: BaseSqlMapDao
    {

        public DataSet GetPosition(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectReturnPositionSearch", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet ExcelGetPosition(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExcelReturnPositionSearch", obj);
            return ds;
        }

        public void Insert(Hashtable obj)
        {
            this.ExecuteInsert("InsertReturnPositionSearch", obj);
        }

        public DataSet GetObjectid(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectReturnPositionSearchDetaile", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet Gettype(Guid id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectReturnPositionSearchType",id);
            return ds;
        }

    }
}
