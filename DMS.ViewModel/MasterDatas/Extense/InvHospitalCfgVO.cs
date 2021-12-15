using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.MasterDatas.Extense
{
    public class InvHospitalCfgVO: BaseQueryVO
    {
        public Guid InvHosId;
        public KeyValue Province { get; set; }

        public KeyValue City { get; set; }

        public KeyValue District { get; set; }

        public ArrayList LstProvinces = null;

        public ArrayList LstCities = null;

        public ArrayList LstDistricts = null;

        public ArrayList RstResultList = null;

        public string HospitalName { get; set; } 

        public string Msg { get; set; }

        public string DeleteSeleteIDs { get; set; }

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0; 
    }
}
