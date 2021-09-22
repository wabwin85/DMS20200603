/*
 * 经销商上传的二维码业务数据（二维码APP上传数据）
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
    public class DealerTransactionData
    {
        public string DealerCode { get; set; }
        public string UserName { get; set; }
        public DateTime? UploadDate { get; set; }
        public string DataType { get; set; }
        public string Remark { get; set; }

       
        public Int32 RowNo { get; set; }      
        public string QRCode { get; set; }
        public string UPN { get; set; }
        public string LOT { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class DealerTransactionDataSet
    {
        [XmlElement("Record")]
        public List<DealerTransactionDataRecord> Records { get; set; }
    }

    [Serializable]
    public class DealerTransactionDataRecord
    {
        public string DealerCode { get; set; }
        public string UserName { get; set; }
        public string DataType { get; set; }
        public string Remark { get; set; }
       
        [XmlIgnore]
        public DateTime? UploadDate { get; set; }
        [XmlElement("UploadDate")]
        public string StrUploadDate
        {
            get
            {
                if (this.UploadDate.HasValue)
                    return this.UploadDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.UploadDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("单据日期格式不正确");

                    this.UploadDate = dt;
                }
            }
        }
        
        [XmlElement("Item")]
        public List<DealerTransactionDataItem> Items { get; set; }
    }

    [Serializable]
    public class DealerTransactionDataItem
    {
        public Int32 RowNo { get; set; }
        public string QRCode { get; set; }
        public string UPN { get; set; }
        public string LOT { get; set; }
    }

}
