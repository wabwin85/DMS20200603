using DMS.DataAccess.MasterData;
using Grapecity.DataAccess.Transaction;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.Business.MasterData
{
    public class InvHospitalBLL : IInvHospitalBLL
    {
        public bool Delete(string ids)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                using (InvHospitalDao dao = new InvHospitalDao())
                {
                   int num = dao.Delete(ids);
                }
                trans.Complete();
                result = true;
            }

            return result;
        }

        public DataSet QueryInvHospitalCfg(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = new DataSet();
            using (InvHospitalDao dao = new InvHospitalDao())
            {
                ds = dao.SelectByFilter(table,start,limit,out totalRowCount);
            }
            return ds;
        }

        public DataSet QueryInvHospitalCfgExport(Hashtable table)
        {
            DataSet ds = new DataSet();
            using (InvHospitalDao dao = new InvHospitalDao())
            {
                ds = dao.SelectByFilterForExport(table);
            }
            return ds;
        }
    }
}
