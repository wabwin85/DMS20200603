
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DealerAuthorizationTableTemp
 * Created Time: 2014/1/6 14:53:18
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using DMS.Model;
	
namespace DMS.DataAccess
{
    /// <summary>
    /// DealerAuthorizationTableTemp的Dao
    /// </summary>
    public class DealerAuthorizationTableTempDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DealerAuthorizationTableTempDao(): base()
        {
        }

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DealerAuthorizationTableTemp obj)
        {
            int cnt = (int)this.ExecuteUpdate("DealerAuthorizationTableTempMap.FakeDeleteDealerAuthorizationTableTemp", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerAuthorization obj)
        {
            this.ExecuteInsert("InsertDealerAuthorizationTableTemp", obj);           
        }

        public DataSet QueryAuthorizationTempListForDataSet(DealerAuthorization obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAuthorizationTempListForDataSet", obj);
            return ds;
        }

        public int UpdateContractTerritory(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateContractTerritory", obj);
            return cnt;
        }


    }
}