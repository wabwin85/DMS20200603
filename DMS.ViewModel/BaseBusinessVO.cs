using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;

namespace DMS.ViewModel
{
    public class BaseBusinessVO : BaseVO
    {
        public BaseBusinessVO()
        {
        }

        public String ViewMode;

        public String LastModifyDate;
        public bool IsNewApply;
        public bool IsDealer;
        public bool IsCanApply;
        [LogAttribute]
        public String InstanceId;

        public IList<Hashtable> RstOperationLog;
    }
}
