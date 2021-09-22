using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Inventory
{
    public class WarehouseEditorVO : BaseQueryVO
    {
        public KeyValue IptWHType;
        public String IptWHName;
        public String IptWHCode;
        public String IptID;
        public String IptDmaID;
        public String IptHosp;
        public String IptWHHospName;
        public bool IptWHActiveFlag;

        public String IptConID;
        public String IptHoldWarehouse;
        public String IptWHProvince;
        public String IptWHCity;
        public String IptWHTown;
        public String IptWHAddress;
        public String IptPostalCOD;
        public String IptWHPhone;
        public String IptWHFax;

        public String ChangeType;
        
        public IList<KeyValue> LstWHType = null;

        public bool EnableHospitalBtn;
        public bool EnableSaveBtn;
        
    }
}
