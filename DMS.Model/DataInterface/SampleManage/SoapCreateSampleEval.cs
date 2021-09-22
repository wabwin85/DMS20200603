using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Model.DataInterface.SampleManage
{
    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class SoapCreateSampleEval
    {
        [XmlElement("Record")]
        public SoapSampleEvalHead SampleEvalHead { get; set; }
    }
}
