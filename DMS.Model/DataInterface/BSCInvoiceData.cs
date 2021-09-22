using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model
{
    [Serializable]
    public class BSCInvoiceData 
    {
        public string OrderNo { get; set; }
        public string InvoiceNo { get; set; }
        public DateTime? InvoiceDate { get; set; }
        public decimal InvoiceAmount { get; set; }
        public string ID733 { get; set; }
        public string DeliveryNo { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class BSCInvoiceDataSet
    {
        public int Count { get; set; }
        [XmlElement("Record")]
        public List<BSCInvoiceDataRecord> Records { get; set; }
    }

    [Serializable]
    public class BSCInvoiceDataRecord
    {
        public string OrderNo { get; set; }
        public string InvoiceNo { get; set; }
        [XmlIgnore]
        public DateTime? InvoiceDate { get; set; }
        [XmlElement("InvoiceDate")]
        public string StrDate
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
        [XmlIgnore]
        public decimal InvoiceAmount { get; set; }
        [XmlElement("InvoiceAmount")]
        public string StrInvoiceAmount
        {
            get
            {
                return this.InvoiceAmount.ToString("0.00");
            }
            set
            {
                decimal qty;
                if (!Decimal.TryParse(value, out qty))
                    throw new Exception("发票金额格式不正确");
                this.InvoiceAmount = qty;
            }
        }
        public string ID733 { get; set; }
        public string DeliveryNo { get; set; }
    }
}
