
using System;
using System.Collections.Generic;
using System.Collections;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.MasterDatas
{
    public class OrderDealerPriceVO : BaseQueryVO
    {
        public KeyValue QryBu;
        public String QryUPN = String.Empty;
        public string hidInitDealerId;
        public string DealerType;
        public KeyValue QryDealer;
        public KeyValue QryPriceType;
        public KeyValue QryProvince;
        public KeyValue QryCity;
        public String DeleteCFNPID = String.Empty;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public IList<KeyValue> ListBu = null;
        public ArrayList ListPriceType = null;
        public ArrayList ListProvince = null;
        public ArrayList ListCity = null;
        public ArrayList LstDealer = null;
    }
}
