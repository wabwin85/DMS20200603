using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class QrCodeInventoryForRedCrossData
    {
        public string SupplyID { get; set; }
        public string SupplyName { get; set; }
        public string MerchandiseID { get; set; }
        public string MerchandiseName { get; set; }
        public string UPN { get; set; }
        public string LOT { get; set; }
        public string QRCode { get; set; }
        public string GTIN { get; set; }
        public string Qty { get; set; }
        public string CR { get; set; }
        public string ExpDate { get; set; }
        public string DOM { get; set; }
        public string IsQRUsable { get; set; }
        public string Remark { get; set; }
        public string WHMType { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class QrCodeInventoryForRedCrossDataSet
    {
        public int Count { get; set; }
        [XmlElement("Record")]
        public List<QrCodeInventoryForRedCrossDataRecord> Records { get; set; }
    }

    [Serializable]
    public class QrCodeInventoryForRedCrossDataRecord
    {
        public string SupplyID { get; set; }
        public string SupplyName { get; set; }
        [XmlElement("Item")]
        public List<QrCodeInventoryForRedCrossDataItem> Items { get; set; }
    }

    [Serializable]
    public class QrCodeInventoryForRedCrossDataItem
    {
        public string MerchandiseID { get; set; }
        public string MerchandiseName { get; set; }
        public string UPN { get; set; }
        public string LOT { get; set; }
        public string QRCode { get; set; }
        public string GTIN { get; set; }
        public string Qty { get; set; }
        public string CR { get; set; }
        public string ExpDate { get; set; }
        public string DOM { get; set; }
        public string IsQRUsable { get; set; }
        public string Remark { get; set; }
        public string WHMType { get; set; }
    }
}
