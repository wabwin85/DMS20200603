using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.POReceipt
{
    public class DeliveryNoteListVO: BaseQueryVO
    {
        public KeyValue QryDealer;
        public KeyValue QryType;
        public DatePickerRange QryPOreceiptDate;
        public String QryDeliveryNoteNbr;
        public String QryPONbr;
        public String QrySapCode;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;

        public ArrayList LstQType= null;
        public ArrayList LstDealer = null;
    }
}
