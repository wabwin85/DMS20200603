
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InventoryReturnBsc
 * Created Time: 2017-08-28 15:36:51
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
    /// InventoryReturnBsc的Dao
    /// </summary>
    public class InventoryReturnBscDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InventoryReturnBscDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InventoryReturnBsc GetObject(Guid objKey)
        {
            InventoryReturnBsc obj = this.ExecuteQueryForObject<InventoryReturnBsc>("SelectInventoryReturnBsc", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InventoryReturnBsc> GetAll()
        {
            IList<InventoryReturnBsc> list = this.ExecuteQueryForList<InventoryReturnBsc>("SelectInventoryReturnBsc", null);          
            return list;
        }


        /// <summary>
        /// 查询InventoryReturnBsc
        /// </summary>
        /// <returns>返回InventoryReturnBsc集合</returns>
		public IList<InventoryReturnBsc> SelectByFilter(InventoryReturnBsc obj)
		{ 
			IList<InventoryReturnBsc> list = this.ExecuteQueryForList<InventoryReturnBsc>("SelectByFilterInventoryReturnBsc", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InventoryReturnBsc obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryReturnBsc", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryReturnBsc", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InventoryReturnBsc obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInventoryReturnBsc", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InventoryReturnBsc obj)
        {
            this.ExecuteInsert("InsertInventoryReturnBsc", obj);           
        }

        public int SaveInventoryReturnBsc(InventoryReturnBsc obj)
        {
            int cnt = (int)this.ExecuteUpdate("SaveInventoryReturnBsc", obj);
            return cnt;
        }
    }
}