using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Report
{
    public class DealerSalesReport_NewVO : BaseQueryVO
    {

        public KeyValue QryProductLine;

        public DatePickerRange QryApplyDate;

        public KeyValue QryStatus;

        public String QryProductModel;

        public String QryBatchNo;

        public ArrayList LstProductLine;

        public ArrayList LstStatus;

        public ArrayList RstResultList;
    }
}
