
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : AopDealerHistory
 * Created Time: 2014/4/4 22:09:28
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
    /// AopDealerHistory的Dao
    /// </summary>
    public class AopDealerHistoryDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public AopDealerHistoryDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public AopDealerHistory GetObject(Guid objKey)
        {
            AopDealerHistory obj = this.ExecuteQueryForObject<AopDealerHistory>("SelectAopDealerHistory", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<AopDealerHistory> GetAll()
        {
            IList<AopDealerHistory> list = this.ExecuteQueryForList<AopDealerHistory>("SelectAopDealerHistory", null);          
            return list;
        }


        /// <summary>
        /// 查询AopDealerHistory
        /// </summary>
        /// <returns>返回AopDealerHistory集合</returns>
		public IList<AopDealerHistory> SelectByFilter(AopDealerHistory obj)
		{ 
			IList<AopDealerHistory> list = this.ExecuteQueryForList<AopDealerHistory>("SelectByFilterAopDealerHistory", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(AopDealerHistory obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAopDealerHistory", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAopDealerHistory", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(AopDealerHistory obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteAopDealerHistory", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(AopDealerHistory obj)
        {
            this.ExecuteInsert("InsertAopDealerHistory", obj);           
        }

        public DataSet GetHistoryAopDealer(AopDealerHistory history, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHistoryAopDealer", history, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetHistoryAopDealer(AopDealerHistory history)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHistoryAopDealer", history);
            return ds;
        }

        public DataSet GetHistoryAopDealer(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHistoryAopDealerByHas", obj, start, limit, out totalCount);
            return ds;
        }
       
    }
}