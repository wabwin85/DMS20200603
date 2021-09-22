using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Consign
{
    public class ConsignInventoryAdjustHeaderListVO : BaseQueryVO
    {

        public KeyValue QryProductLine;

        public String QryDealer;

        public KeyValue QryType;

        public DatePickerRange QryApplyDate;

        public String QryApplyNo;

        public KeyValue QryST;

        public String QryProductModel;

        public String QryProductBatchNo;

        public String QryTwoCode;

        public String QryBillNo;

        public String QryRemark;

        public ArrayList LstProductLine;


        public ArrayList LstType;

        public IList<KeyValuePair<string, string>> LstStatus { get; set; }

      
        public ArrayList RstResultList;
    }
}
