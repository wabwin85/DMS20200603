using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Transfer
{
    public class TransferDistributionListVO : BaseQueryVO
    {
        //查询页面
        public KeyValue QryProductLine;
        public KeyValue QryFromDealerName;
        public KeyValue QryToDealerName;
        public KeyValue QryTransferStatus; 
        public DatePickerRange QryTransferDate;
        public String QryTransferNumber;

        public ArrayList RstTDLResultList = null;
        public IList<KeyValue> LstProductLine = null;
        public IList<Hashtable> LstFromDealer = null;
        public ArrayList LstDealer = null;
        public ArrayList LstToDealer = null;
        public ArrayList LstTransferStatus = null;

        //隐藏值
        public String InstanceId;
        public String hidDealerFromId;
        public String hidDealerToDefaultWarehouseId;
        //明细页面
        public KeyValue QryWinProductLine;
        public KeyValue QryWinDealerFrom;
        public KeyValue QryWinDealerTo;
        public String QryWinNumber;
        public String QryWinDate;
        public String QryWinStatus;
        public String LotId;
        public ArrayList RstWinProductDetail = null;
        //明细选择产品
        public KeyValue WinTDLWarehouse;
        public String WinTDLLotNumber;
        public String WinTDLCFN;
        public String WinTDLQrCode;
        public String ParamProductItem;
        public ArrayList LstFromWarehouse = null;
        public ArrayList RstTDLProductItem = null;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        
    }
}
