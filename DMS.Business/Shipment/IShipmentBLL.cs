using System;
using DMS.Model;
using System.Data;
using System.Collections;
using System.Collections.Generic;

namespace DMS.Business
{
    public interface IShipmentBLL
    {
        DataSet QueryShipmentHeader(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryShipmentHeaderAudit(Hashtable table, int start, int limit, out int totalRowCount);
        void InsertShipmentHeader(ShipmentHeader obj);
        ShipmentHeader GetShipmentHeaderById(Guid id);
        bool DeleteDraft(Guid id);
        bool DeleteDetail(Guid id);
        DataSet QueryShipmentLot(Hashtable table, int start, int limit, out int totalRowCount);
        bool SaveDraft(ShipmentHeader obj);
        bool AddItems(Guid OrderId, Guid DealerId, Guid HospitalId, string[] LotIds);
        bool DeleteItem(Guid LotId);
        DataSet QueryShipmentLot(Hashtable table);

        DataSet QueryShipmentLotSum(Hashtable table);

        ShipmentLot GetShipmentLotById(Guid id);
        bool SaveItem(ShipmentLot lot, double price);
        string Submit(ShipmentHeader obj, string OperatType);
        bool Revoke(Guid OrderId,string orderStatus);
        ShipmentHeader GetShipmentHeaderByLotId(Guid id);
        double GetShipmentTotalAmount(Guid id);
        double GetShipmentTotalQty(Guid id);
        IList<ShipmentOperation> GetShipmentOperationByHeaderId(Guid id);
        void InsertShipmentOperation(ShipmentOperation obj);
        void UpdateShipmentOperation(ShipmentOperation obj);
        void UpdateMainDataInvoiceNo(ShipmentHeader obj);
        //bool Update(ShipmentHeader obj);
        DealerCommonSetting QueryGetDealerCommonSetting(Guid id);
        void InsertDealerCommonSetting(DealerCommonSetting obj);
        void UpdateDealerCommonSetting(DealerCommonSetting obj);
        DataSet QueryShipmentLotForPrint(Hashtable table);
        void InsertSalesInterface(ShipmentHeader obj);
        bool Import(DataTable dt, string fileName, string OperType);
        bool Verify(out string IsValid,int IsImport);
        void Delete(Guid id);
        void Update(ShipmentInit obj);
        IList<ShipmentInit> QueryErrorData(int start, int limit, out int totalRowCount);
        void DeleteByUser();
        ShipmentInit SelectShipmentCount();
        void InsertImportData(out string RtnVal, out string RtnMsg);
        ShipmentHeader GetShipmentHeaderByIdForPrinting(Guid id);
        int InitLPConsignmentInterfaceByClientID(string clientid, string batchNbr);
        IList<LpConsignmentSalesData> QueryLPConsignmentSalesInfoByBatchNbr(string batchNbr);
        bool AfterLpConsignmentSalesInfoDownload(string BatchNbr, string ClientID, string Success, out string RtnVal);
        bool GetSubmittedOrder(Guid nbr);
        void ConsignmentForOrder( ShipmentHeader obj,string ShipmentType, out string RtnVal, out string RtnMsg);
        void UpdateReportInventoryHistory();
        void DoConfirm();
        IDictionary<string, string> SelectShipmentOrderStatus();

        #region Added By Song Yuqi
        bool AddConsignmentItems(Guid OrderId, Guid DealerId, string[] LotIds);
        DataSet QueryShipmentConsignment(Hashtable table, int start, int limit, out int totalRowCount);
        ShipmentConsignment GetShipmentConsignmentById(Guid id);
        bool SaveConsignmentItem(ShipmentConsignment sc);

        double GetConsignmentShipmentTotalAmount(Guid id);
        double GetConsignmentShipmentTotalQty(Guid id);
        bool DeleteConsignmentItem(Guid LotId);
        bool DeleteConsignmentItemByHeaderId(Guid headId);
        bool IsAdminRole();
        bool SelectAdminRoleAction(Guid id);
        #endregion

        //经销商提交医院销售数据前数据校验 Add by Songweiming on 2015-08-27 
        //bool CheckSubmit(Guid sphId, string shipmentDate, Guid shipmentUser, out string rtnVal, out string rtnMsg);
        bool CheckSubmit(Guid sphId, string shipmentDate, Guid shipmentUser, Guid dealerId, Guid productLineId, Guid hospitalId, out string rtnVal, out string rtnMsg);
        //提交订单对二维码验证 add lijie 2016-02-01
        DataSet SelectShipmentLotByChecked(string Id);
        DataSet SelectShipmentdistictLotid(string Id);
        DataSet SelectShipmentLotQty(string lotId,string sphId);

        #region 销售调整 Added By Song Yuqi On 2016-03-29
        DataSet QueryShipmentLotByFilter(Hashtable table);
        DataSet QueryShipmentAdjustLotForShipmentBySphId(Guid sphId);
        DataSet QueryShipmentAdjustLotForInventoryBySphId(Guid sphId);
        void AddShipmentItems(Guid SphId, Guid DealerId, Guid HosId, string LotIdString, string AddType, out string rtnVal, out string rtnMsg);
        bool DeleteAdjustItem(Guid SalId, Guid SphId, Guid LotId);
        bool DeleteShipmentAdjustLotBySphId(Guid sphId);
        ShipmentAdjustLot GetShipmentAdjustLotById(Guid Id);
        bool SaveShipmentAdjust(ShipmentAdjustLot obj);
        void AddShipmentAdjustToShipmentLot(Guid SphId, Guid DealerId, Guid HosId, string ShipmentDate, string Reason,string OpsUser, out string rtnVal, out string rtnMsg);
        #endregion

        bool CheckNeedUploadAttachment(Guid DealerId, Guid ProductLineId);
        //获取退货及寄售销售单 、lijie add 10160826
        ShipmentlpConfirmHeader GetShipmentlpConfirmHeaderByOrderNo(string OrderNo);
        DataSet  GetShipmentlpConfirmHeaderInfoByOrderUpnLot(Hashtable ht, int start, int limit, out int totalRowCount);
        bool UpdateSCHConfirmDate(Hashtable ht);
        bool SaveAdjustItemPrice(Hashtable ht);
        //查询当前日期是否在第6个工作日之内
        int GetCalendarDateSix();
        DataSet SelectLimitNumber(Guid DealerId);
        DataSet SelectShipmentLimitBUCount(Guid DealerId);

        DataSet SelectShipmentLog(string sphId);
        //订单中更换医院只删除不符合医院授权的产品
        string DeleteShipmentNotAuthCfn(Hashtable obj);
        
        DataSet ExportShipmentByFilter(Hashtable table);

        DataSet ExportShipmentAttachment(Hashtable obi);

        DataSet ShipmentAttachmentDownload(string id);

        //关联发票号新增附件 Added By Song Yuqi On 2017-05-02
        int InsertAttachmentForShipmentUploadFile(string fileName, string fileUrl);

        IList<ShipmentInvoiceInit> QueryShipmentInvoiceInitErrorData(int start, int limit, out int totalRowCount);

        void DeleteShipmentInvoiceInitByUser();

        void InvoiceVerify(int IsImport, out string RtnVal, out string RtnMsg);

        bool InvoiceImport(DataTable dt, string fileName);

        //销售单导入功能优化 
        DataSet QueryShipmentInitList(Hashtable table);
        bool ShipmentInitCheck();
        //销售单导入结果
        DataSet QueryShipmentInitResult(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet ExportShipmentInitResult(Hashtable table);
        DataSet QueryShipmentInitProcessing(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryDealerAuthorizationList(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet GetShipmentInitSum(Hashtable table);


        DataSet GetHospitalShipmentbscBeforeSubmitInitByCondition(Hashtable table);

        DataSet GetHospitalShipmentSumBeforeSubmitInitByCondition(Hashtable table);

        int DeleteErrorShipmentLot(Hashtable obj);

        DataSet GetHospitalShipmentbscBeforeSubmitInitForExport(Hashtable table);


        DataSet GetShipmentInitNoConfirm(Hashtable table);
        int ConfirmShipmenInit(string stringNo);

        bool SaveUpdateLog(ShipmentLot lot);
    }
}
