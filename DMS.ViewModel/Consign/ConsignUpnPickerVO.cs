using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Consign
{
     public  class ConsignUpnPickerVO : BaseQueryVO
    {

        public String QryBu;
        public String QryDealer;
        public String QryUPN;
        public String QryUpnChineseName;
        public String QryType;
        public KeyValue QryQueryType;

        public ArrayList RstResultList = null;
        public ArrayList RstResultListSet = null;
        public String QryFilter;
        public ArrayList LstUPN = null;
        public ArrayList LstBu = null;
       


    }
}
