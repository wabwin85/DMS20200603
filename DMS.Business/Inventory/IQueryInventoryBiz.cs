using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using DMS.Model;
using System.Data;

    public interface IQueryInventoryBiz
    {
        IList<QueryInventory> GetInventoryListForDealer(Guid DealerId);
        IList<QueryInventory> GetInventoryList(Hashtable ht);
        IList<QueryInventory> GetInventoryList(Hashtable ht, int start, int limit, out int totalRowCount);
        DataSet SelectInventoryByDealerForExpired(Hashtable ht);

        DataSet GetInventoryDataSet(Hashtable ht);
        DataSet SelectInventoryLotForQABSCComplainsDataSet(Hashtable ht);
        DataSet SelectInventoryUPNForQABSCComplainsDataSet(Hashtable ht);
        DataSet SelectInventoryLotForQACRMComplainsDataSet(Hashtable ht);
        DataSet SelectInventoryUPNForQACRMComplainsDataSet(Hashtable ht);

        DataSet ExportLPInventoryABCDataSet(Hashtable ht);
        DataSet SelectNearEffectInventoryDataSet(Hashtable ht);
    }
}
