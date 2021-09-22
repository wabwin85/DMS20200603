using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class LpRentData
    {
        public string TransferOutDealerCode { get; set; }
        public string TransferInDealerCode { get; set; }
        public DateTime? TransferDate { get; set; }
        public string ProductLine { get; set; }
        public string ERPFormNo { get; set; }
        public string Remark { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public string QRCode { get; set; }
        public string ExpDate { get; set; }
        public decimal Qty { get; set; }
        public string UnitPrice { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class LpRentDataSet
    {
        public int Count { get; set; }

        [XmlElement("Record")]
        public List<LpRentDataRecord> Records { get; set; }
    }

    [Serializable]
    public class LpRentDataRecord
    {
        public string TransferOutDealerCode { get; set; }
        public string TransferInDealerCode { get; set; }
        public string ERPFormNo { get; set; }
        public string Remark { get; set; }
        public string ProductLine { get; set; }

        [XmlIgnore]
        public DateTime? TransferDate { get; set; }
        [XmlElement("TransferDate")]
        public string StrTransferDate
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
                        throw new Exception("借货操作日期格式不正确");

                    this.TransferDate = dt;
                }
            }
        }
       
        [XmlElement("Item")]
        public List<LpRentDataItem> Items { get; set; }
    }

    [Serializable]
    public class LpRentDataItem
    {
        public string UPN { get; set; }
        public string Lot { get; set; }
        public string QRCode { get; set; }
        public string ExpDate { get; set; }
        
          
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
                    throw new Exception("借货产品数量格式不正确");
                this.Qty = qty;
            }
        }
        public string UnitPrice { get; set; }
        
    }
}
