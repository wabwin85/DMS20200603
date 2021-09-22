using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common
{
    /// <summary>
    /// 查询类型,动态构造对话框查询类型
    /// </summary>
    public enum ExistsState
    {
        /// <summary>
        /// 
        /// </summary>
        All = 0,
        /// <summary>
        /// 
        /// </summary>
        IsExists,
        /// <summary>
        /// /// 
        /// </summary>
        IsNotExists
    }



    /// <summary>
    /// 选择器类型，动态构造选择对话框

    /// </summary>
    public enum SelectorType
    {
        /// <summary>
        /// 单选

        /// </summary>
        SingleSelect = 0,
        /// <summary>
        /// 
        /// </summary>
        RowSelect,
        /// <summary>
        /// 
        /// </summary>
        CheckboxSelection
    }


    public enum SelectTerritoryType
    {
        Default = 0,
        District,
        City,
        Province
    }

    /// <summary>
    /// 系统中所有业务单据的种类。同AutoNumber.ATO_Setting同步。

    /// </summary>
    public enum OrderType
    {
        Next_POReceiptNbr,
        Next_TransferNbr,
        Next_RentNbr,
        Next_ShipmentNbr,
        Next_AdjustNbr,
        Next_PurchaseOrder,
        Next_StocktakingNbr,//added by bozhenfei on 20100609 @增加盘点单号规则
        Next_PaymentNbr, //added by bozhenfei on 20110223 @经销商付款单
        Next_OrderMakeNbr,//added by bozhenfei on 20110224 @订单生成接口
        Next_MaintainanceNbr,//added by bozhenfei on 20110228 @维修订单
        Next_ComplainNbr,    //added by songweiming on 2014-3-11 @经销商投诉
        Next_ConsignToSellNbr,
        Next_ConsignmentApplyNbr
    }

    public enum CodeAutoNumberSetting
    {
        Next_WarehouseNbr,
        Next_HospitalNbr
    }

    public enum DataInterfaceType
    {
        ERPOrderStatusUploader,
        SapDeliveryUploader,
        LpOrderDownloader,
        SapDeliveryDownloader,
        SapOrderDownloader,
        T2OrderDownloader,
        LpDeliveryUploader,
        SapDeliveryConfirmationUploader,
        LpReturnConfirmationUploader,
        LpSalesUploader,
        LpConsignmentUploader,
        LpBorrowUploader,
        LpAdjustUploader,
        T2WarehouseInfoUploader,
        T2OrderConfirmationUploader,
        DealerSalesWritebackUploader,
        DealerReturnConfirmUploader,
        DealerConsignmentSalesPriceUploader,

        LpReturnDownloader,
        HospitalInfoDownloader,
        DealerInfoDownloader,
        T2ReturnDownloader,
        T2ConsignmentSalesDownloader,
        ProductDownloader,
        BSCInvoiceDownloader,
        LpComplainDownloader,
        T2ConsignToSellingDownloader,

        //增加畅联波科发货数据接口，Add By SongWeiming on 2015-12-07
        BSCDeliveryUploader,

        //增加二维码平台上传二维码主数据接口，Add By SongWeiming on 2015-12-10
        QRCodeMasterUploader,

        //增加二维码业务数据上传接口，Add By SongWeiming on 2015-12-10
        DealerTransactionUploader,

        //增加平台借货出库数据下载，Add By SongWeiming on 2015-12-10
        LPRentDownloader,

        //经销商库存信息接口 Add By Hu yong on 2016-07-07
        DealerInventoryDownloader,
        //渠道物流信息查询接口
        ChannelLogisticInfoWithQRDownloader,
        //医院收货、使用、退货数据接口
        HospitalTransactionWithQRUploader,
        //经销商调整积分（购买积分）上传
        T2OutLinePointsUploader,
        //DMS计算生成积分信息下载数据
        T2PointsDownloader,
        //经销商红票额度信息上传
        T2RedInvoiceUploader,

        //样品申请
        SampleApplyUploader,
        //样品退货
        SampleReturnUploader,
        //样品评估
        SampleEvalUploader,
        //样品收货
        SampleReceiveUploader,

        //平台发货数据下载接口(佑成)
        LPDeliveryForT2Downloader,
        //经销商收货确认接口(佑成)
        T2DeliveryConfirmUploader,
        //移库数据上传接口(佑成)
        InventoryTransferForT2Uploader,
        //经销商医院销量上报接口(佑成)
        HospitalSalesForT2Uploader,

        //经销商库存信息接口(红会接口) Add By Song Weiming on 2017-03-09
        DealerInventoryWithQRForRedCrossDownloader,
        //红会医院收货、使用、退货数据接口 Add By Song Weiming on 2017-03-09
        RedCrossHospitalTransactionWithQRUploader,

        //样品申请关闭
        SampleCloseApplyUploader,

        //301医院渠道物流信息查询接口
        ChannelLogisticInfoWithQR301Downloader,

        //二级经销商商业指标数据接口
        T2CommercialIndexDownloader,

        //二级经销商联系人信息上传接口
        T2ContactInfoUploader,

        //二级经销商授权数据接口
        T2AuthorizationDownloader,

        //LS上传移库信息接口
        LpTransferUploader
    }

    public enum DataInterfaceLogStatus
    {
        Processing,
        Success,
        Failure
    }
    /// <summary>
    /// 系统中部门的层级类型。同表Lafite_ATTRIBUTE.ATTRIBUTE_TYPE同步。

    /// </summary>
    public enum BusinessUnitType
    {
        Root,
        BU,
        Operation,
        Product_Line,
        Region,
        District,
        TSR,
        Role
    }


    /// <summary>
    /// 系统用户类型
    /// </summary>
    public enum IdentityType
    {
        /// <summary>
        /// User
        /// </summary>
        User,
        /// <summary>
        /// Dealer
        /// </summary>
        Dealer
    }

    public enum WaitProcess
    {
        /// <summary>
        /// 待收货
        /// </summary>
        POReceiptHeader,
        /// <summary>
        /// 投诉回复
        /// </summary>
        DealerComplaint,
        /// <summary>
        /// 需要上传库存数据
        /// </summary>
        UploadInventory,
        /// <summary>
        /// 需要填写销售数据
        /// </summary>
        UploadLog,
        /// <summary>
        /// 需要填写销售数据
        /// </summary>
        ShipmentHeader,
        /// <summary>
        /// 本月已采购数量（订单：数量、金额）
        /// </summary>
        OrderQT,
        /// <summary>
        /// 本月累计销售（销售单：数量、金额）
        /// </summary>
        ShipmentQT,
        /// <summary>
        /// 本月累计冲红（冲红销售单：数量、金额）
        /// </summary>
        ShipmentReversedQT,
        /// <summary>
        /// 本月累计IC产品线发票金额（有发票销售单：金额）
        /// </summary>
        ShipmentICQT,
        /// <summary>
        /// 本月累计借货出库（借货出库单：数量）
        /// </summary>
        TransferQT,
        /// <summary>
        /// 本月累计退货（审批通过的退货单：数量）
        /// </summary>
        InventoryAdjustQT,
        /// <summary>
        /// 经销商普通库库存（包括缺省仓库）
        /// </summary>
        NormalInventory,
        /// <summary>
        /// 经销商寄售库库存数
        /// </summary>
        ConsignmentInventory,
        /// <summary>
        /// 经销商借货库库存数
        /// </summary>
        BorrowInventory,
        /// <summary>
        /// 经销商在途库库存数
        /// </summary>
        SystemHoldInventory,
        /// <summary>
        /// 经销商是否具备订单管理的权限
        /// </summary>
        HasOrderStrategy,

        DealerQA,
        /// <summary>
        /// T2销售预测
        /// </summary>
        UploadSalesForecast,
        /// <summary>
        /// 超过九十天未上传发票
        /// </summary>
        UploadInvoice

    }

    public enum CommandoTrainStatus
    {
        Draft,
        Active,
        Delete
    }

    public enum CommandoTrainType
    {
        Online,
        Class,
        Practice
    }

    public enum CommandoTrainOnlineType
    {
        Self,
        Exam
    }

    public enum CommandoTrainOnlineSelfStatus
    {
        NotLearn,
        Learned
    }

    public enum CommandoTrainOnlineExamStatus
    {
        NotExam,
        NotPass,
        Passed
    }

    public enum CommandoTrainClassStatus
    {
        Wait,
        Signed,
        NotPass,
        Passed
    }

    public enum CommandoSignStatus
    {
        Draft,
        Active,
        Delete
    }

    public enum SalesTrainStatus
    {
        Unfinish,
        Finish
    }

    public enum SampleManageStatus
    {
        New,//新申请
        InApproval,//审批中
        Approved,//审批通过
        Delivery,//已发货
        Receive,//收货确认
        Deny//审批拒绝
    }

    public enum SampleDeliveryStatus
    {
        Waiting,//已发货
        Complete,//收货
        DP,//DP发货
        IE,//IE清关
        CS,//CS发货
        RA//RA确认
    }
    #region 电子合同版本状态
    public enum ContractESignStatus
    {
        Draft, //草稿
        //InApprova,//签章中
        Submitted,//待签章
        Complete,//签章完成
        Cancelled,//撤销签章
        WaitBscSign,//待波科签章
        WaitDealerSign,//待经销商签章
        BscAbandonment,//波科已作废
        WaitDealerAbandonment,//待经销商作废
        Abandonment, //已废弃
        WaitLPSign//待平台签章
    }
    #endregion

}
