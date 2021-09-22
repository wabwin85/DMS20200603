using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class HospitalTransactionData
    {
        public string ApplicationType { get; set; }
        public string DealerCode { get; set; }
        public DateTime? ApplicationDate { get; set; }
        public string ApplicationNbr { get; set; }
        public string Remark { get; set; }

        public string QRCode { get; set; }
        public decimal? Qty { get; set; }
        public decimal? UnitPrice { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class HospitalTransactionDataSet
    {
        [XmlElement("Record")]
        public List<HospitalTransactionDataRecord> Records { get; set; }
    }

    [Serializable]
    public class HospitalTransactionDataRecord
    {
        public string ApplicationType { get; set; }
        public string DealerCode { get; set; }
        [XmlIgnore]
        public DateTime? ApplicationDate { get; set; }
        [XmlElement("ApplicationDate")]
        public string StrApplicationDate
        {
            get
            {
                if (this.ApplicationDate.HasValue)
                    return this.ApplicationDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.ApplicationDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("单据日期格式不正确");

                    this.ApplicationDate = dt;
                }
            }
        }
        public string ApplicationNbr { get; set; }
        public string Remark { get; set; }

        [XmlElement("Item")]
        public List<HospitalTransactionDataItem> Items { get; set; }
    }

    [Serializable]
    public class HospitalTransactionDataItem
    {
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
                    throw new Exception("产品数量格式不正确");
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
                    throw new Exception("含税单价格式不正确");
                this.UnitPrice = unitprice;
            }
        }
    }

}