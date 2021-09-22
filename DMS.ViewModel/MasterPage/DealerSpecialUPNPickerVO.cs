using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.MasterPage
{
    public class DealerSpecialUPNPickerVO : BaseQueryVO
    {
        public KeyValue QryBu;
        public String QryFilter;

        public ArrayList LstBu = null;

        public String InstanceId;

        public ArrayList CFNID;

        public ArrayList RstResultList = null;
    }
}
