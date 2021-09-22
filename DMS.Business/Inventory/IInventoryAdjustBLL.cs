using System;
using DMS.Model;
using System.Data;
using System.Collections;
using System.Collections.Generic;

namespace DMS.Business
{
    public interface IInventoryAdjustBLL
    {
        InventoryAdjustHeader GetInventoryAdjustById(Guid id);
        InventoryAdjustLot GetInventoryAdjustLotById(Guid id);
        DataSet QueryInventoryAdjustHeader(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryInventoryAdjustHeaderAudit(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryInventoryAdjustHeaderAudit(Hashtable table);
        void InsertInventoryAdjustHeader(InventoryAdjustHeader obj);
        void ConsignInsertInventoryAdjustHeader(InventoryAdjustHeader obj);
        DataSet QueryInventoryAdjustLot(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryInventoryAdjustLot(Hashtable table);
        bool SaveDraft(InventoryAdjustHeader obj);
        bool DeleteDraft(Guid id);
        bool DeleteDetail(Guid id);
        bool AddItems(string Type, Guid AdjustId, Guid DealerId, string WarehouseId, string[] LotIds, string ReturnApplyType);

        bool ConsignAddItems(string Type, Guid AdjustId, Guid DealerId, string WarehouseId, string[] LotIds,string [] Price, string ReturnApplyType);
        bool DeleteItem(Guid LotId);
        DataSet CheckLotNumber(Guid LotId, string LotNumber);
        bool SaveItem(InventoryAdjustLot lot);
        bool Submit(InventoryAdjustHeader obj);
        bool Revoke(Guid AdjustId);
        bool Approve(InventoryAdjustHeader obj);
        bool Reject(InventoryAdjustHeader obj);

        DataSet QueryInventoryAdjustHeaderConsignment(Hashtable table, int start, int limit, out int totalRowCount);

        int GetPendingAuditCount();

        DataSet QueryInventoryAdjustHeaderReturn(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryInventoryAdjustHeaderReturnAudit(Hashtable table, int start, int limit, out int totalRowCount);

        DataSet QueryInventoryReturnForExport(Hashtable param);
        DataSet QueryLPGoodsReturnApprove(string OrderID);

        IList<InventoryReturnInit> QueryInventoryReturnInitErrorData(int start, int limit, out int totalRowCount);
        bool VerifyInventoryReturnInit(string ImportType, out string IsValid);
        bool ImportInventoryReturnInit(DataSet ds, string fileName);
        void Update(InventoryReturnInit data);

        #region Added By Song Yuqi On 20140319
        bool AddConsignmentItemsInv(Guid AdjustId, Guid DealerId, string[] LtmIds);
        DataSet QueryInventoryAdjustConsignment(Hashtable table, int start, int limit, out int totalRowCount);
        InventoryAdjustConsignment GetInventoryAdjustConsignmentById(Guid id);
        bool SaveConsignmentItem(InventoryAdjustConsignment sc);
        bool DeleteConsignmentItem(Guid id);
        bool DeleteConsignmentItemByHeaderId(Guid headId);
        DataSet GetPurchaseOrderNbr(Hashtable table);
        #endregion

        IList<InventoryReturnConsignmentInit> QueryInventoryReturnConsignmentInitErrorData(int start, int limit, out int totalRowCount);

        DataSet QueryInventoryAdjustAuditForExport(Hashtable param);

        int IsOtherStockInAvailable(Guid UserId);

        DataSet QueryInventoryAdjustHeaderCTOS(Hashtable table, int start, int limit, out int totalRowCount);

        DataSet QueryInventoryAdjustLotCTOS(Hashtable table, int start, int limit, out int totalRowCount);

        IList<InventoryAdjustInit> QueryInventoryAdjustInitErrorData(int start, int limit, out int totalRowCount);

        DataSet GetReturnDealerListByFilter(Hashtable table);
        DataSet GetConsignmentOrderNbr(Hashtable obj);
        DataSet GetInventoryAdjustBorrowById(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet SelectByFilterInventoryAdjustLotTransfer(Hashtable table, int start, int limit, out int totalRowCount);

        bool QueryQrCodeIsExist(string QrCode);
        bool QueryQrCodeIsDouble(Guid adjustID, string QrCode, Guid lotID);
        //提交时对二维码进行判断 add lijie 20160201
        DataSet SelectInventoryAdjustLotChecked(string Id);
        //校验二维码在同一个经销商下的历史单据中数量是否大于一
        DataSet SelectInverntoryRutrnQrCode(string DealreId, Double Qty, string QrCode, string EditQrCode);
        //获取退货单下的产品数量
        DataSet SelectInverntorRuturSumQty(string HeadId);
        DataSet SelectInvernLotRuturnTransferQty(string HeaId);
        //lijie add 20160330
        DataSet SelectInventoryAdjustLotQrCode(string HeadId, string QrCode);
        DataSet SelectInventoryAdjustLot(string HeadId);
        //lijie add 20160411 根据单据Id和经销商查询二维码是否已经被使用过
        DataSet SelectInventoryAdjustLotQrCodeBYDmIdHeadId(string HeadId, string DmaId);
        //lijie add 2016-05-13 导入审批结果数据到临时表
        bool InventoryAdjustImport(DataTable dt, string fileName, out string batchNumber, out string ClientID, out string Messinge);
        DataSet QueryInterfaceDealerReturnConfirmBybatchNumber(string batchNumber, int start, int limit, out int totalRowCount);
        DataSet SelectExistsDMAParent(string batchNumber, string DmaId);

        DataSet SelectInventoryAdjustPrhIDBYHeadId(string HeaderID);
        //lijie add 2016-05-20 获取RSM
        DataSet SelectT_I_QV_SalesRepDealerByProductLine(Hashtable ht);
        DataSet SelectT_I_QV_SalesRepByProductLine(Hashtable ht);
        void InventoryAdjust_CheckSubmit(string IahId, string AdjustType, out string RtnRegMsg, out string IsValid);

        //Added By Song Yuqi On 2016-06-06
        string CheckProductAuth(Guid id, Guid dealerId, Guid productLineId);

        //判断产品是否有对应的订单号 lijie add 20169830
        DataSet ExistsPOReceiptHeaderIsUpn(Hashtable ht);
        DataSet ExistsConsignmentIsUpn(Hashtable ht);
        //直销医院退货单明细不能有多个仓库lijie add 20160907
        DataSet GetInventoryDtBYIahId(string IahId);
		//lijie add 2016-06-20
        DataSet SelectAdjustRenturn_Reason(Hashtable ht);
        DataSet SelectReturnProductQtyorPrice(string IahId);
        //lijie add 2016-07-15 根据退货原因判断产品是否填写正确
        DataSet SelectAdjustRenturnApplyTypebyHeadid(string iahId);
        DataSet GetProductLineByDmaId(string DmaId);
        InventoryAdjustHeader GetInventoryAdjustByIdPrint(Guid Id);
        bool PushReturnToERP(Guid AdjustID, out string errMsg);
        bool ReturnAutoCreateOrder(string AdjustID, out string msg);
    }
}
