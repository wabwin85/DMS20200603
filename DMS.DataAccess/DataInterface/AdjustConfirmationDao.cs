
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : AdjustConfirmation
 * Created Time: 2013/9/2 16:37:10
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
    /// AdjustConfirmation的Dao
    /// </summary>
    public class AdjustConfirmationDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public AdjustConfirmationDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public AdjustConfirmation GetObject(Guid objKey)
        {
            AdjustConfirmation obj = this.ExecuteQueryForObject<AdjustConfirmation>("SelectAdjustConfirmation", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<AdjustConfirmation> GetAll()
        {
            IList<AdjustConfirmation> list = this.ExecuteQueryForList<AdjustConfirmation>("SelectAdjustConfirmation", null);          
            return list;
        }


        /// <summary>
        /// 查询AdjustConfirmation
        /// </summary>
        /// <returns>返回AdjustConfirmation集合</returns>
		public IList<AdjustConfirmation> SelectByFilter(AdjustConfirmation obj)
		{ 
			IList<AdjustConfirmation> list = this.ExecuteQueryForList<AdjustConfirmation>("SelectByFilterAdjustConfirmation", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(AdjustConfirmation obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAdjustConfirmation", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAdjustConfirmation", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(AdjustConfirmation obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteAdjustConfirmation", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(AdjustConfirmation obj)
        {
            this.ExecuteInsert("InsertAdjustConfirmation", obj);           
        }

        public IList<AdjustConfirmation> SelectAdjustConfirmationByBatchNbrErrorOnly(string batchNbr)
        {
            IList<AdjustConfirmation> list = this.ExecuteQueryForList<AdjustConfirmation>("SelectAdjustConfirmationByBatchNbrErrorOnly", batchNbr);
            return list;
        }
    }
}