using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Model.DataInterface.SampleManage
{
    [Serializable]
    public class SoapSampleEvalHead
    {
        public String ApplyNo { get; set; }

        [XmlArray("EvalList"), XmlArrayItem("EvalItem")]
        public SoapSampleEval[] EvalList;
    }
}
