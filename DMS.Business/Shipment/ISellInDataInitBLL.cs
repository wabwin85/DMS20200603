using DMS.Model;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.Business.Shipment
{
    public interface ISellInDataInitBLL
    {
        bool DeleteTempSellInData();
        DataSet QueryTempSellInDataInfo(Hashtable ht, int start, int limit, out int rowscount);
        void BulkCopy(List<SellInDetailInfoTemp> items);
        string VerifyTempData(string rtnMsg, string rtnVal);
        DataSet QueryErrorData(int start, int pageSize, out int outCont);

        DataSet QueryTempSellInDataInfo();
    }
}
