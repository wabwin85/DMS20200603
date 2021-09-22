using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.MasterDatas
{
    public class OperationManualManageVO : BaseQueryVO
    {
        public String QryManualName;

        public IList<Hashtable> RstResultList = null;

        public ArrayList LstManualID = null;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
