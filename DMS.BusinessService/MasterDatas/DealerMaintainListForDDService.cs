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
    public class DealerMaintainListForDDService : ABaseQueryService, IDealerFilterFac, IQueryExport
    {
        #region Ajax Method
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public DealerMaintainListForDDVO Init(DealerMaintainListForDDVO model)
        {
            try
            {
                IRoleModelContext context = RoleModelContext.Current;
                model.IsDealer = IsDealer;
                IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_Dealer_Type);
                model.LstDealerType = JsonHelper.DataTableToArrayList(dictsCompanyType.ToArray().ToDataSet().Tables[0]);

                DealerMasterDao dealerMasterDao = new DealerMasterDao();
                model.LstDealerName = dealerMasterDao.SelectFilterListAll("");
                model.DealerListType = "0";//默认4
                if (IsDealer)
                {
                    KeyValue kvDealer = new KeyValue();
                    KeyValue kvType = new KeyValue();
                    DealerMaster dealer = dealerMasterDao.GetObject(RoleModelContext.Current.User.CorpId.ToSafeGuid());
                    kvDealer.Key = RoleModelContext.Current.User.CorpId.ToSafeString();
                    kvDealer.Value = dealer.ChineseShortName;
                    kvType.Key = RoleModelContext.Current.User.CorpType;
                    kvType.Value = RoleModelContext.Current.User.CorpType;
                    model.QryDealerName = kvDealer;
                    model.QryDealerType = kvType;
                    model.DealerListType = "3";
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

        public string Query(DealerMaintainListForDDVO model)
        {
            try
            {
                DealerMasterDao dao = new DealerMasterDao();
                int totalCount = 0;

                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QrySAPNo))
                {
                    param.Add("SapCode", model.QrySAPNo.ToSafeString());
                }

                if (!string.IsNullOrEmpty(model.QryDealerAddress))
                {
                    param.Add("Address", model.QryDealerAddress.ToSafeString());
                }
                if (model.QryIsActive != null && !string.IsNullOrEmpty(model.QryIsActive.Key))
                {
                    param.Add("ActiveFlag", model.QryIsActive.Key);
                }
                if (model.QryIsHaveRedFlag != null && !string.IsNullOrEmpty(model.QryIsHaveRedFlag.Key))
                {
                    param.Add("IsHaveRedFlag", model.QryIsHaveRedFlag.Key);
                }

                //平台只搜索自己及下级数据，第三方按照分子公司过滤
                if (IsDealer)
                {
                    if (!string.IsNullOrEmpty(model.QryDealerName.Key))
                    {
                        param.Add("DealerId", model.QryDealerName.Key.ToSafeString());
                    }
                    else
                    {
                        param.Add("DealerIdLP", UserInfo.CorpId);
                    }
                }
                else
                {
                    if (!string.IsNullOrEmpty(model.QryDealerName.Key))
                    {
                        param.Add("DealerId", model.QryDealerName.Key.ToSafeString());
                    }
                    if (!string.IsNullOrEmpty(model.QryDealerType.Key))
                    {
                        param.Add("DealerType", model.QryDealerType.Key.ToSafeString());
                    }
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                int start = (model.Page - 1) * model.PageSize;
                model.RstResultList = JsonHelper.DataTableToArrayList(dao.QueryForDealerMasterForDD(param, start, model.PageSize, out totalCount).Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public string QueryDealerContactInfo(DealerMaintainListForDDVO model)
        {
            try
            {
                using (Interfacet2ContactInfoDao dao = new Interfacet2ContactInfoDao())
                {
                    int totalCount = 0;
                    int start = (model.Page - 1) * model.PageSize;
                    model.LstDealerContact = JsonHelper.DataTableToArrayList(dao.SelectT2ContactInfoByID(new Guid(model.SelectDealerId), start, model.PageSize, out totalCount).ToDataSet().Tables[0]);

                    model.DataCount = totalCount;
                    model.IsSuccess = true;
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.LstDealerContact, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public string QueryAttachInfo(DealerMaintainListForDDVO model)
        {
            try
            {
                using (AttachmentDao dao = new AttachmentDao())
                {
                    int totalCount = 0;
                    Hashtable table = new Hashtable();
                    table.Add("MainId", model.SelectDealerId.ToSafeGuid());
                    table.Add("Type", AttachmentType.DealerLicense.ToString());

                    int start = (model.Page - 1) * model.PageSize;
                    model.RstLCAttachList = JsonHelper.DataTableToArrayList(dao.GetAttachmentByMainId(table, start, model.PageSize, out totalCount).Tables[0]);

                    model.DataCount = totalCount;
                    model.IsSuccess = true;
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstLCAttachList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public DealerMaintainListForDDVO InitLCDetailWin(DealerMaintainListForDDVO model)
        {
            try
            {
                //初始窗体部分
                DealerMasterLicenseDao dao = new DealerMasterLicenseDao();

                //根据经销商ID获取经销商证照相关信息
                if (model.SelectDealerId != null)
                {
                    DealerMasterLicense dml = dao.GetObject(model.SelectDealerId.ToSafeGuid());
                    if (dml != null)
                    {
                        //给当前的控件赋值

                        model.WinLCLicenseNo = string.IsNullOrEmpty(dml.CurLicenseNo) ? "" : dml.CurLicenseNo;
                        model.WinLCHeadOfCorp = string.IsNullOrEmpty(dml.CurRespPerson) ? "" : dml.CurRespPerson;

                        model.WinLCLegalRep = string.IsNullOrEmpty(dml.CurLegalPerson) ? "" : dml.CurLegalPerson;

                        if (dml.CurLicenseValidFrom != null && !String.IsNullOrEmpty(dml.CurLicenseValidFrom.ToString()))
                        {
                            model.WinLCLicenseStart = Convert.ToDateTime(dml.CurLicenseValidFrom);
                        }
                        if (dml.CurLicenseValidTo != null && !String.IsNullOrEmpty(dml.CurLicenseValidTo.ToString()))
                        {
                            model.WinLCLicenseEnd = Convert.ToDateTime(dml.CurLicenseValidTo);
                        }

                        model.WinLCRecordNo = string.IsNullOrEmpty(dml.CurFilingNo) ? "" : dml.CurFilingNo;
                        if (dml.CurFilingValidFrom != null && !String.IsNullOrEmpty(dml.CurFilingValidFrom.ToString()))
                        {
                            model.WinLCRecordStart = Convert.ToDateTime(dml.CurFilingValidFrom);
                        }
                        if (dml.CurFilingValidTo != null && !String.IsNullOrEmpty(dml.CurFilingValidTo.ToString()))
                        {
                            model.WinLCRecordEnd = Convert.ToDateTime(dml.CurFilingValidTo);
                        }

                        if (!String.IsNullOrEmpty(dml.CurSecondClassCatagory))
                        {
                            Hashtable obj = new Hashtable();
                            obj.Add("strCatId", dml.CurSecondClassCatagory);
                            obj.Add("catType", LicenseCatagoryLevel.二类.ToString());
                            obj.Add("versionNumber", "2002版");
                            using (DealerMasterDao daoProduct = new DealerMasterDao())
                            {
                                model.RstLCProductList202 = JsonHelper.DataTableToArrayList(daoProduct.GetDealerLicenseCatagoryByCatId(obj).Tables[0]);
                            }
                        }

                        if (!String.IsNullOrEmpty(dml.NewSecondClassCatagory))
                        {
                            Hashtable obj = new Hashtable();
                            obj.Add("strCatId", dml.NewSecondClassCatagory);
                            obj.Add("catType", LicenseCatagoryLevel.二类.ToString());
                            obj.Add("versionNumber", "2017版");
                            using (DealerMasterDao daoProduct = new DealerMasterDao())
                            {
                                model.RstLCProductList217 = JsonHelper.DataTableToArrayList(daoProduct.GetDealerLicenseCatagoryByCatId(obj).Tables[0]);
                            }
                        }


                        if (!String.IsNullOrEmpty(dml.CurThirdClassCatagory))
                        {
                            Hashtable obj = new Hashtable();
                            obj.Add("strCatId", dml.CurThirdClassCatagory);
                            obj.Add("catType", LicenseCatagoryLevel.三类.ToString());
                            obj.Add("versionNumber", "2002版");
                            using (DealerMasterDao daoProduct = new DealerMasterDao())
                            {
                                model.RstLCProductList302 = JsonHelper.DataTableToArrayList(daoProduct.GetDealerLicenseCatagoryByCatId(obj).Tables[0]);
                            }
                        }

                        if (!String.IsNullOrEmpty(dml.NewThirdClassCatagory))
                        {
                            Hashtable obj = new Hashtable();
                            obj.Add("strCatId", dml.NewThirdClassCatagory);
                            obj.Add("catType", LicenseCatagoryLevel.三类.ToString());
                            obj.Add("versionNumber", "2017版");
                            using (DealerMasterDao daoProduct = new DealerMasterDao())
                            {
                                model.RstLCProductList317 = JsonHelper.DataTableToArrayList(daoProduct.GetDealerLicenseCatagoryByCatId(obj).Tables[0]);
                            }
                        }

                    }
                    else
                    {
                        model.WinLCLicenseNo = "";
                        model.WinLCHeadOfCorp = "";
                        model.WinLCLegalRep = "";
                        model.WinLCRecordNo = "";
                        model.WinLCLicenseStart = DateTime.MinValue;
                        model.WinLCRecordStart = DateTime.MinValue;
                        model.WinLCLicenseEnd = DateTime.MinValue;
                        model.WinLCRecordEnd = DateTime.MinValue;
                    }

                    model.RstLCAddressList = JsonHelper.DataTableToArrayList(dao.SelectSAPWarehouseAddress(model.SelectDealerId.ToSafeGuid()).Tables[0]);

                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("无法获取当前经销商编号！");
                    return model;
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

        public DealerMaintainListForDDVO SaveDealerName(DealerMaintainListForDDVO model)
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
            if (Parameters["DealerListExportType"].ToSafeString() == "ExportByDealer")
            {
                Hashtable param = new Hashtable();
                DealerMasterDao dao = new DealerMasterDao();
                if (!string.IsNullOrEmpty(Parameters["QryDealer"].ToSafeString()))
                {
                    param.Add("DealerId", Parameters["QryDealer"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryDealerType"].ToSafeString()))
                {
                    param.Add("DealerType", Parameters["QryDealerType"].ToSafeString());
                }
                if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                {
                    param.Add("DealerIdLP", RoleModelContext.Current.User.CorpId);
                }
                DataSet ds = dao.GetExcelDealerMasterByAllUser(param);
                ExportFile(ds, DownloadCookie);
            }
            else if (Parameters["DealerListExportType"].ToSafeString() == "ExportByAuthorize")
            {
                Hashtable param = new Hashtable();
                DealerMasterLicenseDao dao = new DealerMasterLicenseDao();
                if (!string.IsNullOrEmpty(Parameters["QryDealer"].ToSafeString()))
                {
                    param.Add("DmaId", Parameters["QryDealer"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryDealerAddress"].ToSafeString()))
                {
                    param.Add("Address", Parameters["QryDealerAddress"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QrySAPNo"].ToSafeString()))
                {
                    param.Add("Code", Parameters["QrySAPNo"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryDealerType"].ToSafeString()))
                {
                    param.Add("DmaType", Parameters["QryDealerType"].ToSafeString());
                }
                DataSet ds = dao.SelectDealerLicenseCfnForExport(param);
                ds.Tables[0].Columns.Remove("DmaId");
                ds.Tables[0].Columns.Remove("Address");
                ExportFile(ds, DownloadCookie);
            }
            else if (Parameters["DealerListExportType"].ToSafeString() == "ExportByLicense")
            {
                Hashtable param = new Hashtable();
                DealerMasterLicenseDao dao = new DealerMasterLicenseDao();
                if (!string.IsNullOrEmpty(Parameters["QrySAPNo"].ToSafeString()))
                    param.Add("SapCode", Parameters["QrySAPNo"].ToSafeString());
                if (!string.IsNullOrEmpty(Parameters["QryDealerType"].ToSafeString()))
                    param.Add("DealerType", Parameters["QryDealerType"].ToSafeString());
                if (!string.IsNullOrEmpty(Parameters["QryDealerAddress"].ToSafeString()))
                    param.Add("Address", Parameters["QryDealerAddress"].ToSafeString());

                //BSC用户可以看所有经销商信息，T1、T2经销商用户只能看自己的发货单,LP可以看自己的以及下属经销商信息
                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                    {
                        param.Add("LPId", RoleModelContext.Current.User.CorpId);
                    }
                    else
                    {
                        param.Add("DealerId", RoleModelContext.Current.User.CorpId);
                    }
                }
                param.Add("OwnerIdentityType", RoleModelContext.Current.User.IdentityType);
                param.Add("OwnerOrganizationUnits", RoleModelContext.Current.User.GetOrganizationUnits());
                param.Add("OwnerId", new Guid(RoleModelContext.Current.User.Id));

                DataSet ds = dao.SelectDealerLicenseForExport(param);
                ExportFile(ds, DownloadCookie);
            }
        }

        protected void ExportFile(DataSet ds, string Cookie)
        {
            DataSet[] result = new DataSet[1];
            result[0] = ds;

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("ExportFile");
            xlsExport.Export(ht, result, Cookie);
        }

        public DealerMaintainListForDDVO RefreshDealerCache(DealerMaintainListForDDVO model)
        {
            DealerCacheHelper.ReloadDealers();
            model.IsSuccess = true;
            return model;
        }

        #endregion
    }
}
