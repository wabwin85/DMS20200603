
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ScAttachment
 * Created Time: 2014/9/21 14:03:07
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// ScAttachment的Dao
    /// </summary>
    public class ScAttachmentDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ScAttachmentDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ScAttachment GetObject(Guid objKey)
        {
            ScAttachment obj = this.ExecuteQueryForObject<ScAttachment>("SelectScAttachment", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ScAttachment> GetAll()
        {
            IList<ScAttachment> list = this.ExecuteQueryForList<ScAttachment>("SelectScAttachment", null);          
            return list;
        }


        /// <summary>
        /// 查询ScAttachment
        /// </summary>
        /// <returns>返回ScAttachment集合</returns>
		public IList<ScAttachment> SelectByFilter(ScAttachment obj)
		{ 
			IList<ScAttachment> list = this.ExecuteQueryForList<ScAttachment>("SelectByFilterScAttachment", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ScAttachment obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateScAttachment", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteScAttachment", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ScAttachment obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteScAttachment", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ScAttachment obj)
        {
            this.ExecuteInsert("InsertScAttachment", obj);           
        }

        public DataSet GetESCAttachment(Guid obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryESCAttachment", obj, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet QueryESCAttachmentByESCNo(string obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryESCAttachmentByESCNo", obj, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet GetFileCount(Guid obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetFileCount", obj);
            return ds;
        }
    }
}