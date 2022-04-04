using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.ViewModel.Common;
namespace DMS.ViewModel.Shipment.Extense
{
    public class EmbedDataModelVO : BaseQueryVO
    { 
        public Guid Id { get; set; }

        public string SubCompany { get; set; }

        public string SubCompanyName { get; set; }

        public string Brand { get; set; }
        public string AccountingYear { get; set; }
        public string AccountingMonth { get; set; }
        public string DealerCode { get; set; }
        public string SalesEntity { get; set; }
        public string DealerName { get; set; }
        public string LegalEntity { get; set; }
        public string Hos_Level { get; set; }
        public string Hos_Type { get; set; }
        public string Hos_Code { get; set; }
        public string Hos_Name { get; set; }
        public string NewOpenMonth { get; set; }
        public string NewOpenProduct { get; set; }
        public string Region { get; set; }
        public string Province { get; set; }
        public string City { get; set; }
        public string CityLevel { get; set; }
        public string RegionOwner { get; set; }
        public string SalesRepresentative { get; set; }
        public string PMA_UPN { get; set; }
        public string CFN_Name { get; set; }
        public string ProductLine { get; set; }
        public string ShipmentNbr { get; set; }
        public string UsedDate { get; set; }
        public string InvoiceNumber { get; set; }
        public string InvoiceDate { get; set; }
        public string InvoiceUploadDate { get; set; }
        public string State { get; set; }
        public string IsValidate { get; set; }
        public string Unit { get; set; }
        public decimal? Quantity { get; set; }

        public decimal? InvoicePrice { get; set; }
        public decimal? InvoiceRate { get; set; }
        public decimal? AssessUnitPrice { get; set; }
        public decimal? AssessPrice { get; set; }
        public string Remark { get; set; }
        public bool? IsLocked { get; set; }

        public DateTime? InsertTime { get; set; }
        public DateTime? ModifiedTime { get; set; }

        public Guid? CreatedBy { get; set; }
        public Guid? ModifiedBy { get; set; }

        public KeyValue SelAccountYear { get; set; }

        public KeyValue SelAccountMonth { get; set; }

        public KeyValue SelSubCompany { get; set; }

        public KeyValue SelBrand { get; set; }

        public int PageSize { get; set; }

        public int Page { get; set; } = 0;
        public int DataCount { get; set; }

        public ArrayList RstResultList = null;
    }
}