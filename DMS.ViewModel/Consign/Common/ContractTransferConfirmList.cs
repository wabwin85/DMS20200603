using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Consign.Common
{
    public class ContractTransferConfirmList
    {
        [LogAttribute]
        public String UpnId;
        [LogAttribute]
        public IList<ContractTransferConfirmItem> ItemList;
    }
}
