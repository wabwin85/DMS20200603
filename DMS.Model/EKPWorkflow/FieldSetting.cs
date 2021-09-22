using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.EKPWorkflow
{
    [Serializable]
    public class FieldSetting
    {
        public Guid Id;
        public string sysId;
        public string modelId;
        public string templateFormId;
        public string language;
        public string fieldId;
        public string fieldName;
        public string type;
        public string Rev1;
        public string Rev2;
        public string Rev3;
        public DateTime CreateDate;
        public Guid CreateUser;
        public DateTime UpdateDate;
        public Guid UpdateUser;
    }
}
