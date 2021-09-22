using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class LpSalesData
    {
        public string CustomerID { get; set; }
        public string Type { get; set; }
        public DateTime? SalesDate { get; set; }
        public string SalesNo { get; set; }
        public string ServiceAgent { get; set; }
        public string Remark { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public decimal Price { get; set; }
        public decimal Qty { get; set; }
        public string QRCode { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class LpSalesDataSet
    {
        public int Count { get; set; }

        [XmlElement("Record")]
        public List<LpSalesDataRecord> Records { get; set; }
    }

    [Serializable]
    public class LpSalesDataRecord
    {
        public string CustomerID { get; set; }
        public string Type { get; set; }
        [XmlIgnore]
        public DateTime? SalesDate { get; set; }
        [XmlElement("SalesDate")]
        public string StrSalesDate
        {
            get
            {
                if (this.SalesDate.HasValue)
                    return this.SalesDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.SalesDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("销售日期格式不正确");

                    this.SalesDate = dt;
                }
            }
        }
        public string SalesNo { get; set; }
        public string ServiceAgent { get; set; }
        public string Remark { get; set; }
        [XmlElement("Item")]
        public List<LpSalesDataItem> Items { get; set; }
    }

    [Serializable]
    public class LpSalesDataItem
    {
        public string WHMCode { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public string QRCode { get; set; }
        [XmlIgnore]
        public decimal UnitPrice { get; set; }
        [XmlElement("UnitPrice")]
        public string StrUnitPrice
        {
            get
            {
                return this.UnitPrice.ToString("0.00");
            }
            set
            {
                decimal unitPrice;
                if (!Decimal.TryParse(value, out unitPrice))
                    throw new Exception("含税单价格式不正确");
                this.UnitPrice = unitPrice;
            }
        }
        [XmlIgnore]
        public decimal Qty { get; set; }
        [XmlElement("Qty")]
        public string StrQty
        {
            get
            {
                return this.Qty.ToString("0.00");
            }
            set
            {
                decimal qty;
                if (!Decimal.TryParse(value, out qty))
                    throw new Exception("订购数量格式不正确");
                this.Qty = qty;
            }
        }
    }
}
