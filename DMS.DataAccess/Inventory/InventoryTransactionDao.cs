
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : InventoryTransaction
 * Created Time: 2009-7-17 4:26:14 PM
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;

namespace DMS.DataAccess
{
    /// <summary>
    /// InventoryTransaction的Dao
    /// </summary>
    public class InventoryTransactionDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InventoryTransactionDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InventoryTransaction GetObject(Guid objKey)
        {
            InventoryTransaction obj = this.ExecuteQueryForObject<InventoryTransaction>("SelectInventoryTransaction", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InventoryTransaction> GetAll()
        {
            IList<InventoryTransaction> list = this.ExecuteQueryForList<InventoryTransaction>("SelectInventoryTransaction", null);          
            return list;
        }


        /// <summary>
        /// 查询InventoryTransaction
        /// </summary>
        /// <returns>返回InventoryTransaction集合</returns>
		public IList<InventoryTransaction> SelectByFilter(InventoryTransaction obj)
		{ 
			IList<InventoryTransaction> list = this.ExecuteQueryForList<InventoryTransaction>("SelectByFilterInventoryTransaction", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InventoryTransaction obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryTransaction", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(InventoryTransaction obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryTransaction", obj);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InventoryTransaction obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInventoryTransaction", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InventoryTransaction obj)
        {
            this.ExecuteInsert("InsertInventoryTransaction", obj);           
        }


    }
}