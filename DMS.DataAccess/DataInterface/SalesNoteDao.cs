
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : SalesNote
 * Created Time: 2013/9/2 16:51:42
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
    /// SalesNote的Dao
    /// </summary>
    public class SalesNoteDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public SalesNoteDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public SalesNote GetObject(Guid objKey)
        {
            SalesNote obj = this.ExecuteQueryForObject<SalesNote>("SelectSalesNote", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<SalesNote> GetAll()
        {
            IList<SalesNote> list = this.ExecuteQueryForList<SalesNote>("SelectSalesNote", null);          
            return list;
        }


        /// <summary>
        /// 查询SalesNote
        /// </summary>
        /// <returns>返回SalesNote集合</returns>
		public IList<SalesNote> SelectByFilter(SalesNote obj)
		{ 
			IList<SalesNote> list = this.ExecuteQueryForList<SalesNote>("SelectByFilterSalesNote", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(SalesNote obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateSalesNote", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteSalesNote", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(SalesNote obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteSalesNote", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(SalesNote obj)
        {
            this.ExecuteInsert("InsertSalesNote", obj);           
        }

        public IList<SalesNote> SelectSalesNoteByBatchNbrErrorOnly(string batchNbr)
        {
            IList<SalesNote> list = this.ExecuteQueryForList<SalesNote>("SelectSalesNoteByBatchNbrErrorOnly", batchNbr);
            return list;
        }

    }
}