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
    public class ConsignmentCfnSetListService : ABaseQueryService
    {
        #region Ajax Method
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public ConsignmentCfnSetListVO Init(ConsignmentCfnSetListVO model)
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

        public string Query(ConsignmentCfnSetListVO model)
        {
            try
            {
                ICfnSetBLL _CfnSetBLL = new CfnSetBLL();
                Hashtable param = new Hashtable();
                if (model.QryBu != null && !string.IsNullOrEmpty(model.QryBu.Key))
                {
                    param.Add("ProductLineBumId", model.QryBu.Key);
                }

                if (!string.IsNullOrEmpty(model.QryCFNSetName))
                {
                    param.Add("CfnSetName", model.QryCFNSetName);
                }

                if (!string.IsNullOrEmpty(model.QryCFN))
                {
                    param.Add("CustomerFaceNbr", model.QryCFN);
                }
                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = _CfnSetBLL.QueryDataByFilterConsignmentCfnSet(param, start, model.PageSize, out outCont);
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

        public ConsignmentCfnSetListVO Delete(ConsignmentCfnSetListVO model)
        {
            CfnSetDao _CfnSetDao = new CfnSetDao();
            try
            {
                if (model.DeleteSeleteID.Count > 0)
                {
                    foreach (string id in model.DeleteSeleteID)
                    {
                        _CfnSetDao.Delete(new Guid(id));
                    }
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("删除出错！");
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
        #endregion
    }


}
