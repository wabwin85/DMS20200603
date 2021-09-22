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
    /// TIQvSalesRepDao
    /// </summary>
    public class TIQvSalesRepDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public TIQvSalesRepDao() : base()
        {
        }

        public IList<Hashtable> SelectFilterListBu(Guid bu, String filter)
        {
            Hashtable condition = new Hashtable();
            condition.Add("Bu", bu);
            condition.Add("Filter", filter);
            return this.ExecuteQueryForList<Hashtable>("Interface.TIQvSalesRepMap.SelectFilterListBu", condition);
        }
        public IList<Hashtable> SelectSalesByHospital(string ProductLine,string HospitalID, String filter)
        {
            Hashtable condition = new Hashtable();
            if (!string.IsNullOrEmpty(ProductLine.Trim()))
            {
                condition.Add("ProductLine", ProductLine);
            }
            if (!string.IsNullOrEmpty(HospitalID.Trim()))
            {
                condition.Add("HospitalID", HospitalID);
            }
            if (!string.IsNullOrEmpty(filter.Trim()))
            {
                condition.Add("Filter", filter);
            }
            return this.ExecuteQueryForList<Hashtable>("Interface.TIQvSalesRepMap.SelectSalesByHosID", condition);
        }
    }
}