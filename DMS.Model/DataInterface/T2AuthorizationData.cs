using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class T2AuthorizationData 
    {
        public string DistributorID { get; set; }
        public string DistributorName { get; set; }
        public string HospitalCode { get; set; }
        public string HospitalName { get; set; }
        public string SubBUCode { get; set; }
        public string SubBUName { get; set; }
        public string AuthCode { get; set; }
        public string AuthName { get; set; }
        public string BU { get; set; }

        public string ProductLine { get; set; }
        public string AuthType { get; set; }
        public DateTime? AuthStartTime { get; set; }
        public DateTime? AuthEndTime { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class T2AuthorizationDataSet
    {
        public int Count { get; set; }
        [XmlElement("Record")]
        public List<T2AuthorizationDataRecord> Records { get; set; }
    }

    [Serializable]
    public class T2AuthorizationDataRecord
    {
        public string DistributorID { get; set; }
        public string DistributorName { get; set; }
        [XmlElement("Item")]
        public List<T2AuthorizationDataItem> Items { get; set; }
    }

    [Serializable]
    public class T2AuthorizationDataItem
    {
        public string HospitalCode { get; set; }
        public string HospitalName { get; set; }
        public string SubBUCode { get; set; }
        public string SubBUName { get; set; }
        public string AuthCode { get; set; }
        public string AuthName { get; set; }
        public string BU { get; set; }
        public string ProductLine { get; set; }
        public string AuthType { get; set; }

        [XmlIgnore]
        public DateTime? AuthStartTime { get; set; }
        [XmlElement("AuthStartTime")]
        public string StrAuthStartTime
        {
            get
            {
                if (this.AuthStartTime.HasValue)
                    return this.AuthStartTime.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.AuthStartTime = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("授权开始时间格式不正确");

                    this.AuthStartTime = dt;
                }
            }
        }

        [XmlIgnore]
        public DateTime? AuthEndTime { get; set; }
        [XmlElement("AuthEndTime")]
        public string StrAuthEndTime
        {
            get
            {
                if (this.AuthEndTime.HasValue)
                    return this.AuthEndTime.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.AuthEndTime = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("授权结束时间格式不正确");

                    this.AuthEndTime = dt;
                }
            }
        }
    }

}
