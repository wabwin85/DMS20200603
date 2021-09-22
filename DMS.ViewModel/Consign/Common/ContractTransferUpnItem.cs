using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Consign.Common
{
    public class ContractTransferUpnItem
    {
        [LogAttribute]
        public String DetailId;
        [LogAttribute]
        public String UpnId;
        [LogAttribute]
        public String UpnNo;
        [LogAttribute]
        public String UpnShortNo;
        [LogAttribute]
        public String UpnName;
        [LogAttribute]
        public String UpnEngName;
        [LogAttribute]
        public String Unit;
        [LogAttribute]
        public int Quantity;
        [LogAttribute]
        public int ConfirmQuantity;
        public int Difference;
        [LogAttribute]
        public decimal Price;
        [LogAttribute]
        public decimal Total;
        [LogAttribute]
        public String DOM;
        [LogAttribute]
        public DateTime? ExpiredDate;
    }
}
