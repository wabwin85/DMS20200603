using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Report
{
    public class DealerBuyInReport_NewVO : BaseQueryVO
    {

        public KeyValue QryProductLine;

        public DatePickerRange QryApplyDate;

        public DatePickerRange QrySubmitDate;

        public String QryProductModel;

        public String QryBatchNo;

        public ArrayList LstProductLine;
      
        public ArrayList RstResultList;
    }
}
