using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Transfer
{
    public class TransferUnfreezeVO : BaseQueryVO
    {
        //主页面
        public KeyValue QryProductLine;
        public KeyValue QryDealer;
        public string QryTransferNumber;
        public DatePickerRange QryApplyDate;
        public KeyValue QryTransferStatus;
        public String QryCFN;
        public String QryLotNumber;
        public KeyValue QryTransferType;
        public bool ShowSearch = true;
        public bool ShowAdd = false;
        
        public ArrayList RstResultList = null;

        public IList<KeyValue> LstProductLine = null;
        public ArrayList LstDealer = null;
        public IList<Hashtable> LstDealerName = null;
        public ArrayList LstType = null;
        public ArrayList LstStatus = null;

        //详细信息页面
        public String WinTransferId;
        public String WinTransferType;
        public KeyValue WinDealer;
        public String WinTransferNumber;
        public String WinTransferStatus;
        public KeyValue WinProductLine;
        public String WinDate;
        public KeyValue WinWarehouse;
        public String WinProductSum;
        public ArrayList LstWarehouse = null;
        public ArrayList RstWinProductList = null;
        public ArrayList RstWinOPLog = null;

        //产品选择
        public KeyValue WinFreezeWarehouse;
        public String WinLotNumber;
        public String WinCFN;
        public String WinQrCode;
        public String DeleteItemId;
        public String ParaChooseItem;
        public ArrayList LstFreezeWarehouse = null;
        public ArrayList RstProductItem = null;

        //导入功能
        public ArrayList ImportErrorGrid = null;
        public string Id;
        public string WarehouseFrom;
        public string WarehouseTo;
        public string ArticleNumber;
        public string LotNumber;
        public string QRCode;
        public string TransferQty;

        //隐藏列
        public bool HideUPN;
        public bool HideUOM;

        //原因
        public ArrayList RstWinReason = null;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
