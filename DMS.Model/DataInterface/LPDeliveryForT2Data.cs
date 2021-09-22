using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class LPDeliveryForT2Data 
    {
        public string DistributorID { get; set; }
        public string OrderNo { get; set; }
        public string DeliveryNo { get; set; }
        public string DeliveryDate { get; set; }
        public string LPName { get; set; }
        public string Carrier { get; set; }
        public string CourierNo { get; set; }
        public string TransportType { get; set; }
        public string UPN { get; set; }
        public string Lot { get; set; }
        public string ExpDate { get; set; }
        public decimal Qty { get; set; }
        public decimal UnitPrice { get; set; }
        public string WarehouseName { get; set; }
        public string QRCode { get; set; }
    }
    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class LPDeliveryForT2DataSet
    {
        public int Count { get; set; }

        [XmlElement("Record")]
        public List<LPDeliveryForT2DataRecord> Records { get; set; }
    }

    [Serializable]
    public class LPDeliveryForT2DataRecord
    {
        public string DistributorID { get; set; }
        public string OrderNo { get; set; }
        public string DeliveryNo { get; set; }
        public string DeliveryDate { get; set; }
        
        public string LPName { get; set; }
        public string Carrier { get; set; }
        public string CourierNo { get; set; }
        public string TransportType { get; set; }
        [XmlElement("Item")]
        public List<LPDeliveryForT2DataItem> Items { get; set; }
    }

    [Serializable]
    public class LPDeliveryForT2DataItem
    {
        public string UPN { get; set; }
        public string Lot { get; set; }
        public string WarehouseName { get; set; }
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
       
        public string ExpDate { get; set; }
        

    }

}

