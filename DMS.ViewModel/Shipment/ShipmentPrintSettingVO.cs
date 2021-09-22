using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Shipment
{
    public class ShipmentPrintSettingVO : BaseQueryVO
    {
        public String HidInstanceId;
        public String HidIsNew;
        public bool SwCertificateName;
        public bool SwEnglishName;
        public bool SwProductType;
        public bool SwLot;
        public bool SwExpiryDate;
        public bool SwShipmentQty;
        public bool SwUnit;
        public bool SwUnitPrice;
        public bool SwCertificateNo;
        public bool SwCertificateENNo;
        public bool SwStartDate;
        public bool SwExpireDate;
    }
}
