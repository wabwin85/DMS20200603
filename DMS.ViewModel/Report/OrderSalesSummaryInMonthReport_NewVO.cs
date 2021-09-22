using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Report
{
    public class OrderSalesSummaryInMonthReport_NewVO : BaseQueryVO
    {

        public KeyValue QryProductLine;

        public KeyValue QryYear;

        public ArrayList LstProductLine;
      
        public ArrayList RstResultList;
    }
}
