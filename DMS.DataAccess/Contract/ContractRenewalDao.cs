
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ContractRenewal
 * Created Time: 2013/12/15 10:38:29
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
    /// ContractRenewal的Dao
    /// </summary>
    public class ContractRenewalDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ContractRenewalDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ContractRenewal GetObject(Guid objKey)
        {
            ContractRenewal obj = this.ExecuteQueryForObject<ContractRenewal>("SelectContractRenewal", objKey);           
            return obj;
        }

        public int UpdateRenewalCmidByConid(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateRenewalCmidByConid", obj);
            return cnt;
        }

        public int UpdateRenewalFromMark(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateRenewalFromMark", obj);
            return cnt;
        }


    }
}