using DMS.DataAccess.Shipment;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.Business.Shipment
{
    public class SellInDataBLL : ISellInDataBLL
    {
        SellInDataDao dao = new SellInDataDao();
        public DataSet QuerySellInData(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = dao.QuerySellInDataInfo(table,start,limit,out totalRowCount);
            return ds;
        }

        public DataSet QuerySellInData(Hashtable table)
        {
            DataSet ds = dao.QuerySellInDataInfo(table);
            return ds;
        }
    }
}
