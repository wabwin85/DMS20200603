
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : SignRelation
 * Created Time: 2015/7/31 10:50:03
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
    /// DealerSales的Dao
    /// </summary>
    public class DealerSalesDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public DealerSalesDao()
            : base()
        {
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerSales obj)
        {
            this.ExecuteInsert("InsertDealerSales", obj);
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerSales", objKey);
            return cnt;
        }

        public DataSet SelectDealerSalesList(Hashtable condition, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerSalesList", condition, start, limit, out totalCount);
            return ds;
        }

        public DataSet SelectRemainWechatUserList(Hashtable condition, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectRemainWechatUserList", condition, start, limit, out totalCount);
            return ds;
        }

        public DataSet SelectRemainDealerSalesList(Hashtable condition, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectRemainDealerSalesList", condition, start, limit, out totalCount);
            return ds;
        }

    }
}