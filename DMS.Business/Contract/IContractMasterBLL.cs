using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using DMS.Model;
    using System.Data;
    using System.Collections;
    using Coolite.Ext.Web;
    using DMS.Common;

    public interface IContractMasterBLL
    {
        DataSet QueryBusinessReferencesList(Hashtable table);

        DataSet QueryMedicalDevicesList(Hashtable table);

        DataSet QueryBusinessLicenseList(Hashtable table);

        DataSet QuerySeniorCompanyList(Hashtable table);

        DataSet QueryCompanyStockholderList(Hashtable table);

        DataSet QueryCorporateEntityList(Hashtable table);

        DataSet QueryPublicOfficeList(Hashtable table);

        DataSet GetTakeEffectStateByContractID(Guid id);

        BusinessReferences GetBusinessReferencesById(Guid id);

        MedicalDevices GetMedicalDevicesById(Guid id);

        BusinessLicense GetBusinessLicenseById(Guid id);

        SeniorCompany GetSeniorCompanyById(Guid id);

        CompanyStockholder GetCompanyStockholderById(Guid id);

        CorporateEntity GetCorporateEntityById(Guid id);

        PublicOffice GetPublicOfficeById(Guid id);

        DataSet GetPurchaseQuotasByConId(Guid id);

        DataSet GetContractTerritoryByContractId(Guid id);

        DataSet GetDistinctTerritoryByContractId(Guid id);

        DataSet GetExcelTerritoryByContractId(Guid id);

        DataSet GetPurchaseQuotasHospitalByConId(Guid id);

        DataSet GetProductLineByDivisionID(Hashtable obj);

        DataSet GetDivision(string DivisionID);

        DataSet GetAuthorCodeAndDivName(Hashtable obj);

        IList<MailDeliveryAddress> GetMailDeliveryAddress(Hashtable obj);
        IList<MailDeliveryAddress> GetLPMailDeliveryAddressByDealerId(Hashtable obj);

        #region  经销商授权
        void UpdateContractTerritory(Hashtable obj);
        DataSet QueryAuthorizationTempListForDataSet(Guid contractId);
        void SaveAuthorizationTemp(DealerAuthorization temp);
        void DetachHospitalFromAuthorization(Guid datId, Guid[] changes);
        bool SaveHospitalOfAuthorization(Guid datId, IDictionary<string, string>[] changes, SelectTerritoryType selectType, string hosProvince, string hosCity, string hosDistrict, Guid productLineId, string hosRemark);
        DataSet GetFormalAuthorizedHospital(Hashtable obj);
        DataSet GetHospitalGrade(Hashtable obj);
        DataSet GetHospitalDepartment(Hashtable obj);
        DataSet GetFormalTerritory(Hashtable obj, int start, int limit, out int totalCount);
        DataSet GetContrateTerritory(Hashtable obj, int start, int limit, out int totalCount);

        DataSet GetHistoryAuthorizedHospital(HospitalListHistory obj, int start, int limit, out int totalCount);
        DataSet GetHistoryAuthorizedHospital(HospitalListHistory obj);
        DataSet DeleteAuthorizationAOP(Hashtable obj);
        void SynchronousHospitalListTemp(Hashtable temp);
        #endregion

        #region 经销商授权到区域
        DataSet QueryAuthorizationAreaTempList(Hashtable obj);
        void SysFormalAuthorizationAreaToTemp(Hashtable obj);
        void ModifyPartsAuthorizationAreaTemp(Hashtable obj);
        DataSet GetPartsAuthorizedAreaTemp(Hashtable obj);//获取授权产品分类并确认是否已经被授权
        void SubmintAreaTemp(Hashtable obj);
        DataSet GetPartAreaExcHospitalTemp(Hashtable obj);
        void RemoveAreaHospitalTemp(string ContractId, Guid[] changes);//删除排除医院
        DataSet GetProvincesForArea(Hashtable obj);
        DataSet GetProvincesForAreaSelected(Hashtable obj);
        DataSet GetProductForAreaSelected(Hashtable obj);
        bool SaveHospitalOfAuthorizationArea(Guid datId, IDictionary<string, string>[] changes, SelectTerritoryType selectType, string hosProvince, string hosCity, string hosDistrict, Guid productLineId, string hosRemark);

        DataSet GetProvincesForAreaSelectedOld(Hashtable obj);
        DataSet GetPartAreaExcHospitalOld(Hashtable obj);
        #endregion

        #region AOP指标
        //经销商标准指标
        DMS.Model.VAopDealer GetYearAopDealers(Guid ContractId, Guid dmaId, Guid prodLineId, string year);
        DMS.Model.VAopDealer GetAopDealersTemp(Hashtable obj);
        DMS.Model.VAopDealer GetAopDealersByHosTemp(Hashtable obj);
        DataSet GetAopDealersByHosTempQuery(Hashtable obj);


        bool SaveAopDealers(Guid ContractId,VAopDealer aopDealers);
        bool RemoveAopDealers(Guid ContractId, Guid dmaId, Guid prodLineId, string year);
        DataSet GetAopDealersByQuery(Hashtable obj, int start, int limit, out int totalCount);
        DataSet GetAopDealersByQuery(Hashtable obj);
        DataSet GetAopDealerUnionHospitalQuery(Guid ContractId, Guid? dmaId, Guid? prodLineId, string year);
        DataSet GetAopDealerUnionHospitalHistoryQuery(Guid ContractId, Guid? dmaId, Guid? prodLineId, string year);

        DataSet ExportAopDealersByQuery(Hashtable obj);
        DataSet GetAopDealersByQueryByContractId(Guid ContractId);
        DataSet GetFormalAopDealer(Hashtable obj);
        DataSet GetFormalAopDealer(Hashtable obj, int start, int limit, out int totalCount);

        DataSet GetHistoryAopDealer(AopDealerHistory obj);
        DataSet GetHistoryAopDealer(AopDealerHistory obj, int start, int limit, out int totalCount);
        DataSet GetHistoryAopDealer(Hashtable obj,int start, int limit, out int totalCount);

        void SynchronousFormalDealerAOPTemp(Hashtable obj);

        DataSet GetAopDealerContrastLastYear(Guid ContractId);
    
        //医院标准指标
        DataSet GetAopDealersHospitalByQuery(Guid ContractId, Guid? dmaId, Guid?[] prodLineId, string[] year, int start, int limit, out int totalCount);
        DataSet GetAopDealersHospitalByQuery2(Guid ContractId, Guid? dmaId, Guid?[] prodLineId, string[] year, int start, int limit, out int totalCount);
        DataSet GetAopDealersHospitalTempByQuery(Hashtable obj);

        DataSet GetAopDealersHospitalByQueryByContractId(Guid ContractId, int start, int limit, out int totalCount);
        DataSet GetAopDealersHospitalByQueryByContractId(Guid ContractId);
        DataSet ExportAopDealersHospitalByQuery(Hashtable obj);

        DMS.Model.VAopDealer GetYearAopHospital(Guid ContractId, Guid dmaId, Guid?[] prodLineId, string[] year,Guid hospitalId);
        bool SaveAopHospital(Guid ContractId, Guid HospitlId, string Month, VAopDealer aopDealers);
        DataSet GetFormalAopHospital(Hashtable obj);
        DataSet GetFormalAopHospital(Hashtable obj, int start, int limit, out int totalCount);
        DataSet GetHistoryAopHospital(AopDealerHospitaHistory obj, int start, int limit, out int totalCount);
        DataSet GetHistoryAopHospital(AopDealerHospitaHistory obj);

        void SynchronousFormalDealerHospiatlAOPTemp(Guid ContractId, Hashtable obj);
        void SynchronousFormalDealerHospiatlAOPTemp2(Hashtable obj);

        //指标设定备注
        void SaveAopRemark(AopRemark ar);
        int UpdateAopRemark(AopRemark ar);
        int DeleteAopRemark(AopRemark ar);

        #endregion

        #region IC 指标设定
        DataSet GetAopICDealersHospitalByQuery(Guid ContractId, Guid? dmaId, Guid?[] prodLineId, string[] year, int start, int limit, out int totalCount);
        DMS.Model.VAopICDealerHospital GetYearAopHospitalForIC(Guid ContractId, Guid dmaId, Guid?[] prodLineId, string[] year, Guid hospitalId, string classification);
        bool SaveAopHospitalForIC(Guid ContractId, VAopICDealerHospital aopDealers);
        bool SaveAopHospitalForICByAmendment(Guid ContractId, VAopICDealerHospital aopDealers, int month);

        DataSet SetAOPHospitalForICInitialValue(Guid ContractId, Guid? dmaId, Guid?[] prodLineId, string year);
        DataSet GetICAopDealersHospitalByQuery(Guid ContractId, int start, int limit, out int totalCount);
        DataSet GetICAopDealersHospitalUnitByQuery(Guid ContractId, int start, int limit, out int totalCount);
        DataSet GetICAopHospitalByContractId(Guid ContractId);
        DataSet GetAopProductHospitalAmount(Hashtable obj);

        DataSet QueryHospitalProduct(Hashtable obj, int start, int limit, out int totalCount);
        DataSet QueryHospitalProduct(Hashtable obj);
        DataSet QueryHospitalProductAOP(Hashtable obj, int start, int limit, out int totalCount);
        DataSet QueryHospitalProductAOPAmendment(Hashtable obj, int start, int limit, out int totalCount);
        DataSet QueryHospitalProductAOPAmendment(Hashtable obj);
        DataSet QueryHospitalProductAOP(Hashtable obj);
        DataSet ExportHospitalProductAOP(Hashtable obj);

        DataSet QueryHospitalProductByDealerTotleAOP(Hashtable obj, int start, int limit, out int totalCount);
        DataSet QueryHospitalProductByDealerTotleAOP(Hashtable obj);
        DataSet QueryHospitalProductByDealerTotleAOP2(Hashtable obj);

        //Begin  GetHospitalProductByProductLineId 不在使用
        IList<IcProductStandardPrice> GetHospitalProductByProductLineId(Hashtable obj);
        //end
        IList<ProductClassification> GetProductClassificationByProductLineId(Hashtable obj);
        DataSet GetContractProductClassification(Hashtable obj);
        DataSet GetContractProductClassificationPrice(Hashtable obj);
        DataSet GetProductClassificationPrice(Hashtable obj);


        DataSet GetHospitalProductMapping(Hashtable obj);
        void SubmintDealerHospitalProductMapping(Hashtable obj);
        void SubmintHospitalProductPrice(Hashtable obj);
        DataSet MaintainDealerHospitalProductAOP(Hashtable obj);


        DataSet GetFormalAopHospitalProduct(Hashtable obj);
        DataSet GetFormalAopHospitalProduct(Hashtable obj, int start, int limit, out int totalCount);
        DataSet GetFormalAopHospitalProductUnit(Hashtable obj, int start, int limit, out int totalCount);

        DataSet GetHistoryAopHospitalProduct(AopicDealerHospitalHistory obj);
        DataSet GetHistoryAopHospitalProduct(AopicDealerHospitalHistory obj, int start, int limit, out int totalCount);

        void SynchronousFormalDealerHospiatlProductAOPTemp(Guid ContractId, Hashtable obj);
        void SynchronousDealerHospiatlProductMapping(Guid ContractId, Hashtable obj);


        DataSet CheckAuthorProductPrice(Hashtable obj);
        #endregion

        void SaveBusinessReferences(BusinessReferences businessReferences);

        void SaveMedicalDevices(MedicalDevices medicalDevices);

        void SaveBusinessLicense(BusinessLicense businessLicense);

        void SaveSeniorCompany(SeniorCompany seniorCompany);

        void SaveCompanyStockholder(CompanyStockholder companyStockholder);

        void SaveCorporateEntity(CorporateEntity corporateEntity);

        void SavePublicOffice(PublicOffice publicOffice);

        void DeleteBusinessReferences(Guid detailId);

        void DeleteMedicalDevices(Guid detailId);

        void DeleteBusinessLicense(Guid detailId);

        void DeleteSeniorCompany(Guid detailId);

        void DeleteCompanyStockholder(Guid detailId);

        void DeleteCorporateEntity(Guid detailId);

        void DeletePublicOffice(Guid detailId);

        void UpdateBusinessReferences(BusinessReferences businessReferences);

        void UpdateMedicalDevices(MedicalDevices medicalDevices);

        void UpdateBusinessLicense(BusinessLicense businessLicense);

        void UpdateSeniorCompany(SeniorCompany seniorCompany);

        void UpdateCompanyStockholder(CompanyStockholder companyStockholder);

        void UpdateCorporateEntity(CorporateEntity corporateEntity);

        void UpdatePublicOffice(PublicOffice publicOffice);

        #region 维护经销商IAF签名

        void SaveDealerIAFSign(DealeriafSign sign);

        DealeriafSign GetDealerIAFSign(Guid Cm_Id);

        int UpdateDealerIAFSign(DealeriafSign sign);

        int UpdateDealerIAFSignFrom3(DealeriafSign sign);

        int UpdateDealerIAFSignFrom5(DealeriafSign sign);

        int UpdateDealerIAFSignFrom6(DealeriafSign sign);

        int UpdateThirdPartyFrom(DealeriafSign sign);
        #endregion

        #region 附件上传后发通知邮件
        void SendMailByDCMSAnnexNotice(string ContractId, string Type);
      
        #endregion

        /// <summary>
        /// 获取Amed
        /// </summary>
        string GetAmandCurrentJudgeDate();

        #region DCMS Update in 201606 
        string GetContractProperty_Last(Hashtable obj);
        void AddContractProduct(Hashtable obj);
        DataSet GetAuthorizationProductAll(Hashtable obj);
        DataSet GetAuthorizationProductSelected(Hashtable obj);
        bool DeleteProductSelected(string dctId);
        DataSet QueryDcmsHospitalSelecedTemp(Hashtable obj);
        void DeleteAuthorizationHospitalTemp(Guid[] changes);//删除授权医院
        DataSet GetCopyProductCan(Hashtable obj);
        void CopyHospitalTempFromOtherAuth(Hashtable obj);
    
        DataSet DepartProductTemp(Hashtable obj);
        DataSet QueryHospitalProductTemp(Hashtable obj, int start, int limit, out int totalCount);
        void HospitalDepartClear(Hashtable obj);
        int UpdateHospitalDepartmentTemp(Hashtable obj);
        DataSet ExcelHospitalProductTemp(Guid contractId);

        //医院批量上传
        bool DeleteTempUploadHospitalByDatId(string dctId);
        DataSet QueryHospitalUpload(Hashtable obj, int start, int limit, out int totalCount);
        bool DCMSHospitalTempImport(DataTable dt, string datId);
        bool VerifyDCMSHospitalImport(string datId,string mktype,out string IsValid);
        bool SubmintHospitalTempInitCheck(Hashtable obj);
        void SaveHospitalTempInit(Hashtable obj);
        //产品区域授权
        DataSet GetAuthorizationAreaProductSelected(Hashtable obj);
        bool AddContractAreaProduct(Hashtable obj);
        bool DeleteAreaProductSelected(string Id);
        DataSet GetAuthorizatonArea(Hashtable obj);
        DataSet GetnArea(Hashtable obj);
        bool AddContractArea(Hashtable obj);
        bool DeleteAreaAreaSelected(Guid[] Id);
        DataSet GetCopHospit(Hashtable obj);
        bool CopeAuthorizatonAreaHospit(Hashtable tb);
        bool RemoveAreaSelectedHospital(Hashtable obj);
        DataSet QueryPartAreaExcHospitalTemp(Hashtable obj, int start, int limit, out int totalCount);
        bool CopeAuthorizatonAreaArea(Hashtable obj);
        bool DeleteHospitByDaId(string DaId);
        void DeleteHospitByDaidHspit(string ContractId, Guid[] changes);//删除排除医院
        DataSet GetDeleteProductQutery(Hashtable obj, int start, int limit, out int totalCount);
        DataSet GetDeleteHospitalQutery(Hashtable obj, int start, int limit, out int totalCount);

        int CheckAuthorizationType(string contractId);

        DataSet TerritoryProductByContractId(Guid id, string subu);
        #endregion
    }
}
