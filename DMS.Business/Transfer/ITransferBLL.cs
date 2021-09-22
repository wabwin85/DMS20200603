using System;
using System.Data;
using System.Collections;
using DMS.Model;
using DMS.Model.Data;
using System.Collections.Generic;
namespace DMS.Business
{
    public interface ITransferBLL
    {
        DataSet QueryTransfer(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryTransferRent(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet SelectByFilterTransferExport(Hashtable table);
        
        DataSet QueryTransferLot(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryTransferLotHasFromToWarehouse(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryTransferLotHasFromToWarehouse(Hashtable table);
        DataSet QueryTransferForAudit(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryTransferRentConsignment(Hashtable table, int start, int limit, out int totalRowCount);

        Transfer GetObject(Guid id);
        void Insert(Transfer obj);
        void Update(Transfer obj);
        bool DeleteDraft(Guid id);
        DealerMaster GetDealerMasterByName(string name);
        DealerMaster GetDealerMasterById(Guid id);
        bool DeleteDetail(Guid id);
        bool SaveDraft(Transfer obj);
        bool Submit(Transfer obj, ReceiptType receiptType, out string err);
        bool DistributionSubmit(Transfer obj, ReceiptType receiptType, out string err);
        bool TransferSubmit(Transfer obj, out string err);
        bool BorrowSubmit(Transfer obj, ReceiptType receiptType, out string err);
        bool AddItemsByType(string type, Guid TransferId, Guid DealerFromId, Guid DealerToId, Guid ProductLineId, string[] LotIds, Guid? ToWarehouseId);
       
        bool SaveItem(Guid LotId, double TransferQty, string LotNumber);
        bool SaveTransferItem(Guid LotId, Guid? ToWarehouseID, double TransferQty, string LotNumber);
       
        bool DeleteItem(Guid LotId);
        bool Revoke(Guid id);
        bool IsTransferLineWarehouseEqualByTrnID(String TransferId);
        bool TransferAudit(Transfer obj,string type,string note);
        Decimal GetTransferLineProductNumByTrnId(Hashtable ht);

        IList<TransferInit> QueryTransferInitErrorData(int start, int limit, out int totalRowCount);

        DataSet SelectTransferLotByFilter(Guid headerId);
        DataSet SelectByFilterTransferForExport(Hashtable table);

        DataSet SelectLimitBUCount(Guid DMAID);
        DataSet SelectLimitReason(Guid DMAID);

        DataSet SelectWarehouse(Guid DMAID);
        DataSet SelectByFilterTransferFrozen(Hashtable table, int start, int limit, out int totalRowCount);

        bool IsTransferDealerTypeEqualByTrnID(Guid FromDMAID,Guid ToDMAID);
    }
}
