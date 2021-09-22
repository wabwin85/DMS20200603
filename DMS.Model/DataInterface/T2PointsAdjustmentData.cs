/*
 * 经销商积分调整（购买积分）信息上传数据结构
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
    public class T2PointsAdjustmentData
    {
        public string Tier2DealerCode { get; set; }
        public DateTime PointsAdjustDate { get; set; }
        public string BSCBU { get; set; }
        public DateTime PointsValidToDate { get; set; }
        public decimal PointsAmount { get; set; }
        public string Remark { get; set; }
    }
    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class T2PointsAdjustmenDataSet
    {
        [XmlElement("Record")]
        public List<T2PointsAdjustmentDataRecord> Records { get; set; }
    }
    [Serializable]
    public class T2PointsAdjustmentDataRecord
    {
        public string Tier2DealerCode { get; set; }
        [XmlIgnore]
        public DateTime? PointsAdjustDate { get; set; }
        [XmlElement("PointsAdjustDate")]
        public string StrPointsAdjustDate
        {
            get
            {
                if (this.PointsAdjustDate.HasValue)
                {
                    return this.PointsAdjustDate.Value.ToString("yyyy-MM-dd HH:mm:ss");

                }
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.PointsAdjustDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("积分调整日期格式不正确");

                    this.PointsAdjustDate = dt;
                }
            }

        }
        public string BSCBU { get; set; }
        [XmlIgnore]
        public DateTime? PointsValidToDate { get; set; }
        [XmlElement("PointsValidToDate")]
        public string StrPointsValidToDate
        {
            get
            {
                if (this.PointsValidToDate.HasValue)
                {
                    return this.PointsValidToDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                }
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.PointsValidToDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("积分有效期期格式不正确");

                    this.PointsValidToDate = dt;
                }
            }
        }
        [XmlIgnore]
        public decimal PointsAmount { get; set; }
        [XmlElement("PointsAmount")]
        public string StrPointsAmount
        {
            get
            {
                return this.PointsAmount.ToString("0.00");
            }
            set
            {
                decimal Amount;
                if (!Decimal.TryParse(value, out Amount))
                    throw new Exception("收货数量格式不正确");
                this.PointsAmount = Amount;
            }
        }
        public string Remark { get; set; }
    }
}
