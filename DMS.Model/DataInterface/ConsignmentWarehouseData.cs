using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class ConsignmentWarehouseData
    {
        public string DistributorID { get; set; }
        public string WHID { get; set; }
        public string WHName { get; set; }
        public string HospitalID { get; set; }
        public string Address { get; set; }
        public string PostalCode { get; set; }
        public int IsActive { get; set; }
        public string Type {get;set;}
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class ConsignmentWarehouseDataSet
    {
        [XmlElement("Record")]
        public List<ConsignmentWarehouseDataRecord> Records { get; set; }
    }

    [Serializable]
    public class ConsignmentWarehouseDataRecord
    {
        public string DistributorID { get; set; }
        public string WHID { get; set; }
        public string WHName { get; set; }
        public string HospitalID { get; set; }
        public string Address { get; set; }
        public string PostalCode { get; set; }
        public int IsActive { get; set; }
        public string Type { get; set; }
    }
}
