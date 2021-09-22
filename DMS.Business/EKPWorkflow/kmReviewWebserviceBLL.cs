using DMS.DataAccess.EKPWorkflow;
using DMS.Model;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using DMS.Model.EKPWorkflow;
using System.Text;
using DMS.Common;
using System.Data;
using Common.Logging;
using DMS.Common.Common;
using System.Web;

namespace DMS.Business.EKPWorkflow
{
    public class kmReviewWebserviceBLL
    {
        private static ILog _log = LogManager.GetLogger("kmReviewWebserviceBLL");
        #region 属性
        kmReviewWebservice.IKmReviewWebserviceServiceService ekpService ;
        kmReviewWebservice.kmReviewParamterForm ekpParam;
        #endregion
        public kmReviewWebserviceBLL()
        {
            ekpParam = new kmReviewWebservice.kmReviewParamterForm();
            ekpService = new kmReviewWebservice.IKmReviewWebserviceServiceService();
            ekpService.Timeout = 1000 * 60 * 3;
            ekpService.Url = System.Configuration.ConfigurationManager.AppSettings["EKPWorkflowURL"];
            //ekpService.RequestSOAPHeader = new RequestSOAPHeader("DMSAdmin", "672505fdb5ecb8b4e26c9e83a6488466");
            string userName = System.Configuration.ConfigurationManager.AppSettings["OAUserName"];
            string passWord = System.Configuration.ConfigurationManager.AppSettings["OAPassWord"];
            ekpService.RequestSOAPHeader = new RequestSOAPHeader(userName, passWord);
            ekpService.RequestSOAPHeader.Namespaces.Add("tns", "http://sys.webservice.client");
        }

        #region Workflow Setting Function
        public string GetWorkflowModelSettingBySysId(string sysId, string language)
        {
            using (WorkflowSettingDao dao = new WorkflowSettingDao())
            {
                Hashtable table = new Hashtable();
                table.Add("sysId", sysId);
                table.Add("language", language);

                IList<ModelSetting> list = dao.SelectModelSettingListByFilter(table);

                var o = from a in list
                        select new
                        {
                            modelId = a.modelId,
                            modelName = a.modelName,
                            templateFormId = a.templateFormId,
                            templateFormName = a.templateFormName,
                            formUrl = a.formUrl
                        };

                return JsonHelper.Serialize(o);
            }
        }

        public string GetWorkflowFieldSettingBySysId(string sysId, string modelId, string templateFormId, string language)
        {
            using (WorkflowSettingDao dao = new WorkflowSettingDao())
            {
                Hashtable table = new Hashtable();
                table.Add("sysId", sysId);
                table.Add("modelId", modelId);
                table.Add("templateFormId", templateFormId);
                table.Add("language", language);

                IList<FieldSetting> list = dao.SelectFieldSettingListByFilter(table);

                var o = from a in list
                        select new
                        {
                            fieldId = a.fieldId,
                            fieldName = a.fieldName,
                            type = a.type
                        };

                return JsonHelper.Serialize(o);
            }
        }

        #endregion

        #region Set FormInstanceMaster Status
        /// <summary>
        /// 设置已拒绝
        /// </summary>
        /// <param name="applyId"></param>
        /// <param name="remark"></param>
        /// <param name="userId"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        /// <returns></returns>
        public void UpdateCommonFormStatus(string applyId, string modelId, string templateFormId, string nodeIds, string operType, string operName, string userAccount, string auditNote)
        {
            using (FormInstanceMasterDao dao = new FormInstanceMasterDao())
            {
                Hashtable table = new Hashtable();
                table.Add("FormInstanceId", applyId);
                table.Add("ModelId", modelId);
                table.Add("TemplateFormId", templateFormId);
                table.Add("NodeId", nodeIds);
                table.Add("OperType", operType);
                table.Add("OperName", operName);
                table.Add("UserAccount", userAccount);
                table.Add("AuditNote", auditNote);

                dao.UpdateCommonFormStatus(table);
            }
        }

