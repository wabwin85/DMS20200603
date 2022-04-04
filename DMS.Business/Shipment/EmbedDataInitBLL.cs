using DMS.DataAccess;
using System.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections; 
using DMS.Model;
using Lafite.RoleModel.Security;

namespace DMS.Business.Shipment
{
    public class EmbedDataInitBLL: IEmbedDataInitBLL
    {
        private EmbedDataInitDao dao = new EmbedDataInitDao();
        private IRoleModelContext _context = RoleModelContext.Current;
        public bool DeleteTempEmbedData()
        {
            int result = dao.DeleteTempEmbedData();

            return true;     
        }

        public DataSet QueryTempEmbedDataInfo(Hashtable ht, int start,int limit, out int rowscount )
        {
            DataSet ds = dao.QueryEmbedDataInfo(ht, start, limit, out rowscount);
            return ds;
        }

        public void BulkCopy(List<SellOutDetailInfoTemp> items)
        {
            dao.BatchInsertData(items); 
        }

        public string VerifyTempData(string rtnMsg, string rtnVal)
        {
            Hashtable ht = new Hashtable();
            ht.Add("RtnMsg", rtnMsg);
            ht.Add("RtnVal",rtnVal); 

           return dao.ExecuteVerifiyTempData(ht);

        }

        public DataSet QueryErrorData(int start, int pageSize, out int outCont)
        {
            Hashtable ht = new Hashtable();
            DataSet ds = dao.QueryEmbedDataInfo(ht, start, pageSize, out outCont);
            return ds;
        }

        public DataSet QueryTempEmbedDataInfo()
        {
            DataSet ds = dao.QueryTempEmbedDataInfo();
            return ds;
        }
    }
}
