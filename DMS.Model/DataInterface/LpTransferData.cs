/*
 * LS移库数据结构
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
    public class LpTransferData
    {
        public string TransferType { get; set; }
        public string DistributorID { get; set; }
        public string TransferNumber { get; set; }
        public string OutWarehouseCode { get; set; }
        public string InWarehouseCode { get; set; }
        public DateTime? TransferDate { get; set; }
        public string Remark { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public string QRCode { get; set; }
        public decimal? Qty { get; set; }        
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class LpTransferDataSet
    {
        [XmlElement("Record")]
        public List<LpTransferDataRecord> Records { get; set; }
    }

    [Serializable]
    public class LpTransferDataRecord
    {
        public string TransferType { get; set; }
        public string DistributorID { get; set; }
        public string TransferNumber { get; set; }
        public string OutWarehouseCode { get; set; }
        public string InWarehouseCode { get; set; }
        [XmlIgnore]
        public DateTime? TransferDate { get; set; }
        [XmlElement("TransferDate")]
        public string StrDate
        {
            get
            {
                if (this.TransferDate.HasValue)
                    return this.TransferDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.TransferDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("移库日期格式不正确");

                    this.TransferDate = dt;
                }
            }
        }

        public string Remark { get; set; }

        [XmlElement("Item")]
        public List<LpTransferDataItem> Items { get; set; }

        
    }

    [Serializable]
    public class LpTransferDataItem
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
                    throw new Exception("移库数量格式不正确");
                this.Qty = qty;
            }
        }        
    }

}
