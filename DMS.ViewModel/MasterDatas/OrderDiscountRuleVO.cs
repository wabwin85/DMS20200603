
using System;
using System.Collections.Generic;
using System.Collections;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.MasterDatas
{
    public class OrderDiscountRuleVO : BaseQueryVO
    {
        public KeyValue QryBu;
        public String QryUPN = String.Empty;
        public String QryLotNumber = String.Empty;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public IList<KeyValue> ListBu = null;
    }
}
