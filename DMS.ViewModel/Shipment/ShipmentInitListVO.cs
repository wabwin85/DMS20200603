using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Shipment
{
    public class ShipmentInitListVO : BaseQueryVO
    {
        public KeyValue QryDealer;
        public KeyValue QryShipmentInitStatus;
        public DatePickerRange QrySubmitDate;
        public String QryShipmentInitNo;

        public IList<Hashtable> LstDealer = null;
        public ArrayList LstDealerName = null;
        public ArrayList LstInitStatus = null;

        public ArrayList RstImportResult = null;

        //窗体部分
        public String WinSelectNo;
        public String WinSelectStatus;
        public String WinWrongCnt;
        public String WinCorrectCnt;
        public String WinInProcessCnt;
        public String WinSumQty;
        public String WinSumPrice;

        public ArrayList RstWinDetailResult = null;

        //导入部分
        public String DelErrorId;
        public ArrayList RstInitImportResult = null;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
