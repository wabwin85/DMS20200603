using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.MasterDatas
{
    public class ConsignmentAuthorizationListVO : BaseQueryVO
    {
        public bool SearchEnabled;
        public bool InsertEnabled;
        public KeyValue QryBu;
        public KeyValue QryDealer;
        public KeyValue QryStatus;
        public KeyValue QryConsignmentRules;

        public ArrayList RstResultList = null;

        public IList<KeyValue> LstBu = null;
        public ArrayList LstDealer = null;
        public ArrayList LstConsignmentRules = null;
        public IList<KeyValuePair<string, string>> LstStatus { get; set; }

        public String InstanceId;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        //弹窗
        public KeyValue WQryBu;
        public KeyValue WQryDealer;
        public KeyValue WQryStatus;
        public KeyValue WQryConsignmentRules;
        public string  WQryBeginDate;
        public string WQryEndDate;
        public ArrayList WRstResultList = null;
        public ArrayList WLstBu = null;
        public ArrayList WLstDealer = null;
        public ArrayList WLstConsignmentRules = null;
        public IList<KeyValuePair<string, string>> WLstStatus { get; set; }
    }
}
