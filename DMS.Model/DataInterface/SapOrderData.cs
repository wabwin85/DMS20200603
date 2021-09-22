/*
 * SAP订单数据结构
 * */
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Model
{
    [Serializable]
    public class SapOrderData
    {
        public string CustomerID { get; set; }
        public string PO { get; set; }
        public string POType { get; set; }
        public string Organization { get; set; }
        public string Remark { get; set; }
        //根据SAP需要添加新的字段，Edit By Weiming on 2016-09-02
        public string PO_ShipTo { get; set; }
        public string Name { get; set; }
        public string RDD { get; set; }
        public string Reference { get; set; }
        public string Telephone { get; set; }
        public string CusPOType { get; set; }
        public string ShipTo { get; set; }

        public string UPN { get; set; }
        public string Lot { get; set; }
        public decimal Qty { get; set; }

        //根据SAP需要添加新的字段，Edit By Weiming on 2016-09-02
        public string Plant { get; set; }
        public string SLocation { get; set; }
    }

    [Serializable]
    [XmlRoot("PODataSet")]
    public class SapOrderDataSet
    {
        public int Count { get; set; }

        [XmlElement("PurchaseOrder")]
        public List<SapOrderDataRecord> Records { get; set; }
    }

    [Serializable]
    public class SapOrderDataRecord
    {
        public string CustomerID { get; set; }
        public string PO { get; set; }
        public string POType { get; set; }
        public string Organization { get; set; }
        public string Remark { get; set; }

        //根据SAP需要添加新的字段，Edit By Weiming on 2016-09-02
        public string PO_ShipTo { get; set; }
        public string Name { get; set; }
        public string RDD { get; set; }
        public string Reference { get; set; }
        public string Telephone { get; set; }
        public string CusPOType { get; set; }
        public string ShipTo { get; set; }


        [XmlElement("Item")]
        public List<SapOrderDataItem> Items { get; set; }
    }

    [Serializable]
    public class SapOrderDataItem
    {
        public string UPN { get; set; }
        public string Lot { get; set; }
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
                    throw new Exception("订购数量格式不正确");
                this.Qty = qty;
            }
        }
        //根据SAP需要添加新的字段，Edit By Weiming on 2016-09-02
        public string Plant { get; set; }
        public string SLocation { get; set; }
    }

}
