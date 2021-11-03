using System;
using System.Collections;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    public interface IInvReconcileBLL
    {
        DataSet QueryInvReconcile(Hashtable table, int start, int limit, out int totalRowCount);

        DataSet QueryInvReconcile(Hashtable table);

        DataSet QueryProductDetail(Hashtable table, int start, int limit, out int totalRowCount);

        DataSet QueryProductDetail(string ids);

        DataSet QueryInvoiceDetail(Hashtable table, int start, int limit, out int totalRowCount);

        DataSet QueryInvoiceDetail(string ids);

        DataSet QueryProductInvoiceDetail(Hashtable table, int start, int limit ,out int totalRowCount);

        int DeleteInvRecDetailTemp();

        bool BatchInsertData(DataTable dt);

        DataSet QueryInvRecDetail(Hashtable ht);

        DataSet QueryInvRecDetailTempByUser(Guid user_id);

        DataSet QueryInvTotalNumber(Hashtable ht);

        void ExeSaveCompareStatus( Guid SPH_ID, string OrderNumber, string CFN, Guid compareUser, string compareStatus, out string RtnVal, out string RtnMsg);

        void ExeUpdateCompareStatus(Guid SPH_ID, string OrderNumber, string CFN, Guid compareUser, string compareStatus, out string RtnVal, out string RtnMsg, bool isSystemCompare);

        int UpdateInvRecSummary(Hashtable ht);

        int UpdateInvRecDetail(string ids);
    }
}
