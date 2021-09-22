using Common.Logging;
using DMS.Business;
using DMS.Business.EKPWorkflow;
using DMS.Business.ERPInterface;
using DMS.Common;
using DMS.DataAccess;
using DMS.DataAccess.EKPWorkflow;
using DMS.Model;
using DMS.Model.Data;
using DMS.Model.EKPWorkflow;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Description;
using System.Web.Services.Protocols;

namespace DMS.DataService
{
    /// <summary>
    /// EkpService 的摘要说明
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [SoapDocumentService(RoutingStyle = SoapServiceRoutingStyle.RequestElement)]
    [System.ComponentModel.ToolboxItem(false)]
    // 若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消注释以下行。 
    // [System.Web.Script.Services.ScriptService]
    public class EKPService : System.Web.Services.WebService
    {
        private static ILog _log = LogManager.GetLogger(typeof(EKPService));
        private EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();

        [WebMethod]
        [SoapRpcMethod(Use = SoapBindingUse.Literal, Action = "http://tempuri.org/getTemplateFormList", RequestNamespace = "http://tempuri.org/", ResponseNamespace = "http://tempuri.org/")]
        public string getTemplateFormList(string sysId, string language)
        {
            _log.Info(string.Format("sysId = {0} language = {1}", sysId, language));

            EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();

            string rtnVal = ekpBll.GetWorkflowModelSettingBySysId(sysId, language);

            _log.Info(string.Format("getTemplateFormList = {0}", rtnVal));

            return rtnVal;

            //List<Hashtable> list = new List<Hashtable>();
            //Hashtable ht = new Hashtable();
            //ht.Add("modelId", "Tender");
            //ht.Add("modelName", "招投标");
            //ht.Add("templateFormId", "TenderTemplate");
            //ht.Add("templateFormName", "招投标模版");
            //ht.Add("formUrl", "https://bscdealer.cn/Pages/EkpControl.aspx");
            //list.Add(ht);

            //Hashtable ht1 = new Hashtable();
            //ht1.Add("modelId", "SampleBusiness");
            //ht1.Add("modelName", "商业样品");
            //ht1.Add("templateFormId", "SampleBusinessTemplate");
            //ht1.Add("templateFormName", "商业样品模版");
            //ht1.Add("formUrl", "https://bscdealer.cn/Pages/EkpControl.aspx");
            //list.Add(ht1);

            //Hashtable ht2 = new Hashtable();
            //ht2.Add("modelId", "SampleReturn");
            //ht2.Add("modelName", "样品退货");
            //ht2.Add("templateFormId", "SampleReturnTemplate");
            //ht2.Add("templateFormName", "样品退货模版");
            //ht2.Add("formUrl", "https://bscdealer.cn/Pages/EkpControl.aspx");
            //list.Add(ht2);

            //string rtnVal = JsonHelper.Serialize(list);
            //return rtnVal;
        }

