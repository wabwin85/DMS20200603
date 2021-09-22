using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class T2ContractInfoData
    {
        public string DistributorID { get; set; }
        public string DistributorName { get; set; }
        public string Position { get; set; }
        public string Contact { get; set; }
        public string Phone { get; set; }
        public string Mobile { get; set; }
        public string EMail { get; set; }
        public string Address { get; set; }
        public string Remark { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class T2ContractInfoDataSet
    {
        public int Count { get; set; }

        [XmlElement("Record")]
        public List<T2ContractInfoDataRecord> Records { get; set; }
    }

    [Serializable]
    public class T2ContractInfoDataRecord
    {
        public string DistributorID { get; set; }
        public string DistributorName { get; set; }

        [XmlElement("User")]
        public List<T2ContractInfoDataItem> Items { get; set; }
    }

    [Serializable]
    public class T2ContractInfoDataItem
    {
        public string Position { get; set; }
        public string Contact { get; set; }
        public string Phone { get; set; }
        public string Mobile { get; set; }
        public string EMail { get; set; }
        public string Address { get; set; }
        public string Remark { get; set; }
    }
}
