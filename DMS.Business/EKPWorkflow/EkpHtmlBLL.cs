using Common.Logging;
using DMS.Business.Contract;
using DMS.Common.Common;
using DMS.Model.EKPWorkflow;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Web;

namespace DMS.Business.EKPWorkflow
{
    public class EkpHtmlBLL
    {
        private static ILog _log = LogManager.GetLogger(typeof(EkpHtmlBLL));
        EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();
        HtmlHelper helper = new HtmlHelper();

        public String GetDmsHtmlCommonById(string instanceId, string modelId, string templateFormId, DmsTemplateHtmlType templateType,string optionListXml)
        {
            _log.Info(string.Format("instanceId:{0} modelId:{1} templateFormId:{2} templateType:{3} optionListXml:{4}", instanceId, modelId, templateFormId, templateType.ToString(),optionListXml.ToString()));
            DataSet ds = ekpBll.GetCommonHtmlData(instanceId, modelId, templateFormId, optionListXml);

            if (ds == null || ds.Tables == null || ds.Tables.Count == 0)
                throw new Exception("没有数据，无法生成HTML");

            //第一个DataTable存放的是模版信息
            //第一个字段TemplateName 第二字段TableNames存放例如"MainData,BudgetData"以逗号分隔
            string templateName = ds.Tables[0].Rows[0]["TemplateName"].ToString();
            string tableNames = ds.Tables[0].Rows[0]["TableNames"].ToString();

            if (templateName == "" || tableNames == "")
                throw new Exception("没有HTML模版信息，无法生成HTML");

            string templatePath = Path.Combine(HttpContext.Current.Server.MapPath("~/HTML/module"), templateName + (templateType == DmsTemplateHtmlType.Email ? "_Email" : "") + ".html");

            if (!File.Exists(templatePath))
                throw new Exception("没有HTML模版文件，无法生成HTML");

            string[] tableNameArray = tableNames.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            if (tableNameArray.Length != ds.Tables.Count - 1)
                throw new Exception("数据与HTML模版不匹配，无法生成HTML");

            //重命名后续DataTable的明细
            for (int i = 0; i < tableNameArray.Length; i++)
            {
                ds.Tables[i + 1].TableName = tableNameArray[i];
            }

            //生成HTML
            return HtmlHelper.Create(templatePath, ds);


            //FormInstanceMaster formInstance = ekpBll.GetFormInstanceMasterByApplyId(instanceId);

            //if (formInstance == null)
            //    throw new Exception("EKP获取表单数据出错");

            //Type t = this.GetType();
            //MethodInfo method = t.GetMethod(string.Format("Create{0}Html", formInstance.ApplyType), new Type[] { typeof(string), typeof(DmsTemplateHtmlType), typeof(StringBuilder) });

            ////获取模板
            //StringBuilder stringBuilder = helper.GetDmsTemplateHtml(formInstance.ApplyType, htmlType);

            //String returnVal = method.Invoke(this, new object[] { instanceId, htmlType, stringBuilder }).ToString();

            //return returnVal;
        }
        
        /// <summary>
        /// 招投标
        /// </summary>
        /// <param name="instanceId"></param>
        /// <param name="htmlType"></param>
        /// <returns></returns>
        //public StringBuilder CreateTenderAuthHtml(string instanceId,DmsTemplateHtmlType htmlType, StringBuilder htmlStringBuilder)
        //{
        //    TenderAuthorizationListBLL bll = new TenderAuthorizationListBLL();
        //    return bll.CreateTenderAuthorizationHtml(instanceId, htmlType, htmlStringBuilder);
        //}
    }
}
