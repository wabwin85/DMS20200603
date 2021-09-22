
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : MailMessageTemplate
 * Created Time: 2011-3-24 11:56:29
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
    /// MailMessageTemplate的Dao
    /// </summary>
    public class MailMessageTemplateDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public MailMessageTemplateDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public MailMessageTemplate GetObject(Guid objKey)
        {
            MailMessageTemplate obj = this.ExecuteQueryForObject<MailMessageTemplate>("SelectMailMessageTemplate", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<MailMessageTemplate> GetAll()
        {
            IList<MailMessageTemplate> list = this.ExecuteQueryForList<MailMessageTemplate>("SelectMailMessageTemplate", null);          
            return list;
        }


        /// <summary>
        /// 查询MailMessageTemplate
        /// </summary>
        /// <returns>返回MailMessageTemplate集合</returns>
		public IList<MailMessageTemplate> SelectByFilter(MailMessageTemplate obj)
		{ 
			IList<MailMessageTemplate> list = this.ExecuteQueryForList<MailMessageTemplate>("SelectByFilterMailMessageTemplate", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(MailMessageTemplate obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateMailMessageTemplate", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteMailMessageTemplate", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(MailMessageTemplate obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteMailMessageTemplate", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(MailMessageTemplate obj)
        {
            this.ExecuteInsert("InsertMailMessageTemplate", obj);
        }

        #region added by bozhenfei on 20110329
        /// <summary>
        /// 根据Code得到模板对象
        /// </summary>
        /// <param name="code"></param>
        /// <returns></returns>
        public MailMessageTemplate GetObjectByCode(string code)
        {
            MailMessageTemplate obj = this.ExecuteQueryForObject<MailMessageTemplate>("SelectMailMessageTemplateByCode", code);
            return obj;
        }
        #endregion
    }
}