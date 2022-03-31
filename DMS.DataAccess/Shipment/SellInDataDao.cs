using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.DataAccess.Shipment
{
    public class SellInDataDao: BaseSqlMapDao
    {
        public DataSet QuerySellInDataInfo(Hashtable table, int start, int limit, out int rowscount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QuerySellInDataInfo", table, start, limit, out rowscount);
            return ds;
        }

        public DataSet QuerySellInDataInfo(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QuerySellInDataInfoByFilter", table);
            return ds;
        }
    }
}
