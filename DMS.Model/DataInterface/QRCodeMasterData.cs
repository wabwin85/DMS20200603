/*
 * 二维码主数据结构（二维码平台上传数据）
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
    public class QRCodeMasterData
    {
        public string QRCode { get; set; }
        public Int32 Status { get; set; }
        public DateTime? CreateDate { get; set; }
        public string UserCode { get; set; }
        public string Channel { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class QRCodeMasterDataSet
    {
        [XmlElement("Record")]
        public List<QRCodeMasterDataRecord> Records { get; set; }
    }

    [Serializable]
    public class QRCodeMasterDataRecord
    {
       
        [XmlElement("Item")]
        public List<QRCodeMasterDataItem> Items { get; set; }
    }

    [Serializable]
    public class QRCodeMasterDataItem
    {
        public string QRCode { get; set; }
        public Int32 Status { get; set; }
        public string UserCode { get; set; }
        public string Channel { get; set; }
      
        [XmlIgnore]
        public DateTime? CreateDate { get; set; }
        [XmlElement("CreateDate")]
        public string StrCreateDate
        {
            get
            {
                if (this.CreateDate.HasValue)
                    return this.CreateDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.CreateDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("条码创建日期格式不正确");

                    this.CreateDate = dt;
                }
            }
        }
    }

}
