using DMS.Business;
using DMS.Business.Cache;
using DMS.Business.Contract;
using DMS.Business.DataInterface;
using DMS.Business.Excel;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.Contract;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Contract
{
    public class ThirdPartyQueryForGenesisService : ABaseQueryService, IQueryExport, IDealerFilterFac
    {
        #region Ajax Method
        IRoleModelContext context = RoleModelContext.Current;
        IThirdPartyDisclosureService thirdPartyDisclosure = new ThirdPartyDisclosureService();
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public ThirdPartyQueryForGenesisVO Init(ThirdPartyQueryForGenesisVO model)
        {
            try
            {
                DealerMasterDao dealerMasterDao = new DealerMasterDao();
                model.LstDealer = dealerMasterDao.SelectFilterListAll("");
                if (IsDealer)
                {
                    model.LstDealer = dealerMasterDao.SelectFilterListAll(context.User.CorpName);
                    model.QryDealer = new KeyValue(context.User.CorpId.ToSafeString(), context.User.CorpName);
                    if (context.User.CorpType.Equals(DealerType.T2.ToString()))
                    {
                        model.DisableSelect = true;
                    }
                    else if (context.User.CorpType.Equals(DealerType.LP.ToString()) || context.User.CorpType.Equals(DealerType.LS.ToString()) || context.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        if (context.User.CorpType.Equals(DealerType.T1.ToString()))
                        {
                            model.DisableSelect = true;
                        }
                    }
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

        public string Query(ThirdPartyQueryForGenesisVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryDealer.Key))
                {
                    param.Add("DmaId", model.QryDealer.Key);
                }
                if (!string.IsNullOrEmpty(model.QryHospitalName))
                {
                    param.Add("Name", model.QryHospitalName);
                }
                if (!string.IsNullOrEmpty(model.QryIsAttach.Key))
                {
                    param.Add("IsAt", model.QryIsAttach.Key);
                }
                if (!string.IsNullOrEmpty(model.QryApprovalStatus.Key))
                {
                    param.Add("ApprovalStatus", model.QryApprovalStatus.Key);
                }
                if (!string.IsNullOrEmpty(model.QryIsHospital.Key))
                {
                    param.Add("IsHospital", model.QryIsHospital.Key);
                }

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                var lists = thirdPartyDisclosure.QueryThirdPartyDisclosure(param, start, model.PageSize, out totalCount);
                model.RstResultList = JsonHelper.DataTableToArrayList(lists.Tables[0]);

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
            return JsonHelper.Serialize(result);
        }

        #endregion

        #region 下载
        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(Parameters["DmaId"].ToSafeString()))
            {
                param.Add("DmaId", Parameters["DmaId"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Name"].ToSafeString()))
            {
                param.Add("Name", Parameters["Name"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["IsAt"].ToSafeString()))
            {
                param.Add("IsAt", Parameters["IsAt"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["ApprovalStatus"].ToSafeString()))
            {
                param.Add("ApprovalStatus", Parameters["ApprovalStatus"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["IsHospital"].ToSafeString()))
            {
                param.Add("IsHospital", Parameters["IsHospital"].ToSafeString());
            }

            DataSet ds = thirdPartyDisclosure.ExportThirdPartyDisclosure(param);
            if (ds != null)
            {
                DataTable dt = ds.Tables[0];
                dt.Columns.Remove("DmaId");
                DataSet[] result = new DataSet[1];
                result[0] = new DataSet();
                result[0].Tables.Add(dt.Copy());

                Hashtable ht = new Hashtable();
                XlsExport xlsExport = new XlsExport("ExportFile");
                xlsExport.Export(ht, result, DownloadCookie);
            }

        }
        #endregion
    }
}
