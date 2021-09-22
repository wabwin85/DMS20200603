using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Model.DataInterface.SampleManage
{
    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class SoapReceiveSample
    {
        [XmlElement("Record")]
        public SoapReceiveSampleHead ReceiveSampleHead { get; set; }
    }
}
