using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Consignment
{
    public class ConsignmentApplyHeaderInfoVO : BaseQueryVO
    {
        public string hidCorpType;//经销商类型
        public string InstanceId;
        public string QryApplyType;
        public string QryDealerId;
        public string QryDealer;
        public string QrySubmitDate;
        public string QryApplyNo;
        public string QryDelayState;
        public KeyValue Qrycbproline;
        public KeyValue QrycbProductsource;//产品来源
        public string QryOrderState;
        public KeyValue QryRule;//寄售合同
        public string QryConsignmentRule;
        public string QryTextHospit;
        public string Qrynumber;
        public string QryTaoteprice;
        public KeyValue QrycbSale;//销售
        public string QrySalesName;
        public string QrySalesEmail;
        public string QrySalesPhone;
        public string QryConsignee;//收货人
        public KeyValue QrycbHospital;//医院
        public KeyValue QrycbSAPWarehouseAddress;//收货地址
        public KeyValue QrycbSuorcePro;//来源经销商


        public string QryTexthospitalname;//医院名称
        public string QryHospitalAddress;//医院地址
        public string QryConsigneePhone;//收货人电话
        public string QrydfRDD;//期望到货日期
        public string QryConsignment;//寄售原因
        public string QryRemark;//说明

        public string QryNumberDays;//寄售天数
        public string QryDelaytimes;//可延期次数
        public string QryBeginData;//时间期限-起始
        public string QryIsControlAmount;//是否控制总金额
        public string QryIsControlNumber;//控制总数量
        public string QryEndData;
        public string QryIsDiscount;//适用近效期规则
        public string QryIsKB;//自动补货:

        public bool QrybtnReturn;//添加退货单产品
        public string QrybtnAddProduct;//添加产品
        public bool QrybtnBtnAddComProduct;//添加组产品

        public bool QrybtnSaveDraft = false;//保存草稿
        public bool QrybtnDeleteDraft = false;//删除草稿
        public bool QrybtnSubmit = false;//提交申请
        public bool QrybtnBtnDelay = false;

        public bool cbHospitalHidden = false;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public ArrayList RstLogDetail = null;

        public ArrayList LstSalesRepStor = null;//产品线下的销售
        public ArrayList LstDealerConsignment = null;//寄售合同
        public ArrayList LstSAPWarehouseAddress = null;//经销商仓库
        public ArrayList LstcbProductsource;//产品来源
        public KeyValue LstProductsource;
        public IList<KeyValue> LstBu;
        public string EntityModel = null;
        public string EditRows = null;//编辑行更新

        public ArrayList LstProlineDma = null;//产品线下经销商
        public ArrayList Lstcbproline = null;
        public ArrayList LstcbHospital = null;//产品线下医院
        public ArrayList LstDealer = null;
        public IList<KeyValuePair<string, string>> LstType { get; set; }
        public IList<KeyValuePair<string, string>> LstStatus { get; set; }

        public string SaleSelectedId;

        public string hidDivisionCode;
        public string hidChanConsignment;
        public string hidProductLine;
        public string HospId;
        public string txtRuleId;
        public string txtConsignmentRuleId;
        public string hidorderState;
        public string hidConsignment;
        public string hidUpdateDate;


        public string QrySpecialPrice;
        public string QryOrderType;
        public string QryPriceType;

        public string DealerParams;
        public string DealerCmId;

        public string PlineItemId;
        public string RequiredQty;
        public string cfnPrice;
        public string Upn;

        public string hidRtnVal;
        public string hidRtnMsg;
        public bool hidIsSaved;

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
