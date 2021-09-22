/*
 * LP订单数据结构
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
    public class LpOrderData
    {
        public string OrderNo { get; set; }
        public string ProductLine { get; set; }
        public string OrderType { get; set; }
        public string DeliveryAddress { get; set; }
        public DateTime? SubmitDate { get; set; }
        public string Remark { get; set; }
        public string ConsignmentSalesOrderNo { get; set; }
        public string UPN { get; set; }
        public string ShortUPN { get; set; }   //产品短编号 Add By SongWeiming on 20161008 
        public string Lot { get; set; }
        public decimal Qty { get; set; }
        public decimal UnitPrice { get; set; }
        public string QRCode { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class LpOrderDataSet
    {
        [XmlElement("Record")]
        public List<LpOrderDataRecord> Records { get; set; }
    }

    [Serializable]
    public class LpOrderDataRecord
    {
        public string OrderNo { get; set; }
        public string ProductLine { get; set; }
        public string OrderType { get; set; }
        public string DeliveryAddress { get; set; }
        
        [XmlIgnore]
        public DateTime? SubmitDate { get; set; }
        [XmlElement("SubmitDate")]
        public string StrSubmitDate
        {
            get
            {
                if (this.SubmitDate.HasValue)
                    return this.SubmitDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.SubmitDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("订单提交日期格式不正确");

                    this.SubmitDate = dt;
                }
            }
        }
        public string Remark { get; set; }
        public string ConsignmentSalesOrderNo { get; set; }
        [XmlElement("Item")]
        public List<LpOrderDataItem> Items { get; set; }
    }

    [Serializable]
    public class LpOrderDataItem
    {
        public string UPN { get; set; }
        public string ShortUPN { get; set; } //产品短编号 Add By SongWeiming on 20161008 
        public string Lot { get; set; }
        [XmlIgnore]
        public decimal Qty { get; set; }
        public string QRCode { get; set; }
        [XmlIgnore]
        public decimal UnitPrice { get; set; }
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
        [XmlElement("UnitPrice")]
        public string StrUnitPrice
        {
            get
            {
                return this.UnitPrice.ToString("0.00");
            }
            set
            {
                decimal price;
                if (!Decimal.TryParse(value, out price))
                    throw new Exception("订购价格格式不正确");
                this.UnitPrice = price;
            }
        }

    }

}
