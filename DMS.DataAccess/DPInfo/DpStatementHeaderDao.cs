
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DpStatementHeader
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
using System.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// DpStatementHeader的Dao
    /// </summary>
    public class DpStatementHeaderDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DpStatementHeaderDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DpStatementHeader GetObject(Guid objKey)
        {
            DpStatementHeader obj = this.ExecuteQueryForObject<DpStatementHeader>("SelectDpStatementHeader", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DpStatementHeader> GetAll()
        {
            IList<DpStatementHeader> list = this.ExecuteQueryForList<DpStatementHeader>("SelectDpStatementHeader", null);          
            return list;
        }


        /// <summary>
        /// 查询DpStatementHeader
        /// </summary>
        /// <returns>返回DpStatementHeader集合</returns>
		public IList<DpStatementHeader> SelectByFilter(DpStatementHeader obj)
		{ 
			IList<DpStatementHeader> list = this.ExecuteQueryForList<DpStatementHeader>("SelectByFilterDpStatementHeader", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DpStatementHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDpStatementHeader", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDpStatementHeader", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DpStatementHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDpStatementHeader", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DpStatementHeader obj)
        {
            this.ExecuteInsert("InsertDpStatementHeader", obj);           
        }

        #region 自定义方法
        public DataSet QueryDealerFinanceStatement(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryDealerFinanceStatement", table, start, limit, out totalRowCount);
            return ds;
        }

        public DpStatementHeader GetDealerFinanceStatementNextYear(Hashtable table)
        {
            DpStatementHeader obj = this.ExecuteQueryForObject<DpStatementHeader>("GetDealerFinanceStatementNextYear", table);
            return obj;
        }

        public DataSet GetDealerFinanceStatementYearList(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetDealerFinanceStatementYearList", table);
            return ds;
        }

        public DataSet GetDealerFinanceStatementYearMonthList(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetDealerFinanceStatementYearMonthList", table);
            return ds;
        }

        public DataSet GetDealerFinanceStatementMonthByYear(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetDealerFinanceStatementMonthByYear", table);
            return ds;
        }
        #endregion

    }
}