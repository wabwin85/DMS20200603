
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ScoreCardLog
 * Created Time: 2014/9/21 16:56:44
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
    /// ScoreCardLog的Dao
    /// </summary>
    public class ScoreCardLogDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ScoreCardLogDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ScoreCardLog GetObject(Guid objKey)
        {
            ScoreCardLog obj = this.ExecuteQueryForObject<ScoreCardLog>("SelectScoreCardLog", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ScoreCardLog> GetAll()
        {
            IList<ScoreCardLog> list = this.ExecuteQueryForList<ScoreCardLog>("SelectScoreCardLog", null);          
            return list;
        }


        /// <summary>
        /// 查询ScoreCardLog
        /// </summary>
        /// <returns>返回ScoreCardLog集合</returns>
		public IList<ScoreCardLog> SelectByFilter(ScoreCardLog obj)
		{ 
			IList<ScoreCardLog> list = this.ExecuteQueryForList<ScoreCardLog>("SelectByFilterScoreCardLog", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ScoreCardLog obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateScoreCardLog", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteScoreCardLog", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ScoreCardLog obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteScoreCardLog", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ScoreCardLog obj)
        {
            this.ExecuteInsert("InsertScoreCardLog", obj);           
        }

        public DataSet QueryScoreCardLogByFilter(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryScoreCardLogByFilter", obj, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet QueryScoreCardLogByFilter(Hashtable table)
        {
            return base.ExecuteQueryForDataSet("QueryScoreCardLogByFilter", table);
        }
    }
}