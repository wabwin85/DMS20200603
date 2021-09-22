using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using System.Data;

namespace DMS.DataAccess.DP
{
    public class DPForecastImportDao : BaseSqlMapDao
    {
        /// <summary>
        /// 默认构造函数
        /// </summary>
        public DPForecastImportDao()
            : base()
        {
        }

        public DataSet DPForecastExport(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DPForecastExport", obj);
            return ds;
        }

        public DataSet GetYearMonth()
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetYearMonth", null);
            return ds;
        }

        public DataSet Get3MonthBP(string obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("Get3MonthBP", obj);
            return ds;
        }

    }
}
