using DMS.DataAccess.Shipment;
using DMS.Model;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.Business.Shipment
{
    public class SellInDataInitBLL : ISellInDataInitBLL
    {
        private SellInDataInitDao dao = new SellInDataInitDao();
        private IRoleModelContext _context = RoleModelContext.Current;

        public void BulkCopy(List<SellInDetailInfoTemp> items)
        {
            dao.BatchInsertData(items);
        }

        public bool DeleteTempSellInData()
        {
            int result = dao.DeleteTempSellInData();

            return true;
        }

        public DataSet QueryErrorData(int start, int pageSize, out int outCont)
        {
            Hashtable ht = new Hashtable();
            DataSet ds = dao.QuerySellInInitData(ht, start, pageSize, out outCont);
            return ds;
        }

        public DataSet QueryTempSellInDataInfo(Hashtable ht, int start, int limit, out int rowscount)
        {
            DataSet ds = dao.QuerySellInInitData(ht, start, limit, out rowscount);
            return ds;
        }

        public string VerifyTempData(string rtnMsg, string rtnVal)
        {
            Hashtable ht = new Hashtable();
            ht.Add("RtnMsg", rtnMsg);
            ht.Add("RtnVal", rtnVal);

            return dao.ExecuteVerifiyTempData(ht);
        }
    }
}
