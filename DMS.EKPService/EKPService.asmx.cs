using Common.Logging;
using DMS.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Description;
using System.Web.Services.Protocols;

namespace DMS.EKPService
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

        [WebMethod]
        [SoapRpcMethod(Use = SoapBindingUse.Literal, Action = "http://tempuri.org/getTemplateFormList", RequestNamespace = "http://tempuri.org/", ResponseNamespace = "http://tempuri.org/")]
        public string getTemplateFormList(string sysId, string language)
        {
            _log.Info(string.Format("sysId = {0} language = {1}", sysId, language));

            List<Hashtable> list = new List<Hashtable>();
            Hashtable ht = new Hashtable();
            ht.Add("modelId", "Tender");
            ht.Add("modelName", "招投标");
            ht.Add("templateFormId", "TenderTemplate");
            ht.Add("templateFormName", "招投标模版");
            ht.Add("formUrl", "http://shaappstn01:8083/Contract/Pages/Vendor/Control.aspx");
            list.Add(ht);
            
            string rtnVal = JsonHelper.Serialize(list);
            return rtnVal;
        }

        [WebMethod]
        [SoapRpcMethod(Use = SoapBindingUse.Literal, Action = "http://tempuri.org/getFormFieldList", RequestNamespace = "http://tempuri.org/", ResponseNamespace = "http://tempuri.org/")]
        public string getFormFieldList(string sysId, string modelId, string templateFormId, string language)
        {
            _log.Info(string.Format("sysId = {0} modelId = {1} templateFormId = {2} language = {3}", sysId, modelId, templateFormId, language));

            List<object> list = new List<object>();

            list.Add(new { fieldId = "Division", fieldName = "产品线", type = "String" });
            list.Add(new { fieldId = "DealerType", fieldName = "经销商类型", type = "String" });
            list.Add(new { fieldId = "RequestNo", fieldName = "申请编号", type = "String" });

            string rtnVal = JsonHelper.Serialize(list);
            return rtnVal;
        }

        [WebMethod]
        [SoapRpcMethod(Use = SoapBindingUse.Literal, Action = "http://tempuri.org/getFormFieldValueList", RequestNamespace = "http://tempuri.org/", ResponseNamespace = "http://tempuri.org/")]
        public string getFormFieldValueList(string sysId, string modelId, string templateFormId, string formInstanceId, string fieldIds, string language)
        {
            _log.Info(string.Format("sysId = {0} modelId = {1} templateFormId = {2} formInstanceId = {3} fieldIds = {4}", sysId, modelId, templateFormId, formInstanceId, fieldIds));
            return "[{\"fieldId\":\"ApplyId\",\"fieldValue\":\"" + Guid.NewGuid().ToString() + "\"},{\"fieldId\":\"ApplyNo\",\"fieldValue\":\"HCP001\"},{\"fieldId\":\"ApplyAmount\",\"fieldValue\":12345678.90}]";
        }

        [WebMethod]
        [SoapRpcMethod(Use = SoapBindingUse.Literal, Action = "http://tempuri.org/getMethodInfo", RequestNamespace = "http://tempuri.org/", ResponseNamespace = "http://tempuri.org/")]
        public string getMethodInfo(string sysId, string modelId, string templateFormId, string language)
        {
            _log.Info(string.Format("sysId = {0} modelId = {1} templateFormId = {2}", sysId, modelId, templateFormId));
            return "[{\"functionId\":\"SendMailToDealer\",\"functionName\":\"SendMailToDealer\",\"functionDes\":\"邮件通知经销商\"}]";
        }

        [WebMethod]
        [SoapRpcMethod(Use = SoapBindingUse.Literal, Action = "http://tempuri.org/DoMethodProcess", RequestNamespace = "http://tempuri.org/", ResponseNamespace = "http://tempuri.org/")]
        public string DoMethodProcess(string formId, string functionId, string processData, string language)
        {
            _log.Info(string.Format("formId = {0} functionId = {1} processData = {2}", formId, functionId, processData));
            return "T";
        }
    }
}

