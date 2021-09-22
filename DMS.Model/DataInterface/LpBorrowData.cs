/*
 * LP借货数据结构
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
    public class LpBorrowData
    {
        public string TransferType { get; set; }
        public string ProductLine { get; set; }
        public string DistributorID { get; set; }
        public DateTime? Date { get; set; }
        public int? IsForTier2 { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public DateTime? ExpDate { get; set; }
        public decimal? Qty { get; set; }
        public string QRCode { get; set; }
        public string ERPFormNo { get; set; }
        public string Remark { get; set; }
        public decimal? UnitPrice { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class LpBorrowDataSet
    {
        [XmlElement("Record")]
        public List<LpBorrowDataRecord> Records { get; set; }
    }

    [Serializable]
    public class LpBorrowDataRecord
    {
        public string TransferType { get; set; }
        public string ProductLine { get; set; }
        public string DistributorID { get; set; }
        [XmlIgnore]
        public DateTime? Date { get; set; }
        [XmlElement("Date")]
        public string StrDate
        {
            get
            {
                if (this.Date.HasValue)
                    return this.Date.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.Date = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("借入（出）日期格式不正确");

                    this.Date = dt;
                }
            }
        }
        [XmlIgnore]
        public int? IsForTier2 { get; set; }
        [XmlElement("IsForTier2")]
        public string StrIsForTier2
        {
            get
            {
                return this.StrIsForTier2;
            }
            set
            {
                int isForTier2;
                if (!Int32.TryParse(value, out isForTier2))
                    throw new Exception("是否二级经销商借货格式不正确");
                this.IsForTier2 = isForTier2;
            }
        }
        [XmlElement("Item")]
        public List<LpBorrowDataItem> Items { get; set; }

        public string ERPFormNo { get; set; }
        public string Remark { get; set; }
    }

    [Serializable]
    public class LpBorrowDataItem
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
                    throw new Exception("产品价格格式不正确");
                this.UnitPrice = unitprice;
            }
        }
    }

}
