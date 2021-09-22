using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.MasterDatas;
using DMS.DataAccess;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.Consignment;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using System.Linq;
using System.Collections.Generic;
using System.Data;
using DMS.Business.Excel;
using System.Collections.Specialized;
using Newtonsoft.Json;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.ViewModel.Common;
using DMS.Model;
using DMS.Model.Data;
using DMS.DataAccess.DataInterface;
using DMS.Business;

namespace DMS.BusinessService.MasterDatas
{
    public class DealerMasterEditorService : ABaseQueryService, IQueryExport
    {
        #region Ajax Method
        public DealerMasterEditorVO Init(DealerMasterEditorVO model)
        {
            try
            {
                IRoleModelContext context = RoleModelContext.Current;
                Guid DealerID = new Guid(string.IsNullOrEmpty(model.IptDmaID) ? Guid.Empty.ToString() : model.IptDmaID);
                model.IsDealer = IsDealer;
                IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_Dealer_Type);
                IDictionary<string, string> dictsTaxType = DictionaryHelper.GetDictionary("CONST_Taxpayer_Type");
                IDictionary<string, string> dictsAuthentication = DictionaryHelper.GetDictionary("CONST_Dealer_Authentication");
                model.LstDmaType = JsonHelper.DataTableToArrayList(dictsCompanyType.ToArray().ToDataSet().Tables[0]);
                model.LstDmaTaxType = JsonHelper.DataTableToArrayList(dictsTaxType.ToArray().ToDataSet().Tables[0]);
                model.LstDmaAuthentication = JsonHelper.DataTableToArrayList(dictsAuthentication.ToArray().ToDataSet().Tables[0]);

                PaymentDao daoPay = new PaymentDao();
                model.LstDmaPayment=JsonHelper.DataTableToArrayList(daoPay.GetAll().ToDataSet().Tables[0]);

                string Type = "";
                if (model.IptDealerType.Equals("T1"))
                {
                    Type = SR.Const_ContractAnnex_Type_T1.ToSafeString();
                }
                if (model.IptDealerType.Equals("T2"))
                {
                    Type = SR.Const_ContractAnnex_Type_T2.ToSafeString();
                }
                if (model.IptDealerType.Equals("LP"))
                {
                    Type = SR.Const_ContractAnnex_Type_LP.ToSafeString();
                }
                IDictionary<string, string> contractStatus = DictionaryHelper.GetDictionary(Type);
                model.LstDmaAttachType = JsonHelper.DataTableToArrayList(contractStatus.ToArray().ToDataSet().Tables[0]);

                COPDao daoYear = new COPDao();
                model.LstYear = JsonHelper.DataTableToArrayList(daoYear.SelectCOP_FY().Tables[0]);

                DealerAuthorizationDao daoProduct = new DealerAuthorizationDao();
                model.LstProductLine = JsonHelper.DataTableToArrayList(daoProduct.GetDealerProductLine(DealerID).Tables[0]);
                IList<Lafite.RoleModel.Domain.AttributeDomain> dataAllProduct = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine);
                model.LstAllProductLine = JsonHelper.DataTableToArrayList(dataAllProduct.ToDataSet().Tables[0]);
                
                ITerritorys bll = new Territorys();
                IList<Territory> provinces = bll.GetProvinces();
                model.LstDmaProvince = JsonHelper.DataTableToArrayList(provinces.ToDataSet().Tables[0]);
                
                DealerMasterDao dealerMasterDao = new DealerMasterDao();
                DealerMaster dealer = dealerMasterDao.GetObject(DealerID);

