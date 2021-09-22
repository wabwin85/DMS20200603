
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
    /// SalesTrainMaster的Dao
    /// </summary>
    public class SalesTrainMasterDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
        public SalesTrainMasterDao()
            : base()
        {
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(SalesTrainMaster obj)
        {
            this.ExecuteInsert("InsertSalesTrainMaster", obj);
        }

        public void UpdateSalesTrainActiveById(SalesTrainMaster obj)
        {
            this.ExecuteUpdate("UpdateSalesTrainActiveById", obj);
        }

        public void UpdateSalesTrainActiveByCondition(SalesTrainMaster obj)
        {
            this.ExecuteUpdate("UpdateSalesTrainActiveByCondition", obj);
        }

        public void UpdateSalesTrainActiveBySign(SalesTrainMaster obj)
        {
            this.ExecuteUpdate("UpdateSalesTrainActiveBySign", obj);
        }

        public DataSet SelectSalesByTrainId(String trainId, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSalesByTrainId", trainId, start, limit, out totalCount);
            return ds;
        }

        public DataSet SelectSalesByTrainId(String trainId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSalesByTrainId", trainId);
            return ds;
        }

        public DataSet SelectSalesByTrainIdForTemplate(String trainId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSalesByTrainIdForTemplate", trainId);
            return ds;
        }

        public int SelectSalesTrainCount(SalesTrainMaster obj)
        {
            int cnt = this.ExecuteQueryForObject<int>("SelectSalesTrainCount", obj);
            return cnt;
        }

        public int SelectTrainSignCount(String salesTrainId)
        {
            int cnt = this.ExecuteQueryForObject<int>("SelectTrainSignCount", salesTrainId);
            return cnt;
        }

        public int SelectDelaerSalesRecordCount(String salesTrainId)
        {
            int cnt = this.ExecuteQueryForObject<int>("SelectDelaerSalesRecordCount", salesTrainId);
            return cnt;
        }

        public int DeleteSalesTrainByTrainId(String trainId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteSalesTrainByTrainId", trainId);
            return cnt;
        }

        public void ProcFillOverdueLesson(Hashtable condition)
        {
            this.ExecuteUpdate("ProcFillOverdueLesson", condition);
        }
    }
}