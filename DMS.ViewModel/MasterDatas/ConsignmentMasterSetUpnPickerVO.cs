using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.MasterDatas
{
    public class ConsignmentMasterSetUpnPickerVO : BaseQueryVO
    {
        public String QryBu;
        public String QryDealer;
        public String QryUPN;
        public String QryUpnChineseName;
        public String QryType;
        public KeyValue QryQueryType;

        public ArrayList RstResultListSet = null;
        public String QryFilter;
        public ArrayList LstUPN = null;
        public ArrayList LstBu = null;

        public string InstanceId;
        public string QryProductLine;
        public string CfnSetId;
        public string Param;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public ArrayList RstResultDetailList = null;
    }
}
