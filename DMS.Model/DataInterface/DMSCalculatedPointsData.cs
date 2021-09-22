/*
 * DMS计算生成积分信息下载数据接口
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
    public class DMSCalculatedPointsData
    {
        public string Tier2DealerCode { get; set; }
        public string PolicyCode { get; set; }
        public string PolicyName { get; set; }
        public string BSCBU { get; set; }
        public string AccountMonth { get; set; }
        public string LargessDesc { get; set; }
        public DateTime PointsValidToDate { get; set; }
        public decimal PointsAmount { get; set; }
    }
    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class DMSCalculatedPointsDataSet
    {

        [XmlElement("Record")]
        public List<DMSCalculatedPointsRecord> Records { get; set; }
    }
    [Serializable]
    public class DMSCalculatedPointsRecord
    {
        public string Tier2DealerCode { get; set; }
        public string ProductLine { get; set; }
        public string PolicyCode { get; set; }
        public string PolicyName { get; set; }
        public string BSCBU { get; set; }
        public string AccountMonth { get; set; }
        public string LargessDesc { get; set; }
        [XmlIgnore]
        public DateTime? PointsValidToDate { get; set; }
        [XmlElement("PointsValidToDate")]
        public String StrPointsValidToDate
        {
            get
            {
                if (this.PointsValidToDate.HasValue)
                {
                    return this.PointsValidToDate.Value.ToString("yyyy-MM-dd");
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
                        throw new Exception("发票日期格式不正确");

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
                    throw new Exception("发票额度格式不正确");
                this.PointsAmount = Amount;
            }
        }
    }
}
