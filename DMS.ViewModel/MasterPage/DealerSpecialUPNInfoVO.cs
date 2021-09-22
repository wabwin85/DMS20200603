using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.MasterPage
{
    public class DealerSpecialUPNInfoVO : BaseQueryVO
    {

        public String InstanceId;

        public String QryFilter;

        public String CFN_ID;

        public ArrayList CFNID;

        public KeyValue QryBu;

        public IList<KeyValue> LstBu = null;

        public ArrayList RstDetailList = null;

    }
}
