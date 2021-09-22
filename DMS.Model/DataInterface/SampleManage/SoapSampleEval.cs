using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.DataInterface.SampleManage
{
    [Serializable]
    public class SoapSampleEval
    {
        public String UpnNo { get; set; }
        public String Lot { get; set; }
        public String EvalQuantity { get; set; }
        public String UpnMemo { get; set; }
    }
}
