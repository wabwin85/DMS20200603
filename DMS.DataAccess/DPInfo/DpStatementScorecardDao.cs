
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DpStatementScorecard
 * Created Time: 2015/12/7 10:32:28
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
    /// DpStatementScorecard的Dao
    /// </summary>
    public class DpStatementScorecardDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DpStatementScorecardDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DpStatementScorecard GetObject(Guid objKey)
        {
            DpStatementScorecard obj = this.ExecuteQueryForObject<DpStatementScorecard>("SelectDpStatementScorecard", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DpStatementScorecard> GetAll()
        {
            IList<DpStatementScorecard> list = this.ExecuteQueryForList<DpStatementScorecard>("SelectDpStatementScorecard", null);          
            return list;
        }


        /// <summary>
        /// 查询DpStatementScorecard
        /// </summary>
        /// <returns>返回DpStatementScorecard集合</returns>
		public IList<DpStatementScorecard> SelectByFilter(DpStatementScorecard obj)
		{ 
			IList<DpStatementScorecard> list = this.ExecuteQueryForList<DpStatementScorecard>("SelectByFilterDpStatementScorecard", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DpStatementScorecard obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDpStatementScorecard", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDpStatementScorecard", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DpStatementScorecard obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDpStatementScorecard", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DpStatementScorecard obj)
        {
            this.ExecuteInsert("InsertDpStatementScorecard", obj);
        }


    }
}