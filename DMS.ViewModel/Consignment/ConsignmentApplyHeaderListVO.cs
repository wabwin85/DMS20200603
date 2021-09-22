using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Consignment
{
    public class ConsignmentApplyHeaderListVO : BaseQueryVO
    {
        public bool InsertVisible;
        public bool DealerDisabled;
        public string DealerType;
        public KeyValue QryBu;
        public KeyValue QryDealer;
        public KeyValue QryType;
        public KeyValue QryStatus;
        //public DatePickerRange QryBeginDate;
        //public DatePickerRange QryEndDate;
        public string QryBeginDate;
        public string QryEndDate;
        public String QryOrderNo;
        public String QryProductType;
        public KeyValue QryDelayStatus;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;

        public ArrayList RstResultList = null;

        public IList<KeyValue> LstBu = null;
        public ArrayList LstDealer = null;
        public IList<KeyValuePair<string, string>> LstType { get; set; }
        public IList<KeyValuePair<string, string>> LstStatus { get; set; }
        public IList<KeyValuePair<string, string>> LstDelayStatus { get; set; }
    }
}
