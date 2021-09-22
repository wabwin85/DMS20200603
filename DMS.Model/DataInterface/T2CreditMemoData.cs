/*
 * 经销商红票额度信息上传接口
 * */
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model
{
    [Serializable]
    public class T2CreditMemoData
    {
        public string Tier2DealerCode { get; set; }
        public string BSCBU { get; set; }
        public string InvoiceNumber { get; set; }
        public DateTime InvoiceDate { get; set; }
        public decimal InvoiceAmount { get; set; }
        public string Remark { get; set; }
    }
    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class T2CreditMemoDataSet
    {
        [XmlElement("Record")]
        public List<T2CreditMemoDataRecord> Records { get; set; }
    }
    [Serializable]
    public class T2CreditMemoDataRecord
    {
        public string Tier2DealerCode { get; set; }
        public string BSCBU { get; set; }
        public string InvoiceNumber { get; set; }
        [XmlIgnore]
        public DateTime? InvoiceDate { get; set; }
        [XmlElement("InvoiceDate")]
        public String StrInvoiceDate
        {
            get
            {
                if (this.InvoiceDate.HasValue)
                {
                    return this.InvoiceDate.Value.ToString("yyyy-MM-dd");

                }
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
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
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
                decimal Amount;
                if (!Decimal.TryParse(value, out Amount))
                    throw new Exception("发票额度格式不正确");
                this.InvoiceAmount = Amount;
            }
        }
        public string Remark { get; set; }
    }
}
