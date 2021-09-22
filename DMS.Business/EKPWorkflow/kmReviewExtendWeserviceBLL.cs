using Common.Logging;
using DMS.Common;
using DMS.DataAccess.EKPWorkflow;
using DMS.Model.EKPWorkflow;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business.EKPWorkflow
{
    public class kmReviewExtendWeserviceBLL
    {
        private static ILog _log = LogManager.GetLogger("kmReviewExtendWeserviceBLL");
        kmReviewNodeService.IKmReviewNodeServiceService ekpService;
        kmReviewWebserviceBLL kmRWService;
        public kmReviewExtendWeserviceBLL()
        {
            ekpService = new kmReviewNodeService.IKmReviewNodeServiceService();
            kmRWService = new kmReviewWebserviceBLL();
            ekpService.Timeout = 1000 * 60 * 3;
            ekpService.Url = System.Configuration.ConfigurationManager.AppSettings["EKPGetNodesURL"];
            string userName = System.Configuration.ConfigurationManager.AppSettings["OAUserName"];
            string passWord = System.Configuration.ConfigurationManager.AppSettings["OAPassWord"];
            ekpService.RequestSOAPHeader = new RequestSOAPHeader(userName, passWord);
            ekpService.RequestSOAPHeader.Namespaces.Add("tns", "http://sys.webservice.client");
        }
        /// <summary>
        /// 获得用户当前所在节点信息
        /// </summary>
        /// <param name="applyId"></param>
        /// <param name="userAccount"></param>
        /// <returns></returns>
        public nodeInfo GetCurrentNodeId(string applyId, string userAccount)
        {            
            return GetOperationListString(userAccount, applyId);
        }
        
        public nodeInfo GetOperationListString(string userAccount, string applyId)
        {
            DateTime startDate = DateTime.Now;
            DateTime endDate = startDate;

            FormInstanceMaster formInstance = kmRWService.GetFormInstanceMasterByApplyId(applyId);

            if (formInstance == null)
                throw new Exception("EKP获取表单数据出错");

            string reqMsg = null;
            string resMsg = null;
            List<nodeInfo> nodeList = new List<nodeInfo>();
            bool success = false;
            nodeInfo retNode = new nodeInfo();
            try
            {                
                reqMsg = string.Format("getNodeById({0})", formInstance.processId);
                resMsg = ekpService.getNodeById(formInstance.processId);

                this.ValidateEkpReturnValue(resMsg);

                nodeList = JsonHelper.Deserialize<List<nodeInfo>>(resMsg);
                //判断用户是否有权限操作
                
                foreach (var node in nodeList)
                {
                    if ((node.handlers.ToLower() + ";").IndexOf(userAccount.ToLower()) >= 0)
                    {
                        retNode = node;
                        success = true;
                        break;
                        
                    }
                    //下面这行两边用户同步后需要删掉
                    //retNode = node;
                }
                if (!success)
                {
                    throw new Exception("当前用户无权限进行审批操作！");
                }
                endDate = DateTime.Now;
                kmRWService.InsertWorkflowLog(applyId, startDate, endDate, reqMsg, resMsg, success, null);
            }
            catch (Exception ex)
            {
                endDate = DateTime.Now;
                success = false;
                kmRWService.InsertWorkflowLog(applyId, startDate, endDate, reqMsg, resMsg, success, ex.Message);

            }

            return retNode;
        }
        public List<EkpOperation> GetOperationList(string userAccount, string applyId)
        {
            DateTime startDate = DateTime.Now;
            DateTime endDate = startDate;

            FormInstanceMaster formInstance = kmRWService.GetFormInstanceMasterByApplyId(applyId);

            if (formInstance == null)
                throw new Exception("EKP获取表单数据出错");

            List<EkpOperation> leot = new List<EkpOperation>();
            string reqMsg = null;
            string resMsg = null;
            List<nodeInfo> nodeList = new List<nodeInfo>();
            bool success = true;
            string currentNode = "";
            try
            {
                reqMsg = string.Format("getNodeById({0})", formInstance.processId);
                resMsg = ekpService.getNodeById(formInstance.processId);

                this.ValidateEkpReturnValue(resMsg);
                List<OperationParam> lop = new List<OperationParam>();
                nodeList = JsonHelper.Deserialize<List<nodeInfo>>(resMsg);
                foreach (var node in nodeList)
                {
                    currentNode += node.handlers.ToLower() + ";";
                    //判断用户是否有权限操作
                    if ((node.handlers.ToLower() + ";").IndexOf(userAccount.ToLower()) >= 0)
                    {
                        OperationParam op = new OperationParam();
                        op.operationName = "通过";
                        op.operationType = EkpOperType.handler_pass.ToString();
                        lop.Add(op);
                        OperationParam op2 = new OperationParam();
                        op2.operationName = "退回";
                        op2.operationType = EkpOperType.handler_refuse.ToString();
                        lop.Add(op2);
                        if (node.nodeId == "N2")
                        {
                            OperationParam op3 = new OperationParam();
                            op.operationName = "提交";
                            op.operationType = EkpOperType.drafter_submit.ToString();
                            lop.Add(op3);
                        }
                        EkpOperation eot = new EkpOperation();
                        eot.operations = lop;
                        //eot.nodeId = node.nodeId;
                        eot.nodeId = node.nodeName;
                        leot.Add(eot);
                    }
                }
                
                endDate = DateTime.Now;
                kmRWService.InsertWorkflowLog(applyId, startDate, endDate, reqMsg, resMsg, success, null);
                //更新当前审批人
                UpdateCurrentApprover(applyId, formInstance.modelId, formInstance.templateFormId, currentNode);
            }
            catch (Exception ex)
            {
                endDate = DateTime.Now;
                success = false;
                kmRWService.InsertWorkflowLog(applyId, startDate, endDate, reqMsg, resMsg, success, ex.Message);

            }

            return leot;
        }
        public string GetCurrentNodeOperation(string processId)
        {
            string accoutList = "";
            DateTime startDate = DateTime.Now;
            DateTime endDate = startDate;
            string reqMsg = null;
            string resMsg = null;
            List<nodeInfo> nodeList = new List<nodeInfo>();
            bool success = true;
            try
            {
                reqMsg = string.Format("getNodeById({0})", processId);
                resMsg = ekpService.getNodeById(processId);

                this.ValidateEkpReturnValue(resMsg);
                nodeList = JsonHelper.Deserialize<List<nodeInfo>>(resMsg);
                foreach (var node in nodeList)
                {
                    accoutList += node.handlers.ToLower() + ";";                    
                }

                endDate = DateTime.Now;
                kmRWService.InsertWorkflowLog(processId, startDate, endDate, reqMsg, resMsg, success, null);
            }
            catch (Exception ex)
            {
                endDate = DateTime.Now;
                success = false;
                kmRWService.InsertWorkflowLog(processId, startDate, endDate, reqMsg, resMsg, success, ex.Message);

            }
            return accoutList;
        }
        private void ValidateEkpReturnValue(string ekpRtnVal)
        {
            if (string.IsNullOrEmpty(ekpRtnVal))
                throw new Exception("EKP返回值为空");

        }
        private void UpdateCurrentApprover(string applyId, string modelId, string templateFormId, string userAccount)
        {
            using (FormInstanceMasterDao dao = new FormInstanceMasterDao())
            {
                Hashtable table = new Hashtable();
                table.Add("FormInstanceId", applyId);
                table.Add("ModelId", modelId);
                table.Add("TemplateFormId", templateFormId);
                table.Add("UserAccount", userAccount);

                dao.UpdateCurrentApprover(table);
            }
        }
    }
}
