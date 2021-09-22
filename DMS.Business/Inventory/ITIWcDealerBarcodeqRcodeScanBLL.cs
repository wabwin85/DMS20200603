using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using DMS.Model;
namespace DMS.Business
{
    public interface ITIWcDealerBarcodeqRcodeScanBLL
    {
        DataSet QueryTIWcDealerBarcodeqRcodeScanByFilter(Hashtable table);
        DataSet QueryTIWcDealerBarcodeqRcodeScanByFilter(Hashtable table, int start, int limit, out int totalRowCount);

        DataSet QueryInventoryqrOperationByFilter(Hashtable table);
        bool AddItem(Guid userId, Guid dealerId, string lotString, string operationType, out string rtnVal, out string rtnMsg);
        bool DeleteItem(Guid Id);
        bool DeleteItems(string[] param);

        bool DeleteOperationItem(string Id);
        bool DeleteOperationItem(string dealerId, string operatinType);
        bool UpdateOperationItemForShipment(Guid Id, decimal qty, decimal? price);
        bool SubmitShipment(Guid dealerId, Guid productLineId, Guid hospitalId, DateTime shipmentDate, string headXmlString, out string rtnVal, out string rtnMsg);

        bool UpdateOperationItemForTransfer(Guid Id, decimal qty, Guid? toWarehouseId);
        bool UpdateInventoryqrOfToWarahouseIdByFilter(Hashtable table);
        bool SubmitTransfer(Guid dealerId, Guid productLineId, string transferType, out string rtnVal, out string rtnMsg);

        //lijie add 2016318
        TIWcDealerBarcodeqRcodeScan GetObject(Guid Id);
        DataSet QueryTIWcDealerBarcodeqRcodeScanByUpnCode(Hashtable table);
        DataSet SelectCfnBUby(string Upn);
        DataSet QueryTIWShipmentCfnBY(Hashtable table, int start, int limit, out int totalRowCount);
        void QrCodeConvert_CheckSumbit(Guid DealerId, string NewQrCode, string LotString, string LotNumber, string Upn,string QrCode,string User,string ShipHeadId,string PamaId,string WhmId, out string rtnVal, out string rtnMsg);
        DataSet SelectStockCfnBYUpnQrCodeLot(Hashtable table);
        void StockQrCodeConvertCheckedSumbit(Guid DealerId, string StockInQrCode, string LotNumber, string Upn, string UserId, string WhmId, out string RtnVal, out string RtnMsg);
        bool StockSumbit(Guid DealerId, string LotNumber, string StockInQrCdoe, string StoCkOutQrCode, string WhmId, string Upn, string ProductLineBumId);
        void UpdateDealerBarcodeRemarkByDmaIdUpnLot(string DmaId, string QrCode, string Upn, string Lot, string Remark);
        void GetCfnPriceHistorybyUpnLotDmaid(string DealerId, string HospId, out string RtnVal, out string RtnMsg);
        //add hou zhi yong
        DataSet selectremark(string DealerId);

    }
}
