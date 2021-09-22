using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.DataInterface.SampleManage
{
    [Serializable]
    public class SoapSampleTesting
    {
        public String Division { get; set; }
        public String Priority { get; set; }
        public String Certificate { get; set; }
        public String CostCenter { get; set; }
        public String ArrivalDate { get; set; }
        public String Irf { get; set; }
        public String Ra { get; set; }
    }
}
