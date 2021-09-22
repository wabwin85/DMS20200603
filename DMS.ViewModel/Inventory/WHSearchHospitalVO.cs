using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Inventory
{
    public class WHSearchHospitalVO : BaseQueryVO
    {
        public KeyValue QryHPLevel;
        public KeyValue QryHPProvince;
        public KeyValue QryHPRegion;
        public KeyValue QryHPTown;
        public String QryHPName;

        public ArrayList RstResultList = null;
        public ArrayList LstHPLevel = null;
        public ArrayList LstHPProvince = null;
        public ArrayList LstHPRegion = null;
        public ArrayList LstHPTown = null;
        
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
