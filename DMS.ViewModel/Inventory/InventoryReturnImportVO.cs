using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Inventory
{
    public class InventoryReturnImportVO : BaseQueryVO
    {
        public bool IsFirstload;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public string Id;
        public string warehouse;
        public string articleNumber;
        public string returnQty;
        public string lotNumber;
        public string qrCode;
        public string purchaseOrderNbr;

    }
}
