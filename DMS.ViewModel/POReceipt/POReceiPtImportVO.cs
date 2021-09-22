using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.POReceipt
{
    public class POReceiPtImportVO : BaseQueryVO
    {
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public string batchNumber;

    }
}
