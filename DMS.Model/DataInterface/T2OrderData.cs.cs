/*
 * T2订单数据结构
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
    public class T2OrderData
    {
        public string DistributorID { get; set; }
        public string OrderNo { get; set; }
        public string ProductLine{ get; set; }
        public string OrderType { get; set; }
        public string Carrier { get; set; }
        public DateTime? RDD { get; set; }
        public string ContactPerson { get; set; }
        public string Contact { get; set; }
        public string ContactMobile { get; set; }
        public string Consignee { get; set; }
        public string ConsigneePhone { get; set; }
        public string DeliveryAddress { get; set; }
        public string Remark { get; set; }
        public string UPN { get; set; }
        public string ShortUPN { get; set; }  //产品短编号 Add By SongWeiming on 20161008
        //public string Lot { get; set; }
        public decimal Qty { get; set; }
        public decimal UnitPrice { get; set; }
        public string Lot { get; set; }
        public string HospitalCode { get; set; }
        public string WHCode { get; set; }
        public string SalesNo { get; set; }
        public string QRCode { get; set; }

    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class T2OrderDataSet
    {
        [XmlElement("Record")]
        public List<T2OrderDataRecord> Records { get; set; }
    }

    [Serializable]
    public class T2OrderDataRecord
    {
        public string DistributorID { get; set; }
        public string OrderNo { get; set; }
        public string ProductLine { get; set; }
        public string OrderType { get; set; }
        public string Carrier { get; set; }
        [XmlIgnore]
        public DateTime? RDD { get; set; }
        [XmlElement("RDD")]
        public string StrRDD
        {
            get
            {
                if (this.RDD.HasValue)
                    return this.RDD.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.RDD = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("期望到货日期格式不正确");

                    this.RDD = dt;
                }
            }
        }
        public string ContactPerson { get; set; }
        public string Contact { get; set; }
        public string ContactMobile { get; set; }
        public string Consignee { get; set; }
        public string ConsigneePhone { get; set; }
        public string DeliveryAddress { get; set; }
        public string Remark { get; set; }
        [XmlElement("Item")]
        public List<T2OrderDataItem> Items { get; set; }
    }

    [Serializable]
    public class T2OrderDataItem
    {
        public string UPN { get; set; }
        public string ShortUPN { get; set; } //产品短编号 Add By SongWeiming on 20161008
        //public string Lot { get; set; }
        [XmlIgnore]
        public decimal Qty { get; set; }
        [XmlIgnore]
        public decimal UnitPrice { get; set; }
        public string Lot { get; set; }
        public string HospitalCode { get; set; }
        public string WHCode { get; set; }
        public string QRCode { get; set; }

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
        public string SalesNo { get; set; }
    }

}
