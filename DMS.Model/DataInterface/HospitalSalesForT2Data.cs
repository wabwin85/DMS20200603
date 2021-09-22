using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class HospitalSalesForT2Data
    {
        public string DistributorID { get; set; }
        public string HospitalCode { get; set; }
        public string Type { get; set; }
        public DateTime? SalesDate { get; set; }
        public string Departments { get; set; }
        public string Remark { get; set; }
        public string InvoiceNo { get; set; }
        public string InvoiceTitle { get; set; }
        public DateTime? InvoiceDate { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public decimal Qty { get; set; }
        public decimal UnitPrice { get; set; }
        public string QRCode { get; set; }
        public string  WarehouseName { get; set; }
    }
    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class HospitalSalesForT2DataSet
    {
        public int Count { get; set; }

        [XmlElement("Record")]
        public List<HospitalSalesForT2DataRecord> Records { get; set; }
    }

    [Serializable]
    public class HospitalSalesForT2DataRecord
    {
        public string DistributorID { get; set; }
        public string HospitalCode { get; set; }
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
        public string Departments { get; set; }
        public string Remark { get; set; }
        public string InvoiceNo { get; set; }
        public string InvoiceTitle { get; set; }
        [XmlIgnore]
        public DateTime? InvoiceDate { get; set; }
        [XmlElement("InvoiceDate")]
        public string StrInvoiceDate
        {
            get
            {
                if (this.InvoiceDate.HasValue)
                    return this.InvoiceDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.InvoiceDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("发票日期格式不正确");

                    this.InvoiceDate = dt;
                }
            }
        }
        [XmlElement("Item")]
        public List<HospitalSalesForT2DataItem> Items { get; set; }
    }

    [Serializable]
    public class HospitalSalesForT2DataItem
    {
        public string UPN { get; set; }
        public string Lot { get; set; }
        public string QRCode { get; set; }
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
                    throw new Exception("数量格式不正确");
                this.Qty = qty;
            }
        }
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
                decimal unitprice;
                if (!Decimal.TryParse(value, out unitprice))
                    throw new Exception("产品价格格式不正确");
                this.UnitPrice = unitprice;
            }
        }

        public string WarehouseName { get; set; }

    }

}


