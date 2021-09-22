using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class LpConsignmentData
    {
        public string DistributorID { get; set; }
        public string OrderNo { get; set; }
        public string DeliveryNo { get; set; }
        public DateTime? DeliveryDate { get; set; }
        public string WHID { get; set; }
        public string Type { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public DateTime? ExpDate { get; set; }
        public decimal Qty { get; set; }
        public string QRCode { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class LpConsignmentDataSet
    {
        public int Count { get; set; }

        [XmlElement("Record")]
        public List<LpConsignmentDataRecord> Records { get; set; }
    }

    [Serializable]
    public class LpConsignmentDataRecord
    {
        public string DistributorID { get; set; }
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
                        throw new Exception("调拨日期格式不正确");

                    this.DeliveryDate = dt;
                }
            }
        }
        public string WHID { get; set; }
        public string Type { get; set; }
        [XmlElement("Item")]
        public List<LpConsignmentDataItem> Items { get; set; }
    }

    [Serializable]
    public class LpConsignmentDataItem
    {
        public string UPN { get; set; }
        public string Lot { get; set; }
        public string QRCode { get; set; }
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
