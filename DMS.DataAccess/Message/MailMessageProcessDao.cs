
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : MailMessageProcess
 * Created Time: 2011-4-1 13:23:07
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
    /// MailMessageProcess的Dao
    /// </summary>
    public class MailMessageProcessDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public MailMessageProcessDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public MailMessageProcess GetObject(Guid objKey)
        {
            MailMessageProcess obj = this.ExecuteQueryForObject<MailMessageProcess>("SelectMailMessageProcess", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<MailMessageProcess> GetAll()
        {
            IList<MailMessageProcess> list = this.ExecuteQueryForList<MailMessageProcess>("SelectMailMessageProcess", null);          
            return list;
        }


        /// <summary>
        /// 查询MailMessageProcess
        /// </summary>
        /// <returns>返回MailMessageProcess集合</returns>
		public IList<MailMessageProcess> SelectByFilter(MailMessageProcess obj)
		{ 
			IList<MailMessageProcess> list = this.ExecuteQueryForList<MailMessageProcess>("SelectByFilterMailMessageProcess", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(MailMessageProcess obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateMailMessageProcess", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteMailMessageProcess", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(MailMessageProcess obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteMailMessageProcess", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(MailMessageProcess obj)
        {
            this.ExecuteInsert("InsertMailMessageProcess", obj);
        }

        #region added by bozhenfei on 20110401
        /// <summary>
        /// 得到待处理的邮件
        /// </summary>
        /// <returns></returns>
        public IList<MailMessageProcess> GetMailMessageProcess()
        {
            IList<MailMessageProcess> list = this.ExecuteQueryForList<MailMessageProcess>("GetMailMessageProcess", null);
            return list;
        }
        #endregion
    }
}