using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.MasterDatas
{
    public class HospitalEditorVO : BaseQueryVO
    {
        public KeyValue IptHPLGrade;
        public KeyValue IptHPLProvince;
        public KeyValue IptHPLRegion;
        public KeyValue IptHPLTown;
        public String IptHPLName;
        public String IptHPLSName;
        public String IptHPLCode;
        public String IptHosID;
        public String IptHPLPhone;
        public String IptHPLAddress;
        public String IptHPLPostalCOD;
        public String IptHPLDean;
        public String IptHPLDeanContact;
        public String IptHPLHead;
        public String IptHPLHeadContact;
        public String IptHPLWeb;
        public String IptHPLBSCode;

        public String ChangeType;

        public ArrayList LstHPLGrade = null;
        public ArrayList LstHPLProvince = null;
        public ArrayList LstHPLRegion = null;
        public ArrayList LstHPLTown = null;
        
    }
}
