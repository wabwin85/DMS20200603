using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Inventory
{
    public class WarehouseMaintVO : BaseQueryVO
    {
        public KeyValue QryDealer;
        public String QryWarehouse;
        public String QryAddress;

        public ArrayList RstResultList = null;

        public ArrayList LstDealer = null;

        public String DealerId;

        public bool IsShowQuery;
        public bool IsShowAdd;
        public bool IsShowSave;
        public bool IsShowDelete;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
