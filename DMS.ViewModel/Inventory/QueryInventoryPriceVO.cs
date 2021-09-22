using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Inventory
{
    public class QueryInventoryPriceVO : BaseQueryVO
    {
        public KeyValue QryDealer;
        public KeyValue QryWarehouse;
        public KeyValue QryProductLine;
        public String QryProductModel;
        public String QrySNQrCode;
        public String QryProductName;
        public String QryStockdays;
        public DatePickerRange QryValidityDate;
        public string lblInvSum;

        public ArrayList RstResultList = null;

        public ArrayList LstDealer = null;
        public ArrayList LstWarehouse = null;
        public IList<KeyValue> LstProductLine = null;

        public String DealerType;
        public String DealerId;
        public bool IsShowQuery;

        public String Lot;
        public String Prop;
        public String Upn;
        public String DownName;
        public String FileName;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
