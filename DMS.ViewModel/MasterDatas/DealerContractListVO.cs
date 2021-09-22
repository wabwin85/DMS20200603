
using System;
using System.Collections.Generic;
using System.Collections;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.MasterDatas
{
    public class DealerContractListVO : BaseQueryVO
    {
        public KeyValue QryDealer;
        public String QryContractNumber = String.Empty;
        public String QryContractYears = String.Empty;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public ArrayList ListDealer = null;

        public String DeleteDealerContractID = null;

        public String AddDealerContractID = null;
        public KeyValue AddDealer = null;
        public String AddContractNumber = String.Empty;
        public String AddContractYears = String.Empty;
        public DateTime AddStartDate;
        public DateTime AddStopDate;
    }
}
