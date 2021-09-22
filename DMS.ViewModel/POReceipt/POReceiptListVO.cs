using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.POReceipt
{
    public class POReceiptListVO : BaseQueryVO
    {
        public bool SerchVisibile = true;
        public bool DealerDisabled = true;
        public bool btnImportHidden = true;

        public string hidDealer;
        public KeyValue QryBu;
        public KeyValue QryDealer;
        public KeyValue QryType;
        public KeyValue QryStatus;
        public string QryBeginDate;
        public string QryEndDate;
        public String QryDeliveryOrderNo;
        public String QryProductType;
        public String QryLotNumber;
        public String QryPurchaseOrderNo;//采购单号
        public String QryERPNbr;
        public String QryERPLineNbr;
        public bool IsDealer;
        public string DealerType;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;

        public IList<KeyValue> LstBu = null;
        public ArrayList LstDealer = null;
        public IList<KeyValuePair<string, string>> LstType { get; set; }
        public IList<KeyValuePair<string, string>> LstStatus { get; set; }
    }
}
