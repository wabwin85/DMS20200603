using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Model
{
    [Serializable]
    public class ProductData
    {
        public string UPN { get; set; }
        public string CNName { get; set; }
        public string ENName { get; set; }
        public string ProductLine { get; set; }
        public string RegName { get; set; }
        public string SourceArea { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class ProductDataSet
    {
        public int Count { get; set; }
        [XmlElement("Record")]
        public List<ProductDataRecord> Records { get; set; }
    }

    [Serializable]
    public class ProductDataRecord
    {
        public string UPN { get; set; }
        public string CNName { get; set; }
        public string ENName { get; set; }
        public string ProductLine { get; set; }
        public string RegName { get; set; }
        public string SourceArea { get; set; }
    }

    [Serializable]
    public class ProductDataForQAComplain
    {
        public string UPN { get; set; }
        public string CNName { get; set; }
        public string ENName { get; set; }
        public string ProductLine { get; set; }
        public string RegName { get; set; }
        public string SourceArea { get; set; }
        public string ConvertFactor { get; set; }
        public string FactorNumber { get; set; }
        public string UPNExpDate { get; set; }
        public string Model { get; set; }
        public string QrCode { get; set; }
        public string Registration { get; set; }
        public string SalesDate { get; set; }
    }
}
