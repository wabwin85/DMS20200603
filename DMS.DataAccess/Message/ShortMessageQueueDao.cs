
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ShortMessageQueue
 * Created Time: 2011-3-29 10:01:09
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
    /// ShortMessageQueue的Dao
    /// </summary>
    public class ShortMessageQueueDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ShortMessageQueueDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ShortMessageQueue GetObject(Guid objKey)
        {
            ShortMessageQueue obj = this.ExecuteQueryForObject<ShortMessageQueue>("SelectShortMessageQueue", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ShortMessageQueue> GetAll()
        {
            IList<ShortMessageQueue> list = this.ExecuteQueryForList<ShortMessageQueue>("SelectShortMessageQueue", null);          
            return list;
        }


        /// <summary>
        /// 查询ShortMessageQueue
        /// </summary>
        /// <returns>返回ShortMessageQueue集合</returns>
		public IList<ShortMessageQueue> SelectByFilter(ShortMessageQueue obj)
		{ 
			IList<ShortMessageQueue> list = this.ExecuteQueryForList<ShortMessageQueue>("SelectByFilterShortMessageQueue", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ShortMessageQueue obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateShortMessageQueue", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShortMessageQueue", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ShortMessageQueue obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteShortMessageQueue", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ShortMessageQueue obj)
        {
            this.ExecuteInsert("InsertShortMessageQueue", obj);           
        }

        public void InsertTask(MessageTaskSend obj)
        {
            this.ExecuteInsert("InsertShortMessageTask", obj);
        }

        #region added by bozhenfei on 20110402
        /// <summary>
        /// 得到待发送短信列表
        /// </summary>
        /// <returns></returns>
        public IList<ShortMessageQueue> GetShortMessageQueue()
        {
            IList<ShortMessageQueue> list = this.ExecuteQueryForList<ShortMessageQueue>("GetShortMessageQueue", null);
            return list;
        }
        #endregion

    }
}