/*
 * 平台其他出入库数据结构
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
    public class LpAdjustData
    {
        public string AdjustType { get; set; }
        public string ProductLine { get; set; }
        public string Remark { get; set; }
        public DateTime? AdjustDate { get; set; }

        public string UPN { get; set; }
        public string Lot { get; set; }
        public DateTime? ExpDate { get; set; }
        public decimal? Qty { get; set; }
        public string QRCode { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class LpAdjustDataSet
    {
        [XmlElement("Record")]
        public List<LpAdjustDataRecord> Records { get; set; }
    }

    [Serializable]
    public class LpAdjustDataRecord
    {
        public string AdjustType { get; set; }
        public string ProductLine { get; set; }
        public string Remark { get; set; }
        [XmlIgnore]
        public DateTime? AdjustDate { get; set; }
        [XmlElement("AdjustDate")]
        public string StrAdjustDate
        {
            get
            {
                if (this.AdjustDate.HasValue)
                    return this.AdjustDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.AdjustDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("调整日期格式不正确");

                    this.AdjustDate = dt;
                }
            }
        }

        [XmlElement("Item")]
        public List<LpAdjustDataItem> Items { get; set; }
    }

    [Serializable]
    public class LpAdjustDataItem
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
