using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.MasterDatas
{
    public class ConsignmentMasterDealerPickerVO : BaseQueryVO
    {
        public string QryBu;
        public string QryBuName;
        public string DivisionCode;
        public string QryDealerName;
        public string InstanceId;
        public KeyValue FilterDealer;
        public string QrySAPCode;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;

        public ArrayList RstResultList = null;
        public  IList<KeyValuePair<string, string>> RstDealerType { get; set; }
    }
}
