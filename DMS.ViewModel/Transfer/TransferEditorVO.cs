using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Transfer
{
    public class TransferEditorVO : BaseQueryVO
    {
        public bool InsertEnable = true;
        public string hidInitDealerId;
        public KeyValue QryBu;
        public KeyValue QryDealer;
        public KeyValue QryTransferStatus;
        public KeyValue QryTransferType;
        public DatePickerRange QryApplyDate = null;
        public String QryLotNumber;
        public String QryCFN;
        public string QryTransferNumber;
        public bool ShowSerch = true;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;

        public ArrayList RstResultList = null;

        public IList<KeyValue> LstBu = null;
        public ArrayList LstDealer = null;
        public ArrayList LstType { get; set; }
        public ArrayList LstStatus { get; set; }
    }
}
