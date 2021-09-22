using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model
{
    [Serializable]
    public class DealerSalesWritebackData
    {
        public string WriteBackNo { get; set; }
        public string SalesNo { get; set; }
        public DateTime? WriteBackDate { get; set; }
        public string Remark { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class DealerSalesWritebackDataSet
    {
        [XmlElement("Record")]
        public List<DealerSalesWritebackDataRecord> Records { get; set; }
    }

    [Serializable]
    public class DealerSalesWritebackDataRecord
    {
        public string WriteBackNo { get; set; }
        public string SalesNo { get; set; }
        [XmlIgnore]
        public DateTime? WriteBackDate { get; set; }
        [XmlElement("WriteBackDate")]
        public string StrWriteBackDate
        {
            get
            {
                if (this.WriteBackDate.HasValue)
                    return this.WriteBackDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.WriteBackDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("冲红日期格式不正确");

                    this.WriteBackDate = dt;
                }
            }
        }
        public string Remark { get; set; }
    }
}
