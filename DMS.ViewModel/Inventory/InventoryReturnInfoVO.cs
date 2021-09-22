using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Inventory
{
    public class InventoryReturnInfoVO : BaseQueryVO
    {
        //增加产品
        public bool IsNewApply;//是否是新申请
        public string UserIdentityType;
        public string UserCorpType;
        public string hiddenReturnType;
        public string hiddenDealerId;
        public string hiddenDealerType;
        public string hiddApplyType;
        public string hiddenProductLineId;
        public string hidSalesAccount;
        public string hiddenReason;
        public string hiddenWhmType;
        public string hiddenIsRsm;
        public string hiddenAdjustTypeId;
        public bool DdsHidden = false;//特殊处理
        public string InstanceId;
        public string QryAdjustType;//首页参数，判断是什么新增类型
        public string QryAdjustDateWin;
        public string QryAdjustNumberWin;
        public string QrytAdjustStatusWin;
        public KeyValue QryDealerWin;//经销商
        public KeyValue QryProductLineWin;//产品线
        public KeyValue QryRsm;
        public KeyValue QryReturnReason;//选择原因
        public string QryAdjustReasonWin;//备注
        public string QryAduitNoteWin;//审批意见
        public KeyValue QryApplyType;//退货类型
        public KeyValue QryReturnTypeWin;//退换货要求
        public string lblInvSum;//产品明细说明
        public string CorpType;
        public string CorpId;
        public bool LPGoodsReturnApprove;
        public bool RsmHidden;//Rsm是否隐藏
        public bool ReturnReasonHidden;//选择原因是否隐藏

        public string LotId;//每一行产品Id
        public string PmaId;
        public string LotNumber;
        public string QRCode;
        public ArrayList LstPurchase;//产品明细关联订单下拉
        public ArrayList LstToDealer;//产品明细转移经销商下拉
        public string PickStatus;
        public string hiddenDialogAdjustType;
        public string hiddenWarehouseType;
        public string hiddenDialogDealerId;
        public string hiddenReturnApplyType;
        public string cbWarehouse1;
        public string cbWarehouse2;

        public string AttachmentId;
        public string AttachmentName;


        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstLogDetail = null;
        public ArrayList RstProductDetail = null;
        public ArrayList RstConsignmentDetail = null;

        public string EntityModel = null;
        public ArrayList LstBu;
        public ArrayList LstAdjustType;//退货类型
        public ArrayList LstReturnType;//退换货要求
        public ArrayList LstReturnReason;//退换原因
        public ArrayList LstRsm;/*Rsm列表*/
        public ArrayList LstStatus;
        public ArrayList LstAttachmentList;//文件列表
        public ArrayList LstSalesRepStor;//销售


        public ArrayList LstDealer = null;
        public string DealerParams;

        //public string LotId;
        //public string LotNumber;
        public string ExpiredDate;
        public string AdjustQty;
        public string PurchaseOrderId;
        //public string QRCode;
        public string EditQrCode;
        public string ToDealer;
        public string UPN;

        public bool IsShowPushERP=false;
    }


}
