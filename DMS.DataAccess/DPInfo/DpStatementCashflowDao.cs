
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DpStatementCashflow
 * Created Time: 2015/12/11 11:35:20
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
    /// DpStatementCashflow的Dao
    /// </summary>
    public class DpStatementCashflowDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DpStatementCashflowDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DpStatementCashflow GetObject(Guid objKey)
        {
            DpStatementCashflow obj = this.ExecuteQueryForObject<DpStatementCashflow>("SelectDpStatementCashflow", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DpStatementCashflow> GetAll()
        {
            IList<DpStatementCashflow> list = this.ExecuteQueryForList<DpStatementCashflow>("SelectDpStatementCashflow", null);          
            return list;
        }


        /// <summary>
        /// 查询DpStatementCashflow
        /// </summary>
        /// <returns>返回DpStatementCashflow集合</returns>
		public IList<DpStatementCashflow> SelectByFilter(DpStatementCashflow obj)
		{ 
			IList<DpStatementCashflow> list = this.ExecuteQueryForList<DpStatementCashflow>("SelectByFilterDpStatementCashflow", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DpStatementCashflow obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDpStatementCashflow", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDpStatementCashflow", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DpStatementCashflow obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDpStatementCashflow", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DpStatementCashflow obj)
        {
            this.ExecuteInsert("InsertDpStatementCashflow", obj);
        }

        #region 自定义方法
        public int DeleteDpStatementCashflowByHeaderId(Guid headerId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDpStatementCashflowByHeaderId", headerId);
            return cnt;
        }

        public IList<DpStatementCashflow> SelectDealerFinanceStatementCashFlowByDealer(Hashtable ht)
        {
            return this.ExecuteQueryForList<DpStatementCashflow>("SelectDealerFinanceStatementCashFlowByDealer", ht);
        }
        #endregion
    }
}