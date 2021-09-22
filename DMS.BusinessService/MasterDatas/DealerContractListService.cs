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
using System.Collections.Generic;
using DMS.Business;
using DMS.DataAccess;
using DMS.Model;

namespace DMS.BusinessService.MasterDatas
{
    public class DealerContractListService : ABaseQueryService, IDealerFilterFac
    {
        private IDealerContracts _dealerContractBiz = new DealerContracts();
        #region Ajax Method
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public DealerContractListVO Init(DealerContractListVO model)
        {
            try
            {
                model.ListDealer = JsonHelper.DataTableToArrayList(GetDealerSource().ToDataSet().Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(DealerContractListVO model)
        {
            try
            {
                DealerContract param = new DealerContract();
                if (model.QryDealer != null && !string.IsNullOrEmpty(model.QryDealer.Key))
                {
                    param.DmaId = new Guid(model.QryDealer.Key);
                }
                if (model.QryContractNumber != null)
                {
                    param.ContractNumber = model.QryContractNumber.Trim();
                }
                if (model.QryContractYears != null)
                {
                    int years = 0;
                    if (int.TryParse(model.QryContractYears, out years))
                        param.ContractYears = years;
                }

                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;

                IList<DealerContract> query = _dealerContractBiz.SelectByFilter(param, start, model.PageSize,
                    out outCont);
                model.RstResultList = JsonHelper.DataTableToArrayList(query.ToDataSet().Tables[0]);
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
            return JsonHelper.Serialize(result);
        }

        public DealerContractListVO SaveDetail(DealerContractListVO model)
        {
            try
            {
                if (string.IsNullOrEmpty(model.AddDealerContractID) && !_dealerContractBiz.VerifyDealerIsUniqueness(new Guid(model.AddDealer.Key)))
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("已有关联该经销商的合同");
                }
                else
                {
                    DealerContract contract = new DealerContract();
                    if (string.IsNullOrEmpty(model.AddDealerContractID))
                    {
                        contract.Id = Guid.NewGuid();
                    }
                    else
                    {
                        contract.Id = new Guid(model.AddDealerContractID);
                    }
                    contract.DmaId = new Guid(model.AddDealer.Key);
                    contract.ContractNumber = model.AddContractNumber;
                    if (!string.IsNullOrEmpty(model.AddContractYears))
                    {
                        int year = 0;
                        if (int.TryParse(model.AddContractYears.Trim(), out year))
                            contract.ContractYears = year;
                    }
                    contract.StartDate = model.AddStartDate;
                    contract.StopDate = model.AddStopDate;
                    model.IsSuccess = _dealerContractBiz.SaveContract(contract);
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

        public DealerContractListVO DeleteDetail(DealerContractListVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.DeleteDealerContractID))
                {
                    model.IsSuccess = _dealerContractBiz.DeleteContract(new Guid(model.DeleteDealerContractID));
                    if (!model.IsSuccess)
                    {
                        model.ExecuteMessage.Add("删除失败,请先删除授权信息!");
                    }
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("请选择需要删除的记录");
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
