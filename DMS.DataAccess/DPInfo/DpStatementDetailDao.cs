
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DpStatementDetail
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
    /// DpStatementDetail的Dao
    /// </summary>
    public class DpStatementDetailDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DpStatementDetailDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DpStatementDetail GetObject(Guid objKey)
        {
            DpStatementDetail obj = this.ExecuteQueryForObject<DpStatementDetail>("SelectDpStatementDetail", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DpStatementDetail> GetAll()
        {
            IList<DpStatementDetail> list = this.ExecuteQueryForList<DpStatementDetail>("SelectDpStatementDetail", null);          
            return list;
        }


        /// <summary>
        /// 查询DpStatementDetail
        /// </summary>
        /// <returns>返回DpStatementDetail集合</returns>
		public IList<DpStatementDetail> SelectByFilter(DpStatementDetail obj)
		{ 
			IList<DpStatementDetail> list = this.ExecuteQueryForList<DpStatementDetail>("SelectByFilterDpStatementDetail", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DpStatementDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDpStatementDetail", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDpStatementDetail", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DpStatementDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDpStatementDetail", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DpStatementDetail obj)
        {
            this.ExecuteInsert("InsertDpStatementDetail", obj);           
        }

        #region 自定义方法
        public IList<DpStatementDetail> SelectDealerFinanceStatementDetailById(Guid id)
        {
            return this.ExecuteQueryForList<DpStatementDetail>("SelectDealerFinanceStatementDetailById", id);
        }

        public IList<DpStatementDetail> SelectChangedDealerFinanceStatementDetailById(Guid id)
        {
            return this.ExecuteQueryForList<DpStatementDetail>("SelectChangedDealerFinanceStatementDetailById", id);
        }

        public DataSet SelectDealerFinanceStatementDetailForCalculation(Hashtable ht)
        {
            return this.ExecuteQueryForDataSet("SelectDealerFinanceStatementDetailForCalculation", ht);
        }

        public DataSet SelectDealerFinanceStatementDetailForCalculationScoreCard(Hashtable ht)
        {
            return this.ExecuteQueryForDataSet("SelectDealerFinanceStatementDetailForCalculationScoreCard", ht);
        }

        public IList<DpStatementDetail> SelectDealerFinanceStatementDetailByDealer(Hashtable ht)
        {
            return this.ExecuteQueryForList<DpStatementDetail>("SelectDealerFinanceStatementDetailByDealer", ht);
        }
        #endregion

    }
}