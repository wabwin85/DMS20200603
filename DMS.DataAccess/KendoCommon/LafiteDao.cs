using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using DMS.Model.DataInterface;
using System.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// LafiteDao
    /// </summary>
    public class LafiteDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public LafiteDao(): base()
        {
        }
		
        public DataTable SelectUserMenu(String userId)
        {
            DataTable list = this.ExecuteQueryForDataSet("LafiteMap.SelectUserMenu", userId).Tables[0];
            return list;
        }
        public string SelectOrderType(String Type,String Key)
        {
            Hashtable ht = new Hashtable();
            if (!string.IsNullOrEmpty(Type))
            {
                ht.Add("TYPE", Type);
            }
            if (!string.IsNullOrEmpty(Key))
            {
                ht.Add("KEY", Key);
            }
            string ordertype = this.ExecuteQueryForObject<string>("LafiteMap.SelectLafiteDictREV", ht);
            return ordertype;
        }
    }
}