using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.EKPWorkflow
{
    [Serializable]
    public class WorkflowLog
    {
        public Guid Id;
        public Guid ApplyId;
        public string Name;
        public DateTime StartTime;
        public DateTime EndTime;
        public string Status;
        public string FileName;
        public string RequestMessage;
        public string ResponseMessage;
        public string ClientId;
        public string BatchNbr;
    }
}
