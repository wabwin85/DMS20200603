using System;
using DMS.Model;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using DMS.Model.Data;

namespace DMS.Business
{
    public interface ICfnPriceService
    {
        DataSet QueryDealerPrice(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryDealerPrice2(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet ExportDealerPrice(Hashtable table);
        DataSet ExportDealerPriceQuery(Hashtable table);
        DataSet QueryErrorData(int start, int limit, out int totalCount);
        bool Import(DataTable dt);
        int DeleteDealerPriceByUser();
        int DeleteCFNPrice(CfnPrice cfnp);
        bool VerifyDealerPriceInit(string importType, out string IsValid);
    }
}
