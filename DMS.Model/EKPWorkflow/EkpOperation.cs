using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.EKPWorkflow
{
    public class EkpFlowTemplate
    {
        public string flowTemplateId;
        public string flowTemplateName;
        public string categoryId;
        public string formUrl;
    }

    public class EkpOperation
    {
        public string activityType;
        public string taskId;
        public string nodeId;
        public string expectedName;
        public List<OperationParam> operations;
        public string taskFrom;
    }

    public class OperationParam
    {
        public string operationType;
        public string operationName;
        public string operationHandlerType;
    }

    public class EkpOperParam
    {
        public string activityType;
        public string taskId;
        public string nodeId;
        public string expectedName;
        public string taskFrom;
        public string operationType;
        public string operationName;
        public string operationHandlerType;
    }

    public class EkpAuditOption
    {
        public EkpAuditOptionPage page;
        public List<EkpAuditOptionDatas> datas;
    }

    public class EkpAuditOptionPage
    {
        public int totalSize;
        public int pageSize;
        public int currentPage;
    }

    public class EkpAuditOptionDatas
    {
        public string fdId;
        public string factNodeId;
        public string factNodeName;
        public string actionName;
        public string actionInfo;
        public string auditNote;
        public string createTime;
        public string nodeId;
        public string workItemId;
        public string handler;
        public string handlerName;
        //public object attachments;
    }

    public enum EkpOperType
    {
        /// <summary>
        /// 发起人——发起申请
        /// </summary>
        drafter_submit,
        /// <summary>
        /// 发起人——催办
        /// </summary>
        drafter_press,
        /// <summary>
        /// 发起人——撤回
        /// </summary>
        drafter_return,
        /// <summary>
        /// 发起人——废弃
        /// </summary>
        drafter_abandon,
        /// <summary>
        /// 审批人——审批通过
        /// </summary>
        handler_pass,
        /// <summary>
        /// 审批人——审批驳回
        /// </summary>
        handler_refuse,
        /// <summary>
        /// 审批人——转办
        /// </summary>
        handler_commission,
        /// <summary>
        /// 审批人——沟通
        /// </summary>
        handler_communicate,
        /// <summary>
        /// 审批人——废弃
        /// </summary>
        handler_abandon,
        /// <summary>
        /// 审批人——加签
        /// </summary>
        handler_additionSign,
        /// <summary>
        /// 流程结束——正常完成
        /// </summary>
        sys_complete,
        /// <summary>
        /// 流程结束——废弃
        /// </summary>
        sys_abandon,
        /// <summary>
        /// 流程通过——EKP触发
        /// </summary>
        sys_pass,
        /// <summary>
        /// 流程驳回——EKP触发
        /// </summary>
        sys_refuse
    }

    public enum EkpModelId
    {
        /// <summary>
        /// 设备招标授权
        /// </summary>
        Tender,
        /// <summary>
        /// 商业样品
        /// </summary>
        SampleBusiness,
        /// <summary>
        /// 样品退货
        /// </summary>
        SampleReturn,
        /// <summary>
        /// 促销政策审批
        /// </summary>
        PromotionPolicy,
        /// <summary>
        /// 积分导入
        /// </summary>
        IntegralImport,
        /// <summary>
        /// 促销执行申请
        /// </summary>
        Promotion,
        /// <summary>
        /// 短期寄售
        /// </summary>
        Consignment,
        /// <summary>
        /// 新经销商申请
        /// </summary>
        ContractAppointment,
        /// <summary>
        /// 经销商修改申请
        /// </summary>
        ContractAmendment,
        /// <summary>
        /// 经销商续约申请
        /// </summary>
        ContractRenewal,
        /// <summary>
        /// 经销商终止申请
        /// </summary>
        ContractTermination,
        /// <summary>
        /// 普通退换货
        /// </summary>
        DealerReturn,
        /// <summary>
        /// 投诉退换货
        /// </summary>
        DealerComplain,
        /// <summary>
        /// CFDA证照维护
        /// </summary>
        DealerLicense,
        /// <summary>
        /// 促销终止
        /// </summary>
        PromotionPolicyClose,
        /// <summary>
        /// 寄售买断
        /// </summary>
        ConsignmentPurchase,
        /// <summary>
        /// 寄售转移
        /// </summary>
        ConsignmentTransfer,

        /// <summary>
        /// 寄售合同
        /// </summary>
        ConsignmentContract,
        /// <summary>
        /// 合同终止
        /// </summary>
        ConsignmentTermination

    }

    public enum EkpTemplateFormId
    {
        /// <summary>
        /// 设备招标授权模板
        /// </summary>
        TenderTemplate,
        /// <summary>
        /// 商业样品模版
        /// </summary>
        SampleBusinessTemplate,
        /// <summary>
        /// 样品退货模版
        /// </summary>
        SampleReturnTemplate,
        /// <summary>
        /// 促销政策审批
        /// </summary>
        PromotionPolicyTemplate,
        /// <summary>
        /// 积分导入
        /// </summary>
        IntegralImportTemplate,
        /// <summary>
        /// 短期寄售
        /// </summary>
        ConsignmentTemplate,
        /// <summary>
        /// 促销执行申请 
        /// </summary>
        PromotionTemplate,
        /// <summary>
        /// 新经销商申请
        /// </summary>
        ContractAppointmentTemplate,
        /// <summary>
        /// 经销商修改申请
        /// </summary>
        ContractAmendmentTemplate,
        /// <summary>
        /// 经销商续约申请
        /// </summary>
        ContractRenewalTemplate,
        /// <summary>
        /// 经销商终止申请
        /// </summary>
        ContractTerminationTemplate,
        /// <summary>
        /// 普通退换货
        /// </summary>
        DealerReturnTemplate,
        /// <summary>
        /// 投诉退换货
        /// </summary>
        DealerComplainTemplate,
        /// <summary>
        /// CFDA证照维护
        /// </summary>
        DealerLicenseTemplate,
        /// <summary>
        /// 促销终止
        /// </summary>
        PromotionPolicyCloseTemplate,
        /// <summary>
        /// 寄售买断
        /// </summary>
        ConsignmentPurchaseTemplate,
        /// <summary>
        /// 寄售转移
        /// </summary>
        ConsignmentTransferTemplate,

        /// <summary>
        /// 寄售合同
        /// </summary>
        ConsignmentContractTemplate,
        /// <summary>
        /// 合同终止
        /// </summary>
        ConsignmentTerminationTemplate
    }
}
