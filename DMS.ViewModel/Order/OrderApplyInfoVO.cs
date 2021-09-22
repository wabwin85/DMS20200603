using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Order
{
    public class OrderApplyInfoVO : BaseQueryVO
    {
        //增加产品
        public bool IsNewApply;//是否是新申请
        public bool IsPageNew;//是否新增
        public string DealerType;//经销商类型

        public string InstanceId;
        public KeyValue QryOrderType;
        public string QryOrderNO;
        public KeyValue QryPointType;//积分分类
        public KeyValue QryProductLine;
        public string QryOrderStatus;
        public KeyValue QryDealer;
        public string QryOrderTo;
        public string QrySubmitDate;
        public KeyValue QryPaymentTpype;
        public string QrySales;

        public string QryTotalAmount;
        public string QryTotalQty;
        public string QryTotalReceiptQty;
        public string QryRemark;
        public string QryContactPerson;
        public string QryContact;
        public string QryContactMobile;
        public string QryRejectReason;
        public KeyValue QryWarehouse;
        public string QryShipToAddress;
        public string QryConsignee;
        public string QryConsigneePhone;
        public string QryRDD;
        public string QryCarrier;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstDealerList = null;
        public ArrayList RstLogDetail = null;
        public ArrayList RstProductDetail = null;
        public ArrayList RstShipDetail = null;
        public IList<KeyValue> LstBu = null;
        public ArrayList LstDealer = null;
        public ArrayList LstWarehouse = null;
        public ArrayList LstOrderType = null;
        public ArrayList LstPointType = null;
        public ArrayList LstAttachmentList;
        // public ArrayList EntityModel = null;
        public string EntityModel = null;

        public string AttachmentId;
        public string AttachmentName;

        public bool IscfnDialog;//添加产品属于那种类型
        public string hidOrderType;
        public string hidOrderStatus;
        public string hidTerritoryCode;
        public string hidLatestAuditDate;
        public string hidWarehouse;
        public string hidVenderId;
        public string hidProductLine;
        public string hidPriceType;
        public string hidSpecialPriceId;
        public string hidDealerId;
        public string hidWareHouseType;
        public string hidPointType;
        public string hidpayment;
        public string hidpaymentType;
        public string hidPointCheckErr;//积分使用状态
        public bool IsExistsPaymentTypBYDma;//如果是普通订单，且经销商在表中有记录，要选择付款方式
        public string hidRtnVal;
        public string hidRtnMsg;
        public string LotId;//产品明细Id
        public string PickerParams;
        public string CheckpickearrParams;
        public string EditRowParams;

        public string ItemId;
        public string RequiredQty;
        public string Amount;

    }
    public class EditRowInfo
    {
        public string Id;
        public string RequiredQty;
        public string Amount;
    }
}
