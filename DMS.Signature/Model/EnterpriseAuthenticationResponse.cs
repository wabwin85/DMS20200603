using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Signature.Model
{
    public class EnterpriseBaseResult
    {
        public int errCode;
        public string msg;
    }

    public class EnterpriseInfoAuthResult: EnterpriseBaseResult
    {
        public string serviceId;
    }

    public class EnterpriseToPayReslt: EnterpriseBaseResult
    {
        public string serviceId;
    }

    public class EnterprisePayComplateReslt
    {
        public string result;
        public string payedTime;
        public string pizId;
        public string serviceId;
        public string projectId;
        public string msg;
    }
}
