using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model.DataInterface
{

    [Serializable]
    public class QrCodeInventoryData
    {
        public string DealerCode { get; set; }
        public string UPN { get; set; }
        public string LOT { get; set; }
        public string QRCode { get; set; }
        public string GTIN { get; set; }
        public string ExpDate { get; set; }
        public string DOM { get; set; }
        public string IsQRUsable { get; set; }
        public string Remark { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class QrCodeInventoryDataSet
    {
        public int Count { get; set; }
        [XmlElement("Record")]
        public List<QrCodeInventoryDataRecord> Records { get; set; }
    }

    [Serializable]
    public class QrCodeInventoryDataRecord
    {
        public string DealerCode { get; set; }
        [XmlElement("Item")]
        public List<QrCodeInventoryDataItem> Items { get; set; }
    }

    [Serializable]
    public class QrCodeInventoryDataItem
    {
        public string UPN { get; set; }
        public string LOT { get; set; }
        public string QRCode { get; set; }
        public string GTIN { get; set; }
        public string ExpDate { get; set; }
        public string DOM { get; set; }
        public string IsQRUsable { get; set; }
        public string Remark { get; set; }
    }
}