        #endregion

        #region Create Form Data HTML
        public DataSet GetCommonHtmlData(string applyId, string modelId, string templateFormId,string optionListXml)
        {
            using (FormInstanceMasterDao dao = new FormInstanceMasterDao())
            {
                Hashtable table = new Hashtable();
                table.Add("FormInstanceId", applyId);
                table.Add("ModelId", modelId);
                table.Add("TemplateFormId", templateFormId);
                table.Add("OptionListXml", optionListXml);

                return dao.GetCommonHtmlData(table);
            }
        }
        #endregion

        public bool CheckFormData(string applyId, string modelId, string templateFormId, string nodeIds, out string rtnMsg)
        {
            rtnMsg = "";
            using (FormInstanceMasterDao dao = new FormInstanceMasterDao())
            {
                return dao.CheckFormData(applyId, modelId, templateFormId, nodeIds, out rtnMsg);
            }
        }

        public void ExecutiveCommonFormBusiness(string applyId, string modelId, string templateFormId, string operName, string userAccount, string auditNote)
        {
            using (FormInstanceMasterDao dao = new FormInstanceMasterDao())
            {
                Hashtable table = new Hashtable();
                table.Add("FormInstanceId", applyId);
                table.Add("ModelId", modelId);
                table.Add("TemplateFormId", templateFormId);
                table.Add("OperName", operName);
                table.Add("UserAccount", userAccount);
                table.Add("AuditNote", auditNote);

                dao.ExecutiveCommonFormBusiness(table);
            }
        }


        #region Ekp公用方法
        /// <summary>
        /// 获取Ekp操作日志Url
        /// </summary>
        /// <param name="applyId"></param>
        /// <returns></returns>
        public string GetEkpHistoryLogByInstanceId(string applyId, string userName)
        {
            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);
            if (formInstance == null)
            {
                return string.Empty;
            }
            else
            {
                Random rad = new Random();

                //return string.Format(EkpSetting.CONST_EKP_HISTORY_URL, EkpSetting.CONST_EKP_SYS_ID, formInstance.modelId, formInstance.templateFormId, formInstance.ApplyId, formInstance.processId, Encryption.Encoder(userName), rad.Next(1000, 10000).ToString());
                return string.Format(EkpSetting.CONST_EKP_HISTORY_URL, formInstance.processId, rad.Next(1000, 10000).ToString());
            }
        }

