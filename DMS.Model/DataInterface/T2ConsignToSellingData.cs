using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model.DataInterface
{
    /// <summary>
    /// 二级经销商寄售转销售数据接口
    /// </summary>
    [Serializable]
    public class T2ConsignToSellingData
    {
        public string AdjustNo { get; set; }
        public string ProductLine { get; set; }
        public DateTime? AdjustDate { get; set; }
        public string Type { get; set; }
        public string DealerCode { get; set; }
        public string Remark { get; set; }
        public string WhmCode { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public decimal Qty { get; set; }
        public string QRCode { get; set; }

    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class T2ConsignToSellingDataSet
    {
        public int Count { get; set; }

        [XmlElement("Record")]
        public List<T2ConsignToSellingDataRecord> Records { get; set; }
    }

    [Serializable]
    public class T2ConsignToSellingDataRecord
    {
        public string AdjustNo { get; set; }
        public string ProductLine { get; set; }
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
                        throw new Exception("申请日期格式不正确");

                    this.AdjustDate = dt;
                }
            }
        }
        public string Type { get; set; }
        public string DealerCode { get; set; }
        public string Remark { get; set; }

        [XmlElement("Item")]
        public List<T2ConsignToSellingDataItem> Items { get; set; }
    }

    [Serializable]
    public class T2ConsignToSellingDataItem
    {
        public string WhmCode { get; set; }
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


    }
}

