using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.ViewModel.MasterDatas;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.MasterDatas
{
    public class ConsignmentMasterDealerPickerService : ABaseQueryService
    {

        public ConsignmentMasterDealerPickerVO Init(ConsignmentMasterDealerPickerVO model)
        {
            try
            {

                IConsignmentApplyHeaderBLL bll = new ConsignmentApplyHeaderBLL();
                DataSet ds = bll.GetProductLineVsDivisionCode(model.QryBu);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    model.QryBuName = ds.Tables[0].Rows[0]["ProductLineName"].ToString();
                    model.DivisionCode = ds.Tables[0].Rows[0]["DivisionCode"].ToString();
                }
                //经销商类别
                //IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_Dealer_Type);
                model.RstDealerType = DictionaryHelper.GetKeyValueList(SR.Consts_Dealer_Type);
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }

        public string Query(ConsignmentMasterDealerPickerVO model)
        {
            try
            {

                int totalCount = 0;

                IConsignmentMasterBLL Bll = new ConsignmentMasterBLL();
                Hashtable ht = new Hashtable();
                ht.Add("Division", model.DivisionCode);
                if (!string.IsNullOrEmpty(model.QryDealerName))
                {
                    ht.Add("ChineseName", model.QryDealerName);

                }
                if (!string.IsNullOrEmpty(model.FilterDealer.Key))
                {
                    ht.Add("DealerType", model.FilterDealer.Key);
                }
                if (!string.IsNullOrEmpty(model.QrySAPCode))
                {
                    ht.Add("SapCode", model.QrySAPCode);
                }

                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = Bll.QeryConsignmentMasterDealerSearch(ht, start, model.PageSize, out totalCount);
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


    }
}
