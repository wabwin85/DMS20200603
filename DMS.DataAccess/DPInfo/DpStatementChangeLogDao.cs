
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DpStatementChangeLog
 * Created Time: 2015/12/7 10:32:27
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
    /// DpStatementChangeLog的Dao
    /// </summary>
    public class DpStatementChangeLogDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DpStatementChangeLogDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DpStatementChangeLog GetObject(Guid objKey)
        {
            DpStatementChangeLog obj = this.ExecuteQueryForObject<DpStatementChangeLog>("SelectDpStatementChangeLog", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DpStatementChangeLog> GetAll()
        {
            IList<DpStatementChangeLog> list = this.ExecuteQueryForList<DpStatementChangeLog>("SelectDpStatementChangeLog", null);          
            return list;
        }


        /// <summary>
        /// 查询DpStatementChangeLog
        /// </summary>
        /// <returns>返回DpStatementChangeLog集合</returns>
		public IList<DpStatementChangeLog> SelectByFilter(DpStatementChangeLog obj)
		{ 
			IList<DpStatementChangeLog> list = this.ExecuteQueryForList<DpStatementChangeLog>("SelectByFilterDpStatementChangeLog", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DpStatementChangeLog obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDpStatementChangeLog", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDpStatementChangeLog", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DpStatementChangeLog obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDpStatementChangeLog", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DpStatementChangeLog obj)
        {
            this.ExecuteInsert("InsertDpStatementChangeLog", obj);           
        }

        #region 自定义方法
        public DataSet SelectDealerFinanceStatementDetailChangeLogByKey(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return this.ExecuteQueryForDataSet("SelectDealerFinanceStatementDetailChangeLogByKey", table, start, limit, out totalRowCount);
        }
        #endregion

    }
}