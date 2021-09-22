using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using DMS.Model.DataInterface;
using System.Data;

namespace DMS.DataAccess.Interface
{
    /// <summary>
    /// RvDealerKpiScoreWarningDao
    /// </summary>
    public class RvDealerKpiScoreWarningDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public RvDealerKpiScoreWarningDao() : base()
        {
        }

        public Hashtable SelectDealerTrend(Guid? dealerId, String yearQuarter, String bu)
        {
            Hashtable condition = new Hashtable();
            condition.Add("DealerId", dealerId);
            condition.Add("YearQuarter", yearQuarter);
            condition.Add("Bu", bu);
            return this.ExecuteQueryForObject<Hashtable>("Interface.RvDealerKpiScoreWarningMap.SelectDealerTrend", condition);
        }
    }
}