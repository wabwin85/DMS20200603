using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.DataInterface.SampleManage
{
    [Serializable]
    public class SoapReceiveSampleHead
    {
        public String ApplyNo { get; set; }
        public String DeliveryNo { get; set; }
    }
}
