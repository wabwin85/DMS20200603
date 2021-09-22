using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.MasterDatas
{
    public class ConsignmentMasterListInfoVO : BaseQueryVO
    {
        public bool IsNewApply;
        public string QryApplyType;
        public string InstanceId;
        public string QryConsignmentName;
        public string QryBu;
        public string QrySubmitDate;
        public string QryOrderNo;
        public string QryOrderStatus;


        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstDealerList = null;
        public ArrayList RstLogDetail = null;
        public ArrayList RstProductDetail = null;

        // public ArrayList EntityModel = null;
        public string EntityModel = null;
        public string EditRows;
        public IList<KeyValue> LstBu;
        public ArrayList LstType;
        public ArrayList LstStatus;

        public ArrayList LstSalesRepStor = null;//产品线下的销售
        public ArrayList LstDealerConsignment = null;//寄售合同
        public ArrayList LstSAPWarehouseAddress = null;//经销商仓库
        public ArrayList LstcbProductsource;

        public string hidRtnVal;
        public string hidRtnMsg;
        public ArrayList LstProlineDma = null;//产品线下经销商
        public ArrayList Lstcbproline = null;
        public ArrayList LstcbHospital = null;
        public ArrayList LstDealer = null;

        public string DealerParams;
        public string DealerCmId;

        public string PlineItemId;
        public string PlineItemNum;
        public string DealerItemId;
        public string RequiredQty;

    }
    public class ConsignmentMasterListInfo
    {
        public string InstanceId;
        public string ProductLineId;
        public string OrderType;
        public string Remark;
        public string ConsignmentName;
        public string ConsignmentDay;
        public string DelayTime;
        public string StartDate;
        public string EndDate;

    }
}
