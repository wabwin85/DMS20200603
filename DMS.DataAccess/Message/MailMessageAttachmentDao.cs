
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : MailMessageAttachment
 * Created Time: 2018-5-29 15:58:42
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
    /// MailMessageAttachment的Dao
    /// </summary>
    public class MailMessageAttachmentDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public MailMessageAttachmentDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public MailMessageAttachment GetObject(Guid objKey)
        {
            MailMessageAttachment obj = this.ExecuteQueryForObject<MailMessageAttachment>("SelectMailMessageAttachment", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<MailMessageAttachment> GetAll()
        {
            IList<MailMessageAttachment> list = this.ExecuteQueryForList<MailMessageAttachment>("SelectMailMessageAttachment", null);
            return list;
        }


        /// <summary>
        /// 查询MailMessageAttachment
        /// </summary>
        /// <returns>返回MailMessageAttachment集合</returns>
		public IList<MailMessageAttachment> SelectByFilter(MailMessageAttachment obj)
        {
            IList<MailMessageAttachment> list = this.ExecuteQueryForList<MailMessageAttachment>("SelectByFilterMailMessageAttachment", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(MailMessageAttachment obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateMailMessageAttachment", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteMailMessageAttachment", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(MailMessageAttachment obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteMailMessageAttachment", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(MailMessageAttachment obj)
        {
            this.ExecuteInsert("InsertMailMessageAttachment", obj);
        }


    }
}