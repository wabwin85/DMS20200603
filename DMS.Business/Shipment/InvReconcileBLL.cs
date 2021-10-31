using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DMS.DataAccess;

namespace DMS.Business
{
    public class InvReconcileBLL: IInvReconcileBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        public DataSet QueryInvReconcile(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = new DataSet();
            using (var dao = new InvReconcileDao())
            {
                ds = dao.SelectInvReconcile(table,start,limit, out totalRowCount);
            }
            return ds;
        }

        public DataSet QueryInvReconcile(Hashtable table)
        {
            DataSet ds = new DataSet();
            using (var dao = new InvReconcileDao())
            {
                ds = dao.SelectInvReconcile(table);
            }
            return ds;
        }

        public DataSet QueryProductDetail(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = new DataSet();
            using (var dao = new InvReconcileDao())
            {
                ds = dao.SelectProductDetail(table, start, limit, out totalRowCount);
            }
            return ds;
        }

        public DataSet QueryProductDetail(string ids)
        {
            DataSet ds = new DataSet();
            using (var dao = new InvReconcileDao())
            {
                ds = dao.SelectProductDetail(ids);
            }
            return ds;
        }

        public DataSet QueryInvoiceDetail(Hashtable table,int start, int limit, out int totalRowCount)
        {
            DataSet ds = new DataSet();
            using (var dao = new InvReconcileDao())
            {
                ds = dao.SelectInvoiceDetail(table, start, limit, out totalRowCount);
            }
            return ds;
        }

        public DataSet QueryInvoiceDetail(string ids)
        {
            DataSet ds = new DataSet();
            using (var dao = new InvReconcileDao())
            {
                ds = dao.SelectInvoiceDetail(ids);
            }
            return ds;
        }

        public DataSet QueryProductInvoiceDetail(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = new DataSet();
            using (var dao = new InvReconcileDao())
            {
                ds = dao.SelectProductInvoiceDetail(table, start, limit, out totalRowCount);
            }
            return ds;
        }

        public int DeleteInvRecDetailTemp()
        {
            int cnt = 0;
            using (var dao = new InvReconcileDao())
            {
                cnt = dao.ExeDelInvRecTemp(new Guid(_context.User.Id));
            }
            return cnt;
        }

        public bool BatchInsertData(DataTable dt)
        {
            bool tag = true;
            try
            {
                using (var dao = new InvReconcileDao())
                {
                   dao.BatchInsertTempData(dt);
                    return tag;
                } 
            }
            catch(Exception ex)
            {
                tag = false; 
                return tag;
            }
        }

        public DataSet QueryInvRecDetail(Hashtable ht)
        {
            DataSet ds = new DataSet();
            using (var dao = new InvReconcileDao())
            {
                ds = dao.SelectInvRecDetail(ht);
            }
            return ds;
        }

        public DataSet QueryInvRecDetailTempByUser(Guid user_id)
        {
            DataSet ds = new DataSet();
            using (var dao = new InvReconcileDao())
            {
                ds = dao.SelectInvRecDetailTempByUser(user_id);
            }
            return ds;
        }

        public DataSet QueryInvTotalNumber(Hashtable ht)
        {
            DataSet ds = new DataSet();
            using (var dao = new InvReconcileDao())
            {
                ds = dao.SelectInvTotalNumber(ht);
            }
            return ds;
        }

        public void ExeSaveCompareStatus(Guid SPH_ID, Guid compareUser, string compareStatus, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;
            using (InvReconcileDao dao = new InvReconcileDao())
            {
                dao.ExeSaveCompareStatus(compareUser, compareStatus, out RtnVal, out RtnMsg);
            }
        }

       public void ExeUpdateCompareStatus(Guid SPH_ID, string OrderNumber, string CFN, Guid compareUser, string compareStatus, out string RtnVal, out string RtnMsg, bool isSystemCompare = true)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;
            using (InvReconcileDao dao = new InvReconcileDao())
            {
                dao.ExeUpdateCompareStatus(SPH_ID, OrderNumber, CFN, compareUser, compareStatus, isSystemCompare, out RtnVal, out RtnMsg);
            }
        }

        public int UpdateInvRecSummary(Hashtable ht)
        {
            int cnt = 0;
            using (InvReconcileDao dao = new InvReconcileDao())
            {
                cnt = dao.UpdateInvRecSummary(ht);
            }
            return cnt;
        }

    }
}
