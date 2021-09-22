using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.DataAccess;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using Lafite.RoleModel.Security;
using DMS.ViewModel.Inventory;
using System.Data;
using Newtonsoft.Json;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using System.Collections.Specialized;
using DMS.Business.Excel;
using DMS.Business;

namespace DMS.BusinessService.Inventory
{
    public class DealerComplainForGoodsRetrunCRMService : ABaseQueryService, IDealerFilterFac, IQueryExport
    {
        #region Ajax Method
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public DealerComplainForGoodsRetrunCRMVO Init(DealerComplainForGoodsRetrunCRMVO model)
        {
            try
            {
                DealerComplainDao DealerComplain = new DealerComplainDao();
                QueryDao Bu = new QueryDao();
                model.IsDealer = IsDealer;
                model.LstStatus = DictionaryHelper.GetKeyValueList(SR.CONST_QAComplainReturn_Status);
                model.IsCanApply = IsDealer;


            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(DealerComplainForGoodsRetrunCRMVO model)
        {
            try
            {
                DealerComplainDao DealerComplain = new DealerComplainDao();
                Hashtable param = new Hashtable();

                if (model.QryDealer!=null&&!string.IsNullOrEmpty(model.QryDealer.Key))
                {
                    param.Add("DealerId", model.QryDealer.Key);
                }

                if (model.QryStatus!=null&&!string.IsNullOrEmpty(model.QryStatus.Key))
                {
                    param.Add("Status", model.QryStatus.Key);
                }

                if (!string.IsNullOrEmpty(model.QryComplainNumber))
                {
                    param.Add("ComplainNumber", model.QryComplainNumber);
                }
                if (!string.IsNullOrEmpty(model.QryDN))
                {
                    param.Add("DN", model.QryDN);
                }

                if (!string.IsNullOrEmpty(model.QryUPN))
                {
                    param.Add("Upn", model.QryUPN);
                }
                if (!string.IsNullOrEmpty(model.QryLotNumber))
                {
                    param.Add("LotNumber", model.QryLotNumber);
                }

                if (model.QrySubmitDate!=null&& !string.IsNullOrEmpty(model.QrySubmitDate.StartDate))
                {
                    param.Add("ApplyDateStart", model.QrySubmitDate.StartDate);
                }
                if (model.QrySubmitDate != null && !string.IsNullOrEmpty(model.QrySubmitDate.EndDate))
                {
                    param.Add("ApplyDateEnd", model.QrySubmitDate.EndDate);
                }
                if (!String.IsNullOrEmpty(model.QryApplyUser))
                {
                    param.Add("ApplyUser", model.QryApplyUser);
                }
                param.Add("ComplainType", "CRM");

                param.Add("OwnerIdentityType", RoleModelContext.Current.User.IdentityType);
                param.Add("OwnerOrganizationUnits", RoleModelContext.Current.User.GetOrganizationUnits());
                param.Add("OwnerId", new Guid(RoleModelContext.Current.User.Id));
                param.Add("OwnerCorpId", RoleModelContext.Current.User.CorpId);

                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = DealerComplain.SelectDealerComplainByHashtable(param, start, model.PageSize, out outCont);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = outCont;
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

        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            DealerComplainDao DealerComplain = new DealerComplainDao();

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(Parameters["Dealer"].ToSafeString()))
            {
                param.Add("DealerId", Parameters["Dealer"].ToSafeString());
            }

            if (!string.IsNullOrEmpty(Parameters["Status"].ToSafeString()))
            {
                param.Add("Status", Parameters["Status"].ToSafeString());
            }

            if (!string.IsNullOrEmpty(Parameters["ComplainNumber"].ToSafeString()))
            {
                param.Add("ComplainNumber", Parameters["ComplainNumber"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["DN"].ToSafeString()))
            {
                param.Add("DN", Parameters["DN"].ToSafeString());
            }

            if (!string.IsNullOrEmpty(Parameters["UPN"].ToSafeString()))
            {
                param.Add("Upn", Parameters["UPN"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["LotNumber"].ToSafeString()))
            {
                param.Add("LotNumber", Parameters["LotNumber"].ToSafeString());
            }

            if (!string.IsNullOrEmpty(Parameters["SubmitDateStartDate"].ToSafeString()))
            {
                param.Add("ApplyDateStart", Parameters["SubmitDateStartDate"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["SubmitDateEndDate"].ToSafeString()))
            {
                param.Add("ApplyDateEnd", Parameters["SubmitDateEndDate"].ToSafeString());
            }
            if (!String.IsNullOrEmpty(Parameters["ApplyUser"].ToSafeString()))
            {
                param.Add("ApplyUser", Parameters["ApplyUser"].ToSafeString());
            }
            param.Add("ComplainType", "CRM");

            param.Add("OwnerIdentityType", RoleModelContext.Current.User.IdentityType);
            param.Add("OwnerOrganizationUnits", RoleModelContext.Current.User.GetOrganizationUnits());
            param.Add("OwnerId", new Guid(RoleModelContext.Current.User.Id));
            param.Add("OwnerCorpId", RoleModelContext.Current.User.CorpId);

            DataTable dt = new DealerComplainBLL().DealerComplainExport(param);
            DataSet[] result = new DataSet[1];
            result[0] = new DataSet();
            result[0].Tables.Add(dt.Copy());

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("DealerComplainForGoodsRetrunCRM");
            xlsExport.Export(ht, result, DownloadCookie);

        }

        #endregion
    }


}
