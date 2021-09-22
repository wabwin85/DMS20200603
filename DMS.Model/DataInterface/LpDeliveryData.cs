/*
 * LP发货单数据结构
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
    public class LpDeliveryData
    {
        public string DistributorID { get; set; }
        public string ProductLine { get; set; }
        public string OrderNo { get; set; }
        public string DeliveryNo { get; set; }
        public DateTime? DeliveryDate { get; set; }
        public string Type { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public decimal Qty { get; set; }
        public DateTime? ExpDate { get; set; }
        public decimal UnitPrice { get; set; }
        public string WHMCode { get; set; }
        public string QRCode { get; set; }
        public decimal TaxRate { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class LpDeliveryDataSet
    {
        [XmlElement("Record")]
        public List<LpDeliveryDataRecord> Records { get; set; }
    }

    [Serializable]
    public class LpDeliveryDataRecord
    {
        public string DistributorID { get; set; }
        public string ProductLine { get; set; }
        public string OrderNo { get; set; }
        public string DeliveryNo { get; set; }
        [XmlIgnore]
        public DateTime? DeliveryDate { get; set; }
        [XmlElement("DeliveryDate")]
        public string StrDeliveryDate
        {
            get
            {
                if (this.DeliveryDate.HasValue)
                    return this.DeliveryDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.DeliveryDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("发货日期格式不正确");

                    this.DeliveryDate = dt;
                }
            }
        }
        public string Type { get; set; }
        [XmlElement("Item")]
        public List<LpDeliveryDataItem> Items { get; set; }
    }

    [Serializable]
    public class LpDeliveryDataItem
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
                    throw new Exception("发货数量格式不正确");
                this.Qty = qty;
            }
        }
        [XmlIgnore]
        public DateTime? ExpDate { get; set; }
        [XmlElement("ExpDate")]
        public string StrExpDate
        {
            get
            {
                if (this.ExpDate.HasValue)
                    return this.ExpDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.ExpDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("产品有效期格式不正确");

                    this.ExpDate = dt;
                }
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
                    throw new Exception("发货产品价格(含税单价)格式不正确");
                this.UnitPrice = unitprice;
            }
        }

        public string WHMCode { get; set; }

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
