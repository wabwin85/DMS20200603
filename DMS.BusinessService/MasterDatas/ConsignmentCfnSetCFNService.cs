using System;
using DMS.Common.Common;
using DMS.Common;
using System.Data;
using Newtonsoft.Json;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.ViewModel.DealerTrain;
using DMS.Business.DealerTrain;
using DMS.ViewModel.MasterDatas;
using DMS.Business;
using System.Collections;
using System.Collections.Generic;
using DMS.Model;
using DMS.DataAccess.ContractElectronic;

namespace DMS.BusinessService.MasterDatas
{
    public class ConsignmentCfnSetCFNService : ABaseQueryService, IDealerFilterFac
    {
        #region Ajax Method
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public ConsignmentCfnSetCFNVO Init(ConsignmentCfnSetCFNVO model)
        {
            try
            {
                QueryDao Bu = new QueryDao();
                Hashtable htbu = new Hashtable();
                htbu.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                htbu.Add("BrandId", BaseService.CurrentBrand?.Key);
                model.LstBu = JsonHelper.DataTableToArrayList(Bu.SelectBU(htbu).Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(ConsignmentCfnSetCFNVO model)
        {
            try
            {
                ICfns bll = new Cfns();

                Hashtable param = new Hashtable();

                if (model.QryBu != null && !string.IsNullOrEmpty(model.QryBu.Key))
                {
                    param.Add("ProductLineBumId", new Guid(model.QryBu.Key));
                }
                if (model.QryIsInclude != null && !string.IsNullOrEmpty(model.QryIsInclude.Key))
                {
                    param.Add("IsContain", model.QryIsInclude.Key);
                }
                if (!string.IsNullOrEmpty(model.QryCFN))
                {
                    param.Add("CustomerFaceNbr", model.QryCFN);
                }

                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                IList<Cfn> query = bll.SelectByFilterIsContain(param, start, model.PageSize, out outCont);
                DataTable dt = query.ToDataSet().Tables[0];
                DataTable Rst = dt.Clone();
                Rst.Clear();
                //去除重复项，ext为何可以直接实现，kendo是否有类似功能
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    bool insert = true;
                    for (int j = 0; j < Rst.Rows.Count; j++)
                    {
                        if (Convert.ToString(Rst.Rows[j]["Id"]) == Convert.ToString(dt.Rows[i]["Id"]))
                        {
                            insert = false;
                            break;
                        }
                    }
                    if (insert)
                    {
                        Rst.Rows.Add(dt.Rows[i].ItemArray);
                    }
                }
                model.RstResultList = JsonHelper.DataTableToArrayList(Rst);

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
