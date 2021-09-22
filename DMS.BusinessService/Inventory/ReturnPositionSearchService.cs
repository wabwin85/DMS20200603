using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Inventory;
using DMS.DataAccess;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.Consignment;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using System.Linq;
using System.Collections.Generic;
using System.Data;
using DMS.Business.Excel;
using System.Collections.Specialized;
using Newtonsoft.Json;
using DMS.Business;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.ViewModel.Common;
using DMS.Model;

namespace DMS.BusinessService.Inventory
{
    public class ReturnPositionSearchService : ABaseQueryService, IQueryExport, IDealerFilterFac
    {
        #region Ajax Method

        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }

        public ReturnPositionSearchVO Init(ReturnPositionSearchVO model)
        {
            try
            {
                IRoleModelContext context = RoleModelContext.Current;
                DealerMasterDao dealerMasterDao = new DealerMasterDao();
                model.IsDealer = IsDealer;
                model.DealerType = context.User.CorpType;
                model.LstProductLine = GetProductLine();
                model.LstWinProductLine = GetProductLine();
                model.LstDealer = dealerMasterDao.SelectFilterListAll("");
                if (IsDealer)
                {
                    model.QryDealer = new KeyValue(context.User.CorpId.ToSafeString(), context.User.CorpName);
                    model.LstDealer = dealerMasterDao.SelectFilterListAll(UserInfo.CorpName);
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

        public ReturnPositionSearchVO InitPromotionType(ReturnPositionSearchVO model)
        {
            try
            {
                DealerMasterDao daoDealer = new DealerMasterDao();
                model.LstWinDealer = daoDealer.SelectFilterListAll("");
                if (!string.IsNullOrEmpty(model.WinIDCode) && !string.IsNullOrEmpty(model.WinProductline))
                {
                    DealerMaster dealer = daoDealer.GetObject(model.WinIDCode.ToSafeGuid());
                    model.WinDealer = new KeyValue(model.WinIDCode, dealer.ChineseShortName);
                    model.LstWinDealer = daoDealer.SelectFilterListAll(dealer.ChineseName);
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

        public string Query(ReturnPositionSearchVO model)
        {
            try
            {
                IReturnPositionSearchBLL business = new ReturnPositionSearchBLL();
                int totalCount = 0;

                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryDealer.Key))
                {
                    param.Add("DealerID", model.QryDealer.Key.ToSafeString());
                }

                if (!string.IsNullOrEmpty(model.QryProductLine.Key))
                {
                    param.Add("ProductLine", model.QryProductLine.Key.ToSafeString());
                }
                param = BaseService.AddCommonFilterCondition(param);

                int start = (model.Page - 1) * model.PageSize;
                model.RstResultList = JsonHelper.DataTableToArrayList(business.GetPosition(param, start, model.PageSize, out totalCount).Tables[0]);

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

        public string QueryDetail(ReturnPositionSearchVO model)
        {
            try
            {
                IReturnPositionSearchBLL business = new ReturnPositionSearchBLL();
                int totalCount = 0;

                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.WinIDCode))
                {
                    param.Add("SAP_Code", model.WinIDCode.ToSafeString());
                }

                if (!string.IsNullOrEmpty(model.WinProductline))
                {
                    param.Add("pid", model.WinProductline.ToSafeString());
                }
                param = BaseService.AddCommonFilterCondition(param);

                int start = (model.Page - 1) * model.PageSize;
                model.RstWinDetail = JsonHelper.DataTableToArrayList(business.GetObjectid(param, start, model.PageSize, out totalCount).Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstWinDetail, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public ReturnPositionSearchVO ChangeDealer(ReturnPositionSearchVO model)
        {
            try
            {
                IReturnPositionSearchBLL business = new ReturnPositionSearchBLL();
                string message = "false";
                DataTable dt = business.baocuo(model.WinDealer.Key.ToSafeGuid()).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    if (dt.Rows[0]["DMA_DealerType"].ToString() == "T2")
                    {
                        message = "true";
                    }
                }
                model.ExecuteMessage.Add(message);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ReturnPositionSearchVO Submit(ReturnPositionSearchVO model)
        {
            try
            {
                IReturnPositionSearchBLL business = new ReturnPositionSearchBLL();
                
                if (!string.IsNullOrEmpty(model.WinIDCode) && !string.IsNullOrEmpty(model.WinProductline))//update
                {
                    //修改退货额度明细校验           
                    if (!string.IsNullOrEmpty(model.WinAmount))
                    {
                        decimal qty;
                        if (!Decimal.TryParse(model.WinAmount, out qty))
                        {
                            model.IsSuccess = false;
                            model.ExecuteMessage.Add("额度格式不正确！");
                            return model;
                        }
                    }
                    else
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("额度不能为空！");
                        return model;
                    }
                    if (string.IsNullOrEmpty(model.WinYears))
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("请填写年份！");
                        return model;
                    }
                    if (string.IsNullOrEmpty(model.WinQuarter.Key))
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("季度不能为空！");
                        return model;
                    }
                    if (decimal.Parse(model.WinAmount) < 0)
                    {
                        if (decimal.Parse(model.WinAmount) + decimal.Parse(model.Winamount) < 0)
                        {
                            model.IsSuccess = false;
                            model.ExecuteMessage.Add("修改额度必须小于当前总额度！");
                            return model;
                        }
                    }
                    if (string.IsNullOrEmpty(model.WinRemark))
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("修改额度必须填写备注！");
                        return model;
                    }
                    bool result = false;
                    result = business.insert(GetInsertValue(model));
                    
                    if (result)
                    {
                        model.IsSuccess = true;
                        model.ExecuteMessage.Add("修改成功！");
                    }
                    else
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("修改失败！");
                    }
                }
                else//insert
                {
                    if (string.IsNullOrEmpty(model.WinDealer.Key))
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("经销商不能为空！");
                        return model;
                    }
                    if (string.IsNullOrEmpty(model.WinProductLine.Key))
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("产品线不能为空！");
                        return model;
                    }
                    if (string.IsNullOrEmpty(model.WinYears))
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("年份不能为空！");
                        return model;
                    }
                    if (string.IsNullOrEmpty(model.WinQuarter.Key))
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("季度不能为空！");
                        return model;
                    }

                    if (!string.IsNullOrEmpty(model.WinAmount))
                    {
                        decimal qty;
                        if (!Decimal.TryParse(model.WinAmount, out qty))
                        {
                            model.IsSuccess = false;
                            model.ExecuteMessage.Add("额度格式不正确！");
                            return model;
                        }
                    }
                    else
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("额度不允许为空！");
                        return model;
                    }

                    bool result = false;
                    result = business.insert(GetInsertValue(model));
                    
                    if (result)
                    {
                        model.IsSuccess = true;
                        model.ExecuteMessage.Add("新增成功！");
                    }
                    else
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("新增失败！");
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
        
        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {

            Hashtable param = new Hashtable();
            IReturnPositionSearchBLL business = new ReturnPositionSearchBLL();

            if (!string.IsNullOrEmpty(Parameters["QryDealer"]))
            {
                param.Add("DealerID", Parameters["QryDealer"].ToSafeString());
            }

            if (!string.IsNullOrEmpty(Parameters["QryProductLine"]))
            {
                param.Add("ProductLine", Parameters["QryProductLine"].ToSafeString());
            }
            
            param = BaseService.AddCommonFilterCondition(param);
            DataSet ds = new DataSet();
            
            ds = business.ExcleGetPosition(param);
            
            DataSet[] result = new DataSet[1];
            result[0] = ds;

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("ExportFile");
            xlsExport.Export(ht, result, DownloadCookie);

        }

        #endregion

        public Hashtable GetInsertValue(ReturnPositionSearchVO model)
        {
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(model.WinDealer.Key))
            {
                param.Add("DealerID", model.WinDealer.Key.ToSafeString());
            }
            if (!string.IsNullOrEmpty(model.WinProductLine.Key))
            {
                param.Add("ProductLine", model.WinProductLine.Key.ToSafeString());
            }
            if (!string.IsNullOrEmpty(model.WinYears))
            {
                param.Add("Years", model.WinYears);
            }
            if (!string.IsNullOrEmpty(model.WinQuarter.Key))
            {
                param.Add("Quarter", model.WinQuarter.Key.ToSafeString());
            }
            if (!string.IsNullOrEmpty(model.WinAmount))
            {
                param.Add("Quota", model.WinAmount);
            }
            if (!string.IsNullOrEmpty(model.WinRemark))
            {
                param.Add("Desc", model.WinRemark);
            }

            string Yeardate = model.WinYears;
            string SubmitBeginDate = Yeardate + "-04-01";
            string SubmitEndDate = int.Parse(Yeardate) + 1 + "-03-31";
            string ExpBeginDate = Yeardate + "-01-01";
            string ExpEndDate = Yeardate + "-12-31";
            param.Add("SubmitBeginDate", SubmitBeginDate);
            param.Add("SubmitEndDate", SubmitEndDate);
            param.Add("ExpBeginDate", ExpBeginDate);
            param.Add("ExpEndDate", ExpEndDate);

            return param;
        }
    }
}
