using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel
{
    public class MyInfoVO : BaseQueryVO
    {
        //-----------Person---------------
        public String LoginID = String.Empty;
        public String UserName = String.Empty;
        public String Email1 = String.Empty;
        public String Email2 = String.Empty;
        public String Phone = String.Empty;
        public String Address = String.Empty;
        public String CustomField1 = String.Empty;
        public String CustomField2 = String.Empty;
        public String CustomField3 = String.Empty;
        //-----------Order----------------
        public bool IsNewOrder = false;
        public String ORContactPerson = String.Empty;
        public String ORContact = String.Empty;
        public String ORContactMobile = String.Empty;
        public String ORConsignee = String.Empty;
        public String ORConsigneePhone = String.Empty;
        public String OROrderEmail = String.Empty;
        public String ORShipmentDealer = String.Empty;
        public bool ORReceiveSMS = false;
        public bool ORReceiveEmail = false;
        public bool ORReceiveOrder = false;
        //-----------Company--------------
        public bool HasCompany = false;
        public String CPDealerID = String.Empty;
        public String CPDealerChineseName = String.Empty;
        public String CPDealerEnglishName = String.Empty;
        public String CPDealerCertification = String.Empty;
        public String CPDealerAddress = String.Empty;
        public String CPDealerPostalCode = String.Empty;
        public String CPDealerPhone = String.Empty;
        public String CPDealerFax = String.Empty;
    }
}
