using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;


namespace DMS.ViewModel.Consign
{
    public class ConsignInventoryAdjustPickerVO : BaseQueryVO
    {
        public KeyValue QryWarehouse;
        public String QryLotNumber;
        public String QryProductModel;
        public String QryTwoCode;
        public String QryProductLine;
        public String QryDealer;


        public ArrayList RstResultList = null;
        public ArrayList LstProduct = null;
        public ArrayList LstWarehouse = null;
    }
}