        [WebMethod]
        [SoapRpcMethod(Use = SoapBindingUse.Literal, Action = "http://tempuri.org/getFormFieldList", RequestNamespace = "http://tempuri.org/", ResponseNamespace = "http://tempuri.org/")]
        public string getFormFieldList(string sysId, string modelId, string templateFormId, string language)
        {
            _log.Info(string.Format("sysId = {0} modelId = {1} templateFormId = {2} language = {3}", sysId, modelId, templateFormId, language));

            EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();

            string rtnVal = ekpBll.GetWorkflowFieldSettingBySysId(sysId, modelId, templateFormId, language);

            _log.Info(string.Format("getFormFieldList = {0}", rtnVal));

            return rtnVal;

            //List<object> list = new List<object>();

            //if (modelId == "Tender" && templateFormId == "TenderTemplate")
            //{
            //    list.Add(new { fieldId = "DeptId", fieldName = "产品线", type = "String" });
            //    list.Add(new { fieldId = "DealerType", fieldName = "经销商类型", type = "String" });
            //    list.Add(new { fieldId = "RequestNo", fieldName = "申请编号", type = "String" });
            //}
            //else if (modelId == "SampleBusiness" && templateFormId == "SampleBusinessTemplate")
            //{
            //    list.Add(new { fieldId = "RequestType", fieldName = "样品类型", type = "String" });
            //    list.Add(new { fieldId = "PurposeType", fieldName = "申请目的", type = "String" });
            //    list.Add(new { fieldId = "TOTALAMOUNTUSD", fieldName = "申请总额（USD）", type = "Number" });
            //    list.Add(new { fieldId = "UPN", fieldName = "UPN", type = "String" });
            //    list.Add(new { fieldId = "SampleNo", fieldName = "申请编号", type = "String" });
            //}
            //else if (modelId == "SampleReturn" && templateFormId == "SampleReturnTemplate")
            //{
            //    list.Add(new { fieldId = "RequestType", fieldName = "样品类型", type = "String" });
            //    list.Add(new { fieldId = "SampleReturnNo", fieldName = "申请编号", type = "String" });
            //}

            //string rtnVal = JsonHelper.Serialize(list);
            //return rtnVal;
        }

        [WebMethod]
        [SoapRpcMethod(Use = SoapBindingUse.Literal, Action = "http://tempuri.org/getFormFieldValueList", RequestNamespace = "http://tempuri.org/", ResponseNamespace = "http://tempuri.org/")]
        public string getFormFieldValueList(string sysId, string modelId, string templateFormId, string formInstanceId, string fieldIds, string language)
        {
            _log.Info(string.Format("sysId = {0} modelId = {1} templateFormId = {2} formInstanceId = {3} fieldIds = {4} language = {5}", sysId, modelId, templateFormId, formInstanceId, fieldIds, language));

            EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();

            string rtnVal = ekpBll.GetCommonFormDataListString(formInstanceId, modelId, templateFormId, fieldIds);

            _log.Info(string.Format("getFormFieldValueList = {0}", rtnVal));

            return rtnVal;
        }

