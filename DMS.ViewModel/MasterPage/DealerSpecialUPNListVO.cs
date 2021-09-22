using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.MasterPage
{
    public class DealerSpecialUPNListVO : BaseQueryVO
    {

        public KeyValue IptDealer;

        public KeyValue QryDealerType;

        public ArrayList LstDealerType = null;

        public ArrayList RstResultList = null;
    }
}
