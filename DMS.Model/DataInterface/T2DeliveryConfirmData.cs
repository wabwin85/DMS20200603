using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class T2DeliveryConfirmData
    {
        public string DeliveryNo { get; set; }
        public DateTime? ConfirmDate { get; set; }
        public string IsConfirm { get; set; }
        public string Remark { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class T2DeliveryConfirmDataSet
    {
        [XmlElement("Record")]
        public List<T2DeliveryConfirmDataRecord> Records { get; set; }
    }

    [Serializable]
    public class T2DeliveryConfirmDataRecord
    {
        public string DeliveryNo { get; set; }
        [XmlIgnore]
        public string IsConfirm { get; set; }
        
        [XmlIgnore]
        public DateTime? ConfirmDate { get; set; }
        [XmlElement("ConfirmDate")]
        public string StrConfirmDate
        {
            get
            {
                if (this.ConfirmDate.HasValue)
                    return this.ConfirmDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.ConfirmDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("确认收货日期格式不正确");

                    this.ConfirmDate = dt;
                }
            }
        }

        public string Remark { get; set; }
    }
}

