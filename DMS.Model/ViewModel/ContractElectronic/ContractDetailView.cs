using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.ViewModel.ContractElectronic
{
    [Serializable]
    public class ContractDetailView : BaseViewModel
    {
        public ContractDetailView()
        {
            ContractList = new ArrayList();
            ContractAttach = new ArrayList();
            QryList = new ArrayList();
        }
        public ArrayList QryList { get; set; }
        public Guid ExportId { get; set; }
        public string SelectExportId { get; set; }

        public string ContractId { get; set; }
        public string ContractNo { get; set; }

        /// <summary>
        /// 合同类型，做新增和续约标识
        /// </summary>
        public string ContractType { get; set; }
        /// <summary>
        /// 终止类型
        /// </summary>
        public string TerminationType { get; set; }

        public string DealerType { get; set; }

        public string DeptId { get; set; }
        public string DeptName { get; set; }
        public string DeptNameEn { get; set; }

        public string SubDepId { get; set; }
        public string DealerId { get; set; }
        public string DealerName { get; set; }
        public string LogisticsCompany { get; set; }

        public string StartDate { get; set; }

        public string EndDate { get; set; }

        public string Date { get; set; }
        public string DealerNameEn { get; set; }
        public string DealerAddress { get; set; }
        public string DealerAddressEn { get; set; }
        public string DealerPhone { get; set; }
        public string DealerFax { get; set; }
        public string DealerMail { get; set; }
        public string DealerManager { get; set; }
        public string DealerManagerEn { get; set; }

        public DateTime? AgreementStartDate { get; set; }
        public DateTime? AgreementEndDate { get; set; }
        public string OriginalNo { get; set; }
        public DateTime? OriginalStartDate { get; set; }
        public DateTime? OriginalEndDate { get; set; }
        public string PaymentType { get; set; }
        public string PaymentDays { get; set; }
        public string CompanyGuarantee { get; set; }
        public string BankGuarantee { get; set; }
        public string CreditLimit { get; set; }
        public string COName { get; set; }
        public string CONameEn { get; set; }
        public string COContactInfo { get; set; }
        public string Rebate { get; set; }
        public string Status { get; set; }
        public string ApplicantName { get; set; }
        public string ApplicantNameEn { get; set; }
        public string Balance { get; set; }
        public string CreateUser { get; set; }
        public DateTime? CreateDate { get; set; }
        public string UpdateUser { get; set; }
        public DateTime? UpdateDate { get; set; }


        public string ExclusiveType { get; set; }

        public string ContractVer { get; set; }

        public string VersionId { get; set; }

        public string IsPreview { get; set; }

        #region T2
        public string SubDeptName { get; set; }
        public string SubDeptNameEn { get; set; }
        public string DealerPostCode { get; set; }
        public string DealerBank { get; set; }
        public string DealerContact { get; set; }
        public string PlatformId { get; set; }
        public string PlatformName { get; set; }
        public string PlatformAddress { get; set; }
        public string PlatformFax { get; set; }
        public string PlatformPostCode { get; set; }
        public string PlatformBank { get; set; }
        public string PlatformContact { get; set; }
        public string Guarantee { get; set; }
        public bool IsAddNew { get; set; }
        public string PlatformBusinessContact { get; set; }
        public string PlatformBusinessPhone { get; set; }
        public string SubBuName { get; set; }
        public string SubBuNameEn { get; set; }

        public DateTime? PaymentDate { get; set; }
        public DateTime? ContractDate { get; set; }

        public string Phone { get; set; }

        public string DealerBank1 { get; set; }
        public string DealerContact1 { get; set; }

        #endregion T2


        public string FilePath { get; set; }

        public string FileName { get; set; }

        public Object FileData { get; set; }

        public ArrayList UploadTemplateFileData { get; set; }

        public string NewFileNameGoods { get; set; }
        public string NewFileNameProxy { get; set; }

        public string FullPath { get; set; }

        public List<SelectedTemplate> ContractTemplateList { get; set; }

        public ArrayList ContractList { get; set; }

        public ArrayList ContractAttach { get; set; }

        public ArrayList ContractVerList { get; set; }

        public List<UserPdfTemplate> ContractTemplatePdfList { get; set; }

        public string QrCde { get; set; }

        public string CreditTerm { get; set; }
        public string SubProductName { get; set; }
        public string SubProductEName { get; set; }
        public int ? IsProduct { get; set; }
        public int? IsPrices { get; set; }
        public int? IsTerritory { get; set; }
        public int? IsPurchase { get; set; }
        public int? IsPayment { get; set; }
        public string ReadID { get; set; }

        public bool IsRead { get; set; }

        public bool TraningOneStatus { get; set; }

        public bool TraningTwoStatus { get; set; }

        public string TraningResult { get; set; }

        public string ESignContractType { get; set; }

        public string VisionStatus { get; set; }
    }
   
}
