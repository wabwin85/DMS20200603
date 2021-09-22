
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InventorySafety
 * Created Time: 2010-5-28 10:27:13
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
    /// InventorySafety的Dao
    /// </summary>
    public class InventorySafetyDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InventorySafetyDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InventorySafety GetObject(Guid objKey)
        {
            InventorySafety obj = this.ExecuteQueryForObject<InventorySafety>("SelectInventorySafety", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InventorySafety> GetAll()
        {
            IList<InventorySafety> list = this.ExecuteQueryForList<InventorySafety>("SelectInventorySafety", null);          
            return list;
        }


        /// <summary>
        /// 查询InventorySafety
        /// </summary>
        /// <returns>返回InventorySafety集合</returns>
		public IList<InventorySafety> SelectByFilter(InventorySafety obj)
		{ 
			IList<InventorySafety> list = this.ExecuteQueryForList<InventorySafety>("SelectByFilterInventorySafety", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InventorySafety obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventorySafety", obj);            
            return cnt;
        }

        public int UpdateQty(Hashtable table)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventorySafetyQty", table);
            return cnt;
        }


        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventorySafety", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InventorySafety obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInventorySafety", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InventorySafety obj)
        {
            this.ExecuteInsert("InsertInventorySafety", obj);           
        }


        public DataSet GetSaftyInventoryByDealerID(Guid DMA_ID)
        {            
            Hashtable ht = new Hashtable();
            ht.Add("DealerId", DMA_ID);

            DataSet ds = (DataSet)this.SqlMap.QueryForObject("GetSaftyInventoryByDealerID", ht);
            return ds;
        }

        //获取安全库存信息
        public DataSet GetInventoryByDMACFN(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetInventoryByDMACFN", table, start, limit, out totalRowCount);
            return ds;
        } 
 
        //获取经销商授权产品的实际库存信息
        public DataSet GetActualInvQtyByCFN(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetActualInvQtyByCFN", table, start, limit, out totalRowCount);
            return ds;
        }

        //获取经销商共享产品的实际库存信息
        public DataSet GetActualInvQtyOfShareCFN(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetActualInvQtyOfShareCFN", table, start, limit, out totalRowCount);
            return ds;
        }

        //获取经销商安全库存信息
        public IList<InventorySafety> GetInventorySafetyByDMACFN(Hashtable table)
        {
            IList<InventorySafety> list = this.ExecuteQueryForList<InventorySafety>("GetInventorySafetyByDMACFN", table);
            return list;
        }

        //复制实际库存信息至安全库存
        public int UpdateSafetyQtyWithAcutalQty(Guid DMA_ID)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateSafetyQtyWithAcutalQty", DMA_ID);
            return cnt;
        }


        //将安全库存中不存在的产品实际库存信息写入安全库存
        public void InsertSafetyQtyWithAcutalQty(Guid DMA_ID)
        {
            this.ExecuteInsert("InsertSafetyQtyWithAcutalQty", DMA_ID);
        }

    }
}