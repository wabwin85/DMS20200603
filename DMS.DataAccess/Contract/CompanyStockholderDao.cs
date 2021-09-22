
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : CompanyStockholder
 * Created Time: 2013/11/12 17:41:42
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
    /// CompanyStockholder的Dao
    /// </summary>
    public class CompanyStockholderDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public CompanyStockholderDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public CompanyStockholder GetObject(Guid objKey)
        {
            CompanyStockholder obj = this.ExecuteQueryForObject<CompanyStockholder>("SelectCompanyStockholder", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<CompanyStockholder> GetAll()
        {
            IList<CompanyStockholder> list = this.ExecuteQueryForList<CompanyStockholder>("SelectCompanyStockholder", null);          
            return list;
        }


        /// <summary>
        /// 查询CompanyStockholder
        /// </summary>
        /// <returns>返回CompanyStockholder集合</returns>
		public IList<CompanyStockholder> SelectByFilter(CompanyStockholder obj)
		{ 
			IList<CompanyStockholder> list = this.ExecuteQueryForList<CompanyStockholder>("SelectByFilterCompanyStockholder", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(CompanyStockholder obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateCompanyStockholder", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteCompanyStockholder", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(CompanyStockholder obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteCompanyStockholder", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(CompanyStockholder obj)
        {
            this.ExecuteInsert("InsertCompanyStockholder", obj);           
        }


        /// <summary>
        /// 查询CompanyStockholder
        /// </summary>
        /// <returns>返回CompanyStockholder集合</returns>
        public DataSet SelectCompanyStockholderByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectCompanyStockholderByFilter", table);
            return ds;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdateCompanyStockholderByFilter(CompanyStockholder obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateCompanyStockholderByFilter", obj);
            return cnt;
        }
    }
}