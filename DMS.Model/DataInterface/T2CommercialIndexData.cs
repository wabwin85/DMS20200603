using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class T2CommercialIndexData
    {
        public string DistributorID { get; set; }
        public string DistributorName { get; set; }
        public string BU { get; set; }
        public string ProductLine { get; set; }
        public string SubBUCode { get; set; }
        public string SubBUName { get; set; }
        public string StartTime { get; set; }
        public string EndTime { get; set; }
        public string MarketType { get; set; }
        public string Year { get; set; }
        public string Month1 { get; set; }
        public string Month2 { get; set; }
        public string Month3 { get; set; }
        public string Month4 { get; set; }
        public string Month5 { get; set; }
        public string Month6 { get; set; }
        public string Month7 { get; set; }
        public string Month8 { get; set; }
        public string Month9 { get; set; }
        public string Month10 { get; set; }
        public string Month11 { get; set; }
        public string Month12 { get; set; }
        public string Amount { get; set; }

    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class T2CommercialIndexDataSet
    {
        public int Count { get; set; }
        [XmlElement("Record")]
        public List<T2CommercialIndexDataRecord> Records { get; set; }
    }

    [Serializable]
    public class T2CommercialIndexDataRecord
    {
        public string DistributorID { get; set; }
        public string DistributorName { get; set; }
        [XmlElement("Item")]
        public List<T2CommercialIndexDataItem> Items { get; set; }
    }

    [Serializable]
    public class T2CommercialIndexDataItem
    {
        public string BU { get; set; }
        public string ProductLine { get; set; }
        public string SubBUCode { get; set; }
        public string SubBUName { get; set; }
       
        public string StartTime { get; set; }
        
        public string EndTime { get; set; }
        
        public string MarketType { get; set; }

        
        public string Year { get; set; }
        
       
        public string Month1 { get; set; }
        public string Month2 { get; set; }
        public string Month3 { get; set; }
        public string Month4 { get; set; }
        public string Month5 { get; set; }
        public string Month6 { get; set; }
        public string Month7 { get; set; }
        public string Month8 { get; set; }
        public string Month9 { get; set; }
        public string Month10 { get; set; }
        public string Month11 { get; set; }
        public string Month12 { get; set; }
        public string Amount { get; set; }

    }
}
