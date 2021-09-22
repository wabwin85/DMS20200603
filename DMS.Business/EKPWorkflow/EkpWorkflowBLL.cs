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

namespace DMS.Business.EKPWorkflow
{
    public class EkpWorkflowBLL
    {
        private static ILog _log = LogManager.GetLogger("EkpWorkflowBLL");
        #region 属性
        EkpWebService.IntegratedWebServiceService ekpService ;
        #endregion
        public EkpWorkflowBLL()
        {
            ekpService = new EkpWebService.IntegratedWebServiceService();
            ekpService.Timeout = 1000 * 60 * 3;
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

        public string GetCommonFormDataListString(string applyId, string modelId, string templateFormId, string fieldIds)
        {
            DataTable dt = this.GetCommonFormData(applyId, modelId, templateFormId);

            List<object> fieldList = new List<object>();

            foreach (DataColumn col in dt.Columns)
            {
                if (string.IsNullOrEmpty(fieldIds) || fieldIds.Split(new char[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries).Contains(col.ColumnName))
                {
                    fieldList.Add(new { fieldId = col.ColumnName, fieldValue = dt.Rows[0][col.ColumnName] });
                }
            }

            return JsonHelper.Serialize(fieldList);
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
                BaseService.AddCommonFilterCondition(table);

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
            , string modelId, string templateFormId, string processId, string rev1, string rev2, string rev3)
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
        /// 校验当前登录人是否有查阅单据的权限
        /// </summary>
        /// <param name="applyId"></param>
        /// <param name="userAccount"></param>
        /// <returns></returns>
        public bool ValidateUserCanReadEkpProcess(string applyId, string userAccount)
        {
            bool result = false;
            EkpAuditOption auditOption = this.GetAuditOptionList(applyId, userAccount, "1", "1");

            if (auditOption != null && auditOption.page != null && auditOption.page.totalSize > 0)
                result = true;

            return result;
        }

        /// <summary>
        /// 校验当前登录人是否有编辑单据的权限（即审批通过的权限）
        /// </summary>
        /// <param name="applyId"></param>
        /// <param name="userAccount"></param>
        /// <returns></returns>
        public bool ValidateUserCanEditEkpProcess(string applyId, string userAccount)
        {
            bool result = false;
            List<EkpOperation> oper = this.GetOperationList(userAccount, applyId);
            EkpOperParam ekpOperParam = GetEkpParam(oper, EkpOperType.handler_pass);
            if (ekpOperParam != null)
                result = true;

            return result;
        }

        /// <summary>
        /// 查询EKP单据审批日志信息
        /// </summary>
        /// <param name="applyId"></param>
        /// <param name="userAccount"></param>
        /// <param name="pageNo"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public EkpAuditOption GetAuditOptionList(string applyId, string userAccount, string pageNo, string pageSize)
        {
            DateTime startDate = DateTime.Now;
            DateTime endDate = startDate;
            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);

            if (formInstance == null)
                throw new Exception("EKP获取表单数据出错");

            string reqMsg = null;
            string resMsg = null;
            EkpAuditOption result = new EkpAuditOption();
            try
            {
                Hashtable formId = new Hashtable();
                formId.Add("sysId", EkpSetting.CONST_EKP_SYS_ID);
                formId.Add("modelId", formInstance.modelId);
                formId.Add("templateFormId", formInstance.templateFormId);
                formId.Add("formInstanceId", applyId);

                Hashtable creator = new Hashtable();
                creator.Add("LoginName", userAccount.ToUpper());

                reqMsg = string.Format("GetAuditOptionList({0}, {1}, {2}, {3}, {4}, null)", JsonHelper.Serialize(formId), formInstance.processId, JsonHelper.Serialize(creator), pageNo, pageSize);
                resMsg = ekpService.GetAuditOptionList(JsonHelper.Serialize(formId), formInstance.processId, JsonHelper.Serialize(creator), pageNo, pageSize, null);

                this.ValidateEkpReturnValue(resMsg);

                if (resMsg.Substring(2).ToUpper() != "FALSE")
                {
                    result = JsonHelper.Deserialize<EkpAuditOption>(resMsg.Substring(2));
                }
                endDate = DateTime.Now;
                this.InsertWorkflowLog(applyId, startDate, endDate, reqMsg, resMsg, true, null);
            }
            catch (Exception ex)
            {
                endDate = DateTime.Now;
                this.InsertWorkflowLog(applyId, startDate, endDate, reqMsg, resMsg, false, ex.Message);
            }

            return result;
        }

        /// <summary>
        /// 获得用户当前所在节点信息
        /// </summary>
        /// <param name="applyId"></param>
        /// <param name="userAccount"></param>
        /// <returns></returns>
        public string GetCurrentNodeId(string applyId, string userAccount)
        {
            string currentNodeIds = string.Empty;

            List<EkpOperation> operList = this.GetOperationList(userAccount, applyId);
            if (operList != null)
            {
                currentNodeIds = string.Join(",", operList.Select(p => p.nodeId).ToArray());
            }

            return currentNodeIds;
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
        public void DoSubmit(string userAccount, string applyId, string applyNo, string applyType, string applySubject, string modelId, string templateFormId)
        {
            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);
            string processId;
            string rev1 = string.Empty, rev2 = string.Empty, rev3 = string.Empty;

            if (formInstance == null)
            {
                processId = this.CreateProcess(userAccount, applyId, applySubject, modelId, templateFormId);
                if (string.IsNullOrEmpty(processId))
                    throw new Exception("EKP获取processId出错");

                ///获取FormInstanceMaster扩展字段的值
                this.GetDmsFormDataExtendedField(applyId, modelId, templateFormId, out rev1, out rev2, out rev3);

                if (this.ApproveProcess(userAccount, EkpOperType.drafter_submit.ToString(), "提交", null, applyId, modelId, templateFormId, processId, null))
                    this.InsertFormInstanceMaster(userAccount, applyId, applyNo, applyType, applySubject, modelId, templateFormId, processId, rev1, rev2, rev3);
                else
                    throw new Exception("EKP提交申请出错");
            }
            else
            {
                DoReSubmit(userAccount, applyId, "");
            }
        }

        /// <summary>
        /// 提交流程（只有提交申请）
        /// </summary>
        /// <param name="userAccount"></param>
        /// <param name="applyId"></param>
        /// <param name="applyNo"></param>
        /// <param name="applyType"></param>
        /// <param name="applySubject"></param>
        /// <param name="modelId"></param>
        /// <param name="templateFormId"></param>
        public void DoReSubmit(string userAccount, string applyId, string auditNote)
        {
            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);

            if (formInstance == null)
                throw new Exception("EKP获取表单数据出错");

            if (!this.ApproveProcess(userAccount, EkpOperType.drafter_submit.ToString(), "提交", auditNote, applyId, formInstance.modelId, formInstance.templateFormId, formInstance.processId, null))
                throw new Exception("EKP提交申请出错");
        }

