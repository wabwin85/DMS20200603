
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DpStatementRatio
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

namespace DMS.DataAccess
{
    /// <summary>
    /// DpStatementRatio的Dao
    /// </summary>
    public class DpStatementRatioDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DpStatementRatioDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DpStatementRatio GetObject(Guid objKey)
        {
            DpStatementRatio obj = this.ExecuteQueryForObject<DpStatementRatio>("SelectDpStatementRatio", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DpStatementRatio> GetAll()
        {
            IList<DpStatementRatio> list = this.ExecuteQueryForList<DpStatementRatio>("SelectDpStatementRatio", null);          
            return list;
        }


        /// <summary>
        /// 查询DpStatementRatio
        /// </summary>
        /// <returns>返回DpStatementRatio集合</returns>
		public IList<DpStatementRatio> SelectByFilter(DpStatementRatio obj)
		{ 
			IList<DpStatementRatio> list = this.ExecuteQueryForList<DpStatementRatio>("SelectByFilterDpStatementRatio", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DpStatementRatio obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDpStatementRatio", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDpStatementRatio", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DpStatementRatio obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDpStatementRatio", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DpStatementRatio obj)
        {
            this.ExecuteInsert("InsertDpStatementRatio", obj);           
        }

        #region 自定义方法
        public int DeleteDpStatementRatioByHeaderId(Guid headerId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDpStatementRatioByHeaderId", headerId);
            return cnt;
        }

        public IList<DpStatementRatio> SelectDealerFinanceStatementRatioByDealer(Hashtable ht)
        {
            return this.ExecuteQueryForList<DpStatementRatio>("SelectDealerFinanceStatementRatioByDealer", ht);
        }
        #endregion
    }
}