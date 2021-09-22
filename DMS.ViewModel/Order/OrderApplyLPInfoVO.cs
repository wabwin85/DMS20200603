using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Order
{
    public class OrderApplyLPInfoVO : BaseQueryVO
    {
        //增加产品
        public bool IsNewApply;//是否是新申请
        public bool IsPageNew;//是否新增
        public string DealerType;//经销商类型

        public string InstanceId;
        public KeyValue QryPickUpOrDeliver;
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
        public string QryCurrency;
        public string QryCrossDock;

        public string QryTotalAmount;
        public string QryTotalQty;
        public string QryTotalReceiptQty;
        public string QryVirtualDC;
        public string QryRemark;
        public string hidSpecialPrice;
        public KeyValue QrySpecialPrice;//政策
        public string QrySpecialPriceCode;
        public string QryPolicyContent;
        public string QryContactPerson;
        public string QryContact;
        public string QryContactMobile;
        public string QryRejectReason;
        public bool QryPickUp;//自提
        public bool QryDeliver;//送货/承运商承运
        public KeyValue QryWarehouse;//收货仓库
        public KeyValue QryShipToAddress;//收货地址
        public string hidSAPWarehouseAddress;
        public string QryTexthospitalname;//医院名称
        public string QryHospitalAddress;//医院地址
        public string QryConsignee;
        public string QryConsigneePhone;
        //public string Texthospitalname;
        //public string HospitalAddress;
        public string QryRDD;
        public string QryCarrier;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstDealerList = null;
        public ArrayList RstLogDetail = null;
        public ArrayList RstProductDetail = null;
        public ArrayList RstInvoiceDetail = null;
        public ArrayList RstShipDetail = null;//发货明细
        public IList<KeyValue> LstBu = null;
        public ArrayList LstDealer = null;
        public ArrayList LstWarehouse = null;
        public ArrayList LstShipToAddress = null;//收货地址
        public ArrayList LstOrderType = null;
        public ArrayList LstPointType = null;
        public ArrayList LstAttachmentList;
        public ArrayList LstSpecialPrice;//表头信息政策集合
        // public ArrayList EntityModel = null;
        public string EntityModel = null;

        public string AttachmentId;
        public string AttachmentName;

        public bool IscfnDialog;//添加产品属于那种类型
        public string hidDealerType;
        public string hidOrderType;
        public string hidOrderStatus;
        public string hidTerritoryCode;
        public string hidLatestAuditDate;
        public string hidWarehouse;
        public string hidVenderId;
        public string hidProductLine;
        public string hidPriceType;
        public string hidDealerId;
        public string Dealer;
        public string hidWareHouseType;
        public string hidPohId;
        public string hidDealerTaxpayer;//是否直销医院
        public string hidCreateType;
        public string hidUpdateDate;
        public string hidPointType;
        public string hidIsUsePro;
        public bool UseProStatus;//促销状态
        public string hidpayment;
        public string hidpaymentType;
        public string hidPointCheckErr;//积分使用状态
        public string hidRtnVal;
        public string hidRtnMsg;
        public string BOMQtyMsg;
        public string LotId;//产品明细Id
        public string PickerParams;
        public string CheckpickearrParams;
        public string EditRowParams;

        //更新产品明细
        public string EditItemId;
        public string EditLot;
        public string EditUpn;
        public string EditCfnPrice;
        public string EditQty;
    }
}