        /// <summary>
        /// 得到DMS公共页面
        /// </summary>
        /// <param name="applyId"></param>
        /// <param name="userName"></param>
        /// <returns></returns>
        public string GetEkpCommonPageUrlByInstanceId(string applyId, string userName)
        {
            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);
            if (formInstance == null)
            {
                return string.Empty;
            }
            else
            {
                Random rad = new Random();

                return string.Format(EkpSetting.CONST_EKP_COMMON_PAGE_URL, formInstance.ApplyId, formInstance.processId, rad.Next(1000, 10000).ToString());
            }
        }


        public string GetCommonFormDataString(string applyId, string modelId, string templateFormId)
        {
            DataTable dt = this.GetCommonFormData(applyId, modelId, templateFormId);
            return JsonHelper.Serialize(JsonHelper.DataTableToArrayList(dt)[0]);
        }

        public string GetCommonFormDataListString(string applyId, string modelId, string templateFormId, string html)
        {
            DataTable dt = this.GetCommonFormData(applyId, modelId, templateFormId);

            Hashtable fieldList = new Hashtable();

            foreach (DataColumn col in dt.Columns)
            {
                if (col.ColumnName != "NoData")
                {
                    fieldList.Add(col.ColumnName, dt.Rows[0][col.ColumnName]);
                }
            }
            //富文本内容
            if (!string.IsNullOrEmpty(html))
            {
                var bytes = Encoding.Unicode.GetBytes(html);
                var stringBuilder = new StringBuilder();
                for (var i = 0; i < bytes.Length; i += 2)
                {
                    stringBuilder.AppendFormat(@"\u{0:x2}{1:x2}", bytes[i + 1], bytes[i]);
                }
                fieldList.Add("fd_dms_rtf", stringBuilder.ToString());
            }
            return (JsonHelper.Serialize(fieldList)).Replace("\\\\u", "\\u");
        }

        /// <summary>
        /// 获取FormData
        /// </summary>
        /// <param name="applyId"></param>
        /// <returns></returns>
        public DataTable GetCommonFormData(string applyId, string modelId, string templateFormId)
        {
            using (FormInstanceMasterDao dao = new FormInstanceMasterDao())
            {
                Hashtable table = new Hashtable();
                table.Add("FormInstanceId", applyId);
                table.Add("ModelId", modelId);
                table.Add("TemplateFormId", templateFormId);
                //BaseService.AddCommonFilterCondition(table);

                DataSet ds = dao.GetCommonFormData(table);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    return ds.Tables[0];
                }
                else
                {
                    throw new Exception("获取FormData异常");
                }
            }
        }

        /// <summary>
        /// 插入申请单信息
        /// </summary>
        /// <param name="applyId"></param>
        /// <param name="applyNo"></param>
        /// <param name="applyAmount"></param>
        /// <param name="applyType"></param>
        /// <param name="modelId"></param>
        /// <param name="templateFormId"></param>
        /// <param name="processId"></param>
        /// <returns></returns>
        public bool InsertFormInstanceMaster(string userAccount, string applyId, string applyNo, string applyType, string applySubject
            , string modelId, string templateFormId, string processId, string rev1, string rev2, string rev3,string fdTemplateFormId,string dcCreator)
        {
            using (FormInstanceMasterDao dao = new FormInstanceMasterDao())
            {
                FormInstanceMaster om = new FormInstanceMaster();

                om.Id = Guid.NewGuid();
                om.ApplyId = new Guid(applyId);
                om.ApplyNo = applyNo;
                om.ApplyType = applyType;
                om.ApplySubject = applySubject;
                om.modelId = modelId.ToString();
                om.templateFormId = templateFormId.ToString();
                om.processId = processId;
                om.CreateDate = DateTime.Now;
                om.CreateUser = userAccount;
                om.Rev1 = rev1;
                om.Rev2 = rev2;
                om.Rev3 = rev3;
                om.fdTemplateFormId = fdTemplateFormId;
                om.docCreator = dcCreator;
                dao.InsertFormInstanceMaster(om);
            }
            return true;
        }

        /// <summary>
        /// 根据ApplyId(DMS)获取相关信息
        /// </summary>
        /// <param name="applyId"></param>
        /// <returns></returns>
        public FormInstanceMaster GetFormInstanceMasterByApplyId(string applyId)
        {
            using (FormInstanceMasterDao dao = new FormInstanceMasterDao())
            {
                Hashtable table = new Hashtable();
                table.Add("ApplyId", applyId);

                IList<FormInstanceMaster> list = dao.SelectFormInstanceMasterListByFilter(table);
                if (list != null && list.Count() > 0)
                {
                    return list.First<FormInstanceMaster>();
                }
                return null;
            }
        }

        /// <summary>
        /// 根据processId(Ekp)获取相关信息
        /// </summary>
        /// <param name="processId"></param>
        /// <returns></returns>
        public FormInstanceMaster GetFormInstanceMasterProcessId(string processId)
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

        /// <summary>
        /// 新增接口日志
        /// </summary>
        /// <param name="startTime"></param>
        /// <param name="endTime"></param>
        /// <param name="requestMessage"></param>
        /// <param name="responseMessage"></param>
        public void InsertWorkflowLog(string applyId,DateTime startDate,DateTime endDate , string requestMessage, string responseMessage, bool success, string errMsg)
        {
            using (WorkflowLogDao dao = new WorkflowLogDao())
            {
                try
                {
                    WorkflowLog log = new WorkflowLog();
                    log.Id = Guid.NewGuid();
                    log.ApplyId = new Guid(applyId);
                    log.StartTime = startDate;
                    log.EndTime = endDate;
                    log.Status = success ? "Success" : "Failure";
                    log.RequestMessage = requestMessage == null ? string.Empty : requestMessage;
                    log.ResponseMessage = responseMessage == null ? string.Empty : responseMessage;
                    log.FileName = errMsg;
                    dao.InsertWorkflowLog(log);
                }
                catch (Exception ex)
                {

                }
            }
        }



        /// <summary>
        /// 提交流程（包含发起流程和提交申请）
        /// </summary>
        /// <param name="applyId"></param>
        /// <param name="applyNo"></param>
        /// <param name="applyAmount"></param>
        /// <param name="modelId"></param>
        /// <param name="templateFormId"></param>
        /// <param name="userAccount"></param>
        /// <param name="applyType"></param>
        /// <returns></returns>
        public void DoSubmit(string userAccount, string applyId, string applyNo, string applyType, string applySubject, string modelId, string templateFormId,string fdTemplateFormId)
        {
            //userAccount = DictionaryHelper.GetDictionaryNameById("CONST_UserAccount", "Admin");
            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);
            string processId="";
            if (formInstance != null)
            {
                processId = formInstance.processId;
            }
            string rev1 = string.Empty, rev2 = string.Empty, rev3 = string.Empty;
            //获取FormInstanceMaster扩展字段的值
            //this.GetDmsFormDataExtendedField(applyId, modelId, templateFormId, out rev1, out rev2, out rev3);

            if (this.ApproveProcess(userAccount, EkpOperType.drafter_submit.ToString(), "提交", null, applyId, modelId, templateFormId, ref processId, null, fdTemplateFormId, applySubject, userAccount))
            {
                if (formInstance == null)
                {
                    this.InsertFormInstanceMaster(userAccount, applyId, applyNo, applyType, applySubject, modelId, templateFormId, processId, rev1, rev2, rev3, fdTemplateFormId, userAccount);
                    //更新表单数据
                    this.UpdateReviewInfo(userAccount, string.Empty, EkpOperType.drafter_submit.ToString(), "提交", null, applyId, modelId, templateFormId, ref processId,null, null, null, fdTemplateFormId, applySubject, userAccount);
                }
            }
            else
                throw new Exception("EKP提交申请出错");
        }


        /// <summary>
        /// 审批通过
        /// </summary>
        /// <returns></returns>
        public void DoAgree(string userAccount, string applyId, string auditNote)
        {
            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);
            kmReviewExtendWeserviceBLL krew = new kmReviewExtendWeserviceBLL();
            if (formInstance == null)
                throw new Exception("EKP获取表单数据出错");

            List<EkpOperation> oper = krew.GetOperationList(userAccount, applyId);
            EkpOperParam ekpOperParam = GetEkpParam(oper, EkpOperType.handler_pass);
            if (ekpOperParam == null)
                throw new Exception("当前用户没有EKP审批通过权限");
            
            nodeInfo nodesInfo = krew.GetCurrentNodeId(applyId, userAccount);

            string nodeIds = string.Empty;
            if (oper != null)
            {
                nodeIds = string.Join(",", oper.Select(p => p.nodeId).ToArray());
            }
            string rtnMsg = "";
            if (!this.CheckFormData(applyId, formInstance.modelId, formInstance.templateFormId, nodeIds, out rtnMsg))
            {
                throw new Exception(rtnMsg);
            }

            string processId = formInstance.processId;
            if (!this.ApproveProcess(nodesInfo.handlers, EkpOperType.handler_pass.ToString(), "admin", auditNote, applyId, formInstance.modelId, formInstance.templateFormId, ref processId, oper, formInstance.fdTemplateFormId,formInstance.ApplySubject,formInstance.docCreator))
                throw new Exception("EKP审批通过出错");
        }


        /// <summary>
        /// 审批拒绝
        /// </summary>
        /// <returns></returns>
        public void DoReject(string userAccount, string applyId, string auditNote)
        {
            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);

            if (formInstance == null)
                throw new Exception("EKP获取表单数据出错");

            //List<EkpOperation> oper = this.GetOperationList(userAccount, applyId);
            //EkpOperParam ekpOperParam = GetEkpParam(oper, EkpOperType.handler_refuse);
            //if (ekpOperParam == null)
            //    throw new Exception("当前用户没有EKP审批驳回权限");
            kmReviewExtendWeserviceBLL krew = new kmReviewExtendWeserviceBLL();
            nodeInfo nodesInfo = krew.GetCurrentNodeId(applyId, userAccount);
            string processId = formInstance.processId;
            if (!this.ApproveProcess(userAccount, EkpOperType.handler_refuse.ToString(), "admin", auditNote, applyId, formInstance.modelId, formInstance.templateFormId, ref processId, null, formInstance.fdTemplateFormId, formInstance.ApplySubject,formInstance.docCreator))
                throw new Exception("EKP审批拒绝出错");
        }


        #region EKP WebService 调用方法



        private bool ApproveProcess(string userAccount, string operationType, string operationName, string auditNote
            , string applyId, string modelId, string templateFormId, ref string processId, List<EkpOperation> operList,string fdTemplateFormId="",string subObject="", string dcCreater = "")
        {
            return ApproveProcess(userAccount, string.Empty, operationType, operationName, string.IsNullOrEmpty(auditNote) ? string.Empty : auditNote
                , applyId, modelId, templateFormId,ref processId, null, operList, null,fdTemplateFormId, subObject, dcCreater);
        }

        /// <summary>
        /// 提交流程
        /// </summary>
        /// <returns></returns>
        private bool ApproveProcess(string userAccount, string activityType, string operationType, string operationName, string auditNote
            , string applyId, string modelId, string templateFormId,ref string processId, string taskId, List<EkpOperation> operList
            , string userList = null,string fdTemplateFormId="",string subObject="",string dcCreater="")
        {
            DateTime startDate = DateTime.Now;
            DateTime endDate = startDate;
            string reqMsg = null;
            string resMsg = null;
            string resMsg2 = null;
            bool success = true;
            //processId = "";
            try
            {
                if (string.IsNullOrEmpty(userAccount))
                {
                    throw new Exception("审批人为空");
                }
                
                ekpParam.fdTemplateId = fdTemplateFormId;//DictionaryHelper.GetDictionaryNameById("CONST_TemplateId", "ApointmentLP");
                ekpParam.docSubject = subObject;
                //docCreator dc = new docCreator();
                Hashtable dc = new Hashtable();
                Hashtable fp = new Hashtable();
                dc.Add("LoginName", dcCreater);
                ekpParam.fdId = processId;
                //流程表单参数
                //ekpParam.formValues = this.GetCommonFormDataString(applyId, modelId, templateFormId);

                //string strContent = "hello world!";

                //ekpParam.docContent = new string(bt, 0, bt.Length, "UTF-8"); new EkpHtmlBLL().GetDmsHtmlCommonById(applyId, modelId, templateFormId, DmsTemplateHtmlType.Normal, "")
                string strInput = "";//new EkpHtmlBLL().GetDmsHtmlCommonById(applyId, modelId, templateFormId, DmsTemplateHtmlType.Normal, "");
                if (!string.IsNullOrEmpty(processId))
                {
                    strInput = new EkpHtmlBLL().GetDmsHtmlCommonById(applyId, modelId, templateFormId, DmsTemplateHtmlType.Normal, "");
                }
                //最后一个参数为富文本内容，传在formvalue
                ekpParam.formValues = this.GetCommonFormDataListString(applyId, modelId, templateFormId, strInput);
                if (string.IsNullOrEmpty(processId))//|| operationType == EkpOperType.drafter_submit.ToString()
                {                    
                    //flowParam fp = new flowParam();
                    
                    ekpParam.docStatus = "20";
                    ekpParam.docCreator = JsonHelper.Serialize(dc);
                    resMsg = ekpService.addReview(ekpParam);
                }
                else
                {
                    
                    //fp.operationType = operationType;
                    fp.Add("operationType", operationType);
                    //fp.auditNode = auditNote;
                    nodeInfo ndi = new kmReviewExtendWeserviceBLL().GetCurrentNodeId(applyId, userAccount);
                    string[] handler = ndi.handlers.Split(';');
                    Hashtable approver = new Hashtable();
                    approver.Add("LoginName", handler[handler.Length - 1]);
                    //string operationUser = "{LoginName:" + handler[handler.Length - 1] + "}";
                    fp.Add("handler", approver);
                    //fp.Add("handler", operationUser);
                    if (operationType == EkpOperType.handler_refuse.ToString())
                    {
                        if (string.IsNullOrEmpty(auditNote))
                        {
                            auditNote = "拒绝";
                        }
                        fp.Add("futureNodeId", "N2");
                        Hashtable op = new Hashtable();
                        op.Add("jumpToNodeId", "N2");
                        op.Add("refusePassedToThisNode", false);
                        fp.Add("operParam", op);
                        //ekpParam.docStatus = "10";
                    }
                    else
                    {
                        if (string.IsNullOrEmpty(auditNote))
                        {
                            if (operationType == EkpOperType.drafter_submit.ToString())
                            {
                                auditNote = "提交";
                            }
                            else
                            {
                                auditNote = "同意";
                            }
                        }
                        //ekpParam.docStatus = "20";
                    }
                    //接口要求  审批意见传auditNode，退回意见传auditNote
                    fp.Add("auditNote", auditNote);
                    fp.Add("auditNode", auditNote);
                    ekpParam.docCreator = JsonHelper.Serialize(dc);
                    
                    ekpParam.flowParam = JsonHelper.Serialize(fp);
                    resMsg = ekpService.approveProcess(ekpParam);
                    //审批之后更新html
                    //resMsg2 = ekpService.updateReviewInfo(ekpParam);
                }
                //日志是否记录富文本相关参数，减轻数据库压力
                string IsWriteFormValuesToDB = System.Configuration.ConfigurationManager.AppSettings["ISWriteFormValues"];
                if(string.IsNullOrEmpty(IsWriteFormValuesToDB) || !IsWriteFormValuesToDB.Equals("1"))
                    ekpParam.formValues = null;
                reqMsg = string.Format("ApproveProcess({0})", JsonHelper.Serialize(ekpParam));
                if (!string.IsNullOrEmpty(resMsg))
                {
                    //ReturnKmRP rkrp = JsonHelper.Deserialize<ReturnKmRP>(resMsg);
                    //processId = rkrp.fdId;
                    processId = resMsg;
                }
                this.ValidateEkpReturnValue(resMsg);
                
                endDate = DateTime.Now;
                this.InsertWorkflowLog(applyId,startDate,endDate, reqMsg, processId, success, null);
            }
            catch (Exception ex)
            {
                processId = "";
                endDate = DateTime.Now;
                success = false;
                this.InsertWorkflowLog(applyId,startDate,endDate, reqMsg, resMsg, success, ex.Message);
            }

            //如果EKP接口调用成功，则处理SW审批事件
            if (success)
            {
                string nodeIds = string.Empty;
                if (operList != null)
                {
                    nodeIds = string.Join(",", operList.Select(p => p.nodeId).ToArray());
                }

                _log.Info("#######ApplyId:" + applyId + "#######nodeIds:" + nodeIds);
                kmReviewExtendWeserviceBLL krew = new kmReviewExtendWeserviceBLL();
                string nextApprove = "";
                do
                {
                    System.Threading.Thread.Sleep(500);
                    nextApprove = krew.GetCurrentNodeOperation(processId);                    
                }
                while (userAccount == nextApprove);
                if (!string.IsNullOrEmpty(nextApprove))
                {
                    this.UpdateCommonFormStatus(applyId, modelId, templateFormId, nodeIds, operationType, operationName, nextApprove, auditNote);
                }
            }

            return success;
        }


        /// <summary>
        /// 更新表单
        /// </summary>
        /// <returns></returns>
        private bool UpdateReviewInfo(string userAccount, string activityType, string operationType, string operationName, string auditNote
            , string applyId, string modelId, string templateFormId, ref string processId, string taskId, List<EkpOperation> operList
            , string userList = null, string fdTemplateFormId = "", string subObject = "", string dcCreater = "")
        {
            DateTime startDate = DateTime.Now;
            DateTime endDate = startDate;
            string reqMsg = null;
            string resMsg = null;
            string resMsg2 = null;
            bool success = true;
            //processId = "";
            try
            {
                

                ekpParam.fdTemplateId = fdTemplateFormId;//DictionaryHelper.GetDictionaryNameById("CONST_TemplateId", "ApointmentLP");
                ekpParam.docSubject = subObject;
                //docCreator dc = new docCreator();
                Hashtable dc = new Hashtable();
                Hashtable fp = new Hashtable();
                dc.Add("LoginName", dcCreater);
                ekpParam.fdId = processId;

                if (string.IsNullOrEmpty(processId))//|| operationType == EkpOperType.drafter_submit.ToString()
                {
                    //ekpParam.docStatus = "20";
                    ekpParam.docCreator = JsonHelper.Serialize(dc);
                    resMsg = ekpService.updateReviewInfo(ekpParam);
                }
                else
                {
                    string strInput = new EkpHtmlBLL().GetDmsHtmlCommonById(applyId, modelId, templateFormId, DmsTemplateHtmlType.Normal, "");
                    //最后一个参数为富文本内容，传在formvalue
                    ekpParam.formValues = this.GetCommonFormDataListString(applyId, modelId, templateFormId, strInput);
                    //fp.operationType = operationType;
                    fp.Add("operationType", operationType);
                    //fp.auditNode = auditNote;
                    nodeInfo ndi = new kmReviewExtendWeserviceBLL().GetCurrentNodeId(applyId, userAccount);
                    string[] handler = ndi.handlers.Split(';');
                    string[] operationUser = new string[] { "LoginName:" + handler[handler.Length - 1] };
                    fp.Add("handler", operationUser);
                    if (operationType == EkpOperType.handler_refuse.ToString())
                    {
                        if (string.IsNullOrEmpty(auditNote))
                        {
                            auditNote = "拒绝";
                        }
                        fp.Add("futureNodeId", "N2");
                        Hashtable op = new Hashtable();
                        op.Add("jumpToNodeId", "N2");
                        op.Add("refusePassedToThisNode", false);
                        fp.Add("operParam", op);
                        //ekpParam.docStatus = "10";
                    }
                    else
                    {
                        if (string.IsNullOrEmpty(auditNote))
                        {
                            if (operationType == EkpOperType.drafter_submit.ToString())
                            {
                                auditNote = "提交";
                            }
                            else
                            {
                                auditNote = "同意";
                            }
                        }
                    }
                    //接口要求  审批意见传auditNode，退回意见传auditNote
                    fp.Add("auditNote", auditNote);
                    fp.Add("auditNode", auditNote);
                    ekpParam.docCreator = JsonHelper.Serialize(dc);

                    ekpParam.flowParam = JsonHelper.Serialize(fp);
                    //审批之后更新html
                    resMsg = ekpService.updateReviewInfo(ekpParam);
                }
                ekpParam.formValues = null;
                reqMsg = string.Format("ApproveProcess({0})", JsonHelper.Serialize(ekpParam));
                if (!string.IsNullOrEmpty(resMsg))
                {
                    //ReturnKmRP rkrp = JsonHelper.Deserialize<ReturnKmRP>(resMsg);
                    //processId = rkrp.fdId;
                    processId = resMsg;
                }
                this.ValidateEkpReturnValue(resMsg);

                endDate = DateTime.Now;
                this.InsertWorkflowLog(applyId, startDate, endDate, reqMsg, processId, success, null);
            }
            catch (Exception ex)
            {
                processId = "";
                endDate = DateTime.Now;
                success = false;
                this.InsertWorkflowLog(applyId, startDate, endDate, reqMsg, resMsg, success, ex.Message);
            }

            return success;
        }

        public EkpOperParam GetEkpParam(List<EkpOperation> list, EkpOperType operType)
        {
            EkpOperParam opParam = null;

            foreach (EkpOperation operation in list)
            {
                foreach (OperationParam ops in operation.operations)
                {
                    if (ops.operationType == operType.ToString())
                    {
                        opParam = new EkpOperParam();
                        opParam.activityType = operation.activityType;
                        opParam.taskId = operation.taskId;
                        opParam.nodeId = operation.nodeId;
                        opParam.expectedName = operation.expectedName;
                        opParam.taskFrom = operation.taskFrom;

                        opParam.operationType = ops.operationType;
                        opParam.operationName = ops.operationName;
                        opParam.operationHandlerType = ops.operationHandlerType;
                        return opParam;
                    }
                }
            }
            return opParam;
        }


        #endregion

        #endregion

        #region 私有方法
        private void ValidateEkpReturnValue(string ekpRtnVal)
        {
            if (string.IsNullOrEmpty(ekpRtnVal))
                throw new Exception("EKP返回值为空");

            if ("1" != ekpRtnVal.Substring(0, 1))
                throw new Exception(string.Format("EKP返回错误信息：{0}", ekpRtnVal));
        }

        /// <summary>
        /// 提交时将FormData的扩展字段中存放数据（列如 申请金额RMB、USD等信息）
        /// </summary>
        /// <param name="applyId"></param>
        /// <param name="modelId"></param>
        /// <param name="templateFormId"></param>
        /// <param name="rev1"></param>
        /// <param name="rev2"></param>
        /// <param name="rev3"></param>
        private void GetDmsFormDataExtendedField(string applyId, string modelId, string templateFormId
            , out string rev1, out string rev2, out string rev3)
        {
            rev1 = string.Empty;
            rev2 = string.Empty;
            rev3 = string.Empty;

            if (modelId == EkpModelId.Consignment.ToString() && templateFormId == EkpTemplateFormId.ConsignmentTemplate.ToString())
            {
                DataTable dt = this.GetCommonFormData(applyId, modelId, templateFormId);

                if (dt.Rows.Count > 0)
                {
                    rev2 = dt.Rows[0]["TotalRMB"].ToString();
                    rev3 = dt.Rows[0]["TotalUSD"].ToString();
                }
                else
                    throw new Exception("FormData获取异常");
            }
            else if (modelId == EkpModelId.DealerReturn.ToString() && templateFormId == EkpTemplateFormId.DealerReturnTemplate.ToString())
            {
                DataTable dt = this.GetCommonFormData(applyId, modelId, templateFormId);

                if (dt.Rows.Count > 0)
                {
                    rev2 = dt.Rows[0]["TotalAmountRMB"].ToString();
                    rev3 = dt.Rows[0]["TotalAmountUSD"].ToString();
                }
                else
                    throw new Exception("FormData获取异常");
            }
        }


        #endregion 
    }
}
