using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.MasterDatas
{
    public class TerritoryEditorVO : BaseQueryVO
    {        
        public KeyValue IptProvince;
        public KeyValue IptCity;
        public String IptTerId;
        public String IptTerName;
        public String IptTerCode;
        public KeyValue IptTerType;

        public String ChangeType;

        public ArrayList LstTerType = null;
        public ArrayList LstProvince = null;
        public ArrayList LstCity= null;        
        
    }
}
