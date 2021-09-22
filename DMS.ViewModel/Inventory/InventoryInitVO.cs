using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Inventory
{
    public class InventoryInitVO : BaseQueryVO
    {
        //导入部分
        public String DelErrorId;
        public ArrayList RstInitImportResult = null;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
