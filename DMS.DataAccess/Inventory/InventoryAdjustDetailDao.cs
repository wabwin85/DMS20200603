
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : InventoryAdjustDetail
 * Created Time: 2009-8-5 16:19:40
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
    /// InventoryAdjustDetail的Dao
    /// </summary>
    public class InventoryAdjustDetailDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InventoryAdjustDetailDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InventoryAdjustDetail GetObject(Guid objKey)
        {
            InventoryAdjustDetail obj = this.ExecuteQueryForObject<InventoryAdjustDetail>("SelectInventoryAdjustDetail", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InventoryAdjustDetail> GetAll()
        {
            IList<InventoryAdjustDetail> list = this.ExecuteQueryForList<InventoryAdjustDetail>("SelectInventoryAdjustDetail", null);          
            return list;
        }


        /// <summary>
        /// 查询InventoryAdjustDetail
        /// </summary>
        /// <returns>返回InventoryAdjustDetail集合</returns>
		public IList<InventoryAdjustDetail> SelectByFilter(InventoryAdjustDetail obj)
		{ 
			IList<InventoryAdjustDetail> list = this.ExecuteQueryForList<InventoryAdjustDetail>("SelectByFilterInventoryAdjustDetail", obj);          
            return list;
		}


        public IList<InventoryAdjustDetail> SelectByHashtable(Hashtable obj)
        {
            IList<InventoryAdjustDetail> list = this.ExecuteQueryForList<InventoryAdjustDetail>("SelectInventoryAdjustDetailByHashtable", obj);
            return list;
        }

        public IList<InventoryAdjustDetail> SelectByHashtable(Guid id)
        {
            Hashtable param = new Hashtable();
            param.Add("IahId", id);
            IList<InventoryAdjustDetail> list = this.ExecuteQueryForList<InventoryAdjustDetail>("SelectInventoryAdjustDetailByHashtable", param);
            return list;
        }
        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InventoryAdjustDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryAdjustDetail", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryAdjustDetail", id);            
            return cnt;
        }

        public int DeleteByAdjustId(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryAdjustDetailByAdjustId", id);
            return cnt;
        }
		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InventoryAdjustDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInventoryAdjustDetail", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InventoryAdjustDetail obj)
        {
            this.ExecuteInsert("InsertInventoryAdjustDetail", obj);           
        }


    }
}