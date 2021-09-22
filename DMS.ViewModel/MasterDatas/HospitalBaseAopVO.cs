
using System;
using System.Collections.Generic;
using System.Collections;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.MasterDatas
{
    public class HospitalBaseAopVO : BaseQueryVO
    {
        public KeyValue QryBu;
        public String QryYear;
        public String QryHospitalNbr;
        public String QryHospitalName;
        public String DeleteAOPHRID = String.Empty;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public IList<KeyValue> ListBu = null;
    }
}
