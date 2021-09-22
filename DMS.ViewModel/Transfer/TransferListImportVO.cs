using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Transfer
{
    public class TransferListImportVO : BaseQueryVO
    {
        public bool ImportButtonDisable;//DB是否可用
        public bool IsFirstload;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public string Id;
        public string DealerFrom;
        public string DealerTo;
        public string WarehouseFrom;
        public string WarehouseTo;
        public string ArticleNumber;
        public string LotNumber;
        public string QRCode;
        public string TransferQty;
    }
}
