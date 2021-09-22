/*
 * 波科发货单数据结构（畅联WMS发货）
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
    public class BSCSLCDeliveryData
    {
        public string DeliveryNo { get; set; }
        public DateTime? DeliveryDate { get; set; }
        public string SoldToSAPCode { get; set; }
        public string SoldToName { get; set; }
        public string ShipToSAPCode { get; set; }
        public string ShipToName { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public string QRCode { get; set; }
        public decimal Qty { get; set; }
        public DateTime? ExpDate { get; set; }
        public string OrderNo { get; set; }
        public string BoxNo { get; set; }
        public string WaveNo { get; set; }
        public string PlateNo { get; set; }



    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class BSCSLCDeliveryDataSet
    {
        [XmlElement("Record")]
        public List<BSCSLCDeliveryDataRecord> Records { get; set; }
    }

    [Serializable]
    public class BSCSLCDeliveryDataRecord
    {
        public string DeliveryNo { get; set; }        
        public string SoldToSAPCode { get; set; }
        public string SoldToName { get; set; }
        public string ShipToSAPCode { get; set; }
        public string ShipToName { get; set; }
        
      
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
        [XmlElement("Item")]
        public List<BSCSLCDeliveryDataItem> Items { get; set; }
    }

    [Serializable]
    public class BSCSLCDeliveryDataItem
    {
        public string UPN { get; set; }
        public string Lot { get; set; }
        public string QRCode { get; set; }
        public string OrderNo { get; set; }
        public string BoxNo { get; set; }
        public string WaveNo { get; set; }
        public string PlateNo { get; set; }


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
       
    }

}
