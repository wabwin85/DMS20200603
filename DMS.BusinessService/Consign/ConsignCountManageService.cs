using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using Lafite.RoleModel.Security;
using System.Data;
using Newtonsoft.Json;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Business;
using DMS.ViewModel.DealerTrain;
using DMS.Business.DealerTrain;
using DMS.DataAccess.Consignment;
using DMS.Model;
using DMS.ViewModel.Consign;
using DMS.Model.Consignment;

namespace DMS.BusinessService.Consign
{
    public class ConsignCountManageService : ABaseQueryService, IDealerFilterFac
    {
        #region Ajax Method
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public ConsignCountManageVO Init(ConsignCountManageVO model)
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

        public string Query(ConsignCountManageVO model)
        {
            try
            {
                ConsignCommonDao _commandoBLL = new ConsignCommonDao();

                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                Hashtable ht = new Hashtable();
                ht.Add("QryDealer", model.QryDealer);
                ht.Add("QryUpn", model.QryUpn);
                DataSet ds = _commandoBLL.SelectConsignCountList(ht, start, model.PageSize, out outCont);
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

        public ConsignCountManageVO Save(ConsignCountManageVO model)
        {
            IDealerMasters _dealerMastersBll = new DealerMasters();
            ConsignCommonDao _commandoBLL = new ConsignCommonDao();
            Guid DealerId = new Guid(model.AddDealer.Key);
            DealerMaster dm = _dealerMastersBll.GetDealerMaster(DealerId);
            try
            {
                if (string.IsNullOrEmpty(model.AddCQID))
                {
                    ConsignCountManagePO ccpo = new ConsignCountManagePO();
                    ccpo.CQ_ID = Guid.NewGuid();
                    
                    if (dm != null)
                    {
                        ccpo.CQ_DMA_SAP_Code = dm.SapCode;
                    }
                    ccpo.CQ_Upn = model.AddUpn.Key;
                    ccpo.CQ_Amount = model.AddAmount;
                    ccpo.CQ_Qty = model.AddTotal;
                    if (!string.IsNullOrEmpty(model.AddValidity.StartDate))
                    {
                        ccpo.CQ_BeginDate = Convert.ToDateTime(model.AddValidity.StartDate);
                    }
                    if (!string.IsNullOrEmpty(model.AddValidity.EndDate))
                    {
                        ccpo.CQ_EndDate = Convert.ToDateTime(model.AddValidity.EndDate);
                    }
                    ccpo.CQ_CreateDate = DateTime.Now;
                    _commandoBLL.InsertConsignCountManage(ccpo);
                    model.IsSuccess = true;
                }
                else
                {
                    ConsignCountManagePO ccpo = new ConsignCountManagePO();
                    ccpo.CQ_ID = new Guid(model.AddCQID);
                    if (dm != null)
                    {
                        ccpo.CQ_DMA_SAP_Code = dm.SapCode;
                    }
                    ccpo.CQ_Upn = model.AddUpn.Key;
                    ccpo.CQ_Amount = model.AddAmount;
                    ccpo.CQ_Qty = model.AddTotal;
                    if (!string.IsNullOrEmpty(model.AddValidity.StartDate))
                    {
                        ccpo.CQ_BeginDate = Convert.ToDateTime(model.AddValidity.StartDate);
                    }
                    if (!string.IsNullOrEmpty(model.AddValidity.EndDate))
                    {
                        ccpo.CQ_EndDate = Convert.ToDateTime(model.AddValidity.EndDate);
                    }
                    ccpo.CQ_CreateDate = DateTime.Now;
                    _commandoBLL.UpdateConsignCountManage(ccpo);
                    model.IsSuccess = true;
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

        public ConsignCountManageVO Delete(ConsignCountManageVO model)
        {
            ConsignCommonDao _commandoBLL = new ConsignCommonDao();
            try
            {
                if (!string.IsNullOrEmpty(model.AddCQID))
                {
                    _commandoBLL.DeleteConsignCountManage(new Guid(model.AddCQID));
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

        public ConsignCountManageVO ChangeDealer(ConsignCountManageVO model)
        {
            ConsignCommonDao _commandoBLL = new ConsignCommonDao();
            try
            {
                Hashtable ht = new Hashtable();
                ht.Add("DMA_ID", model.AddDealer.Key);
                DataSet ds = _commandoBLL.SelectUpnByDealerID(ht);
                model.LstUpn = JsonHelper.DataTableToArrayList(ds.Tables[0]);
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
