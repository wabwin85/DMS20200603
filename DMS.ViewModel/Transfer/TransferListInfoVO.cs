using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Transfer
{
    public class TransferListInfoVO : BaseQueryVO
    {
        //增加产品
        public string QryTransferType;
        public string QryInstanceId;

        public string QryDealerFromId;
        public string QryDealerToId;
        public string QryTransType;
        public string InstanceId;
        public string ProductLineId;
        public KeyValue QryProductLineWin;
        public string QryDate;
        public KeyValue QryWarehouseWin;
        public string QryStatus;
        public string QryOrderNO;
        public KeyValue QryDealerFromWin;
        public KeyValue QryDealerToWin;
        public string LotId;//每一行产品Id
        public string hiddenDealerToId;
        public string hiddenDealerToDefaultWarehouseId;


        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstDealerList = null;
        public ArrayList RstLogDetail = null;
        public ArrayList RstProductDetail = null;

        // public ArrayList EntityModel = null;
        public string EntityModel = null;
        public string EditRows;
        public IList<KeyValue> LstBu;
        public ArrayList LstType;
        public ArrayList LstStatus;
        public ArrayList LstDealerToList;//借入经销商

        public ArrayList LstSalesRepStor = null;//产品线下的销售
        public ArrayList LstDealerConsignment = null;//寄售合同
        public ArrayList LstSAPWarehouseAddress = null;//经销商仓库
        public ArrayList LstcbProductsource;


        public ArrayList LstProlineDma = null;//产品线下经销商
        public ArrayList Lstcbproline = null;
        public ArrayList LstcbHospital = null;
        public ArrayList LstDealer = null;

        public string DealerParams;
        public string DealerCmId;

        public string PlineItemId;
        public string PlineItemNum;
        public string DealerItemId;

        public String TransferQty;
        public String QRCode;
        public String EditQrCode;
        public String LotNumber;
    }
    public class TransferFormInfoEditRow
    {
        public string Id;
        public string TransferQty;
        public string QRCode;
        public string EditQrCode;
        public string LotNumber;
    }

    public class TransferListInfo
    {
        public string InstanceId;
        public string ProductLineId;
        public string OrderType;
        public string Remark;
        public string ConsignmentName;
        public string ConsignmentDay;
        public string DelayTime;
        public string StartDate;
        public string EndDate;

    }
}
