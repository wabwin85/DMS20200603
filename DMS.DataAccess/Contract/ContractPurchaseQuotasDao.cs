
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ContractPurchaseQuotas
 * Created Time: 2013/12/15 16:00:24
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
    /// ContractPurchaseQuotas的Dao
    /// </summary>
    public class ContractPurchaseQuotasDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public ContractPurchaseQuotasDao() : base()
        {
        }

        /// <summary>
        /// 查询PurchaseQuotas
        /// </summary>
        /// <returns>返回PurchaseQuotas集合</returns>
        public DataSet SelectPurchaseQuotasByConId(Guid obj, string SubCompanyId, string BrandId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("value", obj);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectPurchaseQuotasByConId", ht);
            return ds;
        }
    }
}