
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : PoReceipt
 * Created Time: 2009-7-22 10:57:41
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
    /// PoReceipt的Dao
    /// </summary>
    public class PoReceiptDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public PoReceiptDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public PoReceipt GetObject(Guid objKey)
        {
            PoReceipt obj = this.ExecuteQueryForObject<PoReceipt>("SelectPoReceipt", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<PoReceipt> GetAll()
        {
            IList<PoReceipt> list = this.ExecuteQueryForList<PoReceipt>("SelectPoReceipt", null);          
            return list;
        }

        public IList<PoReceipt> SelectByPrhId(Guid PrhId)
        {
            IList<PoReceipt> list = this.ExecuteQueryForList<PoReceipt>("SelectByFilterPrhId", PrhId);
            return list;
        }

        /// <summary>
        /// 查询PoReceipt
        /// </summary>
        /// <returns>返回PoReceipt集合</returns>
		public IList<PoReceipt> SelectByFilter(PoReceipt obj)
		{ 
			IList<PoReceipt> list = this.ExecuteQueryForList<PoReceipt>("SelectByFilterPoReceipt", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(PoReceipt obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePoReceipt", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(PoReceipt obj)
        {
            int cnt = (int)this.ExecuteDelete("DeletePoReceipt", obj);            
            return cnt;
        }


		
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(PoReceipt obj)
        {
            this.ExecuteInsert("InsertPoReceipt", obj);           
        }


    }
}