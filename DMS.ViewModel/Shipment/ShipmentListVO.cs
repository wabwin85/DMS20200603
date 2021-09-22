using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Shipment
{
    public class ShipmentListVO : BaseQueryVO
    {
        public KeyValue QryProductLine;
        public KeyValue QryDealerName;
        public KeyValue QryOrderStatus;
        public KeyValue QryShipmentOrderType;
        public KeyValue QryInvoiceStatus;
        public KeyValue QryInvoiceState;

        public DatePickerRange QryStartDate;
        public DatePickerRange QrySubmitDate;
        public DatePickerRange QryInvoiceDate;

        public String QryHospital;
        public String QryOrderNumber;
        public String QryCFN;
        public String QryLotNumber;
        public String QryInvoiceNo;

        //页面控制
        public bool ShowQuery;
        public bool ShowRemark;
        public bool IsAdmin;

        public ArrayList RstShipmentList = null;

        public IList<Hashtable> LstDealerName = null;
        public ArrayList LstDealer = null;
        public IList<KeyValue> LstProductLine = null;
        public ArrayList LstOrderStatus = null;
        public ArrayList LstShipmentOrderType = null;

        #region 窗体部分

        //Detail
        public KeyValue WinSLDealer;
        public KeyValue WinSLProductLine;
        public KeyValue WinSLHospital;

        public String WinSLOrderType;
        public String WinSLInvoiceNo;
        public String WinSLOrderNo;
        public String WinSLOrderStatus;
        public String WinSLInvoiceHead;
        public String WinSLOrderRemark;
        public String WinSLDealerType;
        public String WinProductQty;
        public String WinProductSum;
        public bool? WinShowReasonBtn;
        public bool? WinDisablePriceBtn;
        public bool? WinDisableRevokeBtn;
        public bool? WinIsDetailUpdate;
        
        //hidden
        public String WinSLOrderId = "00000000-0000-0000-0000-000000000000";
        public String WinIsShipmentUpdate;
        public String WinShipmentType;
        public String WinIsAuth;
        public String HidShipDate;
        public String WinShipmentNbr;
        //详情页面时间
        public DateTime? WinSLShipmentDate;
        public DateTime? WinSLInvoiceDate;
        public DateTime WinSLShipDate_Min = DateTime.MinValue;
        public DateTime WinSLShipDate_Max = DateTime.MaxValue;

        //详情窗体下拉框
        public ArrayList LstWinSLProductLine = null;
        public ArrayList LstWinSLHospital = null;
        //详情窗体Grid
        public ArrayList RstWinSLProductList = null;
        public ArrayList RstWinSLOPLog = null;
        public ArrayList RstWinSLAttachList = null;
        //发票号导入
        public ArrayList RstWinInvoiceNo = null;
        //显示原因
        public ArrayList RstWinSLReason = null;
        //修改产品单价
        public ArrayList RstSLWinOrderPrice = null;
        //提交结果检查
        public String WinWrongCnt;
        public String WinCorrectCnt;
        public ArrayList RstSLWinCheckResult = null;
        //销售调整
        public String WinSADealer;
        public String WinSAProductLine;
        public String WinSAUseDate;
        public String WinSAHospital;
        public KeyValue WinSAAdjustReason;
        public DateTime? WinSAShipDate;
        public ArrayList RstSAHistoryOrderData = null;
        public ArrayList RstSAInventoryData = null;
        //物料选择
        public KeyValue WinSCWarehouse;
        public KeyValue WinSCExpired;
        public String WinSCLotNumber;
        public String WinSCCFN;
        public String WinSCQrCode;
        public ArrayList LstWinSCWarehouse = null;
        public ArrayList LstWinSCExpired = null;
        public ArrayList RstSCInventoryItem = null;
        //历史销售记录
        public KeyValue WinSHWarehouse;
        public String WinSHHospital;
        public String WinSHShipmentNo;
        public String WinSHCFN;
        public String WinSHLotNumber;
        public String WinSHQrCode;
        public ArrayList LstWinSHWarehouse = null;
        public ArrayList RstSHHistoryItem = null;
        //库存数据
        public KeyValue WinSIWarehouse;
        public KeyValue WinSIExpired;
        public String WinSILotNumber;
        public String WinSICFN;
        public String WinSIQrCode;
        public ArrayList LstWinSIWarehouse = null;
        public ArrayList LstWinSIExpired = null;
        public ArrayList RstSIInventoryItem = null;
        //添加的数据
        public String ParaChooseItem;
        public String ParaHistoryItem;
        public String ParaInventoryItem;
        //删除内容
        public String DelProductId;
        public String DelAttachId;
        public String DelAdjustId;
        public String DelAdjustLotId;
        //报台信息
        public String WinSPOId;
        public String WinSOOfficeName;
        public String WinSODoctorName;
        public String WinSOPatientPIN;
        public String WinSOPatientName;
        public String WinSOHospitalNo;
        public bool WinSOPatientGender;
        //授权查看
        public String WinAutDealer;
        public String WinAutUPN;
        public String WinAutHospital;
        public DateTime? WinAutDate;
        public ArrayList RstAutResult = null;

        #endregion

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
