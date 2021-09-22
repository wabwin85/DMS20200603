using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Report
{
    public class DealerBuyInVO : BaseQueryVO
    {
        //查询条件
        public KeyValue QryBrand;        
        public KeyValue QryProductLine;
        public DatePickerRange QryOrderDate;
        public DatePickerRange QryShipmentDate;
        public String QryCFN;
        public String QryLotNumber;
        public KeyValue QryDealer;
        public KeyValue QryDealerType;
        public String QryQRCode;
        public String QryDeliveryNo;
        public String QryOrderNo;

        public ArrayList LstBrand = null;
        public ArrayList LstDealerType = null;
        public IList<KeyValue> LstProductline = null;
        public ArrayList RstResultList = null;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
