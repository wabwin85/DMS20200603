
using System;
using System.Collections.Generic;
using System.Collections;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.DealerTrain
{
    public class SalesUserManageVO : BaseQueryVO
    {
        public String QryDealer = String.Empty;
        public String QrySale = String.Empty;        
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public List<string> DealerSalesIDList = new List<string>();

        public String AddDealerSalesID = null;
        public KeyValue AddDealer = null;
        public String AddSalesName = String.Empty;
        public String AddSalesEmail = String.Empty;
        public String AddSalesPhone = String.Empty;
        public bool AddSalesSex = true;
    }
}
