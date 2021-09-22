using System;
using DMS.Model;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using DMS.Model.Data;
namespace DMS.Business
{
    public interface IDealerPriceBLL
    {
        //订单Excel导入
        DataSet QueryDealerPriceInitErrorData(int start, int limit, out int totalRowCount);
        bool VerifyDealerPriceInit(string ImportType, string remark, out string IsValid);
        //bool ImportPurchaseOrderInit(DataSet ds, string fileName);
        void Update(Hashtable data);
        DataSet QueryDealerPriceHead(Hashtable param, int start, int limit, out int totalRowCount);
        DataSet QueryDealerPriceDetail(String HId, int start, int limit, out int totalRowCount);
    }
}