                KeyValue kvProvince = new KeyValue();
                KeyValue kvRegion = new KeyValue();
                KeyValue kvTown = new KeyValue();
                model.IptDmaProvince = kvProvince;
                model.IptDmaRegion = kvRegion;
                model.IptDmaTown = kvTown;
                if (dealer != null)
                {
                    //基本信息
                    model.IptDmaCName = dealer.ChineseName;
                    model.IptDmaCSName = dealer.ChineseShortName;
                    model.IptDmaEName = dealer.EnglishName;
                    model.IptDmaESName = dealer.EnglishShortName;
                    model.IptDmaNo = dealer.Nbr;
                    model.IptDmaSapNo = dealer.SapCode;
                    model.IptCorpType = dealer.CompanyType;
                    model.IptDmaType = dealer.DealerType;
                    model.IptTaxType = dealer.Taxpayer;
                    model.IptSalesMode = dealer.SalesMode.ToSafeBool();
                    if (dealer.FirstContractDate != null)
                        model.IptFirstSignDate = Convert.ToDateTime(dealer.FirstContractDate);//.ToShortDateString();
                    model.IptDealerAuthentication = dealer.DealerAuthentication;
                    if (dealer.SystemStartDate != null)
                        model.IptSystemStartDate = Convert.ToDateTime(dealer.SystemStartDate);//.ToShortDateString();
                    model.IptCarrier = dealer.Certification;
                    model.IptActiveFlag = dealer.ActiveFlag.ToSafeBool();
                    
                    //获取省市区县信息
                    IList<Territory> ttInfo = bll.GetTerritorys();
                    foreach (Territory item in ttInfo)
                    {
                        if (item.Description == dealer.Province)
                        {
                            kvProvince.Key = item.TerId.ToSafeString();
                            kvProvince.Value = item.Description;
                            model.IptDmaProvince = kvProvince;
                        }
                        if (item.Description == dealer.City)
                        {
                            kvRegion.Key = item.TerId.ToSafeString();
                            kvRegion.Value = item.Description;
                            model.IptDmaRegion = kvRegion;
                        }
                        if (item.Description == dealer.District)
                        {
                            kvTown.Key = item.TerId.ToSafeString();
                            kvTown.Value = item.Description;
                            model.IptDmaTown = kvTown;
                        }
                    }

                    //地址信息
                    model.IptDmaRegisterAddress = dealer.RegisteredAddress;
                    model.IptDmaAddress = dealer.Address;
                    model.IptDmaShipToAddress = dealer.ShipToAddress;
                    model.IptDmaPostalCOD = dealer.PostalCode;
                    model.IptDmaPhone = dealer.Phone;
                    model.IptDmaFax = dealer.Fax;
                    model.IptDmaContact = dealer.ContactPerson;
                    model.IptDmaEmail = dealer.Email;

                    //工商注册信息
                    model.IptDmaGeneralManager = dealer.GeneralManager;
                    model.IptDmaLegalRep = dealer.LegalRep;
                    model.IptDmaRegisteredCapital = dealer.RegisteredCapital.ToSafeString();
                    model.IptDmaBankAccount = dealer.BankAccount;
                    model.IptDmaBank = dealer.Bank;
                    model.IptDmaTaxNo = dealer.TaxNo;
                    model.IptDmaLicense = dealer.License;
                    model.IptDmaLicenseLimit = dealer.LicenseLimit;
                    if (dealer.EstablishDate != null)
                        model.IptDmaEstablishDate = Convert.ToDateTime(dealer.EstablishDate);//.ToShortDateString();

                    //财务信息
                    model.IptDmaFinance = dealer.Finance;
                    model.IptDmaFinancePhone = dealer.FinancePhone;
                    model.IptDmaFinanceEmail = dealer.FinanceEmail;
                    model.IptDmaPayment = dealer.Payment.ToSafeString();
                    
                }

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string QueryAttach(DealerMasterEditorVO model)
        {
            try
            {
                string Type = "";
                if (model.IptDealerType.Equals("T1"))
                {
                    Type = SR.Const_ContractAnnex_Type_T1.ToSafeString();
                }
                if (model.IptDealerType.Equals("T2"))
                {
                    Type = SR.Const_ContractAnnex_Type_T2.ToSafeString();
                }
                if (model.IptDealerType.Equals("LP"))
                {
                    Type = SR.Const_ContractAnnex_Type_LP.ToSafeString();
                }

                AttachmentDao dao = new AttachmentDao();
                int totalCount = 0;
                Guid DealerID = new Guid(model.IptDmaID.Equals("") ? Guid.Empty.ToString() : model.IptDmaID.ToSafeString());
                Hashtable param = new Hashtable();
                param.Add("DealerID", DealerID);
                param.Add("ParType", Type);
                if (!model.IptDmaAttachName.Equals(""))
                {
                    param.Add("AnnexName", model.IptDmaAttachName.ToSafeString());
                }
                if (!model.IptDmaAttachType.Key.Equals(""))
                {
                    param.Add("AttachmentType", model.IptDmaAttachType.Key.ToSafeString());
                }
                
                int start = (model.Page - 1) * model.PageSize;
                model.RstAttachList = JsonHelper.DataTableToArrayList(dao.GetAttachmentContract(param, start, model.PageSize, out totalCount).Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstAttachList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public DealerMasterEditorVO ProvinceChange(DealerMasterEditorVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.IptDmaProvince.Key))
                {
                    ITerritorys bll = new Territorys();

                    IList<Territory> cities = bll.GetTerritorysByParent(new Guid(model.IptDmaProvince.Key.ToSafeString()));

                    model.LstDmaRegion = JsonHelper.DataTableToArrayList(cities.ToDataSet().Tables[0]);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }

        public DealerMasterEditorVO RegionChange(DealerMasterEditorVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.IptDmaRegion.Key))
                {
                    ITerritorys bll = new Territorys();

                    IList<Territory> town = bll.GetTerritorysByParent(new Guid(model.IptDmaRegion.Key.ToSafeString()));

                    model.LstDmaTown = JsonHelper.DataTableToArrayList(town.ToDataSet().Tables[0]);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }

        public DealerMaintainListVO SaveDealerName(DealerMaintainListVO model)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                Hashtable ht = new Hashtable();
                string IsValid = string.Empty;
                ht.Add("NewDealerName", model.WinNewCName);
                ht.Add("SapCode", model.SelectSAPNo);
                ht.Add("DealerID", model.SelectDealerId);
                ht.Add("NewDealerEnglishName", model.WinNewEName);
                ht.Add("DealerType", model.SelectDealerType);
                ht.Add("UserId", new Guid(RoleModelContext.Current.User.Id));
                IsValid = dao.UpdateDealerName(ht);
                if (IsValid == "Success")
                {
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(IsValid);
                }
            }
            return model;
        }

        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            if (Parameters["DealerMasterEditorExportType"].ToSafeString() == "ExportAll")
            {
                DealerMasterDao dao = new DealerMasterDao();
                DataSet ds = dao.ExportDealerMaster(Parameters["QryDealer"].ToSafeGuid());
                ExportFile(ds, DownloadCookie, "ExportFile");
            }
            else if (Parameters["DealerMasterEditorExportType"].ToSafeString() == "Authorize")
            {
                Hashtable obj = new Hashtable();
                DealerAuthorizationDao dao = new DealerAuthorizationDao();
                if (Parameters["QryExportType"].ToSafeString().Equals("1"))
                {
                    obj.Add("DealerId", Parameters["QryDealer"].ToSafeGuid());
                }
                if (Parameters["QryExportType"].ToSafeString().Equals("1") && !Parameters["QryProductLine"].ToSafeString().Equals(""))
                {
                    obj.Add("ProductLineId", Parameters["QryProductLine"].ToSafeString());
                }
                if (Parameters["QryExportType"].ToSafeString().Equals("3") && !Parameters["QryAllProductLine"].ToSafeString().Equals(""))
                {
                    obj.Add("ProductLineId", Parameters["QryAllProductLine"].ToSafeString());
                }

                DataSet ds = dao.ExportDealerAuthorization(obj);
                ds.Tables[0].Columns.Remove("DmaId");
                ds.Tables[0].Columns.Remove("Address");
                ExportFile(ds, DownloadCookie, "ExportFile");
            }
            else if (Parameters["DealerMasterEditorExportType"].ToSafeString() == "AOPD")
            {
                Hashtable obj = new Hashtable();
                AopDealerDao dao = new AopDealerDao();
                if (Parameters["QryExportType"].ToSafeString().Equals("2"))
                {
                    obj.Add("DealerId", Parameters["QryDealer"].ToSafeGuid());
                }

                if (Parameters["QryExportType"].ToSafeString().Equals("2") && !Parameters["QryProductLine"].ToSafeString().Equals(""))
                {
                    obj.Add("ProductLineId", Parameters["QryProductLine"].ToSafeString());
                }
                if (Parameters["QryExportType"].ToSafeString().Equals("4") && !Parameters["QryAllProductLine"].ToSafeString().Equals(""))
                {
                    obj.Add("ProductLineId", Parameters["QryAllProductLine"].ToSafeString());
                }

                if (!Parameters["QryYear"].ToSafeString().Equals(""))
                {
                    obj.Add("Year", Parameters["QryYear"].ToSafeString());
                }

                DataSet ds = dao.ExportAop(obj);
                ExportFile(ds, DownloadCookie, "ExportFile");
            }
            else if (Parameters["DealerMasterEditorExportType"].ToSafeString() == "AOPH")
            {
                Hashtable obj = new Hashtable();
                AopDealerDao dao = new AopDealerDao();
                if (Parameters["QryExportType"].ToSafeString().Equals("2"))
                {
                    obj.Add("DealerId", Parameters["QryDealer"].ToSafeGuid());
                }

                if (Parameters["QryExportType"].ToSafeString().Equals("2") && !Parameters["QryProductLine"].ToSafeString().Equals(""))
                {
                    obj.Add("ProductLineId", Parameters["QryProductLine"].ToSafeString());
                }
                if (Parameters["QryExportType"].ToSafeString().Equals("4") && !Parameters["QryAllProductLine"].ToSafeString().Equals(""))
                {
                    obj.Add("ProductLineId", Parameters["QryAllProductLine"].ToSafeString());
                }

                if (!Parameters["QryYear"].ToSafeString().Equals(""))
                {
                    obj.Add("Year", Parameters["QryYear"].ToSafeString());
                }

                DataSet ds = dao.ExportHospitalAop(obj);
                ExportFile(ds, DownloadCookie, "ExportFile");
            }
            else if (Parameters["DealerMasterEditorExportType"].ToSafeString() == "AOPP")
            {
                Hashtable obj = new Hashtable();
                AopDealerDao dao = new AopDealerDao();
                if (Parameters["QryExportType"].ToSafeString().Equals("2"))
                {
                    obj.Add("DealerId", Parameters["QryDealer"].ToSafeGuid());
                }

                if (Parameters["QryExportType"].ToSafeString().Equals("2") && !Parameters["QryProductLine"].ToSafeString().Equals(""))
                {
                    obj.Add("ProductLineId", Parameters["QryProductLine"].ToSafeString());
                }
                if (Parameters["QryExportType"].ToSafeString().Equals("4") && !Parameters["QryAllProductLine"].ToSafeString().Equals(""))
                {
                    obj.Add("ProductLineId", Parameters["QryAllProductLine"].ToSafeString());
                }

                if (!Parameters["QryYear"].ToSafeString().Equals(""))
                {
                    obj.Add("Year", Parameters["QryYear"].ToSafeString());
                }

                DataSet ds = dao.ExportHospitalProductAop(obj);
                ExportFile(ds, DownloadCookie, "ExportFile");
            }
        }

        protected void ExportFile(DataSet ds, string Cookie, string Type)
        {
            DataSet[] result = new DataSet[1];
            result[0] = ds;

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport(Type);
            xlsExport.Export(ht, result, Cookie);
        }

        public DealerMaintainListVO RefreshDealerCache(DealerMaintainListVO model)
        {
            DealerCacheHelper.ReloadDealers();
            model.IsSuccess = true;
            return model;
        }

        #endregion
    }
}
