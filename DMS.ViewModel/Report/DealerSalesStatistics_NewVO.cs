using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Report
{
    public class DealerSalesStatistics_NewVO : BaseQueryVO
    {
        public KeyValue QryDealer;

        public DatePickerRange QryStartDate;

        public KeyValue QryProductLine;

        public DatePickerRange QryEndDate;

        public KeyValue QryInDueTime;

        public bool QryIsPurchased; 

        public ArrayList LstProductLine;

        public ArrayList LstDealer;

        //public bool CanActiveDealer;

        public ArrayList RstResultList;
    }
}
