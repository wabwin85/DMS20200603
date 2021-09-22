
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DpStatementScorecardHeader
 * Created Time: 2015/12/14 13:30:08
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
    /// DpStatementScorecardHeader的Dao
    /// </summary>
    public class DpStatementScorecardHeaderDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DpStatementScorecardHeaderDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DpStatementScorecardHeader GetObject(Guid objKey)
        {
            DpStatementScorecardHeader obj = this.ExecuteQueryForObject<DpStatementScorecardHeader>("SelectDpStatementScorecardHeader", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DpStatementScorecardHeader> GetAll()
        {
            IList<DpStatementScorecardHeader> list = this.ExecuteQueryForList<DpStatementScorecardHeader>("SelectDpStatementScorecardHeader", null);          
            return list;
        }


        /// <summary>
        /// 查询DpStatementScorecardHeader
        /// </summary>
        /// <returns>返回DpStatementScorecardHeader集合</returns>
		public IList<DpStatementScorecardHeader> SelectByFilter(DpStatementScorecardHeader obj)
		{ 
			IList<DpStatementScorecardHeader> list = this.ExecuteQueryForList<DpStatementScorecardHeader>("SelectByFilterDpStatementScorecardHeader", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DpStatementScorecardHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDpStatementScorecardHeader", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDpStatementScorecardHeader", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DpStatementScorecardHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDpStatementScorecardHeader", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DpStatementScorecardHeader obj)
        {
            this.ExecuteInsert("InsertDpStatementScorecardHeader", obj);           
        }

        #region 自定义方法
        public DataSet QueryDealerFinanceScoreCard(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryDealerFinanceScoreCard", table, start, limit, out totalRowCount);
            return ds;
        }


        public DpStatementScorecardHeader GetCurrentScoreCardVersion(String dealerId)
        {
            DpStatementScorecardHeader list = this.ExecuteQueryForObject<DpStatementScorecardHeader>("GetCurrentScoreCardVersion", dealerId);
            return list;
        }


        public DataTable GetDealerCooperationYears(String dealerId)
        {
            DataTable list = this.ExecuteQueryForDataSet("GetDealerCooperationYears", dealerId).Tables[0];
            return list;
        }
        #endregion

    }
}