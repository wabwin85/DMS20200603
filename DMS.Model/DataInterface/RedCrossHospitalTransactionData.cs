using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Globalization;

namespace DMS.Model.DataInterface
{
    [Serializable]
    public class RedCrossHospitalTransactionData
    {

        public string ApplicationType { get; set; }
        public string HospitalID { get; set; }
        public string HospitalName { get; set; }
        public string SupplyID { get; set; }
        public string SupplyName { get; set; }
        public DateTime? BillDate { get; set; }
        public string BillNo { get; set; }
        public string MerchandiseName { get; set; }
        public string MerchandiseSpec { get; set; }
        public string DI { get; set; }
        public string PI { get; set; }
        public string GTIN { get; set; }
        public string UPN { get; set; }
        public string QRCode { get; set; }
        public string SN { get; set; }
        public decimal? Qty { get; set; }
        public string PackingUnit { get; set; }
        public string ArrivalDate { get; set; }
        public string Remark { get; set; }
        public decimal? UnitPrice { get; set; }
    }

    [Serializable]
    [XmlRoot("InterfaceDataSet")]
    public class RedCrossHospitalTransactionDataSet
    {
        [XmlElement("Record")]
        public List<RedCrossHospitalTransactionDataRecord> Records { get; set; }
    }

    [Serializable]
    public class RedCrossHospitalTransactionDataRecord
    {
        public string ApplicationType { get; set; }
        public string HospitalID { get; set; }
        public string HospitalName { get; set; }
        public string SupplyID { get; set; }
        public string SupplyName { get; set; }      
        public string BillNo { get; set; }
        [XmlIgnore]
        public DateTime? BillDate { get; set; }
        [XmlElement("BillDate")]
        public string StrBillDateDate
        {
            get
            {
                if (this.BillDate.HasValue)
                    return this.BillDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                return string.Empty;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    this.BillDate = null;
                }
                else
                {
                    DateTime dt;
                    if (!DateTime.TryParseExact(value, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                        throw new Exception("单据日期格式不正确");

                    this.BillDate = dt;
                }
            }
        }      

        [XmlElement("Item")]
        public List<RedCrossHospitalTransactionDataItem> Items { get; set; }
    }

    [Serializable]
    public class RedCrossHospitalTransactionDataItem
    {
        public string MerchandiseName { get; set; }
        public string MerchandiseSpec { get; set; }
        public string DI { get; set; }
        public string PI { get; set; }
        public string GTIN { get; set; }
        public string UPN { get; set; }
        public string QRCode { get; set; }
        public string SN { get; set; }       
        public string PackingUnit { get; set; }

        public string ArrivalDate { get; set; }
        public string Remark { get; set; }       

        [XmlIgnore]
        public decimal Qty { get; set; }
        [XmlElement("Qty")]
        public string StrQty
        {
            get
            {
                return this.Qty.ToString("0.00");
            }
            set
            {
                decimal qty;
                if (!Decimal.TryParse(value, out qty))
                    throw new Exception("产品数量格式不正确");
                this.Qty = qty;
            }
        }
        [XmlIgnore]
        public decimal UnitPrice { get; set; }
        [XmlElement("UnitPrice")]
        public string StrUnitPrice
        {
            get
            {
                return this.UnitPrice.ToString("0.00");
            }
            set
            {
                decimal unitprice;
                if (!Decimal.TryParse(value, out unitprice))
                    throw new Exception("含税单价格式不正确");
                this.UnitPrice = unitprice;
            }
        }
    }
}
