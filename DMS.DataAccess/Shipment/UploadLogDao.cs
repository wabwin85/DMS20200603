
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : UploadLog
 * Created Time: 2013/9/2 14:32:16
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
    /// UploadLog的Dao
    /// </summary>
    public class UploadLogDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public UploadLogDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public UploadLog GetObject(Guid objKey)
        {
            UploadLog obj = this.ExecuteQueryForObject<UploadLog>("SelectUploadLog", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<UploadLog> GetAll()
        {
            IList<UploadLog> list = this.ExecuteQueryForList<UploadLog>("SelectUploadLog", null);          
            return list;
        }


        /// <summary>
        /// 查询UploadLog
        /// </summary>
        /// <returns>返回UploadLog集合</returns>
		public IList<UploadLog> SelectByFilter(UploadLog obj)
		{ 
			IList<UploadLog> list = this.ExecuteQueryForList<UploadLog>("SelectByFilterUploadLog", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(UploadLog obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateUploadLog", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteUploadLog", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(UploadLog obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteUploadLog", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(UploadLog obj)
        {
            this.ExecuteInsert("InsertUploadLog", obj);           
        }


    }
}