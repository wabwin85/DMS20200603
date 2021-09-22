using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Inventory
{
    public class InventoryAdjustList_NewVO : BaseQueryVO
    {
        [LogAttribute]
        public KeyValue IptProductLine;
        [LogAttribute]
        public String IptNo;
        [LogAttribute]
        public KeyValue IptDealer;
        [LogAttribute]
        public String IptStatus;
        [LogAttribute]
        public String IptAdjustDate;
        [LogAttribute]
        public bool IptIsUseDiscount;
        [LogAttribute]
        public String IptAdjustReason;
        [LogAttribute]
        public String IptAuditorNotes;
        public KeyValue IptAdjustType;

        public bool IsNewApply;
        public bool hiddenIsRtnValue;
        public string hiddenAdjustTypeId;
        public string EntityModel;
        public String IptApplyPeople;
        public String IptApplyDate;
        public String QryStatus;
        public String InstanceId;
        public String IptNewID;
        public ApplyBasic IptApplyBasic;
        public bool CheckCreateUser;
        public IList<KeyValue> LstBu;

        public IList<Consign.Common.ConsignContractUPN> LstContractDetail;
        public ArrayList RstContractDetail;
        public ArrayList LstDealer = null;
        public ArrayList LstStatus = null;
        public ArrayList LstType = null;
        public ArrayList RstLogDetail = null;

        public string warnMsg;

        public String LotId;
        public String CFN;
        public String lotNumber;
        public String expiredDate;
        public String adjustQty;
        public String EditQrCode;


        public string ProductStrParams;
        public string hiddenDealerId;
        public string cbWarehouse1;
        public string cbWarehouse2;
        public string hiddenDialogAdjustId;
        public string hiddenDialogAdjustType;
        public string hiddenDialogDealerId;
        public string hiddenProductLineId;
        public string hiddenWarehouseType;
        public string hiddenReturnApplyType;
    }
}
