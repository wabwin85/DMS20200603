
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : FileVersion
 * Created Time: 2017/12/19 16:04:15
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Signature;
using DMS.Signature.Model;

namespace DMS.Signature.Daos
{
    /// <summary>
    /// FileVersion的Dao
    /// </summary>
    public class FileVersionDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public FileVersionDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public FileVersion GetObject(Guid objKey)
        {
            FileVersion obj = this.ExecuteQueryForObject<FileVersion>("SelectFileVersion", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<FileVersion> GetAll()
        {
            IList<FileVersion> list = this.ExecuteQueryForList<FileVersion>("SelectFileVersion", null);          
            return list;
        }


        /// <summary>
        /// 查询FileVersion
        /// </summary>
        /// <returns>返回FileVersion集合</returns>
		public IList<FileVersion> SelectByFilter(FileVersion obj)
		{ 
			IList<FileVersion> list = this.ExecuteQueryForList<FileVersion>("SelectByFilterFileVersion", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(FileVersion obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateFileVersion", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteFileVersion", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(FileVersion obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteFileVersion", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(FileVersion obj)
        {
            this.ExecuteInsert("InsertFileVersion", obj);           
        }

        public IList<FileVersion> QueryFileVersionByFilter(Hashtable obj)
        {
            IList<FileVersion> list = this.ExecuteQueryForList<FileVersion>("QueryFileVersionByFilter", obj);
            return list;
        }

    }
}