using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using DMS.Model;

namespace DMS.DataAccess
{
    public class InvReconcileDao: BaseSqlMapDao
    {
        public DataSet SelectInvReconcile(Hashtable table, int start, int limit, out int rowscount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryInvReconcileInfos", table, start, limit, out rowscount);
            return ds;
        }

        public DataSet SelectInvReconcile(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryInvReconcileInfos", table);
            return ds;
        }

        public DataSet SelectTaskInvReconcile()
        {
            Hashtable ht = new Hashtable();
            DataSet ds = this.ExecuteQueryForDataSet("QueryTaskInvReconcileInfos", ht);
            return ds;
        }

        public DataSet SelectProductDetail(Hashtable table, int start, int limit ,out int rowscount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryProductDetail", table, start, limit, out rowscount);
            return ds;
        }

        public DataSet SelectProductDetail(string ids)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryProductDetail",ids);
            return ds;
        }


        public DataSet SelectInvoiceDetail(Hashtable table ,int start, int limit, out int rowscount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryInvoiceDetail", table, start, limit, out rowscount);
            return ds; 
        }

        public DataSet SelectInvRecDetailReport(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryInvRecDetailExport", table);
            return ds;
        }

        public DataSet SelectInvoiceDetail(string ids)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryInvoiceDetail", ids);
            return ds;
        }

        public DataSet SelectProductInvoiceDetail(Hashtable table, int start, int limit, out int rowscount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryProductInvoiceDetail", table, start, limit, out rowscount);
            return ds;
        }

        public void ExeProcForInvReconcileCompare(Hashtable ht)
        {
           this.ExecuteInsert("SaveInvReconcileDetailCompareInfo",ht);
            
        }

        public int ExeDelInvRecTemp(Guid user_id)
        {
            return this.ExecuteUpdate("DeleteReconcileDetailResultByUser", user_id);
        }

        public void BatchInsertTempData(DataTable dt)
        {
            this.ExecuteBatchInsert("InvReconcileDetailTemp", dt);
        }

        public DataSet SelectInvRecDetail(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryInvDetailRecords", ht);
            return ds;
        }

        public DataSet SelectInvRecDetailTempByUser(Guid user_id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInvReconcileTempByUser", user_id);
            return ds;
        }

        public DataSet SelectInvTotalNumber(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryInvoiceTotalNumber", ht);
            return ds;
        }

        public DataSet SelectMatchRule(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryCheckMatchRule", ht);
            return ds;
        }

        public void ExeSaveCompareStatus(Guid SPH_ID, string OrderNumber, string CFN, Guid compareUser, string compareStatus,string compareInfos, out string RtnVal, out string RtnMsg)
        {
            RtnMsg = string.Empty;
            RtnVal = string.Empty;
            Hashtable table = new Hashtable();
            table.Add("SPH_ID", SPH_ID);
            table.Add("OrderNumber", OrderNumber);
            table.Add("CFN",CFN);
            table.Add("CompareUser", compareUser);
            table.Add("CompareStatus", compareStatus);
            table.Add("CompareInfos", compareInfos);
            table.Add("RtnVal", RtnVal);
            table.Add("RtnMsg", RtnMsg);
            this.ExecuteInsert("SaveCompareStatus", table);

            RtnMsg = table["RtnMsg"].ToString();
            RtnVal = table["RtnVal"].ToString();
        }

        public void ExeUpdateCompareStatus(Guid SPH_ID, string OrderNumber, string CFN, Guid ProductLineId, Guid compareUser, string compareStatus,bool isSystemCompare,string compareInfos, out string RtnVal, out string RtnMsg)
        {
            RtnMsg = string.Empty;
            RtnVal = string.Empty;
            Hashtable table = new Hashtable();
            table.Add("SPH_ID", SPH_ID);
            table.Add("OrderNumber", OrderNumber);
            table.Add("CFN", CFN);
            table.Add("ProductLineId", ProductLineId);
            table.Add("CompareUser", compareUser);
            table.Add("CompareStatus", compareStatus);
            table.Add("CompareInfos",compareInfos);
            table.Add("IsSystemCompare",isSystemCompare);
            table.Add("RtnVal", RtnVal);
            table.Add("RtnMsg", RtnMsg);
            this.ExecuteUpdate("UpdateCompareStatus", table);

            RtnMsg = table["RtnMsg"].ToString();
            RtnVal = table["RtnVal"].ToString();
        }

        public int UpdateInvRecSummary(Hashtable ht)
        {
            int cnt = this.ExecuteUpdate("UpdateInvRecSummary", ht);
            return cnt;
        }

        public int UpdateInvRecDetail(string ids)
        {
            int cnt = this.ExecuteUpdate("UpdateInvRecDetail", ids);
            return cnt;
        }
    }
}
