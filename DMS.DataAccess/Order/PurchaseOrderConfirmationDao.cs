
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : PurchaseOrderConfirmation
 * Created Time: 2011-4-18 11:04:37
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// PurchaseOrderConfirmation的Dao
    /// </summary>
    public class PurchaseOrderConfirmationDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public PurchaseOrderConfirmationDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public PurchaseOrderConfirmation GetObject(Guid objKey)
        {
            PurchaseOrderConfirmation obj = this.ExecuteQueryForObject<PurchaseOrderConfirmation>("SelectPurchaseOrderConfirmation", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<PurchaseOrderConfirmation> GetAll()
        {
            IList<PurchaseOrderConfirmation> list = this.ExecuteQueryForList<PurchaseOrderConfirmation>("SelectPurchaseOrderConfirmation", null);          
            return list;
        }


        /// <summary>
        /// 查询PurchaseOrderConfirmation
        /// </summary>
        /// <returns>返回PurchaseOrderConfirmation集合</returns>
        public DataSet SelectByFilter(Hashtable obj, int start, int limit, out int totalRowCount)
		{ 
			DataSet list = this.ExecuteQueryForDataSet("SelectByFilterPurchaseOrderConfirmation", obj, start,  limit, out  totalRowCount);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(PurchaseOrderConfirmation obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePurchaseOrderConfirmation", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeletePurchaseOrderConfirmation", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(PurchaseOrderConfirmation obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeletePurchaseOrderConfirmation", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(PurchaseOrderConfirmation obj)
        {
            this.ExecuteInsert("InsertPurchaseOrderConfirmation", obj);           
        }

        public IList<PurchaseOrderConfirmation> SelectPurchaseOrderConfirmationByBatchNbrErrorOnly(string batchNbr)
        {
            IList<PurchaseOrderConfirmation> list = this.ExecuteQueryForList<PurchaseOrderConfirmation>("SelectPurchaseOrderConfirmationByBatchNbrErrorOnly", batchNbr);
            return list;
        }
    }
}