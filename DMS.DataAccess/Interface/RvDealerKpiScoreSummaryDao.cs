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
    /// RvDealerKpiScoreSummaryDao
    /// </summary>
    public class RvDealerKpiScoreSummaryDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public RvDealerKpiScoreSummaryDao(): base()
        {
        }
		
        public IList<Hashtable> SelectDealerQuarterList(Guid? dealerId)
        {
            Hashtable condition = new Hashtable();
            condition.Add("DealerId", dealerId);
            return this.ExecuteQueryForList<Hashtable>("Interface.RvDealerKpiScoreSummaryMap.SelectDealerQuarterList", condition);
        }

        public IList<Hashtable> SelectDealerBuList(Guid? dealerId,String quarter)
        {
            Hashtable condition = new Hashtable();
            condition.Add("DealerId", dealerId);
            condition.Add("Quarter", quarter);
            return this.ExecuteQueryForList<Hashtable>("Interface.RvDealerKpiScoreSummaryMap.SelectDealerBuList", condition);
        }
    }
}