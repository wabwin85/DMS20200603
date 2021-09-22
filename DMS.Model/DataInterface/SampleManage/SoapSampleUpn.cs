using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Model.DataInterface.SampleManage
{
    [Serializable]
    public class SoapSampleUpn
    {
        public String ApplyNo { get; set; }
        public String UpnNo { get; set; }
        public String Lot { get; set; }
        public String ProductName { get; set; }
        public String ProductDesc { get; set; }
        public String ApplyQuantity { get; set; }
        public String LotReuqest { get; set; }
        public String ProductMemo { get; set; }
    }
}
