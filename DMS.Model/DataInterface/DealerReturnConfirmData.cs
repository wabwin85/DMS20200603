using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class DealerReturnConfirmData
    {
        public string ReturnNo { get; set; }
        public bool IsConfirm { get; set; }
        public DateTime? ConfirmDate { get; set; }
        public string Remark { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public string WarehouseCode { get; set; }
        public decimal Qty { get; set; }
        public decimal UnitPrice { get; set; }
        public bool IsEnd { get; set; }
        public string QRCode { get; set; }
        public decimal TaxRate { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class DealerReturnConfirmDataSet
    {
        public int Count { get; set; }

        [XmlElement("Record")]
        public List<DealerReturnConfirmDataRecord> Records { get; set; }
    }

    [Serializable]
    public class DealerReturnConfirmDataRecord
    {
        public string ReturnNo { get; set; }
        [XmlIgnore]
        public bool? IsConfirm { get; set; }
        [XmlElement("IsConfirm")]
        public string StrIsConfirm
        {
            get
            {
                if (this.IsConfirm.HasValue)
                    return this.IsConfirm.Value ? "1" : "0";
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.IsConfirm = null;
                }
                else
                {
                    this.IsConfirm = (value == "1");
                }
            }
        }
        [XmlIgnore]
        public DateTime? ConfirmDate { get; set; }
        [XmlElement("ConfirmDate")]
        public string StrConfirmDate
        {
            get
            {
                if (this.ConfirmDate.HasValue)
                    return this.ConfirmDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.ConfirmDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("日期格式不正确");

                    this.ConfirmDate = dt;
                }
            }
        }
        public string Remark { get; set; }
        [XmlElement("Item")]
        public List<DealerReturnConfirmDataItem> Items { get; set; }
    }

    [Serializable]
    public class DealerReturnConfirmDataItem
    {
        public string UPN { get; set; }
        public string Lot { get; set; }
        public string WarehouseCode { get; set; }
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
                    throw new Exception("退货数量格式不正确");
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
        [XmlIgnore]
        public bool? IsEnd { get; set; }
        [XmlElement("IsEnd")]
        public string StrIsEnd
        {
            get
            {
                if (this.IsEnd.HasValue)
                    return this.IsEnd.Value ? "1" : "0";
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.IsEnd = null;
                }
                else
                {
                    this.IsEnd = (value == "1");
                }
            }
        }

        [XmlIgnore]
        public decimal TaxRate { get; set; }

        [XmlElement("TaxRate")]
        public string StrTaxRate
        {
            get
            {
                return this.TaxRate.ToString("0.00");
            }
            set
            {
                decimal taxrate;
                if (!Decimal.TryParse(value, out taxrate))
                    throw new Exception("税率格式不正确");
                this.TaxRate = taxrate;
            }
        }
    }
    
}