        [WebMethod]
        [SoapRpcMethod(Use = SoapBindingUse.Literal, Action = "http://tempuri.org/getMethodInfo", RequestNamespace = "http://tempuri.org/", ResponseNamespace = "http://tempuri.org/")]
        public string getMethodInfo(string sysId, string modelId, string templateFormId, string language)
        {
            _log.Info(string.Format("sysId = {0} modelId = {1} templateFormId = {2} language = {3}", sysId, modelId, templateFormId, language));

            List<object> list = new List<object>();

            list.Add(new { functionId = "DmsSynComplete", functionName = "流程完成回调DMS", functionDes = "流程完成回调DMS" });
            list.Add(new { functionId = "DmsSynAbandon", functionName = "流程废弃回调DMS", functionDes = "流程废弃回调DMS" });
            list.Add(new { functionId = "DmsPassCommonFunction", functionName = "DMS流程通过回调通用方法", functionDes = "DMS流程通过回调通用方法" });
            list.Add(new { functionId = "DmsRefuseCommonFunction", functionName = "DMS流程驳回回调通用方法", functionDes = "DMS流程驳回回调通用方法" });
            list.Add(new { functionId = "DmsBusinessCommonFunction", functionName = "DMS流程特殊业务处理通用方法", functionDes = "DMS流程特殊业务处理通用方法" });

            string rtnVal = JsonHelper.Serialize(list);
            return rtnVal;
        }
        [WebMethod]
        [SoapRpcMethod(Use = SoapBindingUse.Literal, Action = "http://tempuri.org/doMethodProcess", RequestNamespace = "http://tempuri.org/", ResponseNamespace = "http://tempuri.org/")]
        public string doMethodProcessForContract(string processId, string functionId, string nodeName)
        {
            DateTime startDate = DateTime.Now;
            DateTime endDate = startDate;
            _log.Info(string.Format("processId = {0} functionId = {1} nodeName = {2}", processId, functionId, nodeName));
            string reqMsg = string.Format("EKP: doMethodProcessForContract :processId:{0};functionId:{1};nodeName:{2};", processId, functionId, nodeName);
            string retString = "T";
            bool success = true;
            try
            {
                FormInstanceMaster formInstance = GetFormInstanceMasterByApplyId(processId);

                if (formInstance != null)
                {
                    if (functionId == "DmsSynComplete")
                    {
                        ekpBll.UpdateCommonFormStatus(formInstance.ApplyId.ToString(), formInstance.modelId, formInstance.templateFormId, string.Empty, EkpOperType.sys_complete.ToString(), "完成", "System", "结束流程");
                        retString = "T";
                        success = true;
                        //普通退换货审批通过后需要自动推送ERP
                        if(formInstance.modelId== EkpModelId.DealerReturn.ToString() && formInstance.templateFormId== EkpTemplateFormId.DealerReturnTemplate.ToString())
                        {
                            IInventoryAdjustBLL business = new InventoryAdjustBLL();
                            string msg = "";
                            bool result = false;
                            result = business.PushReturnToERP(formInstance.ApplyId.Value, out msg);
                            success = result;
                            retString += msg;
                            if (result)
                            {
                                result = business.ReturnAutoCreateOrder(formInstance.ApplyId.ToString(), out msg);
                                success = result;
                                retString += msg;
                            }
                            
                        }
                        
                    }
                    else if (functionId == "DmsSynAbandon")
                    {
                        ekpBll.UpdateCommonFormStatus(formInstance.ApplyId.ToString(), formInstance.modelId, formInstance.templateFormId, string.Empty, EkpOperType.sys_abandon.ToString(), "撤销", "System", "结束流程");
                    }
                    else
                    {
                        retString = "F:参数functionId错误，未找到相应操作！";
                        success = false;
                    }
                    endDate = DateTime.Now;
                    ekpBll.InsertWorkflowLog(formInstance.ApplyId.ToString(), startDate, endDate, reqMsg, retString, success, null);
                }
                else
                {
                    retString = "F:参数processId错误，未找到流程对应表单数据！";
                    success = false;
                    endDate = DateTime.Now;
                    ekpBll.InsertWorkflowLog(processId, startDate, endDate, reqMsg, retString, success, null);
                }
                
            }
            catch (Exception ex)
            {
                _log.Info(ex.ToString());
                endDate = DateTime.Now;
                ekpBll.InsertWorkflowLog(processId, startDate, endDate, reqMsg, ex.Message, false, null);
                retString = string.Format("F:{0}", ex.ToString());
            }
            return retString;
        }
        [WebMethod]
        [SoapRpcMethod(Use = SoapBindingUse.Literal, Action = "http://tempuri.org/doMethodProcess", RequestNamespace = "http://tempuri.org/", ResponseNamespace = "http://tempuri.org/")]
        public string doMethodProcess(string formId, string functionId, string processData, string language)
        {
            DateTime startDate = DateTime.Now;
            DateTime endDate = startDate;
            _log.Info(string.Format("sysId = {0} modelId = {1} templateFormId = {2} language = {3}", formId, functionId, processData, language));
            string reqMsg = string.Format("EKP: doMethodProcess :formId:{0};functionId:{1};processData:{2};language:{3};", formId, functionId, processData, language);

            try
            {
                DmsForm formObj = JsonHelper.Deserialize<DmsForm>(formId);
                DmsFunction functionObj = JsonHelper.Deserialize<DmsFunction>(functionId);
                DmsProcessDate processObj = JsonHelper.Deserialize<DmsProcessDate>(processData);

                if (functionObj.functionId == "DmsSynComplete")
                {
                    ekpBll.UpdateCommonFormStatus(formObj.formInstanceId, formObj.modelId, formObj.templateFormId, string.Empty, EkpOperType.sys_complete.ToString(), "完成", "System", "结束流程");
                }
                else if (functionObj.functionId == "DmsSynAbandon")
                {
                    ekpBll.UpdateCommonFormStatus(formObj.formInstanceId, formObj.modelId, formObj.templateFormId, string.Empty, EkpOperType.sys_abandon.ToString(), "撤销", "System", "结束流程");
                }
                else if (functionObj.functionId == "DmsPassCommonFunction")
                {
                    ekpBll.UpdateCommonFormStatus(formObj.formInstanceId, formObj.modelId, formObj.templateFormId, processObj.nodeFactId, EkpOperType.handler_pass.ToString(), "EKP触发通过", "System", "EKP触发通过");
                }
                else if (functionObj.functionId == "DmsRefuseCommonFunction")
                {
                    ekpBll.UpdateCommonFormStatus(formObj.formInstanceId, formObj.modelId, formObj.templateFormId, processObj.nodeFactId, EkpOperType.handler_refuse.ToString(), "EKP触发驳回", "System", "EKP触发驳回");
                }
                


                endDate= DateTime.Now;
                ekpBll.InsertWorkflowLog(formObj.formInstanceId,startDate,endDate, reqMsg, "T", true, null);
                return "T";
            }
            catch (Exception ex)
            {
                _log.Info(ex.ToString());
                endDate = DateTime.Now;
                ekpBll.InsertWorkflowLog(Guid.Empty.ToString(), startDate, endDate, reqMsg, ex.Message, false, null);
                return string.Format("F:{0}", ex.ToString());
            }
        }

