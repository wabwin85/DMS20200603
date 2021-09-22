using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Order
{
    public class OrderApplyLPImportVO : BaseQueryVO
    {
        public bool ImportButtonDisable;//DB是否可用
        public bool IsFirstload;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public string Id;
        public string OrderType;
        public string articleNumber;
        public string RequiredQty;
        public string lotNumber;
        public string Amount;
        public string ProductLine;
        public string PointType;
    }
}