        /// <summary>
        /// 撤销流程（由提交人申请）
        /// </summary>
        /// <param name="userAccount"></param>
        /// <param name="applyId"></param>
        /// <param name="applyNo"></param>
        /// <param name="applyType"></param>
        /// <param name="applySubject"></param>
        /// <param name="modelId"></param>
        /// <param name="templateFormId"></param>
        public void DoReturn(string userAccount, string applyId, string auditNote)
        {
            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);

            if (formInstance == null)
                throw new Exception("EKP获取表单数据出错");

            List<EkpOperation> oper = this.GetOperationList(userAccount, applyId);
            EkpOperParam ekpOperParam = GetEkpParam(oper, EkpOperType.drafter_return);

            if (ekpOperParam == null)
                throw new Exception("当前用户没有EKP撤销申请权限");

            if (!this.ApproveProcess(userAccount, ekpOperParam.activityType, EkpOperType.drafter_return.ToString(), ekpOperParam.operationName, auditNote, applyId, formInstance.modelId, formInstance.templateFormId, formInstance.processId, ekpOperParam.taskId, oper))
                throw new Exception("EKP撤销申请出错");
        }

        /// <summary>
        /// 废弃流程（由提交人申请）
        /// </summary>
        /// <param name="userAccount"></param>
        /// <param name="applyId"></param>
        /// <param name="applyNo"></param>
        /// <param name="applyType"></param>
        /// <param name="applySubject"></param>
        /// <param name="modelId"></param>
        /// <param name="templateFormId"></param>
        public void DoAbandon(string userAccount, string applyId, string auditNote)
        {
            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);

