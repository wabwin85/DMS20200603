/*
 * 平台退货确认数据结构
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
    public class LpReturnConfirmationData
    {
        public string ReturnNo { get; set; }
        public bool? IsConfirm { get; set; }
        public DateTime? ConfirmDate { get; set; }
        public string Remark { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class LpReturnConfirmationDataSet
    {
        [XmlElement("Record")]
        public List<LpReturnConfirmationDataRecord> Records { get; set; }
    }

    [Serializable]
    public class LpReturnConfirmationDataRecord
    {
        public string ReturnNo { get; set; }
        [XmlIgnore]
        public bool? IsConfirm { get; set; }
        [XmlElement("IsConfirm")]
        public string StrIsConfirm
        {
            get
            {
                if (this.IsConfirm.HasValue)
                    return this.IsConfirm.Value ? "1" : "0";
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.IsConfirm = null;
                }
                else
                {
                    this.IsConfirm = (value == "1");
                }
            }
        }
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
                        throw new Exception("确认日期格式不正确");

                    this.ConfirmDate = dt;
                }
            }
        }
        public string Remark { get; set; }
        //[XmlElement("Item")]
        //public List<LpReturnConfirmationDataItem> Items { get; set; }
    }

    //[Serializable]
    //public class LpReturnConfirmationDataItem
    //{

    //}

}
