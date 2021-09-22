using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Contract
{
    public class HospitalPickerVO : BaseQueryVO
    {
        public String QryProvince;
        public String QryCity;
        public String QryDistrict;
        public String QryHospitalName;
        public String QryHospitalLevel;
        public String QrySelectedProductLine;
        public String QryInstanceId;
        public String parentId;

        public ArrayList RstResultProvincesList = null;
        public ArrayList RstResultCityList = null;
        public ArrayList RstResultAreaList = null;
        public ArrayList RstResultList = null;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;

        public String QryFilter;
        public ArrayList LstUPN = null;
        public ArrayList LstBu = null;
        public ArrayList LstHospitalLevel = null;
    }
}
