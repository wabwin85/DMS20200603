using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class InventoryTransferForT2Data
    {
        public string DistributorID { get; set; }
        public string Remark { get; set; }
        public string TransferFromWHName { get; set; }
        public string TransferToWHName { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public decimal Qty { get; set; }
        public string QRCode { get; set; }
    }
    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class InventoryTransferForT2DataSet
    {
        public int Count { get; set; }

        [XmlElement("Record")]
        public List<InventoryTransferForT2DataRecord> Records { get; set; }
    }

    [Serializable]
    public class InventoryTransferForT2DataRecord
    {
        public string DistributorID { get; set; }
        public string Remark { get; set; }
        
        [XmlElement("Item")]
        public List<InventoryTransferForT2DataItem> Items { get; set; }
    }

    [Serializable]
    public class InventoryTransferForT2DataItem
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
                    throw new Exception("数量格式不正确");
                this.Qty = qty;
            }
        }

        public string TransferFromWHName { get; set; }
        public string TransferToWHName { get; set; }

    }

}



