using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.POReceipt
{
    public class POReceiptListInfoVO : BaseBusinessVO
    {
        [LogAttribute]
        public String IptSapNumber;//发货单
        [LogAttribute]
        public string IptDealer;
        [LogAttribute]
        public String IptStatus;
        [LogAttribute]
        public String IptPoNumber;//收货单
        [LogAttribute]
        public String IptVendor;//发货方
        [LogAttribute]
        public String IptSapShipmentDate;//发货时间

        public string DealerType;
        public String IptFormStatus;//单据状态
        public String IptCarrier;//承运方
        public String IptTrackingNo;//运单号
        public String IptShipType;//运输方式
        public String IptWarehouse;//仓库
        public String IptWhmId;//仓库Id
        public String IptFromWarehouse;//发货仓库
        public ApplyBasic IptApplyBasic;
        public bool CheckCreateUser;

        public ArrayList RstContractDetail;
        public ArrayList RstLogDetail;
        public ArrayList LstWarehouse = null;
        public bool CancelButton = false;//Disabled
        public bool SaveButton = false;//Disabled
    }
}
