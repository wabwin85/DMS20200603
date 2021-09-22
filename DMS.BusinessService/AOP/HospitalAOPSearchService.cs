using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.AOP;
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
using Grapecity.DataAccess.Transaction;

namespace DMS.BusinessService.AOP
{
    public class HospitalAOPSearchService : ABaseQueryService, IDealerFilterFac, IQueryExport
    {
        IRoleModelContext context = RoleModelContext.Current;
        IAopDealerBLL aopDealerBll = new AopDealerBLL();
        IContractCommonBLL contractCommonBLL = new ContractCommonBLL();

        #region Ajax Method
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }

        public HospitalAOPSearchVO Init(HospitalAOPSearchVO model)
        {
            try
            {
                model.LstProductline = base.GetProductLine();
                DealerMasterDao dealerMasterDao = new DealerMasterDao();
                model.LstDealer = dealerMasterDao.SelectFilterListAll("");
                if (IsDealer)
                {
                    model.LstDealer = dealerMasterDao.SelectFilterListAll(context.User.CorpName);
                    model.QryDealer = new KeyValue(context.User.CorpId.ToSafeString(), context.User.CorpName);
                    if (context.User.CorpType.Equals(DealerType.T2.ToString()) || context.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        model.DisableDealer = true;
                    }
                }
                model = ChangeProductLine(model);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(HospitalAOPSearchVO model)
        {
            try
            {
                Hashtable param = new Hashtable();

                if (model.QryProductLine.ToSafeString() != "" && model.QryProductLine.Key.ToSafeString() != "")
                {
                    param.Add("ProductLineBumId", model.QryProductLine.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryDealer.ToSafeString()) && !string.IsNullOrEmpty(model.QryDealer.Key.ToSafeString()))
                {
                    param.Add("DealerDmaId", model.QryDealer.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QrySubProduct.ToSafeString()) && !string.IsNullOrEmpty(model.QrySubProduct.Key.ToSafeString()))
                {
                    param.Add("SubProductCode", model.QrySubProduct.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryQtSubProduct.ToSafeString()) && !string.IsNullOrEmpty(model.QryQtSubProduct.Key.ToSafeString()))
                {
                    param.Add("QtSubProductCode", model.QryQtSubProduct.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryYear))
                {
                    param.Add("Year", model.QryYear.ToSafeString());
                }
                param.Add("OwnerIdentityType", context.User.IdentityType);
                param.Add("OwnerCorpId", context.User.CorpId);
                BaseService.AddCommonFilterCondition(param);

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = aopDealerBll.GetHospitalProductFiller(param, start, model.PageSize, out totalCount);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

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

        public HospitalAOPSearchVO ChangeProductLine(HospitalAOPSearchVO model)
        {
            try
            {
                Hashtable paramSub = new Hashtable();
                model.QrySubProduct = new KeyValue();
                if (!string.IsNullOrEmpty(model.QryProductLine.ToSafeString()) && !string.IsNullOrEmpty(model.QryProductLine.Key.ToSafeString()))
                {
                    paramSub.Add("ProductLineId", model.QryProductLine.Key.ToSafeString());
                }
                DataTable dtSub = contractCommonBLL.GetPartContractIdByProductId(paramSub).Tables[0];
                model.LstSubProduct = JsonHelper.DataTableToArrayList(dtSub);

                Hashtable paramQt = new Hashtable();
                model.QryQtSubProduct = new KeyValue();
                if (!string.IsNullOrEmpty(model.QryProductLine.ToSafeString()) && !string.IsNullOrEmpty(model.QryProductLine.Key.ToSafeString()))
                {
                    paramQt.Add("ProductLineID", model.QryProductLine.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QrySubProduct.ToSafeString()) && !string.IsNullOrEmpty(model.QrySubProduct.Key.ToSafeString()))
                {
                    paramQt.Add("CCCode", model.QrySubProduct.Key.ToSafeString());
                }
                DataTable dtQt = contractCommonBLL.QueryClassificationQuotaByQuery(paramQt).Tables[0];
                model.LstQtSubProduct = JsonHelper.DataTableToArrayList(dtQt);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public HospitalAOPSearchVO ChangeSubProduct(HospitalAOPSearchVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryProductLine.ToSafeString()) && !string.IsNullOrEmpty(model.QryProductLine.Key.ToSafeString()))
                {
                    param.Add("ProductLineID", model.QryProductLine.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QrySubProduct.ToSafeString()) && !string.IsNullOrEmpty(model.QrySubProduct.Key.ToSafeString()))
                {
                    param.Add("CCCode", model.QrySubProduct.Key.ToSafeString());
                }
                DataTable dt = contractCommonBLL.QueryClassificationQuotaByQuery(param).Tables[0];
                model.QryQtSubProduct = new KeyValue();
                model.LstQtSubProduct = JsonHelper.DataTableToArrayList(dt);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        #endregion

        #region 下载
        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(Parameters["ProductLine"].ToSafeString()))
            {
                param.Add("ProductLineBumId", Parameters["ProductLine"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Dealer"].ToSafeString()))
            {
                param.Add("DealerDmaId", Parameters["Dealer"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["SubProduct"].ToSafeString()))
            {
                param.Add("SubProductCode", Parameters["SubProduct"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QtSubProduct"].ToSafeString()))
            {
                param.Add("QtSubProductCode", Parameters["QtSubProduct"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Year"].ToSafeString()))
            {
                param.Add("Year", Parameters["Year"].ToSafeString());
            }
            param.Add("OwnerIdentityType", context.User.IdentityType);
            param.Add("OwnerCorpId", context.User.CorpId);
            BaseService.AddCommonFilterCondition(param);

            DataSet ds = aopDealerBll.ExportHospitalProductFiller(param);
            if (ds != null)
            {
                DataTable dt = ds.Tables[0];
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
