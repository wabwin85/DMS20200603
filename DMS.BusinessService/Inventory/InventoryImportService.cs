using DMS.Business;
using DMS.Business.Cache;
using DMS.Business.Excel;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.Inventory;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Inventory
{
    public class InventoryImportService : ABaseQueryService, IDealerFilterFac
    {
        IInventoryInitBLL business = new InventoryInitBLL();
        IRoleModelContext context = RoleModelContext.Current;
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }

        public InventoryImportVO Init(InventoryImportVO model)
        {
            try
            {
                DealerMasterDao dealerMasterDao = new DealerMasterDao();
                model.LstDealerName = dealerMasterDao.SelectFilterListAll("");

                model.IsDealer = IsDealer;

                //控制页面
                if (IsDealer)
                {
                    model.DealerType = context.User.CorpType;
                    model.LstDealerName = dealerMasterDao.SelectFilterListAll(context.User.CorpName);
                    model.QryDealer = new KeyValue(context.User.CorpId.ToSafeString(), context.User.CorpName);
                    model.QryImportDate = DateTime.Now.AddMonths(-1).ToString("yyyyMM");
                    
                }

                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryDealer.ToSafeString()) && !string.IsNullOrEmpty(model.QryDealer.Key.ToSafeString()))
                {
                    param.Add("DMA_ID", model.QryDealer.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryImportDate.ToSafeString()) && model.QryImportDate.ToSafeString().Length == 6)
                {
                    param.Add("DID_Period", model.QryImportDate.ToSafeString());

                    DealerInventoryData obj = business.QueryRecord(param);
                    if (obj != null)
                    {
                        model.QryInvCount = obj.TotalCount.ToString();
                        model.QryInvQty = obj.TotalQty.ToString("0.00");
                    }
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

        public string Query(InventoryImportVO model)
        {
            try
            {
                int totalCount = 0;
                Hashtable table = new Hashtable();

                if (!string.IsNullOrEmpty(model.QryDealer.ToSafeString()) && !string.IsNullOrEmpty(model.QryDealer.Key.ToSafeString()))
                {
                    table.Add("DMA_ID", model.QryDealer.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryImportDate.ToSafeString()) && model.QryImportDate.ToSafeString().Length == 6)
                {
                    table.Add("DID_Period", model.QryImportDate.ToSafeString());

                    int start = (model.Page - 1) * model.PageSize;
                    IList<DealerInventoryData> list = business.QueryDID(table, start, model.PageSize, out totalCount);
                    model.RstResultList = JsonHelper.DataTableToArrayList(list.ToDataSet().Tables[0]);
                }
                

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

        public InventoryImportVO GetTotalCount(InventoryImportVO model)
        {
            try
            {
                Hashtable table = new Hashtable();

                if (!string.IsNullOrEmpty(model.QryDealer.ToSafeString()) && !string.IsNullOrEmpty(model.QryDealer.Key.ToSafeString()))
                {
                    table.Add("DMA_ID", model.QryDealer.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryImportDate.ToSafeString()) && model.QryImportDate.ToSafeString().Length == 6)
                {
                    table.Add("DID_Period", model.QryImportDate.ToSafeString());

                    DealerInventoryData obj = business.QueryRecord(table);
                    if (obj != null)
                    {
                        model.QryInvCount = obj.TotalCount.ToString();
                        model.QryInvQty = obj.TotalQty.ToString("0.00");
                    }
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
    }
}
