using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class T2OrderConfirmationData
    {
        public string DistributorID { get; set; }
        public string OrderNo { get; set; }
        public string UPN { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal Qty { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class T2OrderConfirmationDataSet
    {
        public int Count { get; set; }

        [XmlElement("Record")]
        public List<T2OrderConfirmationDataRecord> Records { get; set; }
    }

    [Serializable]
    public class T2OrderConfirmationDataRecord
    {
        public string DistributorID { get; set; }
        public string OrderNo { get; set; }
        [XmlElement("Item")]
        public List<T2OrderConfirmationDataItem> Items { get; set; }
    }

    [Serializable]
    public class T2OrderConfirmationDataItem
    {
        public string UPN { get; set; }
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
                    throw new Exception("单价格式不正确");
                this.UnitPrice = unitprice;
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
