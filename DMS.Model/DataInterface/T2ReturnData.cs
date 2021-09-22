using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model.DataInterface
{
    public class T2ReturnData
    {
        public string DistributorID { get; set; }
        public string ReturnType { get; set; }
        public string OrderNo { get; set; }
        public string ProductLine { get; set; }

        public string WarehouseType { get; set; }
        public string ReturnNo { get; set; }
        public DateTime? ReturnDate { get; set; }
        public string Remark { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public decimal Qty { get; set; }
        public string QRCode { get; set; }
        public string WarehouseCode { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class T2ReturnDataSet
    {
        public int Count { get; set; }

        [XmlElement("Record")]
        public List<T2ReturnDataRecord> Records { get; set; }
    }

    [Serializable]
    public class T2ReturnDataRecord
    {
        public string DistributorID { get; set; }
        public string ReturnType { get; set; }
        public string ProductLine { get; set; }
        public string WarehouseType { get; set; }
        public string ReturnNo { get; set; }
        [XmlIgnore]
        public DateTime? ReturnDate { get; set; }
        [XmlElement("ReturnDate")]
        public string StrReturnDate
        {
            get
            {
                if (this.ReturnDate.HasValue)
                    return this.ReturnDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.ReturnDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("退货申请日期格式不正确");

                    this.ReturnDate = dt;
                }
            }
        }
        public string Remark { get; set; }
        [XmlElement("Item")]
        public List<T2ReturnDataItem> Items { get; set; }
    }

    [Serializable]
    public class T2ReturnDataItem
    {
        public string OrderNo { get; set; }
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
                    throw new Exception("退货数量格式不正确");
                this.Qty = qty;
            }
        }
    }
}
