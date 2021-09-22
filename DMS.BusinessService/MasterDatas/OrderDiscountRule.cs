using System;
using DMS.Common.Common;
using DMS.Common;
using System.Data;
using Newtonsoft.Json;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Business.DealerTrain;
using DMS.ViewModel.MasterDatas;
using DMS.DataAccess.ContractElectronic;
using System.Collections;
using DMS.Business;
using DMS.DataAccess;

namespace DMS.BusinessService.MasterDatas
{
    public class OrderDiscountRuleService : ABaseQueryService
    {
        #region Ajax Method
        public OrderDiscountRuleVO Init(OrderDiscountRuleVO model)
        {
            try
            {
                model.ListBu = base.GetProductLine();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(OrderDiscountRuleVO model)
        {
            try
            {
                IOrderDiscountRule business = new OrderDiscountRuleBLL();
                Hashtable param = new Hashtable();
                if (model.QryBu != null && !string.IsNullOrEmpty(model.QryBu.Key))
                {
                    param.Add("ProductLineBumId", model.QryBu.Key);
                }

                if (!string.IsNullOrEmpty(model.QryUPN))
                {
                    param.Add("Upn", model.QryUPN);
                }

                if (!string.IsNullOrEmpty(model.QryLotNumber))
                {
                    param.Add("Lot", model.QryLotNumber);
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                param.Add("BrandId", BaseService.CurrentBrand?.Key);
                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryOrderDiscountRule(param, start, model.PageSize, out outCont);
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

        #endregion
    }


}
