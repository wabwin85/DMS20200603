using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model
{
    [Serializable]
    public class SellInDetailInfoTemp: BaseModel
    {
        public Guid Id { get; set; }
        public string SubCompany { get; set; }
        public string Brand { get; set; }
        public string AccountingYear { get; set; }
        public string AccountingQuarter { get; set; }
        public string AccountingMonth { get; set; }
        public string Channel { get; set; }
        public string SalesIdentity { get; set; }
        public string SalesIdentityRow { get; set; }
        public string OrderType { get; set; }
        public decimal? ActualDiscount { get; set; }
        public string CompanyCode { get; set; }
        public string CompanyName { get; set; }
        public string IsRelated { get; set; }
        public string RevenueType { get; set; }
        public string BorderType { get; set; }
        public string ProductLine { get; set; }
        public string ProductProvince { get; set; }
        public DateTime? InvoiceDate { get; set; }
        public string SoldPartyDealerCode { get; set; }
        public string SoldPartySAPCode { get; set; }
        public string SoldPartyName { get; set; }
        public string BillingType { get; set; }
        public string Province { get; set; }
        public decimal? ExchangeRate { get; set; }
        public string MaterialCode { get; set; }
        public string MaterialName { get; set; }
        public string UPN { get; set; }
        public int? OutInvoiceNum { get; set; }
        public decimal? InvoiceNetAmount { get; set; }
        public decimal? InvoiceRate { get; set; } 
        public decimal? RebateAmount { get; set; }
        public decimal? RebateNetAmount { get; set; }
        public decimal? RebateRate { get; set; }
        public decimal? InvoiceAmount { get; set; }
        public decimal? LocalCurrencyAmount { get; set; }

        public decimal? BusiPurNoRebateAmount { get; set; }
        public decimal? KLocalCurrencyAmount { get; set; }
        public DateTime? DeliveryDate { get; set; }
        public DateTime? OrderCreateDate { get; set; }
        public string ProductLineAndSoldParty { get; set; }
        public string ActualLegalEntity { get; set; }
        public string IsNeedRecovery { get; set; }
        public string RecoveryComment { get; set; }
        public decimal? BusinessCaliber { get; set; }
        public decimal? ClosedAccount { get; set; }
        public string Comment { get; set; }
        public string ProductGeneration { get; set; }
        public decimal? StandardPrice { get; set; }
        public string Region { get; set; }
        public DateTime InsertTime { get; set; }
        public Guid? CreatedBy { get; set; }
        public DateTime ModifiedTime { get; set; }
        public Guid? ModifiedBy { get; set; }
        public string ErrorMsg { get; set; }
        public bool? IsError { get; set; }


    }
}
