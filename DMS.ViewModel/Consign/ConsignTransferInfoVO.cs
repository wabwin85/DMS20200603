using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;
using DMS.ViewModel.Consign.Common;
using Lafite.RoleModel.Domain;

namespace DMS.ViewModel.Consign
{
    public class ConsignTransferInfoVO : BaseBusinessVO
    {
        [LogAttribute]
        public ApplyBasic IptApplyBasic;
        [LogAttribute]
        public KeyValue IptBu;
        [LogAttribute]
        public KeyValue IptDealerOut;
        [LogAttribute]
        public KeyValue IptDealerIn;
        [LogAttribute]
        public KeyValue IptHospital;
        [LogAttribute]
        public KeyValue IptSales;
        [LogAttribute]
        public String IptRemark;

        [LogAttribute]
        public ConsignContract IptConsignContract;

        public IList<KeyValue> LstBu;
        public IList<Hashtable> LstConsignContract;

        public IList<String> LstUpn;
        public IList<ContractTransferUpnItem> LstDetailList;

        [LogAttribute]
        public IList<ContractTransferUpnItem> RstDetailList;
        public IList<ContractTransferConfirmList> RstConfirmList;
    }
}
