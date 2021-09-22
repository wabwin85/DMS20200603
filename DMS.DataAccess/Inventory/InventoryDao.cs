
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : Inventory
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
    /// Inventory的Dao
    /// </summary>
    public class InventoryDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InventoryDao(): base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public Inventory GetObject(Guid objKey)
        {
            Inventory obj = this.ExecuteQueryForObject<Inventory>("SelectInventory", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<Inventory> GetAll()
        {
            IList<Inventory> list = this.ExecuteQueryForList<Inventory>("SelectInventory", null);          
            return list;
        }


        /// <summary>
        /// 查询Inventory
        /// </summary>
        /// <returns>返回Inventory集合</returns>
		public IList<Inventory> SelectByFilter(Inventory obj)
		{ 
			IList<Inventory> list = this.ExecuteQueryForList<Inventory>("SelectByFilterInventory", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体 with hashtable
        /// </summary>
        /// <param name="ht">ht:ID,Add value</param>
        /// <returns>更新的记录数</returns>
        public int UpdateInventoryWithQty(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryWithQty", ht);            
            return cnt;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(Inventory obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventory", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Inventory obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventory", obj);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(Inventory obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInventory", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(Inventory obj)
        {
            this.ExecuteInsert("InsertInventory", obj);           
        }


    }
}