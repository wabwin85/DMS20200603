
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ContractTermination
 * Created Time: 2013/12/16 12:59:26
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
    /// ContractTermination的Dao
    /// </summary>
    public class ContractTerminationDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ContractTerminationDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ContractTermination GetObject(Guid objKey)
        {
            ContractTermination obj = this.ExecuteQueryForObject<ContractTermination>("SelectContractTermination", objKey);           
            return obj;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdateTerminationCmidByConid(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTerminationCmidByConid", obj);            
            return cnt;
        }

        public int UpdateTerminationStatusByConid(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTerminationStatusByConid", obj);
            return cnt;
        }
    }
}