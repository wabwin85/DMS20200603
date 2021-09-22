using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DMS.Website.Common
{
    public static class CommonVariable
    {

        public static readonly string Blank_Guid_String = "00000000-0000-0000-0000-000000000000";

        #region 读取Config文件中的配置
        //added by bozhenfe on 20100604
        public static bool HiddenUPN = System.Configuration.ConfigurationManager.AppSettings["HiddenUPN"].ToLower().Equals("true");
        public static bool HiddenUOM = System.Configuration.ConfigurationManager.AppSettings["HiddenUOM"].ToLower().Equals("true");
        //end

        //报表中日期格式
        public static string DateFormat = System.Configuration.ConfigurationManager.AppSettings["DateFormat"];
        //Reporting Server Url
        public static string ReportServerURL = System.Configuration.ConfigurationManager.AppSettings["ReportServerURL"];

        public static string ShimentAttachmentURL = System.Configuration.ConfigurationManager.AppSettings["ShimentAttachmentURL"];
        //Report View 属性
        public static string ReportViewWidth = System.Configuration.ConfigurationManager.AppSettings["ReportViewWidth"];
        public static string ReportViewHeight = System.Configuration.ConfigurationManager.AppSettings["ReportViewHeight"];

        //报表路径 经销商移库
        public static string ReportPath_DealerTransfer = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerTransfer"];

        //报表路径 经销商移库CRDM

        public static string ReportPath_DealerTransferCRDM = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerTransferCRDM"];

        //报表路径 经销商调拨出库
        public static string ReportPath_DealerTransferOut = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerTransferOut"];
        //报表路径 经销商调拨入库
        public static string ReportPath_DealerTransferIn = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerTransferIn"];
        //报表路径 经销商销售
        public static string ReportPath_DealerSales = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerSales"];
        //报表路径 经销商库存调整
        public static string ReportPath_DealerInvAdjust = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerInvAdjust"];
        //报表路径 经销商BuyIn数据
        public static string ReportPath_DealerBuyIn = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerBuyIn"];

        //报表路径 经销商Buy In数据  月报表
        public static string ReportPath_DealerBuyInMonth = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerBuyInMonth"];
        //报表路径 经销商Buy In数据  周报表
        public static string ReportPath_DealerBuyInWeek = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerBuyInWeek"];
        //报表路径 经销商Buy In数据  季度报表
        public static string ReportPath_DealerBuyInQuarter = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerBuyInQuarter"];
        //报表路径 经销商销售  根据产品线汇总报表
        public static string ReportPath_DealerSalesProdStat = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerSalesProdStat"];
        //报表路径 经销商销售  根据医院汇总报表
        public static string ReportPath_DealerSalesHospStat = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerSalesHospStat"];
        //报表路径 经销商借货在途汇总报表
        public static string ReportPath_DealerTransferOutStat = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerTransferOutStat"];
        //报表路径 产品线包含医院报表
        public static string ReportPath_ProductLineHos = System.Configuration.ConfigurationManager.AppSettings["ReportPath_ProductLineHos"];
        //报表路径 经销商授权报表
        public static string ReportPath_DealerAuthCate = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerAuthCate"];
        //报表路径 未分配销售人员医院报表(已形成销售)
        public static string ReportPath_SalesMissedHos = System.Configuration.ConfigurationManager.AppSettings["ReportPath_SalesMissedHos"];
                //报表路径 经销商库存报表
        public static string ReportPath_InventoryReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_InventoryReport"];

        //报表路径 经销商订单金额汇总报表
        public static string ReportPath_DealerPurchaseOrderAmount = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerPurchaseOrderAmount"];

        //报表路径 经销商订单明细报表
        public static string ReportPath_DealerPurchaseOrderDetail = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerPurchaseOrderDetail"];

        //报表路径 经销商库存核算报表
        public static string ReportPath_DealerInvAccount = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerInvAccount"];

        //报表路径 经销商库存核算报表-Medtronic用户
        public static string ReportPath_DealerInvAccountForMed = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerInvAccountForMed"];

        //报表路径 经销商AOP达成率报表
        public static string ReportPath_DealerAOP = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerAOP"];

        //报表路径 销售人员指标达成率报表
        public static string ReportPath_SalesAOP = System.Configuration.ConfigurationManager.AppSettings["ReportPath_SalesAOP"];

        //报表路径 经销商系统使用情况报表
        public static string ReportPath_DealerOperationDays = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerOperationDays"];
         
        //报表练习
        public static string ReportPath_Test = System.Configuration.ConfigurationManager.AppSettings["ReportPath_Test"];

        //报表路径 经销商销售报表-Medtronic用户
        public static string ReportPath_DealerSalesForMed = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerSalesForMed"];


        //added by songyuqi on 20100625
        //医院库数据报表
        public static string ReportPath_HospitalReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_HospitalReport"];

        //经销商信息报表
        public static string ReportPath_DealerMasterReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerMasterReport"];

        //销售人员负责医院报表
        public static string ReportPath_SalesHospitalReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_SalesHospitalReport"];

        //end


        //added by songweiming on 20100625
        //报表路径 手术报台信息报表
        public static string ReportPath_DealerShipmentOperation = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerShipmentOperation"];
        public static string ReportPath_DealerShipmentOperationForSynthes = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerShipmentOperationForSynthes"];

        //报表路径 经销商仓库库存数据报表
        public static string ReportPath_InventoryWarehouseReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_InventoryWarehouseReport"];
        //end

        //added by songyuqi on 20100921
        //激活账号报表
        public static string ReportPath_ActivateAccountReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_ActivateAccountReport"];

        //SDD经销商销售报表
        public static string ReportPath_SDD_DealerSalesReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_SDD_DealerSalesReport"];

        //SDD经销商库存报表
        public static string ReportPath_SDD_InventoryReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_SDD_InventoryReport"];

        //授权医院报表
        public static string ReportPath_HospitalAuthCate = System.Configuration.ConfigurationManager.AppSettings["ReportPath_HospitalAuthCate"];
        //end

        //added by huyong on 20110212
        //经销商收货数据报表（Synthes用户）
        public static string ReportPath_DealerBuyInForBscReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerBuyInForBscReport"];

        //经销商移库报表（Synthes用户）
        public static string ReportPath_DealerTransferForSynthesReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerTransferForSynthesReport"];

        //经销商借货出库报表（Synthes用户）
        public static string ReportPath_DealerTransferOutForSynthesReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerTransferOutForSynthesReport"];

        //经销商借货入库报表（Synthes用户）
        public static string ReportPath_DealerTransferInForSynthesReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerTransferInForSynthesReport"];

        //经销商销售报表（Synthes用户）
        public static string ReportPath_DealerSalesForSynthesReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerSalesForSynthesReport"];

        //经销商库存调整报表（Synthes用户）
        public static string ReportPath_DealerInvAdjustForSynthesReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerInvAdjustForSynthesReport"];

        //经销商库存报表（Synthes用户）
        public static string ReportPath_InventoryForSynthesReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_InventoryForSynthesReport"];

        //经销商仓库库存数据报表（Synthes用户）
        public static string ReportPath_InventoryWarehouseForSynthesReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_InventoryWarehouseForSynthesReport"];

        //产品分类数据报表
        public static string ReportPath_ProductClassificationReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_ProductClassificationReport"];

        //成套产品数据报表
        public static string ReportPath_CFNSetReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_CFNSetReport"];

        //系统公告明细报表
        public static string ReportPath_BulletinDetailReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_BulletinDetailReport"];

        //系统用户登录报表
        public static string ReportPath_UserLoginReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_UserLoginReport"];

        //付款通知报表
        public static string ReportPath_DealerPaymentReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerPaymentReport"];

        //发票寄送数据上传报表
        public static string ReportPath_SendInvoiceDataReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_SendInvoiceDataReport"];

        //PT维修服务
        public static string ReportPath_PTMaintenanceServices = System.Configuration.ConfigurationManager.AppSettings["ReportPath_PTMaintenanceServices"];

        //经销商历史库存明细报表
        public static string ReportPath_DealerHistoryInvDetailReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerHistoryInvDetailReport"];

        //经销商历史库存明细报表（Synthes用户）
        public static string ReportPath_DealerHistoryInvDetailForSynthesReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerHistoryInvDetailForSynthesReport"];

        //经销商指标达成率报表
        public static string ReportPath_DealerAOPReachReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerAOPReachReport"];

        //经销商订单明细报表 
        public static string ReportPath_DealerOrderDetailReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerOrderDetailReport"];

        //经销商订单明细报表 (Synthes)
        public static string ReportPath_DealerOrderDetailForSynthesReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerOrderDetailForSynthesReport"];


        //经销商库存周转天数报表（经销商维度）
        public static string ReportPath_TurnoverDealerReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_TurnoverDealerReport"];

        //经销商库存周转天数报表（产品维度）
        public static string ReportPath_TurnoverProductReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_TurnoverProductReport"];

        //日订单销售汇总
        public static string ReportPath_OrderSalesSummaryInDayReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_OrderSalesSummaryInDayReport"];
       
        //月订单销售汇总
        public static string ReportPath_OrderSalesSummaryInMonthReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_OrderSalesSummaryInMonthReport"];

        //订单状态报表
        public static string ReportPath_OrderStatusReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_OrderStatusReport"];

        //订单状态报表
        public static string ReportPath_OrderStatusForBscReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_OrderStatusForBscReport"];

        //经销商区域报表
        public static string ReportPath_TerritoryForSynthes = System.Configuration.ConfigurationManager.AppSettings["ReportPath_TerritoryForSynthes"];

        //医院经销商及销售人员报表
        public static string ReportPath_HospDealerUserReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_HospDealerUserReport"];

        //经销商进销存汇总报表
        public static string ReportPath_DealerJXCSummaryReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerJXCSummaryReport"];

        //经销商库对账单
        public static string ReportPath_DealerStatmentsReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerStatmentsReport"];

        //经销商库对账单实时查询
        public static string ReportPath_InterfacePaymentReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_InterfacePaymentReport"];

        //经销商价格报表（BSC）
        public static string ReportPath_DealerPriceForSynthesReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerPriceForSynthesReport"];

        //经销商销售报表（平台用户）
        public static string ReportPath_DealerSalesForLPReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerSalesForLPReport"];

        //平台销售数据报表
        public static string ReportPath_LPSalesForBscReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_LPSalesForBscReport"];

        //平台销售数据报表
        public static string ReportPath_ProductOperationLogReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_ProductOperationLogReport"];

        //二级经销商商业采购报表（平台用户）
        public static string ReportPath_DealerCommercialSalesForLPReport = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerCommercialSalesForLPReport"];

        //报表路径 经销商短期借货汇总报表
        public static string ReportPath_DealerConsignmentTrack = System.Configuration.ConfigurationManager.AppSettings["ReportPath_DealerConsignmentTrack"];

        #endregion
    }
}
