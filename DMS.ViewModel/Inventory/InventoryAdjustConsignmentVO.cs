using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Inventory
{
    public class InventoryAdjustConsignmentVO : BaseQueryVO
    {
        public bool InsertVisible;
        public bool SearchVisible;

        public KeyValue QryBu;
        public KeyValue QryDealer;
        public KeyValue QryType;
        public KeyValue QryStatus;
        //public DatePickerRange QryBeginDate;
        //public DatePickerRange QryEndDate;
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
        public ArrayList LstType { get; set; }
        public ArrayList LstStatus { get; set; }
    }
}
