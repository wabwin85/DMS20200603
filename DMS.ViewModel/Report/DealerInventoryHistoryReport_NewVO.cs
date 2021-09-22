using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Report
{
    public class DealerInventoryHistoryReport_NewVO : BaseQueryVO
    {
        public KeyValue QryDealer;

        public DatePickerRange QryApplyDate;

        public ArrayList LstDealer;

        //public bool CanActiveDealer;

        public ArrayList RstResultList;
    }
}
