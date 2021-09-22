
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DpStatementField
 * Created Time: 2015/12/7 11:29:59
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
    /// DpStatementField的Dao
    /// </summary>
    public class DpStatementFieldDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DpStatementFieldDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DpStatementField GetObject(string objKey)
        {
            DpStatementField obj = this.ExecuteQueryForObject<DpStatementField>("SelectDpStatementField", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DpStatementField> GetAll()
        {
            IList<DpStatementField> list = this.ExecuteQueryForList<DpStatementField>("SelectDpStatementField", null);          
            return list;
        }


        /// <summary>
        /// 查询DpStatementField
        /// </summary>
        /// <returns>返回DpStatementField集合</returns>
		public IList<DpStatementField> SelectByFilter(DpStatementField obj)
		{ 
			IList<DpStatementField> list = this.ExecuteQueryForList<DpStatementField>("SelectByFilterDpStatementField", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DpStatementField obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDpStatementField", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(string objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDpStatementField", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DpStatementField obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDpStatementField", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DpStatementField obj)
        {
            this.ExecuteInsert("InsertDpStatementField", obj);           
        }

        #region 自定义方法
        public DataSet SelectDealerFinanceStatementFieldByType(string type)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerFinanceStatementFieldByType", type);
            return ds;
        }
        #endregion
    }
}