/*
 * 
 * */
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Model
{
    /// <summary>
    /// 医院信息接口 （平台下载）
    /// </summary>
    [Serializable]
    public class LpHospitalData
    {
        public string HospitalID { get; set; }
        public string HospitalName { get; set; }
        public string CityName { get; set; }
    }

        [Serializable]
        [XmlRoot("InterfaceDataSet")]
        public class LpHospitalDataSet
        {
            public int Count { get; set; }
            [XmlElement("Record")]
            public List<LpHospitalDataRecord> Records { get; set; }
        }

        [Serializable]
        public class LpHospitalDataRecord
        {
            public string HospitalID { get; set; }
            public string HospitalName { get; set; }
            public string CityName { get; set; }
        }

}