        [WebMethod]
        [SoapRpcMethod(Use = SoapBindingUse.Literal, Action = "http://tempuri.org/doMethodProcessed", RequestNamespace = "http://tempuri.org/", ResponseNamespace = "http://tempuri.org/")]
        public string doMethodProcessed(string formId, string functionId, string processData, string language)
        {
            DateTime startDate = DateTime.Now;
            DateTime endDate = startDate;
            _log.Info(string.Format("sysId = {0} modelId = {1} templateFormId = {2} language = {3}", formId, functionId, processData, language));
            string reqMsg = string.Format("EKP: doMethodProcessed :formId:{0};functionId:{1};processData:{2};language:{3};", formId, functionId, processData, language);

            try
            {
                DmsForm formObj = JsonHelper.Deserialize<DmsForm>(formId);
                DmsFunction functionObj = JsonHelper.Deserialize<DmsFunction>(functionId);
                DmsProcessDate processObj = JsonHelper.Deserialize<DmsProcessDate>(processData);
                EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();

                ekpBll.ExecutiveCommonFormBusiness(formObj.formInstanceId, formObj.modelId, formObj.templateFormId, "EKP触发执行特殊业务", "System", "EKP触发执行特殊业务");

                endDate = DateTime.Now;
                ekpBll.InsertWorkflowLog(formObj.formInstanceId,startDate,endDate, reqMsg, "T", true, null);
                return "T";

            }
            catch (Exception ex)
            {
                _log.Info(ex.ToString());
                endDate = DateTime.Now;
                ekpBll.InsertWorkflowLog(Guid.Empty.ToString(), startDate, endDate, reqMsg, ex.Message, false, null);
                return string.Format("F:{0}", ex.ToString());
            }
        }
        private FormInstanceMaster GetFormInstanceMasterByApplyId(string processId)
        {
            using (FormInstanceMasterDao dao = new FormInstanceMasterDao())
            {
                Hashtable table = new Hashtable();
                table.Add("processId", processId);

                IList<FormInstanceMaster> list = dao.SelectFormInstanceMasterListByFilter(table);
                if (list != null && list.Count() > 0)
                {
                    return list.First<FormInstanceMaster>();
                }
                return null;
            }
        }
    }

    public class DmsForm
    {
        public string sysId;
        public string modelId;
        public string templateFormId;
        public string formInstanceId;
    }

    public class DmsFunction
    {
        public string functionId;
    }

    public class DmsProcessDate
    {
        public string processId;
        public string docStatus;
        public string nodeFactId;
    }
}

