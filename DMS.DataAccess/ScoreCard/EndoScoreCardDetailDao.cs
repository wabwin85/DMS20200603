
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : EndoScoreCardDetail
 * Created Time: 2015/6/17 11:20:54
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
    /// EndoScoreCardDetail的Dao
    /// </summary>
    public class EndoScoreCardDetailDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public EndoScoreCardDetailDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public EndoScoreCardDetail GetObject(Guid objKey)
        {
            EndoScoreCardDetail obj = this.ExecuteQueryForObject<EndoScoreCardDetail>("SelectEndoScoreCardDetail", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<EndoScoreCardDetail> GetAll()
        {
            IList<EndoScoreCardDetail> list = this.ExecuteQueryForList<EndoScoreCardDetail>("SelectEndoScoreCardDetail", null);          
            return list;
        }


        /// <summary>
        /// 查询EndoScoreCardDetail
        /// </summary>
        /// <returns>返回EndoScoreCardDetail集合</returns>
		public IList<EndoScoreCardDetail> SelectByFilter(EndoScoreCardDetail obj)
		{ 
			IList<EndoScoreCardDetail> list = this.ExecuteQueryForList<EndoScoreCardDetail>("SelectByFilterEndoScoreCardDetail", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(EndoScoreCardDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateEndoScoreCardDetail", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteEndoScoreCardDetail", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(EndoScoreCardDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteEndoScoreCardDetail", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(EndoScoreCardDetail obj)
        {
            this.ExecuteInsert("InsertEndoScoreCardDetail", obj);           
        }

        public DataSet QueryEndoScoreCardDetailById(Guid Id, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryEndoScoreCardDetailById", Id, start, limit, out totalRowCount);
            return ds;
        }

        public int UpdateAdminScore(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAdminScore", obj);
            return cnt;
        }

        public DataSet GetEditTotalScoreById(Hashtable Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetEditTotalScoreById", Id);
            return ds;
        }

        public DataSet ExportEndoScoreCardDetailForLP(Guid Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportEndoScoreCardDetailForLP", Id);
            return ds;
        }
    }
}