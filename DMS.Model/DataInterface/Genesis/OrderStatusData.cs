/*
 * 订单状态数据
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
    public class OrderStatusData
    {
        public Guid Id { get; set; }
        public string OrderNo { get; set; }
        public string OrderStatus { get; set; }
        public int LineNbr { get; set; }
        public DateTime ImportDate { get; set; }
        public string ClientId { get; set; }
        public string BatchNbr { get; set; }
        public string ProblemDescription { get; set; }
        public DateTime ProcessDate { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class OrderStatusDataSet
    {
        [XmlElement("Record")]
        public List<OrderStatusDataRecord> Records { get; set; }
    }

    [Serializable]
    public class OrderStatusDataRecord
    {
        public string OrderNo { get; set; }        
        public string OrderStatus { get; set; }
    }

}
