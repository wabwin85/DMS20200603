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
    public class LpComplainData
    {
        public string ComplainNo { get; set; }
        public string ProductLine { get; set; }
        public DateTime? ComplainDate { get; set; }
        public string Remark { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public decimal Qty { get; set; }
        public decimal UnitPrice { get; set; }
        public string QRCode { get; set; }
        public string DistributorID { get; set; }
        public string WarehouseCode { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class LpComplainDataSet
    {
        public int Count { get; set; }

        [XmlElement("Record")]
        public List<LpComplainDataRecord> Records { get; set; }
    }

    [Serializable]
    public class LpComplainDataRecord
    {
        public string ComplainNo { get; set; }
        public string ProductLine { get; set; }
        public string DistributorID { get; set; }
        [XmlIgnore]
        public DateTime? ComplainDate { get; set; }
        [XmlElement("ComplainDate")]
        public string StrComplainDate
        {
            get
            {
                if (this.ComplainDate.HasValue)
                    return this.ComplainDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.ComplainDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("投诉申请日期格式不正确");

                    this.ComplainDate = dt;
                }
            }
        }
        public string Remark { get; set; }
        [XmlElement("Item")]
        public List<LpComplainDataItem> Items { get; set; }
    }

    [Serializable]
    public class LpComplainDataItem
    {
        public string UPN { get; set; }
        public string Lot { get; set; }
        public string QRCode { get; set; }
        public string WarehouseCode { get; set; }
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
                    throw new Exception("投诉产品数量格式不正确");
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
                    throw new Exception("投诉产品价格格式不正确");
                this.UnitPrice = unitprice;
            }
        }
    }
}
