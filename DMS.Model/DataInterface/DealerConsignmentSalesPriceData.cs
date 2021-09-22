using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class DealerConsignmentSalesPriceData
    {
        public string SalesNo { get; set; }
        public string OrderNo { get; set; }
        public DateTime? ConfirmDate { get; set; }
        public string Remark { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public decimal Qty { get; set; }
        public decimal UnitPrice { get; set; }
        public string QRCode { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class DealerConsignmentSalesPriceDataSet
    {
        public int Count { get; set; }

        [XmlElement("Record")]
        public List<DealerConsignmentSalesPriceDataRecord> Records { get; set; }
    }

    [Serializable]
    public class DealerConsignmentSalesPriceDataRecord
    {
        public string SalesNo { get; set; }
        public string OrderNo { get; set; }
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
        public List<DealerConsignmentSalesPriceDataItem> Items { get; set; }
    }

    [Serializable]
    public class DealerConsignmentSalesPriceDataItem
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
                    throw new Exception("产品单价格式不正确");
                this.UnitPrice = unitprice;
            }
        }
    }
}
