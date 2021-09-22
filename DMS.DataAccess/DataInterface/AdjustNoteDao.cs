
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : AdjustNote
 * Created Time: 2013/9/2 17:09:23
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
    /// AdjustNote的Dao
    /// </summary>
    public class AdjustNoteDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public AdjustNoteDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public AdjustNote GetObject(Guid objKey)
        {
            AdjustNote obj = this.ExecuteQueryForObject<AdjustNote>("SelectAdjustNote", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<AdjustNote> GetAll()
        {
            IList<AdjustNote> list = this.ExecuteQueryForList<AdjustNote>("SelectAdjustNote", null);          
            return list;
        }


        /// <summary>
        /// 查询AdjustNote
        /// </summary>
        /// <returns>返回AdjustNote集合</returns>
		public IList<AdjustNote> SelectByFilter(AdjustNote obj)
		{ 
			IList<AdjustNote> list = this.ExecuteQueryForList<AdjustNote>("SelectByFilterAdjustNote", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(AdjustNote obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAdjustNote", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAdjustNote", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(AdjustNote obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteAdjustNote", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(AdjustNote obj)
        {
            this.ExecuteInsert("InsertAdjustNote", obj);           
        }

        public IList<AdjustNote> SelectAdjustNoteByBatchNbrErrorOnly(string batchNbr)
        {
            IList<AdjustNote> list = this.ExecuteQueryForList<AdjustNote>("SelectAdjustNoteByBatchNbrErrorOnly", batchNbr);
            return list;
        }
    }
}