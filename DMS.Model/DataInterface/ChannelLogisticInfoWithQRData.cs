using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class ChannelLogisticInfoWithQRData
    {
        public string DeliverytCustomer { get; set; }
        public string DeliverytCustomerCode { get; set; }
        public string ReceiveCustomer { get; set; }
        public string ReceiveCustomerCode { get; set; }
        public string DeliveryDate { get; set; }
        public string LogisticType { get; set; }
        public string UPN { get; set; }
        public string LOT { get; set; }
        public string QRCode { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class ChannelLogisticInfoWithQRDataSet
    {
        public int Count { get; set; }
        [XmlElement("Record")]
        public List<ChannelLogisticInfoWithQRDataRecord> Records { get; set; }
    }

    [Serializable]
    public class ChannelLogisticInfoWithQRDataRecord
    {
        public string DeliverytCustomer { get; set; }
        public string DeliverytCustomerCode { get; set; }
        public string ReceiveCustomer { get; set; }
        public string ReceiveCustomerCode { get; set; }
        public string DeliveryDate { get; set; }
        public string LogisticType { get; set; }
        [XmlElement("Item")]
        public List<ChannelLogisticInfoWithQRDataItem> Items { get; set; }
    }

    [Serializable]
    public class ChannelLogisticInfoWithQRDataItem
    {
        public string UPN { get; set; }
        public string LOT { get; set; }
        public string QRCode { get; set; }
    }
}
