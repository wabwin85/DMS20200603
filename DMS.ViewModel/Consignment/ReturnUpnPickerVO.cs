using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Consignment
{
    public class ReturnUpnPickerVO : BaseQueryVO
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
