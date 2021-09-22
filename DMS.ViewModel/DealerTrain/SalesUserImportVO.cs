
using System;
using System.Collections.Generic;
using System.Collections;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.DealerTrain
{
    public class SalesUserImportVO : BaseQueryVO
    {
        public String QryDealer = String.Empty;
        public String QrySale = String.Empty;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
    }
}
