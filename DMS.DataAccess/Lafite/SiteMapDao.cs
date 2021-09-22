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
    /// SiteMapDao
    /// </summary>
    public class SiteMapDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public SiteMapDao(): base()
        {
        }
		
        public IList<Hashtable> SelectUserMenu(Guid userId)
        {
            return this.ExecuteQueryForList<Hashtable>("Lafite.SiteMapMap.SelectUserMenu", userId);
        }
    }
}