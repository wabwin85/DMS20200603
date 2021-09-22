
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DealerSign
 * Created Time: 2015/7/31 10:48:58
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
    /// DealerSign的Dao
    /// </summary>
    public class DealerSignDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DealerSignDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealerSign GetObject(Guid objKey)
        {
            DealerSign obj = this.ExecuteQueryForObject<DealerSign>("SelectDealerSign", objKey);           
            return obj;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealerSign obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerSign", obj);            
            return cnt;
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerSign", objKey);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerSign obj)
        {
            this.ExecuteInsert("InsertDealerSign", obj);           
        }

        public DataSet SelectDealerSignList(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerSignList", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet DeleteDealerSignById(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DeleteDealerSignById", obj);
            return ds;
        }

        public DataSet SelectRemainDealerSalesList(Hashtable condition, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectRemainDealerSalesList", condition, start, limit, out totalCount);
            return ds;
        }

        public DataSet SelectSignDealerSalesList(String signId, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSignDealerSalesList", signId, start, limit, out totalCount);
            return ds;
        }

        public int UpdateDealerSignStatus(DealerSign obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerSignStatus", obj);
            return cnt;
        }

        public int SelectSignSalesRecordCount(String signId)
        {
            int cnt = this.ExecuteQueryForObject<int>("SelectSignSalesRecordCount", signId);
            return cnt;
        }
    }
}