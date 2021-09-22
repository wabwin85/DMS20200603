
using System;
using System.Collections.Generic;
using System.Collections;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.MasterDatas
{
    public class OrderDiscountRuleImportVO : BaseQueryVO
    {
        //public string ProductLineName;
        //public string SAPCode;
        //public string DealerName;
        //public string Upn;
        //public string Lot;
        //public int? LeftValue;
        //public int? RightValue;
        //public decimal? DiscountValue;
        //public DateTime? BeginDate;
        //public DateTime? EndDate;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
    }
}
