using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.EKPWorkflow
{
    public class KmReviewParamterForm
    {
        //文档标题
        public string docSubject;
        //文档模板id
        public string templateId;
        //文档的富文本内容
        public string docContent;
        //流程表单数据
        public string formValues;
        //文档状态，可以为草稿（"10"）或者待审（"20"）两种状态，默认为待审
        public string docStatus;
        //流程发起人，为单值，格式详见人员组织架构的定义说明
        public string docCreator;
        //文档关键字，格式为["关键字1", "关键字2"...]
        public string fdKeyword;
        //辅类别，格式为["辅类别1的ID", "辅类别2的ID"...]
        public string docProperty;
        //流程参数
        public string flowParam;
        //附件列表
        public string attachmentForms;
        //文档模板id
        public string fdId;
    }
    /// <summary>
    /// EKP服务返回值
    /// </summary>
    public class ReturnKmRP
    {
        public string fdId;
    }
    /// <summary>
    /// 流程参数
    /// </summary>
    public class flowParam
    {
        //操作类型，例如：handler_pass或者handler_refuse，不允许为空
        public string operationType;
        //审批意见，不允许为空
        public string auditNode;
        //流向下一节点的ID，需要人工决策时设置此参数，允许为空
        public string futureNodeId;
        //节点的处理人，格式为["节点名1：处理人ID1; 处理人ID2...","节点名2：处理人ID1; 处理人ID2..."...]，需要修改处理人时设置此参数，允许为空
        //public string changeNodeHandlers;
        //操作参数，各种操作需要添加的参数。例如：驳回,格式为{"jumpToNodeId":"N2","refusePassedToThisNode":true,...}，允许为空
        //public string operParam;
        public flowParam()
        {
            operationType = string.Empty;
            auditNode = string.Empty;
            futureNodeId = string.Empty;
            //changeNodeHandlers = string.Empty;
            //operParam = string.Empty;
        }
    }
    public class docCreator
    {
        public string LoginName;
    }
    /// <summary>
    /// 当前节点信息
    /// </summary>
    public class nodeInfo
    {
        public string nodeId;
        public string handlers;
        public string nodeName;
        public string handlersFdId;
    }
}
