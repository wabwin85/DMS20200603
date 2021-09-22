using System;
using DMS.Model;
using System.Data;
using System.Collections;
using System.Collections.Generic;

namespace DMS.Business
{
    public interface IInventoryInitBLL
    {
        bool Import(DataTable dt, string fileName);
        bool Verify(out string IsValid);
        bool Verify2(out string IsValid);
        IList<InventoryInit> QueryErrorData();
        IList<InventoryInit> QueryErrorData(int start, int limit, out int totalRowCount);
        void Insert(InventoryInit data);
        void Delete(Guid id);
        void Update(InventoryInit data);
        IList<DealerInventoryInit> QueryDealerInventoryErrorData(int start, int limit, out int totalRowCount);
        void DeleteByUser();
        bool ImportDealerInv(DataTable dt, string fileName);
        bool VerifyDII(out string IsValid, int IsImport);
        void DeleteDII(Guid id);
        void UpdateDII(DealerInventoryInit init);
        IList<DealerInventoryData> QueryDID(Hashtable param, int start, int limit, out int totalCount);
        DealerInventoryData QueryRecord(Hashtable param);
    }
}
