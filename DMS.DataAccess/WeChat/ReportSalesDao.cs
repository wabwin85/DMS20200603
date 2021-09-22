
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ReportSales
 * Created Time: 2013/11/25 12:16:07
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
    /// ReportSales的Dao
    /// </summary>
    public class ReportSalesDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ReportSalesDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ReportSales GetObject(Guid objKey)
        {
            ReportSales obj = this.ExecuteQueryForObject<ReportSales>("SelectReportSales", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ReportSales> GetAll()
        {
            IList<ReportSales> list = this.ExecuteQueryForList<ReportSales>("SelectReportSales", null);          
            return list;
        }


        /// <summary>
        /// 查询ReportSales
        /// </summary>
        /// <returns>返回ReportSales集合</returns>
		public IList<ReportSales> SelectByFilter(ReportSales obj)
		{ 
			IList<ReportSales> list = this.ExecuteQueryForList<ReportSales>("SelectByFilterReportSales", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ReportSales obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateReportSales", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteReportSales", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ReportSales obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteReportSales", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ReportSales obj)
        {
            this.ExecuteInsert("InsertReportSales", obj);           
        }

        public DataSet GetCountByFilter(string weChatNumber)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetCountByFilter", weChatNumber);
            return ds;
        }
    }
}