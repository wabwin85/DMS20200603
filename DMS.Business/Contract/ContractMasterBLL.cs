using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using DMS.DataAccess;
    using DMS.Model;
    using System.Collections;
    using System.Data;
    using Lafite.RoleModel.Security.Authorization;
    using Lafite.RoleModel.Security;
    using Grapecity.Logging.CallHandlers;
    using Grapecity.DataAccess.Transaction;
    using DMS.Common;

    public class ContractMasterBLL : IContractMasterBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region Select
        public DataSet QueryBusinessReferencesList(Hashtable table)
        {
            using (BusinessReferencesDao dao = new BusinessReferencesDao())
            {
                return dao.SelectBusinessReferencesByFilter(table);
            }
        }

        public DataSet QueryMedicalDevicesList(Hashtable table)
        {
            using (MedicalDevicesDao dao = new MedicalDevicesDao())
            {
                return dao.SelectMedicalDevicesByFilter(table);
            }
        }

        public DataSet QueryBusinessLicenseList(Hashtable table)
        {
            using (BusinessLicenseDao dao = new BusinessLicenseDao())
            {
                return dao.SelectBusinessLicenseByFilter(table);
            }
        }

        public DataSet QuerySeniorCompanyList(Hashtable table)
        {
            using (SeniorCompanyDao dao = new SeniorCompanyDao())
            {
                return dao.SelectSeniorCompanyByFilter(table);
            }
        }

        public DataSet QueryCompanyStockholderList(Hashtable table)
        {
            using (CompanyStockholderDao dao = new CompanyStockholderDao())
            {
                return dao.SelectCompanyStockholderByFilter(table);
            }
        }

        public DataSet QueryCorporateEntityList(Hashtable table)
        {
            using (CorporateEntityDao dao = new CorporateEntityDao())
            {
                return dao.SelectCorporateEntityByFilter(table);
            }
        }

        public DataSet QueryPublicOfficeList(Hashtable table)
        {
            using (PublicOfficeDao dao = new PublicOfficeDao())
            {
                return dao.SelectPublicOfficeByFilter(table);
            }
        }

        public BusinessReferences GetBusinessReferencesById(Guid id)
        {
            using (BusinessReferencesDao dao = new BusinessReferencesDao())
            {
                return dao.GetObject(id);
            }
        }

        public MedicalDevices GetMedicalDevicesById(Guid id)
        {
            using (MedicalDevicesDao dao = new MedicalDevicesDao())
            {
                return dao.GetObject(id);
            }
        }

        public BusinessLicense GetBusinessLicenseById(Guid id)
        {
            using (BusinessLicenseDao dao = new BusinessLicenseDao())
            {
                return dao.GetObject(id);
            }
        }

        public SeniorCompany GetSeniorCompanyById(Guid id)
        {
            using (SeniorCompanyDao dao = new SeniorCompanyDao())
            {
                return dao.GetObject(id);
            }
        }

        public CompanyStockholder GetCompanyStockholderById(Guid id)
        {
            using (CompanyStockholderDao dao = new CompanyStockholderDao())
            {
                return dao.GetObject(id);
            }
        }

        public CorporateEntity GetCorporateEntityById(Guid id)
        {
            using (CorporateEntityDao dao = new CorporateEntityDao())
            {
                return dao.GetObject(id);
            }
        }

        public PublicOffice GetPublicOfficeById(Guid id)
        {
            using (PublicOfficeDao dao = new PublicOfficeDao())
            {
                return dao.GetObject(id);
            }
        }

        public DataSet GetPurchaseQuotasByConId(Guid id)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (ContractPurchaseQuotasDao dao = new ContractPurchaseQuotasDao())
            {
                return dao.SelectPurchaseQuotasByConId(id, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
            }
        }

        public DataSet GetContractTerritoryByContractId(Guid id)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetContractTerritoryByContractId(id, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
            }
        }

        public DataSet GetDistinctTerritoryByContractId(Guid id)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetDistinctTerritoryByContractId(id, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
            }
        }

        public DataSet GetExcelTerritoryByContractId(Guid id)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetExcelTerritoryByContractId(id);
            }
        }

        public DataSet GetPurchaseQuotasHospitalByConId(Guid id)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (PurchaseQuotasHospitalDao dao = new PurchaseQuotasHospitalDao())
            {
                return dao.GetContractTerritoryHospitalByContractId(id, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
            }
        }

        public DataSet QueryAuthorizationTempListForDataSet(Guid conId)
        {
            using (DealerAuthorizationTableTempDao dao = new DealerAuthorizationTableTempDao())
            {
                DealerAuthorization param = new DealerAuthorization();
                param.DclId = conId;
                return dao.QueryAuthorizationTempListForDataSet(param);
            }
        }

        public DataSet GetProductLineByDivisionID(Hashtable obj)
        {
            BaseService.AddCommonFilterCondition(obj);
            using (ContractProductLineDao dao = new ContractProductLineDao())
            {
                return dao.GetProductLineByDivisionID(obj);
            }
        }

        public DataSet GetDivision(string DivisionID)
        {
            Hashtable obj = new Hashtable();
            BaseService.AddCommonFilterCondition(obj);
            if (!String.IsNullOrEmpty(DivisionID)) obj.Add("DivisionID", DivisionID);
            using (ContractProductLineDao dao = new ContractProductLineDao())
            {
                return dao.GetDivision(obj);
            }
        }

        public DataSet GetAuthorCodeAndDivName(Hashtable obj)
        {
            using (ContractMasterDao dao = new ContractMasterDao())
            {
                return dao.GetAuthorCodeAndDivName(obj);
            }
        }

        public IList<MailDeliveryAddress> GetMailDeliveryAddress(Hashtable obj)
        {
            using (MailDeliveryAddressDao dao = new MailDeliveryAddressDao())
            {
                return dao.QueryDCMSMailAddressByConditions(obj);
            }
        }

        public IList<MailDeliveryAddress> GetLPMailDeliveryAddressByDealerId(Hashtable obj)
        {
            using (MailDeliveryAddressDao dao = new MailDeliveryAddressDao())
            {
                return dao.QueryDCMSLPMailAddressByConditions(obj);
            }
        }

        public DataSet GetTakeEffectStateByContractID(Guid id)
        {
            using (ContractMasterDao dao = new ContractMasterDao())
            {
                return dao.GetTakeEffectStateByContractID(id);
            }
        }
        #endregion

        #region Insert
        public void SaveBusinessReferences(BusinessReferences businessReferences)
        {
            using (BusinessReferencesDao dao = new BusinessReferencesDao())
            {
                dao.Insert(businessReferences);
            }
        }

        public void SaveMedicalDevices(MedicalDevices medicalDevices)
        {
            using (MedicalDevicesDao dao = new MedicalDevicesDao())
            {
                dao.Insert(medicalDevices);
            }
        }

        public void SaveBusinessLicense(BusinessLicense businessLicense)
        {
            using (BusinessLicenseDao dao = new BusinessLicenseDao())
            {
                dao.Insert(businessLicense);
            }
        }

        public void SaveSeniorCompany(SeniorCompany seniorCompany)
        {
            using (SeniorCompanyDao dao = new SeniorCompanyDao())
            {
                dao.Insert(seniorCompany);
            }
        }

        public void SaveCompanyStockholder(CompanyStockholder companyStockholder)
        {
            using (CompanyStockholderDao dao = new CompanyStockholderDao())
            {
                dao.Insert(companyStockholder);
            }
        }

        public void SaveCorporateEntity(CorporateEntity corporateEntity)
        {
            using (CorporateEntityDao dao = new CorporateEntityDao())
            {
                dao.Insert(corporateEntity);
            }
        }

        public void SavePublicOffice(PublicOffice publicOffice)
        {
            using (PublicOfficeDao dao = new PublicOfficeDao())
            {
                dao.Insert(publicOffice);
            }
        }

        public void SaveForm3()
        {

        }
        #endregion

        #region Delete
        public void DeleteBusinessReferences(Guid detailId)
        {
            using (BusinessReferencesDao dao = new BusinessReferencesDao())
            {
                dao.Delete(detailId);
            }
        }

        public void DeleteMedicalDevices(Guid detailId)
        {
            using (MedicalDevicesDao dao = new MedicalDevicesDao())
            {
                dao.Delete(detailId);
            }
        }

        public void DeleteBusinessLicense(Guid detailId)
        {
            using (BusinessLicenseDao dao = new BusinessLicenseDao())
            {
                dao.Delete(detailId);
            }
        }

        public void DeleteSeniorCompany(Guid detailId)
        {
            using (SeniorCompanyDao dao = new SeniorCompanyDao())
            {
                dao.Delete(detailId);
            }
        }

        public void DeleteCompanyStockholder(Guid detailId)
        {
            using (CompanyStockholderDao dao = new CompanyStockholderDao())
            {
                dao.Delete(detailId);
            }
        }

        public void DeleteCorporateEntity(Guid detailId)
        {
            using (CorporateEntityDao dao = new CorporateEntityDao())
            {
                dao.Delete(detailId);
            }
        }

        public void DeletePublicOffice(Guid detailId)
        {
            using (PublicOfficeDao dao = new PublicOfficeDao())
            {
                dao.Delete(detailId);
            }
        }
        #endregion

        #region Update
        public void UpdateBusinessReferences(BusinessReferences businessReferences)
        {
            using (BusinessReferencesDao dao = new BusinessReferencesDao())
            {
                dao.UpdateBusinessReferencesByFilter(businessReferences);
            }
        }

        public void UpdateMedicalDevices(MedicalDevices medicalDevices)
        {
            using (MedicalDevicesDao dao = new MedicalDevicesDao())
            {
                dao.UpdateMedicalDevicesByFilter(medicalDevices);
            }
        }

        public void UpdateBusinessLicense(BusinessLicense businessLicense)
        {
            using (BusinessLicenseDao dao = new BusinessLicenseDao())
            {
                dao.UpdateBusinessLicenseByFilter(businessLicense);
            }
        }

        public void UpdateSeniorCompany(SeniorCompany seniorCompany)
        {
            using (SeniorCompanyDao dao = new SeniorCompanyDao())
            {
                dao.UpdateSeniorCompanyByFilter(seniorCompany);
            }
        }

        public void UpdateCompanyStockholder(CompanyStockholder companyStockholder)
        {
            using (CompanyStockholderDao dao = new CompanyStockholderDao())
            {
                dao.UpdateCompanyStockholderByFilter(companyStockholder);
            }
        }

        public void UpdateCorporateEntity(CorporateEntity corporateEntity)
        {
            using (CorporateEntityDao dao = new CorporateEntityDao())
            {
                dao.UpdateCorporateEntityByFilter(corporateEntity);
            }
        }

        public void UpdatePublicOffice(PublicOffice publicOffice)
        {
            using (PublicOfficeDao dao = new PublicOfficeDao())
            {
                dao.UpdatePublicOfficeByFilter(publicOffice);
            }
        }

        #endregion

        #region 合同—经销商授权区域
        public void UpdateContractTerritory(Hashtable obj)
        {
            using (DealerAuthorizationTableTempDao dao = new DealerAuthorizationTableTempDao())
            {
                dao.UpdateContractTerritory(obj);
            }
        }

        public void SaveAuthorizationTemp(DealerAuthorization temp)
        {
            using (DealerAuthorizationTableTempDao dao = new DealerAuthorizationTableTempDao())
            {
                dao.Insert(temp);
            }
        }

        public void DetachHospitalFromAuthorization(Guid datId, Guid[] changes)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                ContractTerritoryDao dao = new ContractTerritoryDao();

                foreach (Guid item in changes)
                {
                    dao.DetachHospitalFromAuthorization(datId, item);
                }

                trans.Complete();
            }
        }

        /// <summary>
        /// 保存授权医院
        /// </summary>
        /// <param name="datId"></param>
        /// <param name="changes"></param>
        /// <param name="selectType"></param>
        /// <param name="hosProvince"></param>
        /// <param name="hosCity"></param>
        /// <param name="hosDistrict"></param>
        /// <param name="productLineId"></param>
        /// <param name="hosRemark"></param>
        /// <returns></returns>
        public bool SaveHospitalOfAuthorization(Guid datId, IDictionary<string, string>[] changes, SelectTerritoryType selectType, string hosProvince, string hosCity, string hosDistrict, Guid productLineId, string hosRemark)
        {
            bool result = false;
            if (selectType == SelectTerritoryType.Default)
            {
                if (changes.Length > 0)
                {
                    using (TransactionScope trans = new TransactionScope())
                    {
                        ContractTerritoryDao dao = new ContractTerritoryDao();

                        foreach (Dictionary<string, string> hospital in changes)
                        {
                            dao.AttachHospitalToAuthorization(datId, new Guid(hospital["HosId"]), hosRemark);
                        }

                        trans.Complete();
                    }

                    result = true;
                }
            }
            else
            {
                int rows = 0;


                using (TransactionScope trans = new TransactionScope())
                {
                    DealerHospitalDao dao = new DealerHospitalDao();

                    string hos_City = hosCity;
                    string hos_District = hosDistrict;

                    foreach (Dictionary<string, string> territory in changes)
                    {
                        if (selectType == SelectTerritoryType.District)
                            hos_District = territory["Value"];
                        else
                        {
                            hos_District = string.Empty;
                            hos_City = territory["Value"];
                        }
                        rows += dao.AttachHospitalToAuthorization(datId, hosProvince, hos_City, hos_District, productLineId, hosRemark, null, null);
                    }
                    if (rows > 0)
                    {
                        trans.Complete();
                    }
                }

                if (rows > 0)
                    result = true;
            }

            return result;
        }

        public DataSet GetFormalAuthorizedHospital(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetFormalAuthorizedHospital(obj);
            }
        }

        public DataSet GetHospitalGrade(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetHospitalGrade(obj);
            }
        }

        public DataSet GetHospitalDepartment(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetHospitalDepartment(obj);
            }
        }

        public DataSet GetFormalTerritory(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetFormalTerritory(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetContrateTerritory(Hashtable obj, int start, int limit, out int totalCount)
        {
            HospitalListHistory history = new HospitalListHistory();
            history.ChangeToContractid = new Guid(obj["ContractId"].ToString());
            DataTable dtcheck = this.GetHistoryAuthorizedHospital(history).Tables[0];

            if (dtcheck.Rows.Count == 0)
            {
                using (ContractTerritoryDao dao = new ContractTerritoryDao())
                {
                    return dao.GetFormalTerritory(obj, start, limit, out totalCount);

                }
            }
            else
            {
                using (HospitalListHistoryDao dao = new HospitalListHistoryDao())
                {
                    return dao.GetHistoryContracteHospital(history, start, limit, out totalCount);
                }

            }

        }

        public DataSet GetHistoryAuthorizedHospital(HospitalListHistory obj, int start, int limit, out int totalCount)
        {
            using (HospitalListHistoryDao dao = new HospitalListHistoryDao())
            {
                return dao.GetHistoryAuthorizedHospital(obj, start, limit, out totalCount);
            }
        }
        public DataSet GetHistoryAuthorizedHospital(HospitalListHistory obj)
        {
            using (HospitalListHistoryDao dao = new HospitalListHistoryDao())
            {
                return dao.GetHistoryAuthorizedHospital(obj);
            }
        }


        public DataSet DeleteAuthorizationAOP(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.DeleteAuthorizationAOP(obj);
            }
        }
        public void SynchronousHospitalListTemp(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                dao.SynchronousHospitalListTemp(obj);
            }
        }
        #endregion

        #region 合同-AOP指标
        public VAopDealer GetYearAopDealers(Guid ContractId, Guid dmaId, Guid prodLineId, string year)
        {
            using (AopDealerTempDao dao = new AopDealerTempDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", ContractId);
                obj.Add("DealerDmaId", dmaId);
                obj.Add("ProductLineBumId", prodLineId);
                obj.Add("Year", year);
                DataTable dt = dao.GetYearAOPAll(obj).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    VAopDealer yearAopDealer = new VAopDealer();
                    yearAopDealer.DealerDmaId = new Guid(dt.Rows[0]["Dealer_DMA_ID"].ToString());
                    yearAopDealer.ProductLineBumId = new Guid(dt.Rows[0]["ProductLine_BUM_ID"].ToString());
                    yearAopDealer.Year = dt.Rows[0]["Year"].ToString();
                    yearAopDealer.Amount1 = double.Parse(dt.Rows[0]["Amount_1"].ToString());
                    yearAopDealer.Amount2 = double.Parse(dt.Rows[0]["Amount_2"].ToString());
                    yearAopDealer.Amount3 = double.Parse(dt.Rows[0]["Amount_3"].ToString());
                    yearAopDealer.Amount4 = double.Parse(dt.Rows[0]["Amount_4"].ToString());
                    yearAopDealer.Amount5 = double.Parse(dt.Rows[0]["Amount_5"].ToString());
                    yearAopDealer.Amount6 = double.Parse(dt.Rows[0]["Amount_6"].ToString());
                    yearAopDealer.Amount7 = double.Parse(dt.Rows[0]["Amount_7"].ToString());
                    yearAopDealer.Amount8 = double.Parse(dt.Rows[0]["Amount_8"].ToString());
                    yearAopDealer.Amount9 = double.Parse(dt.Rows[0]["Amount_9"].ToString());
                    yearAopDealer.Amount10 = double.Parse(dt.Rows[0]["Amount_10"].ToString());
                    yearAopDealer.Amount11 = double.Parse(dt.Rows[0]["Amount_11"].ToString());
                    yearAopDealer.Amount12 = double.Parse(dt.Rows[0]["Amount_12"].ToString());
                    yearAopDealer.AmountY = double.Parse(dt.Rows[0]["Amount_Y"].ToString());

                    yearAopDealer.ReAmount1 = double.Parse((dt.Rows[0]["Re_Amount1"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount1"].ToString()));
                    yearAopDealer.ReAmount2 = double.Parse((dt.Rows[0]["Re_Amount2"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount2"].ToString()));
                    yearAopDealer.ReAmount3 = double.Parse((dt.Rows[0]["Re_Amount3"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount3"].ToString()));
                    yearAopDealer.ReAmount4 = double.Parse((dt.Rows[0]["Re_Amount4"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount4"].ToString()));
                    yearAopDealer.ReAmount5 = double.Parse((dt.Rows[0]["Re_Amount5"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount5"].ToString()));
                    yearAopDealer.ReAmount6 = double.Parse((dt.Rows[0]["Re_Amount6"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount6"].ToString()));
                    yearAopDealer.ReAmount7 = double.Parse((dt.Rows[0]["Re_Amount7"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount7"].ToString()));
                    yearAopDealer.ReAmount8 = double.Parse((dt.Rows[0]["Re_Amount8"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount8"].ToString()));
                    yearAopDealer.ReAmount9 = double.Parse((dt.Rows[0]["Re_Amount9"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount9"].ToString()));
                    yearAopDealer.ReAmount10 = double.Parse((dt.Rows[0]["Re_Amount10"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount10"].ToString()));
                    yearAopDealer.ReAmount11 = double.Parse((dt.Rows[0]["Re_Amount11"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount11"].ToString()));
                    yearAopDealer.ReAmount12 = double.Parse((dt.Rows[0]["Re_Amount12"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount12"].ToString()));

                    yearAopDealer.RmkBody = dt.Rows[0]["RmkBody"].ToString();
                    if (!dt.Rows[0]["RmkId"].ToString().Equals(""))
                    {
                        yearAopDealer.RmkId = new Guid(dt.Rows[0]["RmkId"].ToString());
                    }
                    return yearAopDealer;
                }
                else
                {
                    return null;
                }
            }
        }
        public VAopDealer GetAopDealersTemp(Hashtable obj)
        {
            using (AopDealerTempDao dao = new AopDealerTempDao())
            {
                DataTable dt = dao.GetAOPDealerTemp(obj).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    VAopDealer yearAopDealer = new VAopDealer();
                    yearAopDealer.DealerDmaId = new Guid(dt.Rows[0]["Dealer_DMA_ID"].ToString());
                    yearAopDealer.ProductLineBumId = new Guid(dt.Rows[0]["ProductLine_BUM_ID"].ToString());
                    yearAopDealer.Year = dt.Rows[0]["Year"].ToString();
                    yearAopDealer.Amount1 = double.Parse(dt.Rows[0]["Amount_1"].ToString());
                    yearAopDealer.Amount2 = double.Parse(dt.Rows[0]["Amount_2"].ToString());
                    yearAopDealer.Amount3 = double.Parse(dt.Rows[0]["Amount_3"].ToString());
                    yearAopDealer.Amount4 = double.Parse(dt.Rows[0]["Amount_4"].ToString());
                    yearAopDealer.Amount5 = double.Parse(dt.Rows[0]["Amount_5"].ToString());
                    yearAopDealer.Amount6 = double.Parse(dt.Rows[0]["Amount_6"].ToString());
                    yearAopDealer.Amount7 = double.Parse(dt.Rows[0]["Amount_7"].ToString());
                    yearAopDealer.Amount8 = double.Parse(dt.Rows[0]["Amount_8"].ToString());
                    yearAopDealer.Amount9 = double.Parse(dt.Rows[0]["Amount_9"].ToString());
                    yearAopDealer.Amount10 = double.Parse(dt.Rows[0]["Amount_10"].ToString());
                    yearAopDealer.Amount11 = double.Parse(dt.Rows[0]["Amount_11"].ToString());
                    yearAopDealer.Amount12 = double.Parse(dt.Rows[0]["Amount_12"].ToString());
                    yearAopDealer.AmountY = double.Parse(dt.Rows[0]["Amount_Y"].ToString());
                    yearAopDealer.RmkBody = dt.Rows[0]["RmkBody"].ToString();

                    yearAopDealer.FormalAmount1 = double.Parse((dt.Rows[0]["FormalAmount_1"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_1"].ToString()));
                    yearAopDealer.FormalAmount2 = double.Parse((dt.Rows[0]["FormalAmount_2"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_2"].ToString()));
                    yearAopDealer.FormalAmount3 = double.Parse((dt.Rows[0]["FormalAmount_3"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_3"].ToString()));
                    yearAopDealer.FormalAmount4 = double.Parse((dt.Rows[0]["FormalAmount_4"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_4"].ToString()));
                    yearAopDealer.FormalAmount5 = double.Parse((dt.Rows[0]["FormalAmount_5"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_5"].ToString()));
                    yearAopDealer.FormalAmount6 = double.Parse((dt.Rows[0]["FormalAmount_6"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_6"].ToString()));
                    yearAopDealer.FormalAmount7 = double.Parse((dt.Rows[0]["FormalAmount_7"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_7"].ToString()));
                    yearAopDealer.FormalAmount8 = double.Parse((dt.Rows[0]["FormalAmount_8"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_8"].ToString()));
                    yearAopDealer.FormalAmount9 = double.Parse((dt.Rows[0]["FormalAmount_9"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_9"].ToString()));
                    yearAopDealer.FormalAmount10 = double.Parse((dt.Rows[0]["FormalAmount_10"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_10"].ToString()));
                    yearAopDealer.FormalAmount11 = double.Parse((dt.Rows[0]["FormalAmount_11"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_11"].ToString()));
                    yearAopDealer.FormalAmount12 = double.Parse((dt.Rows[0]["FormalAmount_12"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_12"].ToString()));

                    yearAopDealer.ReAmount1 = double.Parse((dt.Rows[0]["Re_Amount1"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount1"].ToString()));
                    yearAopDealer.ReAmount2 = double.Parse((dt.Rows[0]["Re_Amount2"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount2"].ToString()));
                    yearAopDealer.ReAmount3 = double.Parse((dt.Rows[0]["Re_Amount3"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount3"].ToString()));
                    yearAopDealer.ReAmount4 = double.Parse((dt.Rows[0]["Re_Amount4"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount4"].ToString()));
                    yearAopDealer.ReAmount5 = double.Parse((dt.Rows[0]["Re_Amount5"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount5"].ToString()));
                    yearAopDealer.ReAmount6 = double.Parse((dt.Rows[0]["Re_Amount6"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount6"].ToString()));
                    yearAopDealer.ReAmount7 = double.Parse((dt.Rows[0]["Re_Amount7"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount7"].ToString()));
                    yearAopDealer.ReAmount8 = double.Parse((dt.Rows[0]["Re_Amount8"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount8"].ToString()));
                    yearAopDealer.ReAmount9 = double.Parse((dt.Rows[0]["Re_Amount9"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount9"].ToString()));
                    yearAopDealer.ReAmount10 = double.Parse((dt.Rows[0]["Re_Amount10"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount10"].ToString()));
                    yearAopDealer.ReAmount11 = double.Parse((dt.Rows[0]["Re_Amount11"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount11"].ToString()));
                    yearAopDealer.ReAmount12 = double.Parse((dt.Rows[0]["Re_Amount12"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount12"].ToString()));

                    if (!dt.Rows[0]["RmkId"].ToString().Equals(""))
                    {
                        yearAopDealer.RmkId = new Guid(dt.Rows[0]["RmkId"].ToString());
                    }
                    return yearAopDealer;
                }
                else
                {
                    return null;
                }
            }
        }
        public VAopDealer GetAopDealersByHosTemp(Hashtable obj)
        {
            using (AopDealerTempDao dao = new AopDealerTempDao())
            {
                DataTable dt = dao.GetAopDealersByHosTemp(obj).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    VAopDealer yearAopDealer = new VAopDealer();
                    yearAopDealer.DealerDmaId = new Guid(dt.Rows[0]["Dealer_DMA_ID"].ToString());
                    yearAopDealer.ProductLineBumId = new Guid(dt.Rows[0]["ProductLine_BUM_ID"].ToString());
                    yearAopDealer.Year = dt.Rows[0]["Year"].ToString();
                    yearAopDealer.Amount1 = double.Parse(dt.Rows[0]["Amount_1"].ToString());
                    yearAopDealer.Amount2 = double.Parse(dt.Rows[0]["Amount_2"].ToString());
                    yearAopDealer.Amount3 = double.Parse(dt.Rows[0]["Amount_3"].ToString());
                    yearAopDealer.Amount4 = double.Parse(dt.Rows[0]["Amount_4"].ToString());
                    yearAopDealer.Amount5 = double.Parse(dt.Rows[0]["Amount_5"].ToString());
                    yearAopDealer.Amount6 = double.Parse(dt.Rows[0]["Amount_6"].ToString());
                    yearAopDealer.Amount7 = double.Parse(dt.Rows[0]["Amount_7"].ToString());
                    yearAopDealer.Amount8 = double.Parse(dt.Rows[0]["Amount_8"].ToString());
                    yearAopDealer.Amount9 = double.Parse(dt.Rows[0]["Amount_9"].ToString());
                    yearAopDealer.Amount10 = double.Parse(dt.Rows[0]["Amount_10"].ToString());
                    yearAopDealer.Amount11 = double.Parse(dt.Rows[0]["Amount_11"].ToString());
                    yearAopDealer.Amount12 = double.Parse(dt.Rows[0]["Amount_12"].ToString());
                    yearAopDealer.AmountY = double.Parse(dt.Rows[0]["Amount_Y"].ToString());
                    yearAopDealer.RmkBody = dt.Rows[0]["RmkBody"].ToString();

                    yearAopDealer.FormalAmount1 = double.Parse((dt.Rows[0]["FormalAmount_1"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_1"].ToString()));
                    yearAopDealer.FormalAmount2 = double.Parse((dt.Rows[0]["FormalAmount_2"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_2"].ToString()));
                    yearAopDealer.FormalAmount3 = double.Parse((dt.Rows[0]["FormalAmount_3"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_3"].ToString()));
                    yearAopDealer.FormalAmount4 = double.Parse((dt.Rows[0]["FormalAmount_4"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_4"].ToString()));
                    yearAopDealer.FormalAmount5 = double.Parse((dt.Rows[0]["FormalAmount_5"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_5"].ToString()));
                    yearAopDealer.FormalAmount6 = double.Parse((dt.Rows[0]["FormalAmount_6"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_6"].ToString()));
                    yearAopDealer.FormalAmount7 = double.Parse((dt.Rows[0]["FormalAmount_7"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_7"].ToString()));
                    yearAopDealer.FormalAmount8 = double.Parse((dt.Rows[0]["FormalAmount_8"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_8"].ToString()));
                    yearAopDealer.FormalAmount9 = double.Parse((dt.Rows[0]["FormalAmount_9"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_9"].ToString()));
                    yearAopDealer.FormalAmount10 = double.Parse((dt.Rows[0]["FormalAmount_10"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_10"].ToString()));
                    yearAopDealer.FormalAmount11 = double.Parse((dt.Rows[0]["FormalAmount_11"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_11"].ToString()));
                    yearAopDealer.FormalAmount12 = double.Parse((dt.Rows[0]["FormalAmount_12"].ToString().Equals("") ? "0" : dt.Rows[0]["FormalAmount_12"].ToString()));

                    yearAopDealer.ReAmount1 = double.Parse((dt.Rows[0]["Re_Amount1"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount1"].ToString()));
                    yearAopDealer.ReAmount2 = double.Parse((dt.Rows[0]["Re_Amount2"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount2"].ToString()));
                    yearAopDealer.ReAmount3 = double.Parse((dt.Rows[0]["Re_Amount3"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount3"].ToString()));
                    yearAopDealer.ReAmount4 = double.Parse((dt.Rows[0]["Re_Amount4"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount4"].ToString()));
                    yearAopDealer.ReAmount5 = double.Parse((dt.Rows[0]["Re_Amount5"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount5"].ToString()));
                    yearAopDealer.ReAmount6 = double.Parse((dt.Rows[0]["Re_Amount6"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount6"].ToString()));
                    yearAopDealer.ReAmount7 = double.Parse((dt.Rows[0]["Re_Amount7"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount7"].ToString()));
                    yearAopDealer.ReAmount8 = double.Parse((dt.Rows[0]["Re_Amount8"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount8"].ToString()));
                    yearAopDealer.ReAmount9 = double.Parse((dt.Rows[0]["Re_Amount9"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount9"].ToString()));
                    yearAopDealer.ReAmount10 = double.Parse((dt.Rows[0]["Re_Amount10"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount10"].ToString()));
                    yearAopDealer.ReAmount11 = double.Parse((dt.Rows[0]["Re_Amount11"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount11"].ToString()));
                    yearAopDealer.ReAmount12 = double.Parse((dt.Rows[0]["Re_Amount12"].ToString().Equals("") ? "0" : dt.Rows[0]["Re_Amount12"].ToString()));

                    if (!dt.Rows[0]["RmkId"].ToString().Equals(""))
                    {
                        yearAopDealer.RmkId = new Guid(dt.Rows[0]["RmkId"].ToString());
                    }
                    return yearAopDealer;
                }
                else
                {
                    return null;
                }
            }
        }
        public DataSet GetAopDealersByHosTempQuery(Hashtable obj)
        {
            using (AopDealerTempDao dao = new AopDealerTempDao())
            {
                DataSet ds = dao.GetAopDealersByHosTemp(obj);
                return ds;
            }
        }


        public bool SaveAopDealers(Guid ContractId, VAopDealer aopDealers)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                using (AopDealerTempDao dao = new AopDealerTempDao())
                {


                    Hashtable obj = new Hashtable();
                    obj.Add("ContractId", ContractId);
                    obj.Add("DealerDmaId", aopDealers.DealerDmaId);
                    obj.Add("ProductLineBumId", aopDealers.ProductLineBumId);
                    obj.Add("Year", aopDealers.Year);
                    int cnt = dao.Delete(obj);

                    dao.Insert(this.getAopDealerFromVAopDealer(ContractId, aopDealers, "01", aopDealers.Amount1));
                    dao.Insert(this.getAopDealerFromVAopDealer(ContractId, aopDealers, "02", aopDealers.Amount2));
                    dao.Insert(this.getAopDealerFromVAopDealer(ContractId, aopDealers, "03", aopDealers.Amount3));
                    dao.Insert(this.getAopDealerFromVAopDealer(ContractId, aopDealers, "04", aopDealers.Amount4));
                    dao.Insert(this.getAopDealerFromVAopDealer(ContractId, aopDealers, "05", aopDealers.Amount5));
                    dao.Insert(this.getAopDealerFromVAopDealer(ContractId, aopDealers, "06", aopDealers.Amount6));
                    dao.Insert(this.getAopDealerFromVAopDealer(ContractId, aopDealers, "07", aopDealers.Amount7));
                    dao.Insert(this.getAopDealerFromVAopDealer(ContractId, aopDealers, "08", aopDealers.Amount8));
                    dao.Insert(this.getAopDealerFromVAopDealer(ContractId, aopDealers, "09", aopDealers.Amount9));
                    dao.Insert(this.getAopDealerFromVAopDealer(ContractId, aopDealers, "10", aopDealers.Amount10));
                    dao.Insert(this.getAopDealerFromVAopDealer(ContractId, aopDealers, "11", aopDealers.Amount11));
                    dao.Insert(this.getAopDealerFromVAopDealer(ContractId, aopDealers, "12", aopDealers.Amount12));

                }
                trans.Complete();
                result = true;
            }

            return result;
        }

        private AopDealerTemp getAopDealerFromVAopDealer(Guid ContractId, VAopDealer aopDealers, string month, double amount)
        {
            AopDealerTemp aopDealer = new AopDealerTemp();
            aopDealer.AopdContractId = ContractId;
            aopDealer.AopdId = Guid.NewGuid();
            aopDealer.AopdDealerDmaId = aopDealers.DealerDmaId;
            aopDealer.AopdProductLineBumId = aopDealers.ProductLineBumId;
            aopDealer.AopdMarketType = aopDealers.MarketType;
            aopDealer.AopdYear = aopDealers.Year;
            aopDealer.AopdMonth = month;
            aopDealer.AopdAmount = amount;
            //aopDealer.AopdUpdateUserId = new Guid(this._context.User.Id);
            aopDealer.AopdUpdateUserId = Guid.Empty;
            aopDealer.AopdUpdateDate = DateTime.Now;
            return aopDealer;
        }

        public bool RemoveAopDealers(Guid ContractId, Guid dmaId, Guid prodLineId, string year)
        {
            bool result = false;
            using (AopDealerTempDao dao = new AopDealerTempDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", ContractId);
                obj.Add("DealerDmaId", dmaId);
                obj.Add("ProductLineBumId", prodLineId);
                obj.Add("Year", year);
                int cnt = dao.Delete(obj);
                if (cnt >= 0) result = true;
            }

            return result;
        }

        public DataSet GetAopDealersByQuery(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (AopDealerTempDao dao = new AopDealerTempDao())
            {
                return dao.GetYearAOPAll(obj, start, limit, out totalCount);
            }
        }
        public DataSet GetAopDealersByQuery(Hashtable obj)
        {
            using (AopDealerTempDao dao = new AopDealerTempDao())
            {
                return dao.GetYearAOPAll(obj);
            }
        }

        public DataSet GetAopDealerUnionHospitalQuery(Guid ContractId, Guid? dmaId, Guid? prodLineId, string year)
        {
            using (AopDealerTempDao dao = new AopDealerTempDao())
            {
                Hashtable obj = new Hashtable();
                if (ContractId != null) obj.Add("ContractId", ContractId);
                if (dmaId != null) obj.Add("DealerDmaId", dmaId.Value);
                if (prodLineId != null) obj.Add("ProductLineBumId", prodLineId.Value);
                if (!string.IsNullOrEmpty(year)) obj.Add("Year", year);
                return dao.GetAopDealerUnionHospitalQuery(obj);
            }
        }

        public DataSet GetAopDealerUnionHospitalHistoryQuery(Guid ContractId, Guid? dmaId, Guid? prodLineId, string year)
        {
            using (AopDealerTempDao dao = new AopDealerTempDao())
            {
                Hashtable obj = new Hashtable();
                if (ContractId != null) obj.Add("ContractId", ContractId);
                if (dmaId != null) obj.Add("DealerDmaId", dmaId.Value);
                if (prodLineId != null) obj.Add("ProductLineBumId", prodLineId.Value);
                if (!string.IsNullOrEmpty(year)) obj.Add("Year", year);
                return dao.GetAopDealerUnionHospitalHistoryQuery(obj);
            }
        }

        public DataSet ExportAopDealersByQuery(Hashtable obj)
        {
            BaseService.AddCommonFilterCondition(obj);
            using (AopDealerTempDao dao = new AopDealerTempDao())
            {
                return dao.ExportDealerAOP(obj);
            }
        }

        public DataSet GetAopDealersByQueryByContractId(Guid ContractId)
        {
            using (AopDealerTempDao dao = new AopDealerTempDao())
            {
                Hashtable obj = new Hashtable();
                BaseService.AddCommonFilterCondition(obj);
                if (ContractId != null) obj.Add("ContractId", ContractId);
                return dao.GetAopDealersByQueryByContractId(obj);
            }
        }

        public void SynchronousFormalDealerAOPTemp(Hashtable obj)
        {
            using (AopDealerTempDao dao = new AopDealerTempDao())
            {
                dao.SynchronousFormalDealerAOPTemp(obj);
            }
        }

        public DataSet GetAopDealerContrastLastYear(Guid ContractId)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (AopDealerTempDao dao = new AopDealerTempDao())
            {
                return dao.GetAopDealerContrastLastYear(ContractId, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
            }
        }

        public DataSet GetAopDealersHospitalByQuery(Guid ContractId, Guid? dmaId, Guid?[] prodLineId, string[] year, int start, int limit, out int totalCount)
        {
            using (AopDealerHospitalTempDao dao = new AopDealerHospitalTempDao())
            {
                Hashtable obj = new Hashtable();
                if (ContractId != null) obj.Add("ContractId", ContractId);
                if (dmaId != null) obj.Add("DealerDmaId", dmaId.Value);
                obj.Add("ProductLineBumId", prodLineId);
                obj.Add("year", year);
                return dao.GetHospitalYearAOPAll(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetAopDealersHospitalByQuery2(Guid ContractId, Guid? dmaId, Guid?[] prodLineId, string[] year, int start, int limit, out int totalCount)
        {
            using (AopDealerHospitalTempDao dao = new AopDealerHospitalTempDao())
            {
                Hashtable obj = new Hashtable();
                if (ContractId != null) obj.Add("ContractId", ContractId);
                if (dmaId != null) obj.Add("DealerDmaId", dmaId.Value);
                obj.Add("ProductLineBumId", prodLineId);
                obj.Add("year", year);
                return dao.GetAopDealersHospitalByQuery2(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetAopDealersHospitalTempByQuery(Hashtable obj)
        {
            using (AopDealerHospitalTempDao dao = new AopDealerHospitalTempDao())
            {
                return dao.GetAopDealersHospitalTempByQuery(obj);
            }
        }

        public DataSet GetAopDealersHospitalByQueryByContractId(Guid ContractId, int start, int limit, out int totalCount)
        {
            using (AopDealerHospitalTempDao dao = new AopDealerHospitalTempDao())
            {
                Hashtable obj = new Hashtable();
                if (ContractId != null) obj.Add("ContractId", ContractId);

                return dao.GetAopDealersHospitalByQueryByContractId(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetAopDealersHospitalByQueryByContractId(Guid ContractId)
        {
            using (AopDealerHospitalTempDao dao = new AopDealerHospitalTempDao())
            {
                Hashtable obj = new Hashtable();
                if (ContractId != null) obj.Add("ContractId", ContractId);

                return dao.GetAopDealersHospitalByQueryByContractId(obj);
            }
        }

        public DataSet ExportAopDealersHospitalByQuery(Hashtable obj)
        {
            using (AopDealerHospitalTempDao dao = new AopDealerHospitalTempDao())
            {
                return dao.ExportAopDealersHospitalByQuery(obj);
            }
        }


        public VAopDealer GetYearAopHospital(Guid ContractId, Guid dmaId, Guid?[] prodLineId, string[] year, Guid hospitalId)
        {
            using (AopDealerHospitalTempDao dao = new AopDealerHospitalTempDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", ContractId);
                obj.Add("DealerDmaId", dmaId);
                obj.Add("ProductLineBumId", prodLineId);
                obj.Add("year", year);
                obj.Add("HospitalId", hospitalId);
                DataTable dt = dao.GetYearAOPHospitalAll(obj).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    VAopDealer yearAopDealer = new VAopDealer();
                    yearAopDealer.DealerDmaId = new Guid(dt.Rows[0]["Dealer_DMA_ID"].ToString());
                    yearAopDealer.ProductLineBumId = new Guid(dt.Rows[0]["ProductLine_BUM_ID"].ToString());
                    yearAopDealer.Year = dt.Rows[0]["Year"].ToString();
                    yearAopDealer.Amount1 = double.Parse(dt.Rows[0]["Amount_1"].ToString());
                    yearAopDealer.Amount2 = double.Parse(dt.Rows[0]["Amount_2"].ToString());
                    yearAopDealer.Amount3 = double.Parse(dt.Rows[0]["Amount_3"].ToString());
                    yearAopDealer.Amount4 = double.Parse(dt.Rows[0]["Amount_4"].ToString());
                    yearAopDealer.Amount5 = double.Parse(dt.Rows[0]["Amount_5"].ToString());
                    yearAopDealer.Amount6 = double.Parse(dt.Rows[0]["Amount_6"].ToString());
                    yearAopDealer.Amount7 = double.Parse(dt.Rows[0]["Amount_7"].ToString());
                    yearAopDealer.Amount8 = double.Parse(dt.Rows[0]["Amount_8"].ToString());
                    yearAopDealer.Amount9 = double.Parse(dt.Rows[0]["Amount_9"].ToString());
                    yearAopDealer.Amount10 = double.Parse(dt.Rows[0]["Amount_10"].ToString());
                    yearAopDealer.Amount11 = double.Parse(dt.Rows[0]["Amount_11"].ToString());
                    yearAopDealer.Amount12 = double.Parse(dt.Rows[0]["Amount_12"].ToString());
                    yearAopDealer.AmountY = double.Parse(dt.Rows[0]["Amount_Y"].ToString());

                    yearAopDealer.ReAmount1 = double.Parse(dt.Rows[0]["re_Amount_1"].ToString());
                    yearAopDealer.ReAmount2 = double.Parse(dt.Rows[0]["re_Amount_2"].ToString());
                    yearAopDealer.ReAmount3 = double.Parse(dt.Rows[0]["re_Amount_3"].ToString());
                    yearAopDealer.ReAmount4 = double.Parse(dt.Rows[0]["re_Amount_4"].ToString());
                    yearAopDealer.ReAmount5 = double.Parse(dt.Rows[0]["re_Amount_5"].ToString());
                    yearAopDealer.ReAmount6 = double.Parse(dt.Rows[0]["re_Amount_6"].ToString());
                    yearAopDealer.ReAmount7 = double.Parse(dt.Rows[0]["re_Amount_7"].ToString());
                    yearAopDealer.ReAmount8 = double.Parse(dt.Rows[0]["re_Amount_8"].ToString());
                    yearAopDealer.ReAmount9 = double.Parse(dt.Rows[0]["re_Amount_9"].ToString());
                    yearAopDealer.ReAmount10 = double.Parse(dt.Rows[0]["re_Amount_10"].ToString());
                    yearAopDealer.ReAmount11 = double.Parse(dt.Rows[0]["re_Amount_11"].ToString());
                    yearAopDealer.ReAmount12 = double.Parse(dt.Rows[0]["re_Amount_12"].ToString());

                    yearAopDealer.RmkBody = dt.Rows[0]["Rmk_Body"].ToString();

                    return yearAopDealer;
                }
                else
                {
                    return null;
                }
            }
        }

        public DataSet GetFormalAopDealer(Hashtable obj)
        {
            using (AopDealerTempDao dao = new AopDealerTempDao())
            {
                return dao.GetFormalAopDealer(obj);
            }
        }
        public DataSet GetFormalAopDealer(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (AopDealerTempDao dao = new AopDealerTempDao())
            {
                return dao.GetFormalAopDealer(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetHistoryAopDealer(AopDealerHistory obj)
        {
            using (AopDealerHistoryDao dao = new AopDealerHistoryDao())
            {
                return dao.GetHistoryAopDealer(obj);
            }
        }
        public DataSet GetHistoryAopDealer(AopDealerHistory obj, int start, int limit, out int totalCount)
        {
            using (AopDealerHistoryDao dao = new AopDealerHistoryDao())
            {
                return dao.GetHistoryAopDealer(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetHistoryAopDealer(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet returnds = new DataSet();
            AopDealerHistory objhis = new AopDealerHistory();
            objhis.ChangeToContractid = new Guid(obj["ContractId"].ToString());
            DataTable hsHisDate = this.GetHistoryAopDealer(objhis).Tables[0];

            using (AopDealerHistoryDao dao = new AopDealerHistoryDao())
            {

                if (hsHisDate.Rows.Count > 0)
                {
                    returnds = dao.GetHistoryAopDealer(obj, start, limit, out totalCount);
                }
                else
                {
                    returnds = this.GetFormalAopDealer(obj, start, limit, out totalCount);
                }

                return returnds;
            }
        }


        public bool SaveAopHospital(Guid ContractId, Guid HospitalId, string Month, VAopDealer aopDealers)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                using (AopDealerHospitalTempDao dao = new AopDealerHospitalTempDao())
                {


                    Hashtable obj = new Hashtable();
                    obj.Add("ContractId", ContractId);
                    obj.Add("DealerDmaId", aopDealers.DealerDmaId);
                    obj.Add("ProductLineBumId", aopDealers.ProductLineBumId);
                    obj.Add("Year", aopDealers.Year);
                    obj.Add("HospitalId", HospitalId);
                    int cnt = dao.Delete(obj);

                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, HospitalId, aopDealers, "01", aopDealers.Amount1));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, HospitalId, aopDealers, "02", aopDealers.Amount2));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, HospitalId, aopDealers, "03", aopDealers.Amount3));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, HospitalId, aopDealers, "04", aopDealers.Amount4));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, HospitalId, aopDealers, "05", aopDealers.Amount5));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, HospitalId, aopDealers, "06", aopDealers.Amount6));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, HospitalId, aopDealers, "07", aopDealers.Amount7));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, HospitalId, aopDealers, "08", aopDealers.Amount8));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, HospitalId, aopDealers, "09", aopDealers.Amount9));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, HospitalId, aopDealers, "10", aopDealers.Amount10));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, HospitalId, aopDealers, "11", aopDealers.Amount11));
                    dao.Insert(this.getAopDealerFromVAopHospital(ContractId, HospitalId, aopDealers, "12", aopDealers.Amount12));

                }
                //根据医院指标维护经销商指标
                using (AopDealerTempDao dao = new AopDealerTempDao())
                {
                    Hashtable objDealer = new Hashtable();
                    objDealer.Add("ContractId", ContractId);
                    objDealer.Add("DealerDmaId", aopDealers.DealerDmaId);
                    objDealer.Add("ProductLineBumId", aopDealers.ProductLineBumId);
                    objDealer.Add("MarketType", aopDealers.MarketType);
                    objDealer.Add("Year", aopDealers.Year);
                    objDealer.Add("MinMonth", Month);
                    int cnt = dao.Delete(objDealer);
                    //同步指标
                    dao.InsertSynchronousHospitalAOP(objDealer);
                }

                trans.Complete();
                result = true;
            }

            return result;
        }

        private AopDealerHospitalTemp getAopDealerFromVAopHospital(Guid ContractId, Guid HospitalId, VAopDealer aopDealers, string month, double amount)
        {
            AopDealerHospitalTemp aopHospital = new AopDealerHospitalTemp();
            aopHospital.ContractId = ContractId;
            aopHospital.Id = Guid.NewGuid();
            aopHospital.DealerDmaId = aopDealers.DealerDmaId;
            aopHospital.ProductLineBumId = aopDealers.ProductLineBumId;
            aopHospital.Year = aopDealers.Year;
            aopHospital.Month = month;
            aopHospital.Amount = amount;
            //aopHospital.UpdateUserId = new Guid(this._context.User.Id);
            aopHospital.UpdateUserId = Guid.Empty;
            aopHospital.UpdateDate = DateTime.Now;
            aopHospital.HospitalId = HospitalId;
            return aopHospital;
        }

        public DataSet GetFormalAopHospital(Hashtable obj)
        {
            using (AopDealerHospitalTempDao dao = new AopDealerHospitalTempDao())
            {
                return dao.GetFormalAopHospital(obj);
            }
        }
        public DataSet GetFormalAopHospital(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (AopDealerHospitalTempDao dao = new AopDealerHospitalTempDao())
            {
                return dao.GetFormalAopHospital(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetHistoryAopHospital(AopDealerHospitaHistory obj, int start, int limit, out int totalCount)
        {
            using (AopDealerHospitaHistoryDao dao = new AopDealerHospitaHistoryDao())
            {
                return dao.GetHistoryAopHospital(obj, start, limit, out totalCount);
            }
        }
        public DataSet GetHistoryAopHospital(AopDealerHospitaHistory obj)
        {
            using (AopDealerHospitaHistoryDao dao = new AopDealerHospitaHistoryDao())
            {
                return dao.GetHistoryAopHospital(obj);
            }
        }

        public void SynchronousFormalDealerHospiatlAOPTemp(Guid ContractId, Hashtable obj)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (AopDealerHospitalTempDao dao = new AopDealerHospitalTempDao())
                {
                    Hashtable check = new Hashtable();
                    check.Add("ContractId", ContractId);

                    if (dao.GetAopDealersHospitalByQueryByContractId(check).Tables[0].Rows.Count == 0)
                    {
                        dao.SynchronousFormalDealerHospitalAOPTemp(obj);

                        using (AopDealerTempDao daoDealer = new AopDealerTempDao())
                        {
                            Hashtable objDealer = new Hashtable();
                            objDealer.Add("ContractId", ContractId);
                            objDealer.Add("DealerDmaId", obj["Dma_Id"].ToString());
                            objDealer.Add("ProductLineBumId", obj["Plb_Id"].ToString());
                            objDealer.Add("IsEmerging", obj["IsEmerging"].ToString());
                            int cnt = dao.Delete(objDealer);
                            //同步指标
                            //daoDealer.InsertSynchronousHospitalAOP(objDealer);
                            daoDealer.SynchronousFormalDealerAOPTemp(obj);
                        }
                    }
                }
                trans.Complete();
            }
        }

        public void SynchronousFormalDealerHospiatlAOPTemp2(Hashtable obj)
        {
            using (AopDealerHospitalTempDao dao = new AopDealerHospitalTempDao())
            {
                dao.SynchronousFormalDealerHospitalAOPTemp2(obj);
            }
        }

        public void SaveAopRemark(AopRemark ar)
        {
            using (AopRemarkDao dao = new AopRemarkDao())
            {
                dao.Insert(ar);
            }
        }

        public int UpdateAopRemark(AopRemark ar)
        {
            using (AopRemarkDao dao = new AopRemarkDao())
            {
                return dao.Update(ar);
            }
        }

        public int DeleteAopRemark(AopRemark ar)
        {
            using (AopRemarkDao dao = new AopRemarkDao())
            {
                return dao.DeleteAopRemark(ar);
            }
        }
        #endregion

        #region IC 指标设定
        public DataSet GetAopICDealersHospitalByQuery(Guid ContractId, Guid? dmaId, Guid?[] prodLineId, string[] year, int start, int limit, out int totalCount)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                Hashtable obj = new Hashtable();
                if (ContractId != null) obj.Add("ContractId", ContractId);
                if (dmaId != null) obj.Add("DealerDmaId", dmaId.Value);
                obj.Add("ProductLineBumId", prodLineId);
                obj.Add("year", year);
                return dao.GetHospitalYearAOPICAll(obj, start, limit, out totalCount);
            }
        }
        public VAopICDealerHospital GetYearAopHospitalForIC(Guid ContractId, Guid dmaId, Guid?[] prodLineId, string[] year, Guid hospitalId, string classification)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", ContractId);
                obj.Add("DealerDmaId", dmaId);
                obj.Add("ProductLineBumId", prodLineId);
                obj.Add("year", year[0].ToString());
                obj.Add("HospitalId", hospitalId);
                obj.Add("Classification", classification);

                DataTable dt = dao.GetYearAOPHospitalAllForIC(obj).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    VAopICDealerHospital yearAopDealer = new VAopICDealerHospital();
                    yearAopDealer.DmaId = new Guid(dt.Rows[0]["Dealer_DMA_ID"].ToString());
                    yearAopDealer.ProductLineId = new Guid(dt.Rows[0]["ProductLine_BUM_ID"].ToString());
                    yearAopDealer.Year = dt.Rows[0]["Year"].ToString();
                    yearAopDealer.Unit1 = double.Parse(dt.Rows[0]["Unit_1"].ToString());
                    yearAopDealer.Unit2 = double.Parse(dt.Rows[0]["Unit_2"].ToString());
                    yearAopDealer.Unit3 = double.Parse(dt.Rows[0]["Unit_3"].ToString());
                    yearAopDealer.Unit4 = double.Parse(dt.Rows[0]["Unit_4"].ToString());
                    yearAopDealer.Unit5 = double.Parse(dt.Rows[0]["Unit_5"].ToString());
                    yearAopDealer.Unit6 = double.Parse(dt.Rows[0]["Unit_6"].ToString());
                    yearAopDealer.Unit7 = double.Parse(dt.Rows[0]["Unit_7"].ToString());
                    yearAopDealer.Unit8 = double.Parse(dt.Rows[0]["Unit_8"].ToString());
                    yearAopDealer.Unit9 = double.Parse(dt.Rows[0]["Unit_9"].ToString());
                    yearAopDealer.Unit10 = double.Parse(dt.Rows[0]["Unit_10"].ToString());
                    yearAopDealer.Unit11 = double.Parse(dt.Rows[0]["Unit_11"].ToString());
                    yearAopDealer.Unit12 = double.Parse(dt.Rows[0]["Unit_12"].ToString());
                    yearAopDealer.UnitY = double.Parse(dt.Rows[0]["Unit_Y"].ToString());
                    yearAopDealer.FormalUnit_1 = double.Parse(dt.Rows[0]["FormalUnit1"].ToString());
                    yearAopDealer.FormalUnit_2 = double.Parse(dt.Rows[0]["FormalUnit2"].ToString());
                    yearAopDealer.FormalUnit_3 = double.Parse(dt.Rows[0]["FormalUnit3"].ToString());
                    yearAopDealer.FormalUnit_4 = double.Parse(dt.Rows[0]["FormalUnit4"].ToString());
                    yearAopDealer.FormalUnit_5 = double.Parse(dt.Rows[0]["FormalUnit5"].ToString());
                    yearAopDealer.FormalUnit_6 = double.Parse(dt.Rows[0]["FormalUnit6"].ToString());
                    yearAopDealer.FormalUnit_7 = double.Parse(dt.Rows[0]["FormalUnit7"].ToString());
                    yearAopDealer.FormalUnit_8 = double.Parse(dt.Rows[0]["FormalUnit8"].ToString());
                    yearAopDealer.FormalUnit_9 = double.Parse(dt.Rows[0]["FormalUnit9"].ToString());
                    yearAopDealer.FormalUnit_10 = double.Parse(dt.Rows[0]["FormalUnit10"].ToString());
                    yearAopDealer.FormalUnit_11 = double.Parse(dt.Rows[0]["FormalUnit11"].ToString());
                    yearAopDealer.FormalUnit_12 = double.Parse(dt.Rows[0]["FormalUnit12"].ToString());

                    yearAopDealer.ReferenceUnit_1 = double.Parse(dt.Rows[0]["re_Unit_1"].ToString());
                    yearAopDealer.ReferenceUnit_2 = double.Parse(dt.Rows[0]["re_Unit_2"].ToString());
                    yearAopDealer.ReferenceUnit_3 = double.Parse(dt.Rows[0]["re_Unit_3"].ToString());
                    yearAopDealer.ReferenceUnit_4 = double.Parse(dt.Rows[0]["re_Unit_4"].ToString());
                    yearAopDealer.ReferenceUnit_5 = double.Parse(dt.Rows[0]["re_Unit_5"].ToString());
                    yearAopDealer.ReferenceUnit_6 = double.Parse(dt.Rows[0]["re_Unit_6"].ToString());
                    yearAopDealer.ReferenceUnit_7 = double.Parse(dt.Rows[0]["re_Unit_7"].ToString());
                    yearAopDealer.ReferenceUnit_8 = double.Parse(dt.Rows[0]["re_Unit_8"].ToString());
                    yearAopDealer.ReferenceUnit_9 = double.Parse(dt.Rows[0]["re_Unit_9"].ToString());
                    yearAopDealer.ReferenceUnit_10 = double.Parse(dt.Rows[0]["re_Unit_10"].ToString());
                    yearAopDealer.ReferenceUnit_11 = double.Parse(dt.Rows[0]["re_Unit_11"].ToString());
                    yearAopDealer.ReferenceUnit_12 = double.Parse(dt.Rows[0]["re_Unit_12"].ToString());

                    yearAopDealer.Remark = dt.Rows[0]["RmkBody"].ToString();
                    return yearAopDealer;
                }
                else
                {
                    return null;
                }
            }
        }
        public bool SaveAopHospitalForIC(Guid ContractId, VAopICDealerHospital aopDealers)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
                {


                    Hashtable obj = new Hashtable();
                    obj.Add("ContractId", ContractId);
                    obj.Add("DealerDmaId", aopDealers.DmaId);
                    obj.Add("ProductLineBumId", aopDealers.ProductLineId);
                    obj.Add("Year", aopDealers.Year);
                    obj.Add("HospitalId", aopDealers.HospitalId);
                    obj.Add("Classification", aopDealers.PctId);
                    int cnt = dao.Delete(obj);

                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "01", aopDealers.Unit1));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "02", aopDealers.Unit2));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "03", aopDealers.Unit3));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "04", aopDealers.Unit4));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "05", aopDealers.Unit5));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "06", aopDealers.Unit6));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "07", aopDealers.Unit7));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "08", aopDealers.Unit8));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "09", aopDealers.Unit9));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "10", aopDealers.Unit10));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "11", aopDealers.Unit11));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "12", aopDealers.Unit12));

                    //更新经销商指标列表
                    using (AopDealerTempDao daoDealer = new AopDealerTempDao())
                    {
                        Hashtable objDealer = new Hashtable();
                        objDealer.Add("ContractId", ContractId);
                        objDealer.Add("DealerDmaId", aopDealers.DmaId);
                        objDealer.Add("ProductLineBumId", aopDealers.ProductLineId);
                        objDealer.Add("MarketType", aopDealers.MarketType);
                        objDealer.Add("Year", aopDealers.Year);
                        daoDealer.Delete(objDealer);

                        daoDealer.InsertFromICDate(objDealer);
                    }


                }
                trans.Complete();
                result = true;
            }

            return result;
        }

        public bool SaveAopHospitalForICByAmendment(Guid ContractId, VAopICDealerHospital aopDealers, int month)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
                {


                    Hashtable obj = new Hashtable();
                    obj.Add("ContractId", ContractId);
                    obj.Add("DealerDmaId", aopDealers.DmaId);
                    obj.Add("ProductLineBumId", aopDealers.ProductLineId);
                    obj.Add("Year", aopDealers.Year);
                    obj.Add("HospitalId", aopDealers.HospitalId);
                    obj.Add("Classification", aopDealers.PctId);
                    int cnt = dao.Delete(obj);

                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "01", aopDealers.Unit1));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "02", aopDealers.Unit2));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "03", aopDealers.Unit3));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "04", aopDealers.Unit4));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "05", aopDealers.Unit5));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "06", aopDealers.Unit6));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "07", aopDealers.Unit7));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "08", aopDealers.Unit8));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "09", aopDealers.Unit9));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "10", aopDealers.Unit10));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "11", aopDealers.Unit11));
                    dao.Insert(this.getAopDealerFromVAopHospitalForIC(ContractId, aopDealers, "12", aopDealers.Unit12));

                    //更新经销商指标列表
                    using (AopDealerTempDao daoDealer = new AopDealerTempDao())
                    {
                        Hashtable objDealer = new Hashtable();
                        objDealer.Add("ContractId", ContractId);
                        objDealer.Add("DealerDmaId", aopDealers.DmaId);
                        objDealer.Add("ProductLineBumId", aopDealers.ProductLineId);
                        objDealer.Add("Year", aopDealers.Year);
                        objDealer.Add("MarketType", aopDealers.MarketType);
                        objDealer.Add("MinMonth", month);
                        daoDealer.Delete(objDealer);

                        daoDealer.InsertAopDealerTempByHospitalProduct(objDealer);
                    }


                }
                trans.Complete();
                result = true;
            }

            return result;
        }

        private AopicDealerHospitalTemp getAopDealerFromVAopHospitalForIC(Guid ContractId, VAopICDealerHospital aopDealers, string month, double? number)
        {
            AopicDealerHospitalTemp aopHospital = new AopicDealerHospitalTemp();
            aopHospital.ContractId = ContractId;
            aopHospital.Id = Guid.NewGuid();
            aopHospital.DmaId = aopDealers.DmaId;
            aopHospital.ProductLineId = aopDealers.ProductLineId;
            aopHospital.PctId = aopDealers.PctId;
            aopHospital.HospitalId = aopDealers.HospitalId;
            aopHospital.Year = aopDealers.Year;
            aopHospital.Month = month;
            aopHospital.Unit = number;

            aopHospital.UpdateUserId = Guid.Empty;
            aopHospital.UpdateDate = DateTime.Now;

            return aopHospital;
        }
        public DataSet SetAOPHospitalForICInitialValue(Guid ContractId, Guid? dmaId, Guid?[] prodLineId, string year)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", ContractId);
                obj.Add("DealerDmaId", dmaId.Value);
                obj.Add("ProductLineBumId", prodLineId[0].ToString());
                obj.Add("year", year);
                obj.Add("RtnVal", "");
                obj.Add("RtnMsg", "");
                return dao.SetAOPHospitalForICInitialValue(obj);
            }

        }
        public DataSet GetICAopHospitalByContractId(Guid ContractId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", ContractId);
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.GetICAopHospitalByContractId(obj);
            }
        }
        public DataSet GetICAopDealersHospitalByQuery(Guid ContractId, int start, int limit, out int totalCount)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", ContractId);
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.GetICAopDealersHospitalByQuery(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetICAopDealersHospitalUnitByQuery(Guid ContractId, int start, int limit, out int totalCount)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", ContractId);
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.GetICAopDealersHospitalUnitByQuery(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetAopProductHospitalAmount(Hashtable obj)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.GetAopProductHospitalAmount(obj);
            }
        }

        public DataSet QueryHospitalProduct(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.QueryHospitalProduct(obj, start, limit, out totalCount);
            }
        }

        public DataSet QueryHospitalProduct(Hashtable obj)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.QueryHospitalProduct(obj);
            }
        }

        public DataSet QueryHospitalProductAOP(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.QueryHospitalProductAOP(obj, start, limit, out totalCount);
            }
        }

        public DataSet QueryHospitalProductAOP(Hashtable obj)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.QueryHospitalProductAOP(obj);
            }
        }

        public DataSet QueryHospitalProductAOPAmendment(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.QueryHospitalProductAOPAmendment(obj, start, limit, out totalCount);
            }
        }

        public DataSet QueryHospitalProductAOPAmendment(Hashtable obj)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.QueryHospitalProductAOPAmendment(obj);
            }
        }

        public DataSet ExportHospitalProductAOP(Hashtable obj)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.ExportHospitalProductAOP(obj);
            }
        }

        public DataSet QueryHospitalProductByDealerTotleAOP(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.QueryHospitalProductByDealerTotleAOP(obj, start, limit, out totalCount);
            }
        }

        public DataSet QueryHospitalProductByDealerTotleAOP(Hashtable obj)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.QueryHospitalProductByDealerTotleAOP(obj);
            }
        }

        public DataSet QueryHospitalProductByDealerTotleAOP2(Hashtable obj)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.QueryHospitalProductByDealerTotleAOP2(obj);
            }
        }

        public DataSet GetHospitalProductMapping(Hashtable obj)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.GetHospitalProductMapping(obj);
            }
        }

        //GetHospitalProductByProductLineId 不在使用 
        public IList<IcProductStandardPrice> GetHospitalProductByProductLineId(Hashtable obj)
        {
            using (IcProductStandardPriceDao dao = new IcProductStandardPriceDao())
            {
                return dao.GetHospitalProductByProductLineId(obj);
            }
        }

        public IList<ProductClassification> GetProductClassificationByProductLineId(Hashtable obj)
        {
            using (ProductClassificationDao dao = new ProductClassificationDao())
            {
                return dao.GetProductClassificationByProductLineId(obj);
            }
        }

        public DataSet GetContractProductClassification(Hashtable obj)
        {
            using (ProductClassificationDao dao = new ProductClassificationDao())
            {
                return dao.GetContractProductClassification(obj);
            }
        }

        public DataSet GetContractProductClassificationPrice(Hashtable obj)
        {
            using (ProductClassificationDao dao = new ProductClassificationDao())
            {
                return dao.GetContractProductClassificationPrice(obj);
            }
        }

        public DataSet GetProductClassificationPrice(Hashtable obj)
        {
            using (ProductClassificationDao dao = new ProductClassificationDao())
            {
                return dao.GetProductClassificationPrice(obj);
            }
        }

        public void SubmintDealerHospitalProductMapping(Hashtable obj)
        {
            try
            {
                using (ProductClassificationDao dao = new ProductClassificationDao())
                {
                    dao.DeleteHospitalProductMapping(obj);
                    dao.SubmintDealerHospitalProductMapping(obj);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void SubmintHospitalProductPrice(Hashtable obj)
        {
            try
            {
                using (ProductClassificationDao dao = new ProductClassificationDao())
                {
                    dao.UpdateNullHospitalProductPrice(obj);
                    dao.SubmintHospitalProductPrice(obj);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public DataSet MaintainDealerHospitalProductAOP(Hashtable obj)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.MaintainDealerHospitalProductAOP(obj);
            }
        }

        public DataSet GetFormalAopHospitalProduct(Hashtable obj)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.GetFormalAopHospitalProduct(obj);
            }
        }
        public DataSet GetFormalAopHospitalProduct(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.GetFormalAopHospitalProduct(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetFormalAopHospitalProductUnit(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
            {
                return dao.GetFormalAopHospitalProductUnit(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetHistoryAopHospitalProduct(AopicDealerHospitalHistory obj)
        {
            using (AopicDealerHospitalHistoryDao dao = new AopicDealerHospitalHistoryDao())
            {
                return dao.GetHistoryAopHospitalProduct(obj);
            }
        }

        public DataSet GetHistoryAopHospitalProduct(AopicDealerHospitalHistory obj, int start, int limit, out int totalCount)
        {
            using (AopicDealerHospitalHistoryDao dao = new AopicDealerHospitalHistoryDao())
            {
                return dao.GetHistoryAopHospitalProduct(obj, start, limit, out totalCount);
            }
        }

        public void SynchronousFormalDealerHospiatlProductAOPTemp(Guid ContractId, Hashtable obj)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
                {
                    Hashtable check = new Hashtable();
                    check.Add("ContractId", ContractId);

                    if (dao.GetICAopHospitalByContractId(check).Tables[0].Rows.Count == 0)
                    {
                        dao.SynchronousHospitalProductOrNextMapping(obj);

                        using (AopDealerTempDao daoDealer = new AopDealerTempDao())
                        {
                            Hashtable objDealer = new Hashtable();
                            objDealer.Add("ContractId", ContractId);
                            objDealer.Add("DealerDmaId", obj["Dma_Id"].ToString());
                            objDealer.Add("ProductLineBumId", obj["Plb_Id"].ToString());
                            int cnt = dao.Delete(objDealer);
                            //同步指标
                            //daoDealer.InsertSynchronousHospitalProductAOP(objDealer);
                            daoDealer.SynchronousFormalDealerAOPTemp(obj);
                        }
                    }
                }
                trans.Complete();
            }
        }

        public void SynchronousDealerHospiatlProductMapping(Guid ContractId, Hashtable obj)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (AopicDealerHospitalTempDao dao = new AopicDealerHospitalTempDao())
                {
                    Hashtable check = new Hashtable();
                    check.Add("ContractId", ContractId);

                    if (dao.GetICAopHospitalByContractId(check).Tables[0].Rows.Count == 0)
                    {
                        dao.SynchronousHospitalProductOrNextMapping(obj);
                    }
                }
                trans.Complete();
            }
        }

        public DataSet CheckAuthorProductPrice(Hashtable obj)
        {
            using (ProductClassificationDao dao = new ProductClassificationDao())
            {
                return dao.CheckAuthorProductPrice(obj);
            }
        }
        #endregion

        #region 维护经销商IAF签名
        public void SaveDealerIAFSign(DealeriafSign sign)
        {
            using (DealeriafSignDao dao = new DealeriafSignDao())
            {
                dao.Insert(sign);
            }
        }

        public DealeriafSign GetDealerIAFSign(Guid Cm_Id)
        {
            using (DealeriafSignDao dao = new DealeriafSignDao())
            {
                return dao.GetObject(Cm_Id);
            }
        }

        public int UpdateDealerIAFSign(DealeriafSign sign)
        {
            using (DealeriafSignDao dao = new DealeriafSignDao())
            {
                return dao.Update(sign);
            }
        }

        public int UpdateDealerIAFSignFrom3(DealeriafSign sign)
        {
            using (DealeriafSignDao dao = new DealeriafSignDao())
            {
                return dao.UpdateDealerIAFSignFrom3(sign);
            }
        }

        public int UpdateDealerIAFSignFrom5(DealeriafSign sign)
        {
            using (DealeriafSignDao dao = new DealeriafSignDao())
            {
                return dao.UpdateDealerIAFSignFrom5(sign);
            }
        }

        public int UpdateDealerIAFSignFrom6(DealeriafSign sign)
        {
            using (DealeriafSignDao dao = new DealeriafSignDao())
            {
                return dao.UpdateDealerIAFSignFrom6(sign);
            }
        }

        public int UpdateThirdPartyFrom(DealeriafSign sign)
        {
            using (DealeriafSignDao dao = new DealeriafSignDao())
            {
                return dao.UpdateThirdPartyFrom(sign);
            }
        }
        #endregion

        #region 附件上传后发通知邮件
        public void SendMailByDCMSAnnexNotice(string ContractId, string Type)
        {
            using (AttachmentDao dao = new AttachmentDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", ContractId);
                obj.Add("Type", Type);
                dao.SendMailByDCMSAnnexNotice(obj);
            }
        }
        #endregion

        #region 经销商授权到区域
        public DataSet QueryAuthorizationAreaTempList(Hashtable obj)
        {
            using (DealerAuthorizationAreaTempDao dao = new DealerAuthorizationAreaTempDao())
            {
                return dao.QueryAuthorizationAreaTempList(obj);
            }
        }

        public void SysFormalAuthorizationAreaToTemp(Hashtable obj)
        {
            using (DealerAuthorizationAreaTempDao dao = new DealerAuthorizationAreaTempDao())
            {
                dao.SysFormalAuthorizationAreaToTemp(obj);
            }
        }

        public void ModifyPartsAuthorizationAreaTemp(Hashtable obj)
        {
            using (DealerAuthorizationAreaTempDao dao = new DealerAuthorizationAreaTempDao())
            {
                dao.ModifyPartsAuthorizationAreaTemp(obj);
            }
        }

        public DataSet GetPartsAuthorizedAreaTemp(Hashtable obj)
        {
            using (DealerAuthorizationAreaTempDao dao = new DealerAuthorizationAreaTempDao())
            {
                return dao.QueryPartsAuthorizedAreaTemp(obj);
            }
        }

        public void SubmintAreaTemp(Hashtable obj)
        {
            using (DealerAuthorizationAreaTempDao dao = new DealerAuthorizationAreaTempDao())
            {
                dao.DeleteAreaTemp(obj);
                dao.SubmintAreaTemp(obj);
            }
        }

        public DataSet GetPartAreaExcHospitalTemp(Hashtable obj)
        {
            using (DealerAuthorizationAreaTempDao dao = new DealerAuthorizationAreaTempDao())
            {
                return dao.GetPartAreaExcHospitalTemp(obj);
            }
        }

        /// <summary>
        ///删除排除医院 
        /// </summary>
        /// <param name="contractId"></param>
        /// <param name="changes"></param>
        public void RemoveAreaHospitalTemp(string contractId, Guid[] changes)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                DealerAuthorizationAreaTempDao dao = new DealerAuthorizationAreaTempDao();

                foreach (Guid item in changes)
                {
                    dao.RemoveAreaHospitalTemp(contractId, item);
                }
                trans.Complete();
            }
        }

        public DataSet GetProvincesForArea(Hashtable obj)
        {
            using (DealerAuthorizationAreaTempDao dao = new DealerAuthorizationAreaTempDao())
            {
                return dao.GetProvincesForArea(obj);
            }
        }

        public DataSet GetProvincesForAreaSelected(Hashtable obj)
        {
            using (DealerAuthorizationAreaTempDao dao = new DealerAuthorizationAreaTempDao())
            {
                return dao.GetProvincesForAreaSelected(obj);
            }
        }

        public DataSet GetProductForAreaSelected(Hashtable obj)
        {
            using (DealerAuthorizationAreaTempDao dao = new DealerAuthorizationAreaTempDao())
            {
                return dao.GetProductForAreaSelected(obj);
            }
        }

        public DataSet GetProvincesForAreaSelectedOld(Hashtable obj)
        {
            using (DealerAuthorizationAreaTempDao dao = new DealerAuthorizationAreaTempDao())
            {
                DataSet ds = dao.GetProvincesForAreaSelectedOld(obj);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    return ds;
                }
                else
                {
                    return dao.GetProvincesForAreaSelectedFormal(obj);
                }
            }
        }

        public DataSet GetPartAreaExcHospitalOld(Hashtable obj)
        {
            using (DealerAuthorizationAreaTempDao dao = new DealerAuthorizationAreaTempDao())
            {
                DataSet ds = dao.GetPartAreaExcHospitalOld(obj);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    return ds;
                }
                else
                {
                    return dao.GetPartAreaExcHospitalFormal(obj);
                }
            }
        }

        public bool SaveHospitalOfAuthorizationArea(Guid datId, IDictionary<string, string>[] changes, SelectTerritoryType selectType, string hosProvince, string hosCity, string hosDistrict, Guid productLineId, string hosRemark)
        {
            bool result = false;
            if (selectType == SelectTerritoryType.Default)
            {
                if (changes.Length > 0)
                {
                    using (TransactionScope trans = new TransactionScope())
                    {
                        DealerAuthorizationAreaTempDao dao = new DealerAuthorizationAreaTempDao();

                        foreach (Dictionary<string, string> hospital in changes)
                        {
                            dao.AttachHospitalToAuthorizationArea(datId, new Guid(hospital["HosId"]), hosRemark);
                        }

                        trans.Complete();
                    }

                    result = true;
                }
            }
            return result;
        }

        #endregion

        public string GetAmandCurrentJudgeDate()
        {
            string retValue = "";
            using (ContractMasterDao dao = new ContractMasterDao())
            {
                DataTable dtValue = dao.GetAmandCurrentJudgeDate().Tables[0];
                if (dtValue.Rows.Count > 0)
                {
                    retValue = dtValue.Rows[0]["ValueDate"].ToString();
                }
            }
            return retValue;
        }

        #region DCMS Update in 201606

        public string GetContractProperty_Last(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetContractProperty_Last(obj);
            }
        }

        /// <summary>
        /// 临时表维护授权产品
        /// </summary>
        public void AddContractProduct(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                dao.AddContractProduct(obj);
            }
        }

        /// <summary>
        /// 更具条件获取可选产品分类
        /// </summary>
        public DataSet GetAuthorizationProductAll(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetAuthorizationProductAll(obj);
            }
        }

        /// <summary>
        /// 获取临时表中已授权产品
        /// </summary>
        public DataSet GetAuthorizationProductSelected(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetAuthorizationProductSelected(obj);
            }
        }

        public bool DeleteProductSelected(string dctId)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.DeleteProductSelected(dctId);
            }
        }

        public DataSet QueryDcmsHospitalSelecedTemp(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.QueryDcmsHospitalSelecedTemp(obj);
            }
        }

        public void DeleteAuthorizationHospitalTemp(Guid[] changes)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                ContractTerritoryDao dao = new ContractTerritoryDao();

                foreach (Guid item in changes)
                {
                    dao.DeleteAuthorizationHospitalTemp(item);
                }
                trans.Complete();
            }
        }
        public DataSet GetCopyProductCan(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetCopyProductCan(obj);
            }
        }

        public void CopyHospitalTempFromOtherAuth(Hashtable obj)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                ContractTerritoryDao dao = new ContractTerritoryDao();

                dao.CopyHospitalTempFromOtherAuth(obj);

                trans.Complete();
            }
        }

        public DataSet DepartProductTemp(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.DepartProductTemp(obj);
            }
        }

        public DataSet QueryHospitalProductTemp(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.QueryHospitalProductTemp(obj, start, limit, out totalCount);
            }
        }

        public void HospitalDepartClear(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                dao.HospitalDepartClear(obj);
            }
        }

        public int UpdateHospitalDepartmentTemp(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.UpdateHospitalDepartmentTemp(obj);
            }
        }

        public DataSet ExcelHospitalProductTemp(Guid contractId)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.ExcelHospitalProductTemp(contractId);
            }
        }

        public bool DeleteTempUploadHospitalByDatId(string dctId)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.DeleteTempUploadHospitalByDatId(dctId);
            }
        }

        public DataSet QueryHospitalUpload(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.QueryHospitalUpload(obj, start, limit, out totalCount);
            }
        }

        /// <summary>
        /// 批量导入医院
        /// </summary>
        public bool DCMSHospitalTempImport(DataTable dt, string datId)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ContractTerritoryDao dao = new ContractTerritoryDao();
                    int lineNbr = 1;
                    IList<ContractTerritoryInsetTemp> list = new List<ContractTerritoryInsetTemp>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        ContractTerritoryInsetTemp data = new ContractTerritoryInsetTemp();
                        data.DatId = datId;
                        data.HospitalName = null;
                        data.HospitalCode = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        data.Depart = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        data.DepartRemark = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        data.ErrMsg = null;
                        if (lineNbr != 1)
                        {
                            list.Add(data);
                        }
                        lineNbr += 1;
                    }
                    dao.BatchHospitalTempInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyDCMSHospitalImport(string datId, string mktype, out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                IsValid = dao.VerifyDCMSHospitalImport(datId, mktype);
                result = true;
            }
            return result;
        }

        public bool SubmintHospitalTempInitCheck(Hashtable obj)
        {
            bool result = false;
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                DataTable dt = dao.SubmintHospitalTempInitCheck(obj).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    result = false;
                }
                else
                {
                    result = true;
                }
            }
            return result;
        }

        public void SaveHospitalTempInit(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                dao.SaveHospitalTempInit(obj);
            }
        }

        #endregion
        #region 产品区域授权
        public DataSet GetAuthorizationAreaProductSelected(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetAuthorizationAreaProductSelected(obj);
            }
        }
        public bool AddContractAreaProduct(Hashtable obj)
        {
            bool result = false;

            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                dao.AddContractAreaProduct(obj);
                result = true;
            }
            return result;

        }
        public bool DeleteAreaProductSelected(string Id)
        {
            bool result = false;

            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                dao.DeleteAreaProductSelected(Id);
                result = true;
            }
            return result;
        }
        public DataSet GetAuthorizatonArea(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetAuthorizatonArea(obj);

            }
        }
        public DataSet GetnArea(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetnArea(obj);

            }
        }
        public bool AddContractArea(Hashtable obj)
        {
            bool reslut = false;
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                dao.AddContractArea(obj);
                reslut = true;
            }
            return reslut;
        }
        public bool DeleteAreaAreaSelected(Guid[] Id)
        {
            bool reslut = false;
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    foreach (Guid item in Id)
                    {
                        dao.DeleteAreaAreaSelected(item.ToString());
                    }
                    trans.Complete();
                }
                reslut = true;

            }
            return reslut;
        }
        public DataSet GetCopHospit(Hashtable obj)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetCopHospit(obj);

            }
        }
        public bool CopeAuthorizatonAreaHospit(Hashtable obj)
        {
            bool result = false;
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                dao.CopeAuthorizatonAreaHospit(obj);
                result = true;
            }
            return result;
        }
        public bool RemoveAreaSelectedHospital(Hashtable obj)
        {
            bool result = false;
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                dao.RemoveAreaSelectedHospital(obj);
                result = true;
            }
            return result;
        }
        public DataSet QueryPartAreaExcHospitalTemp(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.QueryPartAreaExcHospitalTemp(obj, start, limit, out totalCount);
            }
        }
        public bool CopeAuthorizatonAreaArea(Hashtable obj)
        {
            bool result = false;
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                dao.CopeAuthorizatonAreaArea(obj);
                result = true;
            }
            return result;
        }
        public bool DeleteHospitByDaId(string DaId)
        {
            bool result = false;
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                dao.DeleteTerritoryAreaExcTempByDaId(DaId);
                result = true;
            }
            return result;
        }

        public void DeleteHospitByDaidHspit(string DaID, Guid[] changes)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                DealerAuthorizationAreaTempDao dao = new DealerAuthorizationAreaTempDao();

                foreach (Guid item in changes)
                {
                    dao.DeleteHospitByDaidHspit(DaID, item);
                }
                trans.Complete();
            }
        }
        #endregion

        #region DCMS被删除产品、医院查询
        public DataSet GetDeleteProductQutery(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetDeleteProductQutery(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetDeleteHospitalQutery(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.GetDeleteHospitalQutery(obj, start, limit, out totalCount);
            }
        }

        public int CheckAuthorizationType(string contractId)
        {
            int i = 0;
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                DataTable dt = dao.CheckAuthorizationType(contractId).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    i = Convert.ToInt32(dt.Rows[0]["RESOULT"]);
                }
            }
            return i;
        }
        #endregion

        public DataSet TerritoryProductByContractId(Guid id, string subu)
        {
            using (ContractTerritoryDao dao = new ContractTerritoryDao())
            {
                return dao.TerritoryProductByContractId(id, subu);
            }
        }

    }
}
