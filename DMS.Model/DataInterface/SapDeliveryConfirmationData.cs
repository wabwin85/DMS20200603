/*
 * SAP发货确认数据结构
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
    public class SapDeliveryConfirmationData
    {
        public string DeliveryNo { get; set; }
        public bool? IsConfirm { get; set; }
        public DateTime? ConfirmDate { get; set; }
        public string Remark { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public decimal Qty { get; set; }
        public string QRCode { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class SapDeliveryConfirmationDataSet
    {
        [XmlElement("Record")]
        public List<SapDeliveryConfirmationDataRecord> Records { get; set; }
    }

    [Serializable]
    public class SapDeliveryConfirmationDataRecord
    {
        public string DeliveryNo { get; set; }
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
                        throw new Exception("确认日期格式不正确");

                    this.ConfirmDate = dt;
                }
            }
        }
        public string Remark { get; set; }
        [XmlElement("Item")]
        public List<SapDeliveryConfirmationDataItem> Items { get; set; }
    }

    [Serializable]
    public class SapDeliveryConfirmationDataItem
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
                    throw new Exception("收货数量格式不正确");
                this.Qty = qty;
            }
        }
    }

}
