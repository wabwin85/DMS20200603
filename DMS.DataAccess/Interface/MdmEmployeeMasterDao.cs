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
    /// MdmEmployeeMasterDao
    /// </summary>
    public class MdmEmployeeMasterDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public MdmEmployeeMasterDao() : base()
        {
        }

        public IList<Hashtable> SelectFilterListAll(String filter)
        {
            Hashtable condition = new Hashtable();
            condition.Add("Filter", filter);
            return this.ExecuteQueryForList<Hashtable>("Interface.MdmEmployeeMasterMap.SelectFilterListAll", condition);
        }

        public String SelectEmployeeName(String userId)
        {
            return this.ExecuteQueryForObject<String>("Interface.MdmEmployeeMasterMap.SelectEmployeeName", userId);
        }
    }
}