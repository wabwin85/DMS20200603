
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : PurchaseQuotasHospital
 * Created Time: 2014/1/2 17:58:24
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
    /// PurchaseQuotasHospital的Dao
    /// </summary>
    public class PurchaseQuotasHospitalDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public PurchaseQuotasHospitalDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DataSet GetContractTerritoryHospitalByContractId(Guid ContractId,string SubCompanyId,string BrandId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("value", ContractId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectPurchaseQuotasHospital", ht);
            return ds;
        }
    }
}