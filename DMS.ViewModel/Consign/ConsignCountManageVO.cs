
using System;
using System.Collections.Generic;
using System.Collections;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.Consign
{
    public class ConsignCountManageVO : BaseQueryVO
    {
        public String QryDealer = String.Empty;
        public String QryUpn = String.Empty;        
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public List<string> CQIDList = new List<string>();

        public String AddCQID = null;
        public KeyValue AddDealer = null;
        public KeyValue AddUpn = null;
        public DatePickerRange AddValidity = null;
        public Decimal? AddAmount = 0;
        public Decimal? AddTotal = 0;

        public ArrayList LstUpn = null;
    }
}
