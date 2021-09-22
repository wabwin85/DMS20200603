using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model
{
    /// <summary>
    /// 二级经销商销售数据（寄售产品）接口
    /// </summary>
    [Serializable]
    public class LpConsignmentSalesData
    {
        public string DistributorID { get; set; }
        public DateTime? SalesDate { get; set; }
        public string CustomerID { get; set; }
        public string Remark { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal Qty { get; set; }
        public string SalesNo { get; set; }
        public string WHID { get; set; }
        public string QRCode { get; set; }

    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class LpConsignmentSalesDataSet
    {
        public int Count { get; set; }

        [XmlElement("Record")]
        public List<LpConsignmentSalesDataRecord> Records { get; set; }
    }

    [Serializable]
    public class LpConsignmentSalesDataRecord
    {
        public string DistributorID { get; set; }
        public string SalesNo { get; set; }
        [XmlIgnore]
        public DateTime? SalesDate { get; set; }
        [XmlElement("SalesDate")]
        public string StrSalesDate
        {
            get
            {
                if (this.SalesDate.HasValue)
                    return this.SalesDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.SalesDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("销售日期格式不正确");

                    this.SalesDate = dt;
                }
            }
        }
        public string CustomerID { get; set; }
        public string Remark { get; set; }

        [XmlElement("Item")]
        public List<LpConsignmentSalesDataItem> Items { get; set; }
    }

    [Serializable]
    public class LpConsignmentSalesDataItem
    {
        public string UPN { get; set; }
        public string Lot { get; set; }
        public string WHID { get; set; }
        public string QRCode { get; set; }
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
                decimal unitPrice;
                if (!Decimal.TryParse(value, out unitPrice))
                    throw new Exception("产品含税单价格式不正确");
                this.UnitPrice = unitPrice;
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
                    throw new Exception("销售数量格式不正确");
                this.Qty = qty;
            }
        }


    }
}
