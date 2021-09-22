using DMS.Business;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.DataAccess.Consignment;
using DMS.DataAccess.ContractElectronic;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.Consignment;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Consignment
{
    public class ConsignmentApplyHeaderListService : ABaseQueryService, IDealerFilterFac
    {
        #region Ajax Method

        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public ConsignmentApplyHeaderListVO Init(ConsignmentApplyHeaderListVO model)
        {
            try
            {
                model.InsertVisible = IsDealer;
                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                    {
                        model.LstDealer = new ArrayList(DealerList().ToList());
                        model.DealerDisabled = true;
                        model.DealerType = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                    else
                    {
                        model.LstDealer = new ArrayList(DealerListByFilter(false).ToList());
                        model.DealerListType = "2";
                    }
                }
                else
                {
                    model.LstDealer = new ArrayList(DealerList().ToList());
                }
                model.IsDealer = IsDealer;
                model.LstBu = base.GetProductLine();
                model.LstType = DictionaryHelper.GetKeyValueList(SR.ConsignmentApply_Order_Type);
                model.LstStatus = DictionaryHelper.GetKeyValueList(SR.ConsignmentApply_Status);
                model.LstDelayStatus = DictionaryHelper.GetKeyValueList(SR.CONST_Delay_Status);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(ConsignmentApplyHeaderListVO model)
        {
            try
            {
                ConsignInventoryAdjustHeaderDao ContractHeader = new ConsignInventoryAdjustHeaderDao();

                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryBu.ToSafeString()))
                    if (model.QryBu.Value != "全部" && model.QryBu.Key != "")
                        param.Add("ProductLineBumId", model.QryBu.Key.ToSafeString());
                if (!string.IsNullOrEmpty(model.QryDealer.ToSafeString()))
                    if (model.QryDealer.Value != "全部" && model.QryDealer.Key != "")
                        param.Add("DmaId", model.QryDealer.Key);
                if (!string.IsNullOrEmpty(model.QryType.ToSafeString()))
                    if (model.QryType.Value != "全部" && model.QryType.Key != "")
                        param.Add("OrderType", model.QryType.Key);
                if (!string.IsNullOrEmpty(model.QryBeginDate.ToSafeString()))
                    param.Add("SubmitDate", model.QryBeginDate);
                if (!string.IsNullOrEmpty(model.QryEndDate.ToSafeString()))
                    param.Add("SubmitDateEnd", model.QryEndDate);
                if (!string.IsNullOrEmpty(model.QryOrderNo.ToSafeString()))
                    param.Add("OrderNo", model.QryOrderNo);
                if (!string.IsNullOrEmpty(model.QryStatus.ToSafeString()))
                    if (model.QryStatus.Value != "全部" && model.QryStatus.Key != "")
                        param.Add("OrderStatus", model.QryStatus.Key);
                if (!string.IsNullOrEmpty(model.QryProductType.ToSafeString()))
                    param.Add("Cfn", model.QryProductType);
                if (!string.IsNullOrEmpty(model.QryDelayStatus.ToSafeString()))
                    if (model.QryDelayStatus.Value != "全部" && model.QryDelayStatus.Key != "")
                        param.Add("DelayStatus", model.QryDelayStatus.Key);
                if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString())))
                {
                    param.Add("CreateUser", new Guid(RoleModelContext.Current.User.Id));
                }
                if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.HQ.ToString()))
                {
                    param.Add("IsHQ", "True");
                }
                param.Add("OwnerIdentityType", RoleModelContext.Current.User.IdentityType);
                param.Add("OwnerOrganizationUnits", RoleModelContext.Current.User.GetOrganizationUnits());
                param.Add("OwnerId", new Guid(RoleModelContext.Current.User.Id));
                param.Add("OwnerCorpId", RoleModelContext.Current.User.CorpId);
                BaseService.AddCommonFilterCondition(param);
                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = ContractHeader.QueryConsignmentApplyHeaderDealer(param, start, model.PageSize, out totalCount);
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
            return JsonConvert.SerializeObject(result);
        }

        #endregion
    }
}
