
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : InventoryTransactionLot
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
    /// InventoryTransactionLot的Dao
    /// </summary>
    public class InventoryTransactionLotDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InventoryTransactionLotDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InventoryTransactionLot GetObject(Guid objKey)
        {
            InventoryTransactionLot obj = this.ExecuteQueryForObject<InventoryTransactionLot>("SelectInventoryTransactionLot", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InventoryTransactionLot> GetAll()
        {
            IList<InventoryTransactionLot> list = this.ExecuteQueryForList<InventoryTransactionLot>("SelectInventoryTransactionLot", null);          
            return list;
        }


        /// <summary>
        /// 查询InventoryTransactionLot
        /// </summary>
        /// <returns>返回InventoryTransactionLot集合</returns>
		public IList<InventoryTransactionLot> SelectByFilter(InventoryTransactionLot obj)
		{ 
			IList<InventoryTransactionLot> list = this.ExecuteQueryForList<InventoryTransactionLot>("SelectByFilterInventoryTransactionLot", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InventoryTransactionLot obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryTransactionLot", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(InventoryTransactionLot obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryTransactionLot", obj);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InventoryTransactionLot obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInventoryTransactionLot", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InventoryTransactionLot obj)
        {
            this.ExecuteInsert("InsertInventoryTransactionLot", obj);           
        }


    }
}