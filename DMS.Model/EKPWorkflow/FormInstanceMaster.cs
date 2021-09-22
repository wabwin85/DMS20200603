using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.EKPWorkflow
{
    [Serializable]
    public class FormInstanceMaster
    {
        public Guid Id;
        public Guid? ApplyId;
        public string ApplyNo;
        public string ApplyType;
        public string ApplySubject;
        public string sysId;
        public string modelId;
        public string templateFormId;
        public string fdTemplateFormId;
        public string language;
        public string processId;
        public string taskId;
        public string nodeId;
        public string nodeName;
        public string approverUser;
        public string Rev1;
        public string Rev2;
        public string Rev3;
        public string desc;
        public DateTime CreateDate;
        public string CreateUser;
        public DateTime? UpdateDate;
        public string UpdateUser;
        public string docCreator;
    }
}
