using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.MasterDatas
{
    public class ConsignmentMasterListVO : BaseQueryVO
    {
        public bool SearchEnabled;
        public bool InsertEnable = true;
        public KeyValue QryBu;
        public KeyValue QryDealer;
        public KeyValue QryType;
        public KeyValue QryStatus;
        public DatePickerRange QryApplyDate = null;
        public String QryOrderNo;
        public String QryProductType;
        public string QryConsignmentName;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;

        public ArrayList RstResultList = null;

        public IList<KeyValue> LstBu = null;
        public ArrayList LstDealer = null;
        public ArrayList LstType { get; set; }
        public ArrayList LstStatus { get; set; }
    }
}
