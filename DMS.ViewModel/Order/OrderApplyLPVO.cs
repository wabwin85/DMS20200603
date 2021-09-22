using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Order
{
    public class OrderApplyLPVO : BaseQueryVO
    {
        public bool SerchVisibile = true;
        public bool InsertDisabled = true;
        public string TemporaryId;//修改操作临时Id
        public bool btnImportDisabled = true;
        public bool btnStockpriceDisabled = true;
        public bool cbDealerDisabled;
        public string hidCorpType;
        public string hidInitDealerId;
        public string hidNewOrderInstanceId;
        public string hidRtnVal;
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
        public ArrayList LstShipToAddress { get; set; }
    }
}
