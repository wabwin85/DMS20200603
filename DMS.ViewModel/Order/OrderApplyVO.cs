using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Order
{
    public class OrderApplyVO : BaseQueryVO
    {
        public bool SerchVisibile = true;
        public bool InsertDisabled = true;
        public bool btnImportDisabled = true;
        public bool btnStockpriceDisabled = true;
        public bool cbDealerDisabled;
        public string hidInitDealerId;
        public KeyValue QryBu;
        public KeyValue QryDealer;
        public KeyValue QryOrderStatus;
        public KeyValue QryOrderType;
        public DatePickerRange QryApplyDate = null;
        public String QryCFN;
        public string QryOrderNo;
        public String QryRemark;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;

        public ArrayList RstResultList = null;

        public IList<KeyValue> LstBu = null;
        public ArrayList LstDealer = null;
        public ArrayList LstToDealer = null;
        public ArrayList LstType { get; set; }
        public ArrayList LstStatus { get; set; }
    }
}
