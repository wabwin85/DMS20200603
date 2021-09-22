using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Consign
{
    public class ConsignInventoryAdjustHeaderInfoVO : BaseBusinessVO
    {
        [LogAttribute]
        public KeyValue IptDealer;
        [LogAttribute]
        public String IptAdjustNumber;
        [LogAttribute]
        public KeyValue IptProductLine;
        [LogAttribute]
        public String IptType;
        [LogAttribute]
        public KeyValue IptBoSales;
        [LogAttribute]
        public String IptStatus;
        [LogAttribute]
        public String IptRemark;
        [LogAttribute]
        public String IptSubMit;

        public IList<KeyValue> LstBu;

        public ArrayList LstDealer;

        public ArrayList LstBoSales;

        public String IptNewID;

        public ArrayList IptLOTID;

        public ArrayList IptPrice;

        public ApplyBasic IptApplyBasic;

        public String IptInstanceId;

        public bool CheckBoSales;

        public bool CheckCreateUser;

        public ArrayList LstInventoryAdjustDetail;

        

    }
}
