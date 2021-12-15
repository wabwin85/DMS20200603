using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.MasterDatas.Extense
{
    public class InvHospitalCfgInitVO: BaseQueryVO
    {
        public Guid Id; 
        public string Province;
        public string City;
        public string District;
        public string DMSHospitalName;
        public string InvHospitalName;
        public string Hos_Code;
        public string Hos_SFECode;
        public string Hos_Province;
        public string Hos_City;
        public string Hos_District;

        public string ErrorMsg;
        public bool? IsError;
        public string QryCFN;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;

        public string Msg; 
        public ArrayList RstResultList;
    }
}
