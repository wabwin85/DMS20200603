using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Transfer
{
    public class TransferListVO : BaseQueryVO
    {
        public bool InsertEnable = true;
        public string hidInitDealerId;
        public KeyValue QryBu;
        public KeyValue QryDealerFrom;
        public KeyValue QryDealerTo;
        public KeyValue QryTransferStatus;
        public KeyValue QryTransferType;
        public DatePickerRange QryApplyDate = null;
        public String QryLotNumber;
        public String QryCFN;
        public string QryTransferNumber;
        public string QryLPUploadNo;//平台上传单号
        public bool ShowSerch = true;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;

        public ArrayList RstResultList = null;

        public IList<KeyValue> LstBu = null;
        public ArrayList LstDealer = null;
        public ArrayList LstToDealer = null;
        public ArrayList LstType { get; set; }
        public ArrayList LstStatus { get; set; }


    }
}
