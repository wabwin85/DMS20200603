using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Transfer
{
    public class TransferEditorPickerVO : BaseQueryVO
    {
        public string QryTransferType;
        public string QryInstanceId;
        public string QryDealerFromId;
        public string QryDealerToId;
        public string QryProductLineWin;
        public string QryWarehouseWin;

        public KeyValue QryWorehourse;//分仓库
        public string QryLotNumber;
        public string QryCFN;
        public string QryQrCode;
        public string QryUPN;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstTransferWarehouseList = null;
        public ArrayList RstResultList = null;
        public ArrayList RstResultDetailList = null;

        public string InstanceId;
        public string DealerParams;
    }
}
