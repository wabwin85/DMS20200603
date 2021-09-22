using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Inventory
{
    public class InventoryQROperationVO : BaseQueryVO
    {
        //主页面
        public KeyValue QryProductLine;
        public KeyValue QryDealer;
        public String QryQrCode;
        public String QryCfnChineseName;
        public KeyValue QryWarehouse;
        public String QryCFN;
        public DatePickerRange QryExpiredDate;
        public KeyValue QryScanType;
        public String QryLotNumber;
        public DatePickerRange QryRemarkDate;
        public String QryRemark;
        public KeyValue QryQtyIsZero;
        public DatePickerRange QryCreateDate;
        public KeyValue QryShipmentState;
        public bool ShowRemark;
        public String ChooseParam;
        public String DelItem;
        public String InvType;

        public ArrayList RstResultList = null;

        public IList<KeyValue> LstProductLine = null;
        public IList<Hashtable> LstDealerName = null;
        public ArrayList LstWarehouse = null;

        //销售单页面
        public String WinShipmentDealerName;
        public KeyValue WinShipmentProductLine;
        public DateTime WinShipmentDate;
        public String WinShipmentDate_Max;
        public String WinShipmentDate_Min;
        public KeyValue WinShipmentHospital;
        public String WinShipmentInvoiceNo;
        public String WinShipmentInvoiceTitle;
        public DateTime WinShipmentInvoiceDate;
        public String WinShipmentDepartment;
        public String WinShipmentRemark;
        public String ShipmentRecordSum;
        public String ShipmentQtySum;
        public String HidDealerId;
        public String DelAttachId;
        public String DelProductId;

        public ArrayList LstShipmentHospital = null;
        public ArrayList RstWinShipmentList = null;
        public ArrayList RstWinAttachList = null;

        //移库单页面
        public String WinTransferDealerName;
        public KeyValue WinTransferProductLine;
        public KeyValue WinTransferType;
        public KeyValue WinTransferWarehouse;
        public String TransferRecordSum;
        public String TransferQtySum;

        public ArrayList LstTransferType = null;
        public ArrayList LstTransferWarehouse = null;
        public ArrayList RstWinTransferList = null;

        //销售二维码
        public String WinQrCodeConvertDealerName;
        public KeyValue WinQrCodeConvertProductLine;
        public String WinQrCodeConvertUpn;
        public String WinQrCodeConvertLotNumber;
        public String WinQrCodeConvertUsedQrCode;
        public String WinQrCodeConvertNewQrCode;
        public KeyValue WinQrCodeConvert;
        public KeyValue WinQrCodeWarehouse;
        public String WinQrCode;
        public String ChangeParam;
        public String HidHeadId;
        public String HidShipHeadId;
        public String HidPmaId;
        public String HidLotId;
        public String HidWhmId;

        public ArrayList LstDealer = null;
        public ArrayList RstWinQrCodeConvertList = null;
        public ArrayList RstWinQrCodeCfnList = null;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