            if (formInstance == null)
                throw new Exception("EKP获取表单数据出错");

            List<EkpOperation> oper = this.GetOperationList(userAccount, applyId);
            EkpOperParam ekpOperParam = GetEkpParam(oper, EkpOperType.drafter_abandon);

            if (ekpOperParam == null)
                throw new Exception("当前用户没有EKP废弃申请权限");

            if (!this.ApproveProcess(userAccount, ekpOperParam.activityType, EkpOperType.drafter_abandon.ToString(), ekpOperParam.operationName, auditNote, applyId, formInstance.modelId, formInstance.templateFormId, formInstance.processId, ekpOperParam.taskId, oper))
                throw new Exception("EKP废弃申请出错");
        }

        /// <summary>
        /// 废弃流程（由审批人申请）
        /// </summary>
        /// <param name="userAccount"></param>
        /// <param name="applyId"></param>
        /// <param name="auditNote"></param>
        public void DoAbandonByHandler(string userAccount, string applyId, string auditNote)
        {
            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);

            if (formInstance == null)
                throw new Exception("EKP获取表单数据出错");

            List<EkpOperation> oper = this.GetOperationList(userAccount, applyId);
            EkpOperParam ekpOperParam = GetEkpParam(oper, EkpOperType.handler_abandon);

            if (ekpOperParam == null)
                throw new Exception("当前用户没有EKP废弃操作权限");

            if (!this.ApproveProcess(userAccount, ekpOperParam.activityType, EkpOperType.handler_abandon.ToString(), ekpOperParam.operationName, auditNote, applyId, formInstance.modelId, formInstance.templateFormId, formInstance.processId, ekpOperParam.taskId, oper))
                throw new Exception("EKP废弃操作出错");
        }

        /// <summary>
        /// 催办（由提交人申请）
        /// </summary>
        /// <param name="userAccount"></param>
        /// <param name="applyId"></param>
        /// <param name="applyNo"></param>
        /// <param name="applyType"></param>
        /// <param name="applySubject"></param>
        /// <param name="modelId"></param>
        /// <param name="templateFormId"></param>
        public void DoPress(string userAccount, string applyId, string auditNote)
        {
            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);

            if (formInstance == null)
                throw new Exception("EKP获取表单数据出错");

            List<EkpOperation> oper = this.GetOperationList(userAccount, applyId);
            EkpOperParam ekpOperParam = GetEkpParam(oper, EkpOperType.drafter_press);

            if (ekpOperParam == null)
                throw new Exception("当前用户没有EKP催办申请权限");

            if (!this.ApproveProcess(userAccount, ekpOperParam.activityType, EkpOperType.drafter_press.ToString(), ekpOperParam.operationName, auditNote, applyId, formInstance.modelId, formInstance.templateFormId, formInstance.processId, ekpOperParam.taskId, oper))
                throw new Exception("EKP催办申请出错");
        }

        /// <summary>
        /// 审批通过
        /// </summary>
        /// <returns></returns>
        public void DoAgree(string userAccount, string applyId, string auditNote)
        {
            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);

            if (formInstance == null)
                throw new Exception("EKP获取表单数据出错");

            List<EkpOperation> oper = this.GetOperationList(userAccount, applyId);
            EkpOperParam ekpOperParam = GetEkpParam(oper, EkpOperType.handler_pass);
            if (ekpOperParam == null)
                throw new Exception("当前用户没有EKP审批通过权限");

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

            if (!this.ApproveProcess(userAccount, EkpOperType.handler_pass.ToString(), ekpOperParam.operationName, auditNote, applyId, formInstance.modelId, formInstance.templateFormId, formInstance.processId, oper))
                throw new Exception("EKP审批通过出错");
        }

        public void DoPending(string userAccount, string applyId, string auditNote)
        {
            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);

            if (formInstance == null)
                throw new Exception("EKP获取表单数据出错");

            List<EkpOperation> oper = this.GetOperationList(userAccount, applyId);

            if (!this.ApproveProcess(userAccount, EkpOperType.handler_pass.ToString(), "Pending", auditNote, applyId, formInstance.modelId, formInstance.templateFormId, formInstance.processId, oper))
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

            List<EkpOperation> oper = this.GetOperationList(userAccount, applyId);
            EkpOperParam ekpOperParam = GetEkpParam(oper, EkpOperType.handler_refuse);
            if (ekpOperParam == null)
                throw new Exception("当前用户没有EKP审批驳回权限");

            if (!this.ApproveProcess(userAccount, ekpOperParam.activityType, EkpOperType.handler_refuse.ToString(), ekpOperParam.operationName, auditNote, applyId, formInstance.modelId, formInstance.templateFormId, formInstance.processId, ekpOperParam.taskId, oper))
                throw new Exception("EKP审批拒绝出错");
        }

        /// <summary>
        /// 加签
        /// </summary>
        /// <param name="userAccount"></param>
        /// <param name="applyId"></param>
        /// <param name="auditNote"></param>
        public void DoAdditionSign(string userAccount, string applyId, string auditNote, string userList)
        {
            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);

            if (formInstance == null)
                throw new Exception("EKP获取表单数据出错");

            List<EkpOperation> oper = this.GetOperationList(userAccount, applyId);
            EkpOperParam ekpOperParam = GetEkpParam(oper, EkpOperType.handler_additionSign);
            if (ekpOperParam == null)
                throw new Exception("当前用户没有EKP审批加签权限");

            if (!this.ApproveProcess(userAccount, ekpOperParam.activityType, EkpOperType.handler_additionSign.ToString(), ekpOperParam.operationName, auditNote, applyId, formInstance.modelId, formInstance.templateFormId, formInstance.processId, ekpOperParam.taskId, oper, userList))
                throw new Exception("EKP审批加签出错");
        }

        //public void DoApprove(string userAccount, string applyId, string auditNote
        //    , string activityType, string taskId, string nodeId, string taskFrom
        //    , string operationType, string operationName, string operationHandlerType
        //    , string userCodeList)
        //{
        //    FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);

        //    if (formInstance == null)
        //        throw new Exception("EKP获取表单数据出错");

        //    if (!this.ApproveProcess(userAccount, activityType, operationType, operationName, auditNote, applyId, formInstance.modelId, formInstance.templateFormId, formInstance.processId, taskId, null, userCodeList))
        //        throw new Exception("EKP审批" + operationName + "出错");
        //}

        #region EKP WebService 调用方法

        /// <summary>
        /// 通过模块Id和模板Id
        /// </summary>
        /// <param name="modelId"></param>
        /// <param name="templateFormId"></param>
        /// <returns></returns>
        private string GetFlowTemplateList(string applyId, string modelId, string templateFormId)
        {
            DateTime startDate = DateTime.Now;
            DateTime endDate = startDate;
            string flowTemplateId = null;
            string reqMsg = null;
            string resMsg = null;

            try
            {
                Hashtable formId = new Hashtable();
                formId.Add("sysId", EkpSetting.CONST_EKP_SYS_ID);
                formId.Add("modelId", modelId);
                formId.Add("templateFormId", templateFormId);

                reqMsg = string.Format("GetFlowTemplateList(null, {0}, null, null)", JsonHelper.Serialize(formId));
                resMsg = ekpService.GetFlowTemplateList(null, JsonHelper.Serialize(formId), null, null);

                this.ValidateEkpReturnValue(resMsg);

                if (resMsg.Length <= 3 || resMsg.Substring(2) == "[]")
                {
                    throw new Exception("无法或许EKP flowTemplateId");
                }
                IList<EkpFlowTemplate> flowTemplateList = JsonHelper.Deserialize<IList<EkpFlowTemplate>>(resMsg.Substring(2));

                if (flowTemplateList == null || flowTemplateList.Count() == 0)
                {
                    throw new Exception("无法或许EKP flowTemplateId");
                }

                flowTemplateId = flowTemplateList.First<EkpFlowTemplate>().flowTemplateId;
                endDate= DateTime.Now;
                this.InsertWorkflowLog(applyId,startDate,endDate, reqMsg, resMsg, true, null);
            }
            catch (Exception ex)
            {
                endDate = DateTime.Now;
                this.InsertWorkflowLog(applyId, startDate, endDate, reqMsg, resMsg, false, ex.Message);

            }
            return flowTemplateId;
        }

        /// <summary>
        /// 发起一个流程
        /// </summary>
        /// <returns></returns>
        private string CreateProcess(string userAccount, string applyId, string applySubject, string modelId, string templateFormId)
        {
            DateTime startDate = DateTime.Now;
            DateTime endDate = startDate;

            //获取EKP的流程ID
            string flowTemplateId = GetFlowTemplateList(applyId, modelId, templateFormId);

            if (string.IsNullOrEmpty(flowTemplateId))
                throw new Exception("EKP获取flowTemplateId出错");

            string processId = null;
            string reqMsg = null;
            string resMsg = null;

            try
            {
                if (string.IsNullOrEmpty(userAccount))
                {
                    throw new Exception("创建人为空");
                }

                Hashtable rtnParam = new Hashtable();
                rtnParam.Add("formInstanceId", applyId);

                Hashtable formId = new Hashtable();
                formId.Add("sysId", EkpSetting.CONST_EKP_SYS_ID);
                formId.Add("modelId", modelId);
                formId.Add("templateFormId", templateFormId);
                formId.Add("formInstanceId", applyId);

                Hashtable creator = new Hashtable();
                creator.Add("LoginName", userAccount.ToUpper());

                Hashtable exParam = new Hashtable();
                exParam.Add("docSubject", applySubject);

                //ekpService.Credentials = new NetworkCredential("Lium4", "Pa88word", "bsci");
                reqMsg = string.Format("CreateProcess({0}, {1}, {2}, {3}, null)", flowTemplateId, JsonHelper.Serialize(formId), JsonHelper.Serialize(creator), JsonHelper.Serialize(exParam));
                resMsg = ekpService.CreateProcess(flowTemplateId, JsonHelper.Serialize(formId), JsonHelper.Serialize(creator), JsonHelper.Serialize(exParam), null);

                this.ValidateEkpReturnValue(resMsg);

                processId = resMsg.Split(new char[] { ':' })[1];
                endDate = DateTime.Now;
                this.InsertWorkflowLog(applyId,startDate, endDate, reqMsg, resMsg, true, null);
            }
            catch (Exception ex)
            {
                endDate = DateTime.Now;
                this.InsertWorkflowLog(applyId, startDate, endDate, reqMsg, resMsg, false, ex.Message);

            }
            return processId;
        }

        private bool ApproveProcess(string userAccount, string operationType, string operationName, string auditNote
            , string applyId, string modelId, string templateFormId, string processId, List<EkpOperation> operList)
        {
            return ApproveProcess(userAccount, string.Empty, operationType, operationName, string.IsNullOrEmpty(auditNote) ? string.Empty : auditNote
                , applyId, modelId, templateFormId, processId, null, operList);
        }

        /// <summary>
        /// 提交流程
        /// </summary>
        /// <returns></returns>
        private bool ApproveProcess(string userAccount, string activityType, string operationType, string operationName, string auditNote
            , string applyId, string modelId, string templateFormId, string processId, string taskId, List<EkpOperation> operList
            , string userList = null)
        {
            DateTime startDate = DateTime.Now;
            DateTime endDate = startDate;
            string reqMsg = null;
            string resMsg = null;
            bool success = true;

            try
            {
                if (string.IsNullOrEmpty(userAccount))
                {
                    throw new Exception("审批人为空");
                }

                string jsonFormData = this.GetCommonFormDataString(applyId, modelId, templateFormId);

                Hashtable formId = new Hashtable();
                formId.Add("sysId", EkpSetting.CONST_EKP_SYS_ID);
                formId.Add("modelId", modelId);
                formId.Add("templateFormId", templateFormId);
                formId.Add("formInstanceId", applyId);

                Hashtable handler = new Hashtable();
                handler.Add("LoginName", userAccount.ToUpper());

                Hashtable processParam = new Hashtable();

                Hashtable param = new Hashtable();

                if (operationType == EkpOperType.drafter_return.ToString()
                    || operationType == EkpOperType.drafter_press.ToString()
                    || operationType == EkpOperType.drafter_abandon.ToString()
                    || operationType == EkpOperType.handler_refuse.ToString()
                    || operationType == EkpOperType.handler_abandon.ToString())
                {
                    if (!string.IsNullOrEmpty(taskId))
                    {
                        param.Add("taskId", taskId);
                    }
                    param.Add("activityType", activityType);
                }

                param.Add("processId", processId);
                param.Add("operationType", operationType);

                Hashtable audit = new Hashtable();
                audit.Add("operationName", operationName);
                //audit.Add("notifyType", "todo");
                audit.Add("auditNote", auditNote);

                if (operationType == EkpOperType.handler_refuse.ToString())
                    audit.Add("jumpToNodeId", "N2");
                else if (operationType == EkpOperType.handler_additionSign.ToString())
                {
                    if (string.IsNullOrEmpty(userList))
                    {
                        throw new Exception("加签用户不能为空！");
                    }

                    List<object> additionSign = new List<object>();
                    foreach (string signUserCode in userList.Split(';'))
                    {
                        if (!string.IsNullOrEmpty(signUserCode))
                        {
                            additionSign.Add(new { LoginName = signUserCode.ToUpper() });
                        }
                    }

                    audit.Add("toOtherHandlerIds", JsonHelper.Serialize(additionSign));
                    audit.Add("taskId", taskId);
                    audit.Add("activityType", activityType);
                }

                param.Add("param", audit);
                processParam.Add("sysWfBusinessForm.fdParameterJson", param);

                reqMsg = string.Format("ApproveProcess({0}, {1}, {2}, {3}, {4}, null)", JsonHelper.Serialize(formId), processId, JsonHelper.Serialize(handler), jsonFormData, JsonHelper.Serialize(processParam));
                resMsg = ekpService.ApproveProcess(JsonHelper.Serialize(formId), processId, JsonHelper.Serialize(handler), jsonFormData, JsonHelper.Serialize(processParam), null);

                this.ValidateEkpReturnValue(resMsg);
                endDate = DateTime.Now;
                this.InsertWorkflowLog(applyId,startDate,endDate, reqMsg, resMsg, success, null);
            }
            catch (Exception ex)
            {
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
                this.UpdateCommonFormStatus(applyId, modelId, templateFormId, nodeIds, operationType, operationName, userAccount, auditNote);
            }

            return success;
        }

        public List<EkpOperation> GetOperationList(string userAccount, string applyId)
        {
            List<EkpOperation> operationList = new List<EkpOperation>();
            string operationString = this.GetOperationListString(userAccount, applyId);
            try
            {
                if (operationString != "[]")
                {
                    operationList = JsonHelper.Deserialize<List<EkpOperation>>(operationString);
                    //if (operationList != null && operationList.Count() > 0)
                    //{
                    //    operation = operationList.First<EkpOperation>();

                    //    operationList.Remove(operation);

                    //    foreach (var ol in  operationList)
                    //    {
                    //        foreach (var op in ol.operations)
                    //        {
                    //            if(operation.operations.Where<OperationParam>(p=>p.operationType == op.operationType 
                    //            && p.operationName == op.operationName).Count() == 0) {
                    //                operation.operations.Add(op);
                    //            }
                    //        }
                    //    }
                    //}
                }
            }
            catch (Exception ex)
            {
                throw new Exception("获取EKP可执行操作出错");
            }
            return operationList;
        }

        public string GetOperationListString(string userAccount, string applyId)
        {
            DateTime startDate = DateTime.Now;
            DateTime endDate = startDate;

            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);

            if (formInstance == null)
                throw new Exception("EKP获取表单数据出错");

            string reqMsg = null;
            string resMsg = null;
            string operation = "[]";
            bool success = true;
            try
            {
                Hashtable formId = new Hashtable();
                formId.Add("sysId", EkpSetting.CONST_EKP_SYS_ID);
                formId.Add("modelId", formInstance.modelId);
                formId.Add("templateFormId", formInstance.templateFormId);
                formId.Add("formInstanceId", applyId);

                Hashtable handler = new Hashtable();
                handler.Add("LoginName", userAccount.ToUpper());

                reqMsg = string.Format("GetOperationList({0}, {1}, {2}, null)", JsonHelper.Serialize(formId), formInstance.processId, JsonHelper.Serialize(handler));
                resMsg = ekpService.GetOperationList(JsonHelper.Serialize(formId), formInstance.processId, JsonHelper.Serialize(handler), null);

                this.ValidateEkpReturnValue(resMsg);

                operation = resMsg.Substring(2);
                endDate = DateTime.Now;
                this.InsertWorkflowLog(applyId,startDate,endDate,reqMsg, resMsg, success, null);
            }
            catch (Exception ex)
            {
                endDate = DateTime.Now;
                success = false;
                this.InsertWorkflowLog(applyId, startDate, endDate, reqMsg, resMsg, success, ex.Message);

            }

            return operation;
        }

        public string GetCurrentNodeInfo(string userAccount, string applyId)
        {
            DateTime startDate = DateTime.Now;
            DateTime endDate = startDate;

            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(applyId);

            if (formInstance == null)
                throw new Exception("EKP获取表单数据出错");

            string reqMsg = null;
            string resMsg = null;
            string operation = "[]";
            bool success = true;
            try
            {
                Hashtable formId = new Hashtable();
                formId.Add("sysId", EkpSetting.CONST_EKP_SYS_ID);
                formId.Add("modelId", formInstance.modelId);
                formId.Add("templateFormId", formInstance.templateFormId);
                formId.Add("formInstanceId", applyId);

                reqMsg = string.Format("GetCurrentNodesInfo({0}, {1}, null)", JsonHelper.Serialize(formId), formInstance.processId);
                resMsg = ekpService.GetCurrentNodesInfo(JsonHelper.Serialize(formId), formInstance.processId, null);

                this.ValidateEkpReturnValue(resMsg);

                //operation = resMsg.Substring(2);
                endDate = DateTime.Now;
                this.InsertWorkflowLog(applyId,startDate,endDate, reqMsg, resMsg, success, null);
            }
            catch (Exception ex)
            {
                success = false;
                endDate = DateTime.Now;
                this.InsertWorkflowLog(applyId, startDate, endDate, reqMsg, resMsg, success, ex.Message);

            }

            return operation;
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

        public List<EkpOperParam> GetEkpParamList(string userAccount, string applyId)
        {
            List<EkpOperation> list = this.GetOperationList(userAccount, applyId);

            List<EkpOperParam> paramList = new List<EkpOperParam>();
            EkpOperParam opParam = null;

            foreach (EkpOperation operation in list)
            {
                foreach (OperationParam ops in operation.operations)
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

                    paramList.Add(opParam);
                }
            }
            return paramList;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="userAccount"></param>
        /// <param name="delayApplyId"></param>
        /// <param name="mainId"></param>
        /// <param name="applyNo"></param>
        /// <param name="applyType"></param>
        /// <param name="applySubject"></param>
        /// <param name="modelId"></param>
        /// <param name="templateFormId"></param>
        public void DoSubmitForConsignmentDelayApply(string userAccount, string delayApplyId, string mainId, string applyNo, string applyType, string applySubject, string modelId, string templateFormId)
        {
            FormInstanceMaster formInstance = this.GetFormInstanceMasterByApplyId(delayApplyId);
            string processId;
            if (formInstance == null)
            {
                processId = this.CreateProcess(userAccount.ToUpper(), delayApplyId, applySubject, modelId, templateFormId);
                if (string.IsNullOrEmpty(processId))
                    throw new Exception("EKP获取processId出错");

                if (this.ApproveProcess(userAccount.ToUpper(), EkpOperType.drafter_submit.ToString(), "提交", null, delayApplyId, modelId, templateFormId, processId, null))
                {
                    string rev1 = string.Empty, rev2 = string.Empty, rev3 = string.Empty;
                    this.GetDmsFormDataExtendedField(delayApplyId, modelId, templateFormId, out rev1, out rev2, out rev3);

                    //扩展字段：Rev1:申请单CAH_ID; Rev2:TotalRmb; Rev3:TotalUsd;
                    this.InsertFormInstanceMaster(userAccount.ToUpper(), delayApplyId, applyNo, applyType, applySubject, modelId, templateFormId, processId
                        , mainId, rev2, rev3);
                }
                else
                    throw new Exception("EKP提交申请出错");
            }
            else
            {
                DoReSubmit(userAccount.ToUpper(), delayApplyId, "");
            }
        }

        #endregion

        #endregion

        #region 私有方法
        private void ValidateEkpReturnValue(string ekpRtnVal)
        {
            if (string.IsNullOrEmpty(ekpRtnVal))
                throw new Exception("EKP返回值为空");

            if ("T" != ekpRtnVal.Substring(0, 1))
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
