
using System;
using System.Collections.Generic;
using System.Collections;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.MasterDatas
{
    public class ConsignmentCfnSetCFNVO : BaseQueryVO
    {
        public String QryCFN = String.Empty;
        public KeyValue QryIsInclude = new KeyValue();
        public KeyValue QryBu = new KeyValue();
        public ArrayList LstBu = null;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
    }
}
