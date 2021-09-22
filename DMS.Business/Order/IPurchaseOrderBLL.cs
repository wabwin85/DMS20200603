using System;
using DMS.Model;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using DMS.Model.Data;
namespace DMS.Business
{
    public interface IPurchaseOrderBLL
    {
        //订单表头
        PurchaseOrderHeader GetPurchaseOrderHeaderById(Guid id);
        void InsertPurchaseOrderHeader(PurchaseOrderHeader obj);
        DataSet QueryPurchaseOrderHeaderForDealer(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryPurchaseOrderHeaderForLPDealer(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet ExportPurchaseOrderLogForLPDealer(Hashtable table);
        DataSet ExportPurchaseOrderInvoiceForLPDealer(Hashtable table);
        DataSet ExportPurchaseOrderLogForLPDealerForAudit(Hashtable table);
        DataSet QueryPurchaseOrderHeaderForT2Dealer(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet ExportPurchaseOrderDetailForT2Dealer(Hashtable table);
        DataSet QueryPurchaseOrderHeaderForAudit(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryPurchaseOrderHeaderForMake(Hashtable table, int start, int limit, out int totalRowCount);
        //订单明细
        PurchaseOrderDetail GetPurchaseOrderDetailById(Guid id);
        void InsertPurchaseOrderDetail(PurchaseOrderDetail obj);
        DataSet QueryPurchaseOrderDetail(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryPurchaseOrderDetailByHeaderId(Guid id, int start, int limit, out int totalRowCount);
        DataSet QueryLPPurchaseOrderDetailByHeaderId(Guid id, String virtualDCCode, int start, int limit, out int totalRowCount);
        DataSet QueryLPPurchaseOrderDetailByHeaderId(Guid id, String virtualDCCode);
        int QueryLotNumberCount(Guid detailId, string lot);
        int QueryLotPriceCount(Guid DetailID, string UPN, string lot, string Price);
        //订单操作日志
        void InsertPurchaseOrderLog(Guid headerId, Guid userId, PurchaseOrderOperationType operType, string operNote);
        DataSet QueryPurchaseOrderLog(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryPurchaseOrderLogByHeaderId(Guid id, int start, int limit, out int totalRowCount);
        DataSet QueryInvoiceByHeaderId(Guid id, int start, int limit, out int totalRowCount);
        //经销商区域查询
        DataSet QueryTerritoryMaster(Guid dealerId, Guid productLineId);
        //经销商默认收货地址
        DealerMaster GetDealerMasterByDealer(Guid dealerId);
        //经销商订单相关信息
        DealerShipTo GetDealerShipToByUser(Guid userId);

        //订单操作
        bool PushToERP(PurchaseOrderHeader header, out string errMsg);
        bool SaveDraft(PurchaseOrderHeader header);
        bool DeleteDraft(Guid headerId);
        bool DiscardModify(Guid headerId);
        bool Submit(PurchaseOrderHeader header, String crossDockingNo);
        bool DeleteDetail(Guid dealerId);
        bool AddCfn(Guid headerId, Guid dealerId, string cfnString,string ordertype, out string rtnVal, out string rtnMsg);
        bool AddSpecialCfn(Guid headerId, Guid dealerId, string cfnString, string specialPriceId, string orderType, out string rtnVal, out string rtnMsg);
        bool AddCfnSet(Guid headerId, Guid dealerId, string cfnString, out string rtnVal, out string rtnMsg);
        bool UpdateCfn(PurchaseOrderDetail detail);
        bool DeleteCfn(Guid detailId);
        //bool CheckSubmit(Guid headerId, Guid dealerId, out string rtnVal, out string rtnMsg, out string rtnRegMsg, out string errorMsg);
        bool CheckSubmit(Guid headerId, Guid dealerId, out string rtnVal, out string rtnMsg, out string rtnRegMsg);
        bool CheckSubmit(Guid headerId, Guid dealerId, String promotionPolicyID, String priceType, String orderType, out string rtnVal, out string rtnMsg);
        bool CheckSubmitSpecial(Guid headerId, Guid dealerId, Guid specialPriceId, out string rtnVal, out string rtnMsg);
        bool Copy(Guid headerId, Guid dealerId, String priceType, out string rtnVal, out string rtnMsg);
        bool CopyForTemporary(Guid headerId, Guid instanceId, out string rtnVal, out string rtnMsg);
        bool Agree(Guid headerId);
        bool Reject(Guid headerId, string note);
        bool RevokeConfirm(Guid headerId, string note);
        bool CompleteOrder(Guid headerId, string note);
        bool RejectRevoke(Guid headerId, string note);
        bool RejectComplete(Guid headerId, string note);
        bool RevokeLPOrder(Guid headerId);
        bool CloseLPOrder(Guid headerId);
        bool RevokeT2Order(Guid headerId);
        bool Lock(string listString, out string rtnVal, out string rtnMsg);
        bool Unlock(string listString, out string rtnVal, out string rtnMsg);
        bool MakeManual(string listString, out string rtnVal, out string rtnMsg, out string batchNbr);
        DataSet SumPurchaseOrderByHeaderId(Guid headerId);
        //订单自动生成设定
        DealerOrderSetting QueryGetDealerOrderSetting(Guid dealerId);
        void UpdateDealerOrderSetting(DealerOrderSetting order);
        void InsertDealerOrderSetting(DealerOrderSetting order);
        //订单联系
        void UpdateDealerShipTo(DealerShipTo order);
        void InsertDealerShipTo(DealerShipTo order);
        //订单生成接口处理
        IList<PurchaseOrderInterface> GetPurchaseOrderInterfaceByBatchNbr(string batchNbr);
        //added by bozhenfei on 20130716 @根据客户端ID初始化接口表
        int InitPurchaseOrderInterfaceByClientID(string clientid, string batchNbr);
        int InitPurchaseOrderInterfaceForLpByClientID(string clientid, string batchNbr);
        int InitPurchaseOrderInterfaceForT2ByClientID(string clientid, string batchNbr);
        //added by bozhenfei on 20130716 @根据批处理号得到订单明细数据
        IList<SapOrderData> QueryPurchaseOrderDetailInfoByBatchNbr(string batchNbr);
        IList<LpOrderData> QueryPurchaseOrderDetailInfoByBatchNbrForLp(string batchNbr);
        IList<T2OrderData> QueryPurchaseOrderDetailInfoByBatchNbrForT2(string batchNbr);
        //added by bozhenfei on 20130717 @客户端下载完订单后更新数据
        bool AfterPurchaseOrderDetailInfoDownload(string BatchNbr, string ClientID, string Success, out string RtnVal);

        //发送短信与邮件
        void AddToMailMessageQueue(MailMessageTemplateCode code, PurchaseOrderHeader header, DealerShipTo info);
        void AddToShortMessageQueue(ShortMessageTemplateCode code, PurchaseOrderHeader header, DealerShipTo info);

        //查询订单SAP反馈记录 (huxiang 110419)
        DataSet GetConfirmationByFilter(Hashtable obj, int start, int limit, out int totalRowCount);

        //订单Excel导入
        IList<PurchaseOrderInit> QueryPurchaseOrderInitErrorData(int start, int limit, out int totalRowCount);
        bool VerifyPurchaseOrderInit(string ImportType, out string IsValid);
        bool ImportPurchaseOrderInit(DataSet ds, string fileName);
        void Update(PurchaseOrderInit data);

        //获取下单人员
        DataSet GetSubmintUserByUserID(Guid userId);

        //检查批号
        bool CheckLotNumberByUPN(string lot, string upn);

        //检查批号(带二维码)
        bool CheckLotNumberByUPNQRCode(string lot, string upn);

        //导出一级经销商订单明细
        DataSet ExportPurchaseOrderDetailForLPDealer(Hashtable table);
        //The Promotion Policy of T1 and LP
        DataSet QueryPromotionPolicy(Hashtable table, int start, int limit, out int totalRowCount);

        DataSet ExportPromotionPolicy(Hashtable param);

        void SaveItem(decimal qty,string remark,string id);

        DataSet QueryPromotionPolicyForT2(Hashtable table, int start, int limit, out int totalRowCount);

        DataSet ExportPromotionPolicyForT2(Hashtable param);

        void SaveItemForT2(decimal qty, string remark, string id);

        DataSet QueryPromotionPolicyT2(Hashtable param, int p, int p_3, out int totalCount);
        DataSet ExportPromotionPolicyT2(Hashtable param);

        DataSet SelectSalesByDealerAndProductLine(Hashtable table);

        //积分订单删除当前使用积分
        int DeleteOrderPointByOrderHeaderId(Guid id);
        
        //绑定可用积分
        void OrderPointCheck(Hashtable obj, out string rtnVal);
        //校验即时买赠订单的使用促销
        void PolicyFit(Guid prhid, string policyid, out string rtnVal, out string rtnMsg);
        //根据仓库获取收货地址 lijie add 20160810
        DataSet SelectSAPWarehouseAddressByWhmId(string WhmId);
        //获取产品是否可订购的信息 lijie add 20160824
        DataSet GetCfnIsorderByUpn(Hashtable ht);
        //根据订单号获取订单状态
        PurchaseOrderHeader GetOrderByOrderNo(string OrderNo);
        //根据订单号获取固定类型的订单状态
        PurchaseOrderHeader GetOrderByOrderNoManual(string OrderNo);
        //更改订单状态
        bool UpdateOrderByOrder(PurchaseOrderHeader Header);
        //修改订单要记日志
        void InsertOrderOperationLog(Hashtable ht);
        //二级经销商促销订单红票额度是否足够
        void RedInvoice_SumbitChecked(string PohId, string DealerId, string BuId,string PointType,string OrderType, out string RtnVal, out string RtnMsg);
        //预提额度 LIJIE ADD 20161012
        void RedInvoice_RedInvoicesCheck(string PohId, string DealerId, string PlineId, out string RtnVal, out string RtnMsg);
        DataSet SumPurchaseOrderByRedInvoicesHeaderId(string PohId);
        void DeleteOrderRedInvoicesByOrderHeaderId(string PohId);
        bool SelectDealerPaymentTypBYDmaId(string DmaId);
        string CheckDealerPermissions(Hashtable ht);

        void AddNoticeCfn(Guid headerId, string cfnString);
        DataSet PurchasingForecastReport(Hashtable obj, int start, int limit, out int totalCount);
        DataSet ExportPurchasingForecastReport(Hashtable obj);
        //获取订单币种
        string GetPurchaseOrderCarrierById(Hashtable obj);
        bool CheckBomOrderQty(Hashtable obj);
        int UpdateOrderWmsSendflg(Hashtable obj);
        DataSet GetPurchaseOrderWmsInfo();

    }
}
