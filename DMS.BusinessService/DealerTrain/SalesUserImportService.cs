using System;
using DMS.Common.Common;
using DMS.Common;
using System.Data;
using Newtonsoft.Json;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.ViewModel.DealerTrain;
using DMS.Business.DealerTrain;

namespace DMS.BusinessService.DealerTrain
{
    public class SalesUserImportService : ABaseQueryService, IDealerFilterFac
    {
        #region Ajax Method
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public SalesUserImportVO Init(SalesUserImportVO model)
        {
            try
            {

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(SalesUserImportVO model)
        {
            try
            {
                CommandoUserBLL _commandoUserBLL = new CommandoUserBLL();

                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = _commandoUserBLL.GetRemainWechatUserList(model.QryDealer, model.QrySale, start, model.PageSize, out outCont);
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
