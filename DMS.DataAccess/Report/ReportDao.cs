using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// Report的Dao
    /// </summa
    public class ReportDao : BaseSqlMapDao
    {
        /// <summary>
        /// 默认构造函数
        /// </summary>
        public ReportDao() : base()
        {
        }
        public DataSet QueryDealerInventoryDetail(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerInventoryDetail", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet ExportDealerInventoryDetail(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportDealerInventoryDetail", obj);
            return ds;
        }
        public DataSet HospitalSales(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalSales", obj, start, limit, out totalCount);
            return ds;

        }
        public DataSet ExprotHospitalSales(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportHospitalSales", obj);
            return ds;

        }

        public DataSet ScorecardDIOHReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectScorecardDIOHReport", obj, start, limit, out totalCount);
            return ds;

        }
        public DataSet ExprotScorecardDIOHReport(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportScorecardDIOHReport", obj);
            return ds;

        }
        public DataSet DealerPurchaseDetailReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerPurchaseDetailReport", obj, start, limit, out totalCount);
            return ds;

        }
        public DataSet ExprotDealerPurchaseDetailReport(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExprotDealerPurchaseDetailReport", obj);
            return ds;

        }
        public DataSet DealerSalesStatistics(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DealerSalesStatistics", obj, start, limit, out totalCount);
            return ds;

        }

        public DataSet DealerOrderDetailReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DealerOrderDetailReport", obj, start, limit, out totalCount);
            return ds;

        }
        public DataSet DealerInvAdjustReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DealerInvAdjustReport", obj, start, limit, out totalCount);
            return ds;

        }
        public DataSet DealerBuyInReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DealerBuyInReport", obj, start, limit, out totalCount);
            return ds;

        }

        public DataSet DealerJXCSummaryReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DealerJXCSummaryReport", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet DealerHistoryInvDetailReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DealerHistoryInvDetailReport", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet SalesHospitalReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SalesHospitalReport", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet DealerTransferReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DealerTransferReport", obj, start, limit, out totalCount);
            return ds;

        }
        public DataSet DealerTransferInReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DealerTransferInReport", obj, start, limit, out totalCount);
            return ds;

        }
        public DataSet DealerTransferOutReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DealerTransferOutReport", obj, start, limit, out totalCount);
            return ds;

        }
        public DataSet ProductOperationLogReport(Hashtable obj, int start, int limit, out int totalCount)
        {            
            DataSet ds = this.ExecuteQueryForDataSet("ProductOperationLogReport", obj, start, limit, out totalCount);
            return ds;

        }
        public DataSet DealerOperationDaysReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DealerOperationDaysReport", obj, start, limit, out totalCount);
            return ds;

        }
        public DataSet AOPDealerReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("AOPDealerReport", obj, start, limit, out totalCount);
            return ds;

        }
        public DataSet DealerQuotaReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DealerQuotaReport", obj, start, limit, out totalCount);
            return ds;

        }
        public DataSet DealerHospitalQuotaReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DealerHospitalQuotaReport", obj, start, limit, out totalCount);
            return ds;

        }
        public DataSet DealerContractReport(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DealerContractReport", obj, start, limit, out totalCount);
            return ds;

        }
    }
}
