using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using DMS.Model.DataInterface;
using System.Data;

namespace DMS.DataAccess.Lafite
{
    /// <summary>
    /// IdentityDao
    /// </summary>
    public class IdentityDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public IdentityDao(): base()
        {
        }
		
        public String SelectUserName(Guid userId)
        {
            return this.ExecuteQueryForObject<String>("Lafite.IdentityMap.SelectUserName", userId);
        }

        public IList<Hashtable> SelectByMobile(String mobile)
        {
            return this.ExecuteQueryForList<Hashtable>("Lafite.IdentityMap.SelectByMobile", mobile);
        }
    }
}