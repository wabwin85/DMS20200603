using System;
using System.Collections.Generic;
using DMS.Model;
using System.Data;
using System.Collections;

namespace DMS.Business
{
    public interface IPOReceipt
    {
        IList<PoReceiptHeader> GetAll();
        PoReceiptHeader GetObject(Guid id);
        DataSet QueryPoReceipt(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryPoReceipt(Hashtable table);
        DataSet QueryPoReceiptLot(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryPoReceiptLot(Hashtable table);
        IList<PoReceiptHeader> SelectByFilter(PoReceiptHeader header);
        string SavePoReceipt(Guid id, Guid WhmId);

        bool CancelPoReceipt(Guid id);
        int GetPoReceiptCountByDealer(Guid DealerId);
        DataSet GetPoReceiptProductLine(Guid dealerId);

        bool Import(DataSet ds, string fileName);
        bool Verify(out string IsValid);
        DataSet GetErrorList(Guid UserId);
        int DeleteByUserID(Guid objKey);
        void Insert(WaybillInit obj);
        string Initialize(Guid UserId);
        PoReceiptHeader GetObjectAddWarehouse(Guid id);
        double GetReceiptTotalAmount(Guid id);
        double GetReceiptTotalQty(Guid id);
        //lijie add
        bool POReceImport(DataTable dt, string fileName, out string batchNumber, out string ClientID, out string Messinge);
        DataSet SelectInterfaceShipmentBYBatchNbr(string BatchNbr, int start, int limit, out int totalRowCount);
        DataSet DistinctInterfaceShipmentBYBatchNbr(string BatchNbr);
        DataSet SelectInterfaceShipmentBYBatchNbrQtyUnprice(string BatchNbr);
        DataSet QueryPoReceiptForExport(Hashtable param);
        DataSet SelectPoreCeExistsDma(string batchNumber, string DmaId);
        PoReceiptHeader GetPoReceiptHeaderByOrderNo(string OrderNo);
        bool UpdatePoReceipHeaderDate(PoReceiptHeader Header);
        bool DeletePOReceipt(string ProOrderNo);

        bool DeliveryNoteBSCSLC(string ProOrderNo);
        DataSet GetPOReceiptHeader_SAPNoQR(string ProOrderNo);
        bool UpdatePOReceiptHeader_SAPNoQR(string ProOrderNo);
        DataSet DNB_BatchNbr(string ProOrderNo);

    }

    public interface IPoReceiptHeaders
    {

    }

    public interface IPoReceipts
    {

    }

    public interface IPoReceiptLots
    {
    }

    public interface IArrivalDate
    {
        bool ImportArrivalDate(DataSet ds, string fileName);
        bool Verify(out string IsValid, string FileName);
        DataSet GetArrivalDateErrorList(Guid UserId, string FileName);
        void InsertArrivalDate(ArrivalDateInit obj);
        string InitializeArrivalDate(Guid UserId, string FileName);
    }

    public interface ISendInvoice
    {
        bool ImportSendInvoice(DataSet ds, string fileName);
        bool Verify(out string IsValid);
        DataSet GetSendInvoiceErrorList(Guid UserId);
        void InsertSendInvoice(SendInvoiceInit obj);
    }

}
