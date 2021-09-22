/**********************************************
 *
 * NameSpace   : DMS.Model.Data
 * ClassName   : AuthorizationType
 * Created Time: 2009-7 
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.Data
{
    /// <summary>
    /// AuthorizationType, 存储 DealerAuthorizationTable.AuthorizationType
    /// </summary>
    public enum AuthorizationType
    {
        /// <summary>
        /// 按产品线
        /// </summary>
        ProductLine = 0,

        /// <summary>
        /// 按类别

        /// </summary>
        Clasification,

        /// <summary>
        ///  按产品  
        /// </summary>
        Product
    }

    public enum DealerTransferStatus
    {
        Draft,
        OntheWay,
        Complete,
        Cancelled,
        Submitted, //待审批
        Deny
    }

    public enum ReceiptType
    {
        Rent,   //借货入库
        PurchaseOrder,  //销售入库
        TransferDistribution,  //分销入库
        Retail,  //added by Song Yuqi on 20130524
        Complain //投诉换货退货added by huyong on 20160407
    }

    public enum TransferType
    {
        Rent,       //借货出库
        Transfer,    //移库
        TransferConsignment, //寄售移库
        RentConsignment, //寄售借货（调拨）
        TransferDistribution  //分销出库
    }

    public enum ReceiptStatus
    {
        Hold,
        Waiting,
        Complete,
        Cancelled,
        //added by bozhenfei on 20110212
        WaitingForDelivery
    }

    public enum AdjustStatus
    {
        Cancelled,
        Reject,
        Draft,
        Submitted,
        Accept,
        Submit,
        Complete,
        RsmApproval
    }

    public enum AdjustType
    {
        Return,//退货
        StockOut,//其他出库
        StockIn,//其他入库
        Exchange, //换货
        CTOS, //寄售转销售
        Transfer //转移给其他经销商
    }

    public enum AdjustWarehouseType
    {
        Normal,//普通库
        Consignment,//寄售库
        Borrow //借货库
    }

    public enum ShipmentOrderStatus
    {
        Draft,//草稿
        Reversed,//已冲红
        Complete,//已完成
        Submitted,//待审批
        Cancelled//已取消
    }

    /// <summary>
    /// 销售单类型
    /// </summary>
    public enum ShipmentOrderType
    {
        Hospital,//销售到医院
        Retail,//分销到二级经销商
        Consignment,//寄售产品销售到医院
        Borrow//借货产品销售到医院
    }


    /// <summary>
    /// CFN价格类型
    /// </summary>
    public enum CfnPriceType
    {
        Base,
        Group,
        Dealer
    }

    //added by bozhenfei on 20100528
    public enum BulletinStatus
    {
        Draft,
        Published,
        Cancelled
    }

    //added by songweiming on 20100604
    public enum StocktakingStatus
    {
        NotAdjust,
        Cancelled,
        Adjusted
    }

    public enum DealerQAStatus
    {
        Draft,
        Submitted,
        Replied
    }

    //added by bozhenfei on 20110212
    /// <summary>
    /// 采购订单状态
    /// </summary>
    public enum PurchaseOrderStatus
    {
        Draft,
        Submitted,
        Approved,
        Rejected,
        Uploaded,
        Confirmed,
        Delivering,
        Completed,
        Revoked,
        Revoking,
        ApplyComplete
    }

    /// <summary>
    /// 采购单创建类型
    /// </summary>
    public enum PurchaseOrderCreateType
    {
        Manual,
        System,
        Temporary
    }
    /// <summary>
    /// 采购订单操作类型
    /// </summary>
    public enum PurchaseOrderOperationType
    {
        Submit,
        Approve,
        Reject,
        Lock,
        Unlock,
        ManualMake,
        AutoMake,
        Confirm,//确认
        Generate,
        ExcelImport,
        Download,
        WriteOff,     //冲红
        Cancel,//取消
        Revoked,  //撤销订单
        Revoking,  //申请撤销订单
        Complete,  //关闭订单
        Receipt,  //确认收货
        Delivery,  //发货
        ApplyComplete,  //申请关闭
        RejectRevoke, //拒绝撤销
        RejectComplete, //拒绝关闭
        CreateShipment  //二维码扫描上报标志位
    }
    /// <summary>
    /// 短期寄售订单操作类型
    /// </summary>
    public enum ConsignmentOrderType
    {
        Draft,
        Submitted,
        Rejected,
        Approved,
        Revoked
    }
    public enum ConsignmentDelayStatus
    {
        Submitted,
        Rejected,
        Approved
    }
    public enum ConsignmentMasterType
    {
        Submitted,
        Revoked,
        Draft
    }
    /// <summary>
    /// 采购订单接口生成状态
    /// </summary>
    public enum PurchaseOrderMakeStatus
    {
        Pending,
        Processing,
        Success,
        Failure
    }
    /// <summary>
    /// 采购订单接口生成类型
    /// </summary>
    public enum PurchaseOrderMakeType
    {
        Manual,
        System
    }
    /// <summary>
    /// 经销商付款通知状态
    /// </summary>
    public enum DealerPaymentStatus
    {
        Draft,
        Submitted
    }

    /// <summary>
    /// 邮件发送状态
    /// </summary>
    public enum MailMessageQueueStatus
    {
        Waiting,
        Success,
        Failure
    }

    /// <summary>
    /// 短信发送状态
    /// </summary>
    public enum ShortMessageQueueStatus
    {
        Waiting,
        Success,
        Failure
    }

    /// <summary>
    /// 邮件处理状态
    /// </summary>
    public enum MailMessageProcessStatus
    {
        Waiting,
        Success,
        Failure
    }

    /// <summary>
    /// 短信处理状态
    /// </summary>
    public enum ShortMessageProcessStatus
    {
        Waiting,
        Success,
        Failure
    }

    /// <summary>
    /// 邮件发送代码
    /// </summary>
    public enum MailMessageTemplateCode
    {
        EMAIL_ORDER_REJECTED,
        EMAIL_ORDER_UPLOADED,
        EMAIL_ORDER_CONFIRMED,
        EMAIL_ORDER_COMPLETED,
        EMAIL_RECEIVE,
        EMAIL_SEND_INVOICE,
        EMAIL_ACCOUNT_STATEMENT,
        EMAIL_EXPIRATION_REMIND,
        EMAIL_ORDER_SUBMIT,
        EMAIL_ORDER_REVOKE,
        EMAIL_ORDER_CONFIRM,
        EMAIL_ORDER_CLOSE,
        EMAIL_ORDER_REVOKECONFIRM,
        EMAIL_INVENTORY_TRANSFER,
        EMAIL_INVENTORY_RETURN,
        EMAIL_ORDER_AUTOGENERATE,
        //Added By Song Yuqi On 2013-9-3
        EMAIL_DEALER_COMPLAINT,
        EMAIL_ORDER_REJECTREVOKE,
        EMAIL_ORDER_REJECTCOMPLETE,
        EMAIL_ORDER_APPLYCOMPLETE,

        //Add by Hua Kaichun on 2014-4-2
        EMAIL_CONTRACT_IAFUPDATE_TODEALER,
        EMAIL_CONTRACT_IAFSUBMINT_TOCO,
        EMAIL_CONTRACT_SupplementaryLetter_Quota,

        //Add By Song Weiming on 2015-09-26
        EMAIL_DEALER_CFDALICENSE_MODIFICATION,
        //Add By Song Yuqi On 2015-12-21
        EMAIL_DEALER_COMSIGNMENTAPPLY_SUBMIT,
        EMAIL_DEALER_COMSIGNMENTAPPLY_DELAY,

        //added by bozhenfei on 2016-9-27
        EMAIL_SAMPLE_NOTIFY_DP,
        EMAIL_SAMPLE_NOTIFY_IE,
        EMAIL_SAMPLE_NOTIFY_SS_PO,
        EMAIL_SAMPLE_NOTIFY_SS_SAP,

        //added by huyong on 2016-11-05
        EMAIL_SHIPMENT_FINANCE_APPROVE,

        EMAIL_QACOMPLAIN_SUBMITAPPLY,
        /// <summary>
        /// Added By SongYuqi On 2018-12-05
        /// </summary>
        EMAIL_ESIGN_BSCSIGN_ALERT
    }

    /// <summary>
    /// 短信发送代码
    /// </summary>
    public enum ShortMessageTemplateCode
    {
        SMS_ORDER_REJECTED,
        SMS_ORDER_UPLOADED,
        SMS_ORDER_CONFIRMED,
        SMS_ORDER_COMPLETED,
        SMS_RECEIVE,
        SMS_SEND_INVOICE,
        SMS_ORDER_SUBMIT,
        SMS_ORDER_REVOKE
    }

    /// <summary>
    /// 库存上报类型
    /// </summary>
    public enum InventoryQrType
    {
        /// <summary>
        /// 销售
        /// </summary>
        Shipment,
        /// <summary>
        /// 移库
        /// </summary>
        Transfer,
        /// <summary>
        /// 退货
        /// </summary>
        Return
    }

    /// <summary>
    /// 库存上报状态
    /// </summary>
    public enum InventoryQrStatus
    {
        /// <summary>
        /// 新增
        /// </summary>
        New,
        /// <summary>
        /// 删除
        /// </summary>
        Delete
    }

    /// <summary>
    /// 授权类型
    /// </summary>
    public enum DealerAuthorizationType
    {
        /// <summary>
        /// 正式授权
        /// </summary>
        Normal,
        /// <summary>
        /// 临时授权
        /// </summary>
        Temp,
        /// <summary>
        /// 订单特殊授权
        /// </summary>
        Order,
        /// <summary>
        /// 销售特殊授权
        /// </summary>
        Shipment,
        /// <summary>
        /// 退换货特殊授权
        /// </summary>
        Return,
        /// <summary>
        /// 借货特殊授权
        /// </summary>
        Transfer
    }

    #region BSC
    /// <summary>
    /// 经销商类型
    /// </summary>
    public enum DealerType
    {
        LP,//物流平台
        T1,//一级经销商
        T2,//二级经销商
        HQ, //表示公司总部，即波科
        LS //表示两票制的配送商
    }

    /// <summary>
    /// 物权类型
    /// </summary>
    public enum PropertyRightsType
    {
        波科内部使用,
        T2物权,
        平台物权,
        T1物权,
        医院物权,
        波科物权
    }

    public enum PurchaseOrderType
    {
        Normal,
        SpecialPrice,
        Consignment,
        ConsignmentSales,
        ConsignmentWriteOff,
        ConsignmentReturn,
        Borrow,
        Transfer,
        ClearBorrow,
        EEGoodsReturn,
        PEGoodsReturn,
        ClearBorrowManual,
        Exchange,
        BOM,  //组套设备订单
        SCPO, //短期寄售订单
        PRO,  //促销订单
        CRPO,  //积分订单
        SampleApply,
        ZTKB,
        ZTKA,
        Return, //退货订单
        ZRB
    }

    public enum WarehouseType
    {
        DefaultWH,
        SystemHold,
        Normal,
        LP_Consignment,
        LP_Borrow,
        Consignment,
        Borrow,
        Frozen
    }
    /// <summary>
    /// 已过期，有效期1个月内，有效期1至3个月，有效期3至6个月，有效期6个月以上
    /// </summary>
    public enum ExpiryDateType
    {
        Expired,
        Valid1,
        Valid2,
        Valid3,
        Valid4
    }

    //Added By Song Yuqi On 2013-9-2 Begin
    public enum DealerQAType
    {
        /// <summary>
        /// 系统使用
        /// </summary>
        A,
        /// <summary>
        /// 业务咨询
        /// </summary>
        B,
        /// <summary>
        /// 没有QA类型
        /// </summary>
        NONE
    }

    public enum DealerQACategory
    {
        /// <summary>
        /// 经销商问答
        /// </summary>
        QA = 1,
        /// <summary>
        /// 经销商投诉
        /// </summary>
        Complaint = 2
    }

    public enum DealerComplaintType
    {
        /// <summary>
        /// 发货不及时
        /// </summary>
        A,
        /// <summary>
        /// 货物有损坏
        /// </summary>
        B,
        /// <summary>
        /// 其他
        /// </summary>
        C
    }

    public enum DealerComplaintStatus
    {
        /// <summary>
        /// 草稿
        /// </summary>
        Draft,
        /// <summary>
        /// 已提交
        /// </summary>
        Submitted,
        /// <summary>
        /// 已回复
        /// </summary>
        Replied
    }

    public enum AttachmentType
    {
        /// <summary>
        /// 经销商公告和通知
        /// </summary>
        Bulletin,
        /// <summary>
        /// 经销商政策
        /// </summary>
        Issues,
        /// <summary>
        /// 经销商合同(经销商)
        /// </summary>
        ContractForDealer,
        /// <summary>
        /// 经销商合同(Bsc)
        /// </summary>
        ContractForBsc,
        /// <summary>
        /// 产品说明
        /// </summary>
        ProductDescription,
        /// <summary>
        /// 产品使用手册
        /// </summary>
        ProductManual,
        /// <summary>
        /// 经销商上报医院销量
        /// </summary>
        ShipmentToHospital,
        /// <summary>
        /// 经销商CFDA证照信息
        /// </summary>
        DealerLicense,
        /// <summary>
        /// 医院第三方披露信息
        /// </summary>
        HospitalThirdPart,
        /// <summary>
        /// 二维码收集页面库存上报
        /// </summary>
        Dealer_Shipment_Qr,
        /// <summary>
        /// 经销商授权
        /// </summary>
        DealerAuthorization,
        /// <summary>
        /// 退货申请
        /// </summary>
        ReturnAdjust,
        /// <summary>
        /// 经销商投诉退换货CRM-投述单
        /// </summary>
        DealerComplainCRM,
        /// <summary>
        /// 经销商投诉退换货CRM-退货单
        /// </summary>
        DealerComplainCRMRtn,
        /// <summary>
        /// 经销商投诉退换货CNF-投述单
        /// </summary>
        DealerComplainCNF,
        /// <summary>
        /// 经销商投诉退换货CNF-退货单
        /// </summary>
        DealerComplainCNFRtn,
        /// <summary>
        /// 管理员修改经销商合同
        /// </summary>
        UpdateContractAdmin,
        /// <summary>
        /// 发货二维码错误修改
        /// </summary>
        ConsignmentDelete,
        /// <summary>
        /// 经销商DD信息
        /// </summary>
        DealerMasterDD
    }
    //Added By Song Yuqi On 2013-9-2 End

    //Added By Hu yong On 2014-9-21
    public enum ScoreCardStatus
    {
        /// <summary>
        /// 未提交
        /// </summary>
        Submit,
        /// <summary>
        /// 波科已提交，待审批
        /// </summary>
        Submitted,
        /// <summary>
        /// 波科已审批，待确认
        /// </summary>
        Confirming,
        /// <summary>
        /// 已完成
        /// </summary>
        Completed
    }

    //Added By SongWeiming On 2015-9-14 For GSP Project
    /// <summary>
    /// 产品分类级别
    /// </summary>
    public enum LicenseCatagoryLevel
    {
        一类,
        二类,
        三类
    }

    /// <summary>
    /// 产品分类级别
    /// </summary>
    public enum DealerLicenseUpdateStatus
    {
        审批通过,
        审批拒绝,
        待QA审批

    }

    public enum NearEffectiveRule
    {
        ThreeMonth,//近效期3个月
        SixMonth, //近效期3~6个月
        UnEffective //非近效期
    }

    public enum ConsignmentType
    {
        Draft,//草稿
        Cancel, //取消
        Submit //发布
    }

    public enum ShipmentInitStatus
    {
        Submitted,//队列处理中
        PartCompleted,//部分导入成功
        Completed,//导入成功
        Error //导入失败
    }
    #endregion

    #region DCMS
    public enum PageOperationType
    {
        INSERT,
        EDIT
    }

    public enum ContractStatus
    {
        Reject,
        WaitLPConfirm,
        LPConfirm,
        NCMApproved,
        COApproved,
        COSubmitPDF,
        Completed,
        COConfirm
    }

    public enum ContractType
    {
        Appointment,
        Amendment,
        Renewal,
        Termination
    }

    public enum ContractMastreStatus
    {
        Draft,
        Submit
    }

    public enum ContractAttachmentType
    {
        /// <summary>
        /// Appointment System Create
        /// </summary>
        ApSystemCreate,
        /// <summary>
        /// Amendment System Create
        /// </summary>
        AdSystemCreate,
        /// <summary>
        /// Renewal System Create
        /// </summary>
        ReSystemCreate,
        /// <summary>
        /// Termination System Create
        /// </summary>
        TeSystemCreate
    }

    public enum DivisionName
    {
        Cardio,
        CRM,
        Endo,
        EP,
        PI,
        Uro,
        AS,
        SH
    }

    public enum ContractDealerType
    {
        Distributor,
        Dealer,
        Agent
    }

    public enum BSCEntity
    {
        China,
        Hong_Kong,
        International
    }

    public enum Exclusiveness
    {
        Exclusive,
        Non_Exclusive
    }

    public enum TerminationStatus
    {
        Non_Renewal,
        Termination
    }

    public enum TermaiationReason
    {

    }
    #endregion
}
