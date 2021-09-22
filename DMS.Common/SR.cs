using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DMS.Common
{
    using Coolite.Ext.Web;


    public sealed class SR
    {

        public class Resource
        {
            public const string Default = "Default";    //默认首页 
            #region 库存管理       
            public const string M2_WarehouseList = "M2_WarehouseList";//列表页面
            public const string M3_WarehouseEdit = "M3_WarehouseEdit";//新增编辑页面
            public const string DealerWarehouseMaint = "DealerWarehouseMaint";  //新增/编辑按钮（仓库维护功能）
            #endregion
            public const string M2_InventoryQuery = "M2_InventoryQuery";//库存查询

            #region 库存调整
            public const string M2_InventoryAdjust = "M2_InventoryAdjust";//库存调整
            public const string M3_InventoryAdjustEdit = "M3_InventoryAdjustEdit";//库存调整(新增编辑页面)
            public const string M2_InventoryAdjustAudit = "M2_InventoryAdjustAudit";//库存审批  
            public const string DealerAdj = "DealerAdj";//经销商库存调整  
            #endregion

            public const string M2_InitStockInput = "M2_InitStockInput";//期初库存导入页面
            public const string M2_MonthlyStockCheck = "M2_MonthlyStockCheck";//月末库存上传页面
            public const string MonthlyStockExport = "MonthlyStockExport";//月末库存上传导出
            public const string MonthlyStockImport = "MonthlyStockImport";//月末库存上传导入

            public const string M2_WFSetting = "M2_WFSetting";//流程设定

            public const string M2_DealerInfo = "M2_DealerInfo";//经销商列表页面
            public const string M2_DealerEdit = "M2_DealerEdit";//经销商编辑页面
            public const string DealerInfo = "DealerInfo";//经销商编辑按钮

            public const string M2_SalesHospital = "M2_SalesHospital";//岗位与医院维护页面

            public const string M2_CFN = "M2_CFN";//产品基础信息列表及编辑页面
            public const string CFNInfo = "CFNInfo";//产品基础信息列表查询、保存及产品关系维护

            public const string M2_PartsClassification = "M2_PartsClassification";//产品分类页面

            public const string M2_SAPPrice = "M2_SAPPrice";//SAP价格维护页面

            public const string M2_TransferWarehouse = "M2_TransferWarehouse";//经销商移库列表页面
            public const string DealerMovement = "DealerMovement";//经销商移库列表查询

            public const string M2_DealerReceipt = "M2_DealerReceipt";//经销商收货

            public const string M2_TransferOut = "M2_TransferOut";//经销商借货出库页面
            public const string M2_CFNSet = "M2_CFNSet";//产品组套维护
            public const string M2_WholeHospitalList = "M2_WholeHospitalList";//医院列表
            public const string M2_HospitalInfo = "M2_HospitalInfo";//医院信息维护

            public const string M2_TransferDistributionList = "M2_TransferDistributionList";//分销出库

            public const string M2_OrderBrowse = "M2_OrderBrowse";//订单查询列表页面
            public const string M2_OrderNewApply = "M2_OrderNewApply";//订单申请页面
            public const string M2_OrderView = "M2_OrderView";//订单查看页面
            public const string M2_OrderAuditList = "M2_OrderAuditList";//订单审核列表页面
            public const string M2_OrderAuditDetail = "M2_OrderAuditDetail";//订单审核页面
            public const string M2_OrderConfirmList = "M2_OrderConfirmList";//订单待确认列表页面
            public const string PurchaseOrder_Query_Dealer = "PurchaseOrder_Query_Dealer";//经销商下订单
            public const string PurchaseOrder_Query_User = "PurchaseOrder_Query_User";//厂商审核订单
            public const string M2_PurchaseOrderImport = "M2_PurchaseOrderImport";//订单导入页面

            public const string M2_ShipmentOrder = "M2_ShipmentOrder";//销售出库单
            public const string M2_ShipmentReceiptAudit = "M2_ShipmentReceiptAudit";//销售出库单票据审核

            public const string M2_BulletinManage = "M2_BulletinManage";//公告维护
            public const string M2_IssuesList = "M2_IssuesList";//问题管理
        }

        #region 字典常量定义
        public const string Consts_Active_Flag = "CONST_Active_Flag";
        public const string Consts_AdjustQty_Status = "CONST_AdjustQty_Status";
        public const string Consts_AdjustQty_Type = "CONST_AdjustQty_Type";
        //public const string Consts_Authorization_Type = "CONST_Authorization_Type";
        public const string Consts_BusinessUnit_Type = "CONST_BusinessUnit_Type";
        public const string Consts_Company_Grade = "CONST_Company_Grade";
        public const string Consts_Company_Type = "CONST_Company_Type";
        public const string Consts_Dealer_Type = "CONST_Dealer_Type";
        //Warehouse Type
        public const string Consts_WarehouseType = "MS_WarehouseType";


        //OBOR 
        public const string OBORESign_Status = "OBORESign_Status";
        public const string OBORESign_Type = "OBORESign_Type";
        /// <summary>
        /// Hospital Grade
        /// </summary>
        public const string Consts_Hospital_Grade = "CONST_Hospital_Grade";

        public const string Consts_Hospital_Level = "CONST_Hospital_Level";

        public const string Consts_Implant = "CONST_Implant";
        public const string Consts_Inv_Transaction_Type = "CONST_Inv_Transaction_Type";
        public const string Consts_Receipt_Status = "CONST_Receipt_Status";
        public const string Consts_Receipt_Type = "CONST_Receipt_Type";
        public const string Consts_Rent_Status = "CONST_Rent_Status";
        public const string Consts_ShipmentOrder_Status = "CONST_ShipmentOrder_Status";
        public const string Consts_TransferOrder_Status = "CONST_TransferOrder_Status";//经销商移库状态
        public const string Consts_DealerTransfer_Status = "CONST_DealerTransfer_Status";//经销商借货状态
        public const string Consts_TransferOrder_Type = "CONST_TransferOrder_Type";
        //added by bozhenfei on 20130704
        public const string Consts_ShipmentOrder_Type = "Consts_ShipmentOrder_Type";
        public const string Consts_Order_Type = "CONST_Order_Type";
        public const string Consts_ExpiryDate_Type = "Consts_ExpiryDate_Type";

        //added by bozhenfei on 20100528
        public const string Consts_Bulletin_Status = "CONST_Bulletin_Status";
        public const string Consts_Bulletin_Important = "CONST_Bulletin_Important";
        public const string Consts_Taxpayer_Type = "CONST_Taxpayer_Type";
        public const string Consts_Stocktaking_Type = "CONST_Stocktaking_Type";
        public const string Consts_DealerQA_Type = "CONST_DealerQA_Type";
        public const string Consts_DealerQA_Status = "CONST_DealerQA_Status";
        //Added By Song Yuqi On 2013-9-3
        public const string Consts_DealerComplaint_Type = "CONST_DealerComplaint_Type";
        public const string Consts_DealerComplaint_Status = "CONST_DealerComplaint_Status";

        public const string Const_Consignment_Rule = "CONST_Consignment_Rule";
        public const string Const_Consignment_Type = "CONST_Consignment_Type";

        //hou zhi-yong
        public const string CONST_TenderType = "CONST_TenderType";
        //导出授权类型
        public const string Tender_Authorization = "Tender_Authorization";
        public const string Tender_AuthorizationLP = "Tender_AuthorizationLP";
        public const string Tender_AuthorizationBSC = "Tender_AuthorizationBSC";
        //页面授权
        public const string Provisional_Authorization = "Provisional_Authorization";
        /// <summary>
        /// System User Type
        /// </summary>
        public const string Consts_System_Medtronic_User = "User";
        public const string Consts_System_Dealer_User = "Dealer";

        //add by songweiming on 2014-4-24 经销商投诉换货
        public const string CONST_QAComplainReturn_Status = "CONST_QAComplainReturn_Status";

        public const string Consts_TrainType = "TrainType";
        #endregion

        #region 组织结构类型定义

        public const int Organization_ProductLine_Level = 6;
        public const string Organization_Root = "Root";
        public const string Organization_SubCompany = "SubCompany";
        public const string Organization_Brand = "Brand";
        public const string Organization_ProductLine = "Product_Line";

        public const string Organization_BU = "BU";
        public const string Organization_Operation = "Operation";
        public const string Organization_Region = "Region";
        public const string Organization_District = "District";
        public const string Organization_TSRManager = "TSR_Manager";
        public const string Organization_TSR = "TSR";
        public const string Organization_Position = "Position";

        #endregion

        /// <summary>
        /// 库存事项类型
        /// </summary>
        public const string CONST_INV_TRANS_TYPE_POReceipt = "采购入库";
        public const string CONST_INV_TRANS_TYPE_Shipment = "销售出库";
        public const string CONST_INV_TRANS_TYPE_Transfer = "经销商移库";
        public const string CONST_INV_TRANS_TYPE_Transfer_RentOut = "经销商借货：借出";
        public const string CONST_INV_TRANS_TYPE_Transfer_Borrow = "经销商借货：借入";
        public const string CONST_INV_TRANS_TYPE_Adjust_Return = "库存调整：退货";
        public const string CONST_INV_TRANS_TYPE_Adjust_StockIn = "库存调整：其他入库";//即StockIn
        public const string CONST_INV_TRANS_TYPE_Adjust_Scrap = "库存调整：报废";
        public const string CONST_INV_TRANS_TYPE_Adjust_StockOut = "库存调整：其他出库";//即StockOut
        //added by bozhenfei on 20100609
        public const string CONST_INV_TRANS_TYPE_Stocktaking = "库存盘点调整";
        //end
        //added by huyong on 2015-11-27
        public const string CONST_INV_TRANS_TYPE_Adjust_Transfer = "库存调整：转移给其他经销商";
        //end

        public const string Consts_Default_Warehouse = "DefaultWH";
        public const string Consts_SystemHold_Warehouse = "SystemHold";

        public const string ListDeliveryNoteImportParameters = "DeliveryNoteImportParameters";

        #region 模块所写定义
        /// <summary>
        /// Add by wuxitao 20100409
        /// </summary>
        public const string CONST_MODULE_POReceipt = "PORL";
        public const string CONST_MODULE_ORDERNEW = "ONA";
        public const string CONST_MODULE_ORDERMODIFY = "OMA";
        public const string CONST_MODULE_ORDERREVOKE = "ORA";
        public const string CONST_MODULE_ADJUST = "IAL";
        public const string CONST_MODULE_TRANSFER = "TE";
        public const string CONST_MODULE_SHIPMENT = "SPL";
        public const string CONST_MODULE_RENT = "TFL";
        #endregion

        //紧急订单提示信息
        public const string CONST_MESSAGE_URGENT = "紧急订单提示信息";

        //系统语言
        public const string CONST_SYS_LANG_CN = "zh-CN";
        public const string CONST_SYS_LANG_EN = "en-US";

        //added by bozhenfei on 20110212
        public const string Consts_CFN_PriceType = "CONST_CFN_PriceType";
        public const string Consts_Territory_Level = "CONST_Territory_Level";
        public const string Consts_Order_Status = "CONST_Order_Status";
        public const string Consts_Order_CreateType = "CONST_Order_CreateType";
        public const string Consts_Order_OperType = "CONST_Order_OperType";
        public const string Consts_MakeOrder_Status = "CONST_MakeOrder_Status";
        public const string Consts_MakeOrder_Type = "CONST_MakeOrder_Type";
        public const string Consts_Payment_Type = "CONST_Payment_Type";
        public const string Consts_Payment_Status = "CONST_Payment_Status";
        public const string ConsignmentApply_Status = "ConsignmentApply_Order_Status";
        public const string ConsignmentApply_Order_Type = "ConsignmentApply_Order_Type";
        //end

        //added by bozhenfei on 20110212
        public const decimal Consts_TaxRate = 1.17M;
        //end

        //added by Huakaichun on 20131126
        public const string CONST_Contract_Status = "CONST_Contract_Status";
        public const string ThirdPartType = "ThirdPartType";
        #region 市场类型
        public const string Market_Type = "Market_Type";
        #endregion

        #region 注销
        public const string Const_ContractAnnex_Type_Amendment = "CONST_ContAnnex_Ad";
        public const string Const_ContractAnnex_Type_Appointment = "CONST_ContAnnex_Ap";
        public const string Const_ContractAnnex_Type_Renewal = "CONST_ContAnnex_Re";
        public const string Const_ContractAnnex_Type_Termination = "CONST_ContAnnex_Te";
        #endregion
        public const string Const_ContractAnnex_Type_T1 = "CONST_ContAnnex_T1";
        public const string Const_ContractAnnex_Type_T2 = "CONST_ContAnnex_T2";
        public const string Const_ContractAnnex_Type_LP = "CONST_ContAnnex_LP";


        public const string CONST_Contract_Type = "CONST_Contract_Type";

        #region 用户角色
        public const string Const_UserRole_ChannelOperation = "渠道管理员";
        public const string Const_UserRole_ContractQuery = "合同查询";
        public const string Const_UserRole_ContractAudit = "审计用基础查询";
        public const string Const_UserRole_TenderAdmin = "招投标合同管理员";
        public const string Const_UserRole_Admin = "Administrators";
        #region WeChat 用户角色
        public const string WeChat_UserRole_Admin = "微信管理员";
        #endregion
        #endregion

        #region 汇率转换
        public const string Const_ExchangeRate = "CNY (USD 1=CNY 6.15)";
        #endregion
        //end

        public const string CONST_ESC_UploadType = "CONST_ESC_UploadType";
        public const string CONST_ESC_Status = "CONST_ESC_Status";

        #region 士兵突击-大区
        public const string Train_Area = "Train_Area";
        public const string Train_OnlineType = "Train_OnlineType";
        public const string BscUser_UserType = "BscUser_UserType";
        #endregion

        #region 促销政策参数
        public const string PRO_Status = "PRO_Status";
        public const string PRO_TimeStatus = "PRO_TimeStatus";
        public const string PRO_Type = "PRO_Type";
        public const string PRO_Period = "PRO_Period";
        public const string PRO_YesOrNo = "PRO_YesOrNo";
        public const string PRO_TO = "PRO_TO";
        public const string PRO_ToType = "PRO_ToType";
        public const string PRO_TopType = "PRO_TopType";
        public const string PRO_CarryType = "PRO_CarryType";
        public const string PRO_ProGiftType = "PRO_ProGiftType";
        public const string PRO_ProRoleSymbol = "PRO_ProRoleSymbol";
        public const string PRO_LogicType = "PRO_LogicType";
        public const string PRO_TargetType = "PRO_TargetType";
        public const string PRO_PolicyClass = "PRO_PolicyClass"; //add 20160124
        public const string PRO_IsGiftConvter = "PRO_IsGiftConvter";//add 20160216
        #endregion

        #region PromotionStatus
        public const string PRO_Status_Draft = "草稿"; // 页面保存草稿状态
        public const string PRO_Status_Approving = "审批中"; //e-workflow审批通过
        public const string PRO_Status_Reject = "审批拒绝"; //被E-workflow审批拒绝
        public const string PRO_Status_Dffective = "有效";//完成E-workflow审批后，系统自动更新
        public const string PRO_Status_Invalid = "无效"; //系统自动跑出

        #endregion

        #region PromotionApprovalStatus


        #endregion

        #region PromotionPointOrder
        public const string PRO_PointType = "PRO_PointOrderType";

        #endregion

        public const string CONST_DMS_Authentication_Type = "CONST_DMS_Authentication_Type";

        public const string CONST_Delay_Status = "CONST_Delay_Status";

        public const string CONST_Consignment_Rule = "CONST_Consignment_Rule";

        public const string Consign_Contract_Type = "Consignment_ContractHeader_Status";

        public const string CONST_AdjustQty_Status = "CONST_AdjustQty_Status";

        public const string Consign_ConsignTransfer_Status = "Consignment_ConsignTransfer_Status";

        public const string Consignment_ConsignmentTermination_Status = "Consignment_ConsignmentTermination_Status";

        #region E-Workflow审批参数
        /// <summary>
        /// 短期寄售Ewf审批流程编号
        /// </summary>
        public static string CONST_CONSIGNMENT_FLOWNO = System.Configuration.ConfigurationManager.AppSettings["ConsignmentFlowNo"];
        /// <summary>
        /// Endo订单审批流程编号
        /// </summary>
        public static string CONST_ENDO_ORDER_NO = System.Configuration.ConfigurationManager.AppSettings["EndoOrderNo"];

        /// <summary>
        /// Promotion 审批流程编号
        /// </summary>
        public static string CONST_PROMOTION_POLICY_NO = System.Configuration.ConfigurationManager.AppSettings["PromotionPolicyNo"];

        /// <summary>
        /// Promotion 赠品审批流程编号
        /// </summary>
        public static string CONST_PROMOTION_POLICYGIFT_NO = System.Configuration.ConfigurationManager.AppSettings["PromotionPolicyGiftNo"];

        /// <summary>
        /// DMS_Promotion开发环境，1为是，0为否，0会调用Ewf接口
        /// </summary>
        public static string CONST_DMS_Promotion_DEVELOP = System.Configuration.ConfigurationManager.AppSettings["DMSPromotionDevelop"];

        /// <summary>
        /// Ewf接口通讯密码
        /// </summary>
        public static string CONST_EWF_WEB_PWD = System.Configuration.ConfigurationManager.AppSettings["EwfWebPwd"];
        /// <summary>
        /// Ewf密码
        /// </summary>
        public static string CONST_EWF_USER_NAME = System.Configuration.ConfigurationManager.AppSettings["EwfUserName"];
        /// <summary>
        /// Ewf用户名
        /// </summary>
        public static string CONST_EWF_USER_PWD = System.Configuration.ConfigurationManager.AppSettings["EwfUserPwd"];
        /// <summary>
        /// Ewf域
        /// </summary>
        public static string CONST_EWF_DOMAIN = System.Configuration.ConfigurationManager.AppSettings["EwfDomain"];
        /// <summary>
        /// DMS开发环境，1为是，0为否，0会调用Ewf接口
        /// </summary>
        public static string CONST_DMS_DEVELOP = System.Configuration.ConfigurationManager.AppSettings["DMSDevelop"];
        /// <summary>
        /// Ewf金额
        /// </summary>
        public static string CONST_EWF_AMOUNT = System.Configuration.ConfigurationManager.AppSettings["EwfAmount"];
        /// <summary>
        /// Ewf金额
        /// </summary>
        public static string CONST_EWF_DELAY_AMOUNT = System.Configuration.ConfigurationManager.AppSettings["EwfDelayAmount"];

        /// <summary>
        /// 积分导入流程编号
        /// </summary>
        public static string CONST_INIT_POINT_NO = System.Configuration.ConfigurationManager.AppSettings["InitPointNo"];
        /// <summary>
        /// 清指定批号订单中特殊处理的经销商
        /// </summary>
        public static string CONST_PurchaseOrder_DFDMA = System.Configuration.ConfigurationManager.AppSettings["ClearBorrowManualDealerDF"];
        /// <summary>
        /// JavaScriptVersion
        /// </summary>
        public static string CONST_JAVA_SCRIPT_VERSION = System.Configuration.ConfigurationManager.AppSettings["JavaScriptVersion"];
        #endregion
        #region 字典表接口类型
        public const string Consts_DataInterfaceType = "CONST_DataInterfaceType";
        #endregion

        public const string CONST_UploadExcelAllowedExtensions = ".xls,.xlsx";

        public const string CONST_CFNPrice_Level = "CONST_CFNPrice_Level";
    }

    public static class AppSettings
    {
        public static string QA_Systeam = System.Configuration.ConfigurationManager.AppSettings["qa_system"];
        public static string QA_Business = System.Configuration.ConfigurationManager.AppSettings["qa_business"];

        //public static string HostUrl = HttpContext.Current.Request.Url.AbsoluteUri.Replace(HttpContext.Current.Request.Url.Query, "").Replace(HttpContext.Current.Request.Url.AbsolutePath, "");
    }

    public sealed class EkpSetting
    {
        public static string CONST_EKP_COMMON_PAGE_URL = System.Configuration.ConfigurationManager.AppSettings["EkpCommonPageUrl"];
        public static string CONST_EKP_REDIRECT_URL = System.Configuration.ConfigurationManager.AppSettings["EkpRedirectUrl"];
        public static string CONST_EKP_HISTORY_URL = System.Configuration.ConfigurationManager.AppSettings["EkpHistoryUrl"];
        public static string CONST_EKP_SYS_ID = System.Configuration.ConfigurationManager.AppSettings["EkpSysId"];
        public static string CONST_EKP_SSO_KEY = System.Configuration.ConfigurationManager.AppSettings["EkpSSOKey"];
    }
}
