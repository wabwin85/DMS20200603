using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Report
{
    public class OrderStatusReport_NewVO : BaseQueryVO
    {

        public KeyValue QryProductLine;

        public DatePickerRange QryApplyDate;

        public bool QryIsInclude;

        public ArrayList LstProductLine;

        public ArrayList RstResultList;
    }
}
