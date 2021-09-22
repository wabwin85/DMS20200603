/*
 * 经销商信息接口 （平台下载）
 * */
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Model
{
    [Serializable]
    public class LpDistributorData
    {
        public string DistributorID { get; set; }
        public string DistributorName { get; set; }
        public string DistributorType { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class LpDistributorDataSet
    {
        public int Count { get; set; }
        [XmlElement("Record")]
        public List<LpDistributorDataRecord> Records { get; set; }
    }

    [Serializable]
    public class LpDistributorDataRecord
    {
        public string DistributorID { get; set; }
        public string DistributorName { get; set; }
        public string DistributorType { get; set; }
    }
}
