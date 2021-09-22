using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Inventory
{
    public class InventoryAdjustListVO : BaseQueryVO
    {
        public bool SearchVisible;
        public bool InsertVisible;
        public bool ImportVisible;
        public bool DealerDisabled;

        public string DealerId;
        public KeyValue QryBu;
        public KeyValue QryDealer;
        public KeyValue QryType;
        public KeyValue QryStatus;
        public string QryBeginDate;
        public string QryEndDate;
        public String QryOrderNo;
        public String QryProductType;
        public String QryLotNumber;
    


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
