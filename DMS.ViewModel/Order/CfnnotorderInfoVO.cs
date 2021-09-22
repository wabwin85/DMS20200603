using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Order
{
    public class CfnnotorderInfoVO : BaseQueryVO
    {
        public KeyValue QryDealer;
        public String QryCFN;
        public bool cbDealerDisabled;
        public string hidDealerId;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;

        public ArrayList RstResultList = null;
        public ArrayList LstDealer = null;
    }
}
