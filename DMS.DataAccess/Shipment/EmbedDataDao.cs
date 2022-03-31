using System;
using System.Collections;
using System.Data;

namespace DMS.DataAccess
{
    public class EmbedDataDao:BaseSqlMapDao
    {
        public EmbedDataDao()
        {
        }

        public DataSet QueryEmbedDataInfo(Hashtable table, int start, int limit, out int rowscount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryQueryEmbedDataInfo", table, start, limit, out rowscount);
            return ds;
        }

        public DataSet QueryEmbedDataInfo(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryEmbedDataInfoByFilter", table);
            return ds;
        }
    }
}