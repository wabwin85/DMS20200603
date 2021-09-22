using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Inventory
{
    public class InventoryAdjustListMtrPickerVO : BaseQueryVO
    {
        public string QryInstanceId;//hiddenDialogAdjustId
        public string QryDealerId;//hiddenDialogDealerId
        public string QryProductLineWin;//hiddenDialogProductLineId
        public string QryAdjustType;//hiddenDialogAdjustType
        public string QryWarehouseType;//hiddenWarehouseType
        public string QryReturnApplyType;//hiddenReturnApplyType

        public bool IsCFN;//判断属于哪一种类型
        //类型1
        public KeyValue QryWorehourse;//分仓库
        public string QryLotNumber;
        public string QryCFN;
        public string QryQrCode;
        public string QryUPN;

        //类型2
        public KeyValue QryWarehouse2;//分仓库
        public string QryCFN_CFN;
        public bool QryIsShareCFN;
        public string QryUPN_CFN;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstWarehouseList = null;
        public ArrayList RstResultList = null;
        public ArrayList RstResultDetailList = null;

        public string InstanceId;
        public string DealerParams;
    }
}
