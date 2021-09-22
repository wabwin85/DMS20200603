using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Model.DataInterface.SampleManage
{
    [Serializable]
    public class SoapSampleReturnHead
    {
        public String SampleType { get; set; }
        public String ReturnNo { get; set; }
        public String SapCode { get; set; }
        public String ReturnRequire { get; set; }
        public String ReturnDate { get; set; }
        public String ReturnUserID { get; set; }
        public String ReturnUser { get; set; }
        public String ProcessUserID { get; set; }
        public String ProcessUser { get; set; }
        public String ReturnHosp { get; set; }
        public String ReturnDept { get; set; }
        public String ReturnDivision { get; set; }
        public String DealerName { get; set; }
        public String ReturnReason { get; set; }
        public String ReturnQuantity { get; set; }
        public String ConfirmQuantity { get; set; }
        public String ReturnMemo { get; set; }

        [XmlArray("UpnList"), XmlArrayItem("UpnItem")]
        public SoapSampleUpn[] UpnList;
    }
}
