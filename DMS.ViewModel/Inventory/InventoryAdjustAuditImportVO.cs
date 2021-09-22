using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Inventory
{
    public class InventoryAdjustAuditImportVO : BaseQueryVO
    {
        public bool ImportButtonDisable;//DB是否可用
        public bool IsFirstload;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public string Id;
        public string ChineseName;
        public string Warehouse;
        public string ArticleNumber;
        public string ReturnQty;
        public string LotNumber;
        public string AdjustType;
        public string SAPCode;
        public string QrCode;
    }
}
