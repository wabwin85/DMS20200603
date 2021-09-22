using System;
using DMS.Model;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using DMS.Model.Data;

namespace DMS.Business
{
    public interface IReportBLL
    {
        DataSet QueryDealerInventoryDetail(Hashtable obj, int start, int limit, out int totalCount);
        DataSet ExportDealerInventoryDetail(Hashtable obj);

        DataSet HospitalSales(Hashtable obj, int start, int limit, out int totalCount);

        DataSet ExportHospitalSales(Hashtable obj);

        DataSet ScorecardDIOHReport(Hashtable obj, int start, int limit, out int totalCount);
        DataSet ExportScorecardDIOHReport(Hashtable obj);

        DataSet DealerPurchaseDetailReport(Hashtable obj, int start, int limit, out int totalCount);

        DataSet ExportDealerPurchaseDetailReport(Hashtable obj);

        //add houzhiyong
        DataSet DealerSalesStatistics(Hashtable obj, int start, int limit, out int totalCount);
    }
}
