using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.EKPWorkflow
{
    [Serializable]
    public class ModelSetting
    {
        public Guid Id;
        public string sysId;
        public string modelId;
        public string modelName;
        public string templateFormId;
        public string templateFormName;
        public string formUrl;
        public string language;
        public string Rev1;
        public string Rev2;
        public string Rev3;
        public DateTime CreateDate;
        public Guid CreateUser;
        public DateTime UpdateDate;
        public Guid UpdateUser;
    }
}