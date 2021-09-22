using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.ViewModel.InventoryReturn
{
    public class InventoryReturnBscVO : BaseViewModel
    {
        public String AdjId;
        public String InvoiceNo;
        public String RGANo;
        public String DeliveryNo;
        public String ReasonCode;
        public String ReasonCn;
        public String ReasonEn;
        public String RevokeRemark;
        public String Rev1;
        public String Rev2;
        public String Rev3;
        public String LastUpdateTime;
        public String CurrentNodeIds;

        public KeyValuePair<string, string>[] LstReason;
        public String HtmlString;
    }
}
