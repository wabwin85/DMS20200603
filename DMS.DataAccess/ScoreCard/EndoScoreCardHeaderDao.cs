
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : EndoScoreCardHeader
 * Created Time: 2015/6/17 11:20:30
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
    /// EndoScoreCardHeader的Dao
    /// </summary>
    public class EndoScoreCardHeaderDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public EndoScoreCardHeaderDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public EndoScoreCardHeader GetObject(Guid objKey)
        {
            EndoScoreCardHeader obj = this.ExecuteQueryForObject<EndoScoreCardHeader>("SelectEndoScoreCardHeader", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<EndoScoreCardHeader> GetAll()
        {
            IList<EndoScoreCardHeader> list = this.ExecuteQueryForList<EndoScoreCardHeader>("SelectEndoScoreCardHeader", null);          
            return list;
        }


        /// <summary>
        /// 查询EndoScoreCardHeader
        /// </summary>
        /// <returns>返回EndoScoreCardHeader集合</returns>
		public IList<EndoScoreCardHeader> SelectByFilter(EndoScoreCardHeader obj)
		{ 
			IList<EndoScoreCardHeader> list = this.ExecuteQueryForList<EndoScoreCardHeader>("SelectByFilterEndoScoreCardHeader", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(EndoScoreCardHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateEndoScoreCardHeader", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteEndoScoreCardHeader", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(EndoScoreCardHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteEndoScoreCardHeader", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(EndoScoreCardHeader obj)
        {
            this.ExecuteInsert("InsertEndoScoreCardHeader", obj);           
        }

        public DataSet QueryEndoScoreCardHeaderByCondition(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryEndoScoreCardHeaderByCondition", obj, start, limit, out totalRowCount);
            return ds;
        }

        public EndoScoreCardHeader QueryEndoScoreCardHeaderByID(Guid Id)
        {
            EndoScoreCardHeader obj = this.ExecuteQueryForObject<EndoScoreCardHeader>("QueryEndoScoreCardHeaderByID", Id);
            return obj;
        }

        public DataSet QueryEndoScoreCardByIDForDS(string Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryEndoScoreCardByIDForDateSet", Id);
            return ds;
        }

        public int UpdateDealerConfirm(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerConfirm", obj);
            return cnt;
        }

        public int UpdateLPConfirm(string obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateLPConfirm", obj);
            return cnt;
        }
    }
}