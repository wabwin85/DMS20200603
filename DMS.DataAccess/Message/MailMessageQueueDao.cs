
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : MailMessageQueue
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
    /// MailMessageQueue的Dao
    /// </summary>
    public class MailMessageQueueDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public MailMessageQueueDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public MailMessageQueue GetObject(Guid objKey)
        {
            MailMessageQueue obj = this.ExecuteQueryForObject<MailMessageQueue>("SelectMailMessageQueue", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<MailMessageQueue> GetAll()
        {
            IList<MailMessageQueue> list = this.ExecuteQueryForList<MailMessageQueue>("SelectMailMessageQueue", null);          
            return list;
        }


        /// <summary>
        /// 查询MailMessageQueue
        /// </summary>
        /// <returns>返回MailMessageQueue集合</returns>
		public IList<MailMessageQueue> SelectByFilter(MailMessageQueue obj)
		{ 
			IList<MailMessageQueue> list = this.ExecuteQueryForList<MailMessageQueue>("SelectByFilterMailMessageQueue", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(MailMessageQueue obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateMailMessageQueue", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteMailMessageQueue", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(MailMessageQueue obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteMailMessageQueue", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(MailMessageQueue obj)
        {
            this.ExecuteInsert("InsertMailMessageQueue", obj);           
        }

        #region added by bozhenfei on 20110309
        /// <summary>
        /// 得到待发送清单
        /// </summary>
        /// <returns></returns>
        public IList<MailMessageQueue> GetMailMessageQueue()
        {
            IList<MailMessageQueue> list = this.ExecuteQueryForList<MailMessageQueue>("GetMailMessageQueue", null);
            return list;
        }
        #endregion

    }
}