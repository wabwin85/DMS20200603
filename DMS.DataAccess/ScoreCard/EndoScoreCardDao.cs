
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : EndoScoreCard
 * Created Time: 2014/9/17 15:11:46
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
    /// EndoScoreCard的Dao
    /// </summary>
    public class EndoScoreCardDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public EndoScoreCardDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public EndoScoreCard GetObject(Guid objKey)
        {
            EndoScoreCard obj = this.ExecuteQueryForObject<EndoScoreCard>("SelectEndoScoreCard", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<EndoScoreCard> GetAll()
        {
            IList<EndoScoreCard> list = this.ExecuteQueryForList<EndoScoreCard>("SelectEndoScoreCard", null);          
            return list;
        }


        /// <summary>
        /// 查询EndoScoreCard
        /// </summary>
        /// <returns>返回EndoScoreCard集合</returns>
		public IList<EndoScoreCard> SelectByFilter(EndoScoreCard obj)
		{ 
			IList<EndoScoreCard> list = this.ExecuteQueryForList<EndoScoreCard>("SelectByFilterEndoScoreCard", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(EndoScoreCard obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateEndoScoreCard", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteEndoScoreCard", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(EndoScoreCard obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteEndoScoreCard", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(EndoScoreCard obj)
        {
            this.ExecuteInsert("InsertEndoScoreCard", obj);           
        }

        public DataSet QueryEndoScoreCardByCondition(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryEndoScoreCardByCondition", obj, start, limit, out totalRowCount);
            return ds;
        }

        public EndoScoreCard QueryEndoScoreCardByID(Guid Id)
        {
            EndoScoreCard obj = this.ExecuteQueryForObject<EndoScoreCard>("QueryEndoScoreCardByID", Id);
            return obj;
        }

        //public DataSet QueryEndoScoreCardDetailById(Guid Id, int start, int limit, out int totalRowCount)
        //{
        //    DataSet obj = this.ExecuteQueryForDataSet("QueryEndoScoreCardDetailById", Id, start, limit, out totalRowCount);
        //    return obj;
        //}


        

        

        
        public DataSet GetScoreCardIdByNo(string Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetScoreCardIdByNo", Id);
            return ds;
        }

        public DataSet GetUserIdByName(string Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetUserIdByName", Id);
            return ds;
        }
    } 
}