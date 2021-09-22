using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using DMS.Model.DataInterface;
using System.Data;

namespace DMS.DataAccess.Platform
{
    /// <summary>
    /// SystemManualDao
    /// </summary>
    public class SystemManualDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public SystemManualDao(): base()
        {
        }
		
        public IList<Hashtable> SelectListByType(Hashtable ht)
        {
            return this.ExecuteQueryForList<Hashtable>("SystemManualMap.SelectListByType", ht);
        }

        public void InsertSystemManual(Hashtable ht)
        {
            this.ExecuteInsert("SystemManualMap.InsertSystemManual", ht);
        }

        public int FakeDelete(Hashtable ht)
        {
            return base.ExecuteUpdate("SystemManualMap.UpdateSystemManual", ht);
        }
    }
}