using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Inventory
{
    public class DealerComplainForGoodsRetrunCRMVO : BaseQueryVO
    {

        public KeyValue QryDealer = null;
        public KeyValue QryStatus = null;
        public String QryComplainNumber = String.Empty;
        public DatePickerRange QrySubmitDate = null;
        public String QryApplyUser = String.Empty;
        public String QryUPN = String.Empty;
        public String QryLotNumber = String.Empty;
        public String QryDN = String.Empty;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;

        public IList<KeyValuePair<string, string>> LstStatus { get; set; }
    }
}
