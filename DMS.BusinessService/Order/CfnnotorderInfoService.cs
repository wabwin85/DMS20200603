using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.Model.Data;
using DMS.ViewModel.Order;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Order
{

    public class CfnnotorderInfoService : ABaseQueryService
    {
        #region Ajax Method
        private IPurchaseOrderBLL _business = new PurchaseOrderBLL();
        IRoleModelContext _context = RoleModelContext.Current;

        public CfnnotorderInfoVO Init(CfnnotorderInfoVO model)
        {
            try
            {
                model.IsDealer = IsDealer;
                model.cbDealerDisabled = false;
                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                    {
                        model.LstDealer = new ArrayList(DealerList().ToList());
                        model.cbDealerDisabled = true;
                        model.hidDealerId = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                    else
                    {
                        model.LstDealer = new ArrayList(DealerListByFilter(false).ToList());
                    }

                }
                {
                    model.LstDealer = new ArrayList(DealerList().ToList());
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


        public string Query(CfnnotorderInfoVO model)
        {
            try
            {
                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryDealer.ToSafeString()))
                {
                    param.Add("DealerId", model.QryDealer.Key);
                }
                if (!string.IsNullOrEmpty(model.QryCFN))
                {
                    param.Add("Upn", model.QryCFN.Split(',')[0]);
                }
                DataSet ds = _business.GetCfnIsorderByUpn(param);
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

        #endregion


    }
}
