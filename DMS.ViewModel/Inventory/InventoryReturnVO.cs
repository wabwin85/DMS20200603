using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Inventory
{
    public class InventoryReturnVO : BaseQueryVO
    {
        public bool InsertVisible = true;
        public bool InsertConsignment = false;
        public bool InsertBorrow = false;
        public bool BtnResultShow = false;
        public bool DealerDisabled;
        public bool SearchVisible;
        public bool ExportVisible;
        public string DealerId;
        public KeyValue QryBu;
        public KeyValue QryDealer;
        public KeyValue QryReturnType;
        public DatePickerRange QryApplyDate;
        public KeyValue QryAdjustStatus;
        public string QryAdjustNumber;
        public string QryCFN;
        public string QryLotNumber;
        public KeyValue QryDealerType;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;

        public ArrayList RstResultList = null;

        public IList<KeyValue> LstBu = null;
        public ArrayList LstDealer = null;
        public ArrayList LstReturnType { get; set; }
        public ArrayList LstDealerType { get; set; }
        public ArrayList LstAdjustStatus { get; set; }
    }
}
