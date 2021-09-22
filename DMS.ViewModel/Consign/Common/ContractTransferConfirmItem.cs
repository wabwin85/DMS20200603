using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Consign.Common
{
    public class ContractTransferConfirmItem
    {
        [LogAttribute]
        public String DetailId;
        [LogAttribute]
        public String LotMasterId;
        [LogAttribute]
        public String UpnId;
        [LogAttribute]
        public String WarehouseId;
        [LogAttribute]
        public String WarehouseName;
        [LogAttribute]
        public String ProductId;
        [LogAttribute]
        public String LotId;
        [LogAttribute]
        public String Lot;
        [LogAttribute]
        public String QrCode;
        [LogAttribute]
        public String DOM;
        [LogAttribute]
        public DateTime? ExpiredDate;
    }
}
