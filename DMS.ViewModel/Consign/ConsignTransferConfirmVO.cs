using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;
using DMS.ViewModel.Consign.Common;
using Lafite.RoleModel.Domain;

namespace DMS.ViewModel.Consign
{
    public class ConsignTransferConfirmVO : BaseBusinessVO
    {
        [LogAttribute]
        public ApplyBasic IptApplyBasic;
        [LogAttribute]
        public String IptBu;
        [LogAttribute]
        public String IptDealerOut;
        [LogAttribute]
        public String IptDealerIn;
        [LogAttribute]
        public String IptHospital;
        [LogAttribute]
        public String IptSales;
        [LogAttribute]
        public String IptRemark;

        public String IptUpnId;
        public String IptDetailId;

        [LogAttribute]
        public IList<ContractTransferUpnItem> RstDetailList;
        public IList<ContractTransferConfirmItem> RstInventoryList;
        [LogAttribute]
        public IList<ContractTransferConfirmList> RstConfirmList;
    }
}
