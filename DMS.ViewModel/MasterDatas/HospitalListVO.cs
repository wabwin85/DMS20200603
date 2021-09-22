using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.MasterDatas
{
    public class HospitalListVO : BaseQueryVO
    {
        public KeyValue QryHPLGrade;
        public KeyValue QryHPLProvince;
        public KeyValue QryHPLRegion;
        public KeyValue QryHPLTown;
        public String QryHPLName;
        public String QryHPLDean;

        public ArrayList RstResultList = null;
        public ArrayList LstHPLGrade = null;
        public ArrayList LstHPLProvince = null;
        public ArrayList LstHPLRegion = null;
        public ArrayList LstHPLTown = null;

        public ArrayList LstHosID = null;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
