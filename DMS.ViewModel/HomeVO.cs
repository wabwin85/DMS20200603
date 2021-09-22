using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;

namespace DMS.ViewModel
{
    public class HomeVO: BaseQueryVO
    {
        public bool IsAdmin;

        public String IptUserName;
        public String IptUserMobile;

        public String IptDealerName;
        public String IptAccount;

        public String IptSubCompanyName;
        public String IptSubCompanyId;

        public String IptBrandName;
        public String IptBrandId;

        public String IptPhone;

        public String IptEmail;

        public bool IsWechat;
        public bool IsDisclosure;
        public bool IsShipment;
        public String IptShipmentMessage;
        public String IptShipmentNo;
        public bool IsNearEffect;

        public IList<Hashtable> LstMenuList;
        public IList<Hashtable> LstDealerList;
        public ArrayList LstSubCompany;
        public ArrayList LstBrand;

        public ArrayList RstNearEffect;
    }
}
