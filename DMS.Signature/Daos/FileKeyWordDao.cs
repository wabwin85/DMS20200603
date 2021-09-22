
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : FileKeyWord
 * Created Time: 2017/12/29 16:49:14
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Signature.Model;

namespace DMS.Signature.Daos
{
    /// <summary>
    /// FileKeyWord的Dao
    /// </summary>
    public class FileKeyWordDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public FileKeyWordDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public FileKeyWord GetObject(Guid objKey)
        {
            FileKeyWord obj = this.ExecuteQueryForObject<FileKeyWord>("SelectFileKeyWord", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<FileKeyWord> GetAll()
        {
            IList<FileKeyWord> list = this.ExecuteQueryForList<FileKeyWord>("SelectFileKeyWord", null);          
            return list;
        }


        /// <summary>
        /// 查询FileKeyWord
        /// </summary>
        /// <returns>返回FileKeyWord集合</returns>
		public IList<FileKeyWord> SelectByFilter(FileKeyWord obj)
		{ 
			IList<FileKeyWord> list = this.ExecuteQueryForList<FileKeyWord>("SelectByFilterFileKeyWord", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(FileKeyWord obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateFileKeyWord", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteFileKeyWord", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(FileKeyWord obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteFileKeyWord", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(FileKeyWord obj)
        {
            this.ExecuteInsert("InsertFileKeyWord", obj);           
        }

        public IList<FileKeyWord> QueryFileKeyWordByFilter(Hashtable table)
        {
            IList<FileKeyWord> list = this.ExecuteQueryForList<FileKeyWord>("QueryFileKeyWordByFilter", table);
            return list;
        }
        
    }
}