
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : StocktakingHeader
 * Created Time: 2010-6-3 11:32:12
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
    /// StocktakingHeader的Dao
    /// </summary>
    public class StocktakingHeaderDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public StocktakingHeaderDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public StocktakingHeader GetObject(Guid objKey)
        {
            StocktakingHeader obj = this.ExecuteQueryForObject<StocktakingHeader>("SelectStocktakingHeader", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<StocktakingHeader> GetAll()
        {
            IList<StocktakingHeader> list = this.ExecuteQueryForList<StocktakingHeader>("SelectStocktakingHeader", null);          
            return list;
        }


        /// <summary>
        /// 查询StocktakingHeader
        /// </summary>
        /// <returns>返回StocktakingHeader集合</returns>
		public IList<StocktakingHeader> SelectByFilter(StocktakingHeader obj)
		{ 
			IList<StocktakingHeader> list = this.ExecuteQueryForList<StocktakingHeader>("SelectByFilterStocktakingHeader", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(StocktakingHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateStocktakingHeader", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteStocktakingHeader", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(StocktakingHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteStocktakingHeader", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public object Insert(StocktakingHeader obj)
        {
            return this.ExecuteInsert("InsertStocktakingHeader", obj);           
        }

        //获取盘点单明细信息
        public DataSet GetStocktakingListByCondition(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetStocktakingListByCondition", table, start, limit, out totalRowCount);
            return ds;
        }

        //根据经销商和仓库获取所有盘点单单据号
        public DataSet GetAllStocktakingNoByCondition(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetAllStocktakingNoByCondition", table);
            return ds;
        }

        //将当前仓库其他状态为未调整的盘点单状态修改为“不调整”
        public int UpdateHistoryCheckListStatus(Hashtable table)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateHistoryCheckListStatus", table);
            return cnt;
        }

        //更新盘点单状态
        public int UpdateStocktakingHeaderStatus(Hashtable param)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateStocktakingHeaderStatus", param);
            return cnt;
        }
        //获取差异报告
        public DataSet GetDifReportById(Guid SthID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetDifReportById", SthID);
            return ds;
        }
        //获取盘点报告
        public DataSet GetStockReportById(Guid SthID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetStockReportById", SthID);
            return ds;
        }

        //获取报表表头
        public DataSet GetReportHeaderById(Guid SthID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetReportHeaderById", SthID);
            return ds;
        }
    }
}