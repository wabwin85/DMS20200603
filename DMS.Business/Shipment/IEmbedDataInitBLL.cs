using DMS.Model; 
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.Business.Shipment
{
    public interface IEmbedDataInitBLL
    {
        bool DeleteTempEmbedData();
        DataSet QueryTempEmbedDataInfo(Hashtable ht, int start, int limit, out int rowscount);
        void BulkCopy(List<SellOutDetailInfoTemp> items);
        string VerifyTempData(string rtnMsg, string rtnVal);
        DataSet QueryErrorData(int start, int pageSize, out int outCont);
    }
}
