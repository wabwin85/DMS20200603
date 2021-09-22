using DMS.Business;
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
using DMS.ViewModel.Report;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Report
{
    public class DealerHistoryInvDetailService : ABaseQueryService, IQueryExport, IDealerFilterFac
    {
        #region Ajax Method
        ReportDao rptDao = new ReportDao();
        IRoleModelContext context = RoleModelContext.Current;
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public DealerHistoryInvDetailVO Init(DealerHistoryInvDetailVO model)
        {
            try
            {
                if (null != BaseService.CurrentSubCompany)
                {
                    DataSet dsAuthBrand = GetAuthBrand(new Guid(BaseService.CurrentSubCompany.Key));
                    model.LstBrand = JsonHelper.DataTableToArrayList(dsAuthBrand.Tables[0]);

                    if (IsDealer)
                    {
                        if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()))
                        {
                            //model.LstDealer = new ArrayList(DealerList().ToList());
                        }
                        else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                        {
                            // model.LstDealer = new ArrayList(DealerListByFilter(false).ToList());
                            model.DealerListType = "2";
                        }
                        else
                        {
                            //  model.LstDealer = new ArrayList(DealerList().ToList());
                        }
                    }
                    else
                    {
                        //model.LstDealer = new ArrayList(DealerList().ToList());
                    }
                }
                else
                {
                    model.LstBrand = null;
                }
                model.LstProductline = base.GetProductLine();
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
        public DealerHistoryInvDetailVO ChangeBrand(DealerHistoryInvDetailVO model)
        {
            try
            {
                ProductLineBLL bllProductLine = new ProductLineBLL();
                IList<KeyValue> productlines = base.GetProductLine(false);
                var lstAuthProductLine = bllProductLine.SelectViewProductLine(BaseService.CurrentSubCompany?.Key, model.QryBrand?.Key,
                null);
                model.LstProductline =
                    productlines.Where(
                        item => lstAuthProductLine.Any(p => p.Id.Equals(item.Key, StringComparison.OrdinalIgnoreCase))).ToList();
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
        public string Query(DealerHistoryInvDetailVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                if (model.QryBrand.ToSafeString() != "" && model.QryBrand.Key.ToSafeString() != "")
                {
                    param.Add("Brand", model.QryBrand.Key.ToSafeString());
                }
                if (model.QryProductLine.ToSafeString() != "" && model.QryProductLine.Key.ToSafeString() != "")
                {
                    param.Add("ProductLine", model.QryProductLine.Key.ToSafeString());
                }
                if (model.QryInventDate != null && !string.IsNullOrEmpty(model.QryInventDate.StartDate))
                {
                    param.Add("InventDateStart", model.QryInventDate.StartDate);
                }
                if (model.QryInventDate != null && !string.IsNullOrEmpty(model.QryInventDate.EndDate))
                {
                    param.Add("InventDateEnd", model.QryInventDate.EndDate);
                }
                if (!string.IsNullOrEmpty(model.QryCFN.ToSafeString()))
                {
                    param.Add("CFN", model.QryCFN.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryLotNumber.ToSafeString()))
                {
                    param.Add("LotNumber", model.QryLotNumber.ToSafeString());
                }
                if (model.QryDealer!=null&&!string.IsNullOrEmpty(model.QryDealer.Key.ToSafeString()))
                {
                    param.Add("Dealer", model.QryDealer.Key.ToSafeString());
                }

                
                if (IsDealer)
                {
                    DealerMasterDao dao = new DealerMasterDao();
                    DealerMaster dm = dao.GetObject(context.User.CorpId.Value);
                    if(dm!=null && dm.DealerType == DealerType.LP.ToSafeString())
                    {
                        param.Add("DealerType", "LP");
                    }
                    else
                    {
                        param.Add("DealerType", "DEALER");
                    }
                }
                else
                {
                    param.Add("DealerType", "USER");
                }
                if (context.User.CorpId != null)
                {
                    param.Add("CorpId", context.User.CorpId.Value);
                }
                if (context.User.Id != null)
                {
                    param.Add("UserId", context.User.Id);
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = rptDao.DealerHistoryInvDetailReport(param, start, model.PageSize, out totalCount);
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

        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            if (Parameters["ExportType"].ToSafeString() == "DealerHistoryInvDetail")
            {
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(Parameters["QryBrand"].ToSafeString()))
                {
                    param.Add("Brand", Parameters["QryBrand"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryProductLine"].ToSafeString()))
                {
                    param.Add("ProductLine", Parameters["QryProductLine"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryInventDateStart"].ToSafeString()))
                {
                    param.Add("InventDateStart", Parameters["QryInventDateStart"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryInventDateEnd"].ToSafeString()))
                {
                    param.Add("InventDateEnd", Parameters["QryInventDateEnd"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryCFN"].ToSafeString()))
                {
                    param.Add("CFN", Parameters["QryCFN"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryLotNumber"].ToSafeString()))
                {
                    param.Add("LotNumber", Parameters["QryLotNumber"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["Dealer"].ToSafeString()))
                {
                    param.Add("Dealer", Parameters["Dealer"].ToSafeString());
                }
                if (IsDealer)
                {
                    DealerMasterDao dao = new DealerMasterDao();
                    DealerMaster dm = dao.GetObject(context.User.CorpId.Value);
                    if (dm != null && dm.DealerType == DealerType.LP.ToSafeString())
                    {
                        param.Add("DealerType", "LP");
                    }
                    else
                    {
                        param.Add("DealerType", "DEALER");
                    }
                }
                else
                {
                    param.Add("DealerType", "USER");
                }
                if (context.User.CorpId != null)
                {
                    param.Add("CorpId", context.User.CorpId.Value);
                }
                if (context.User.Id != null)
                {
                    param.Add("UserId", context.User.Id);
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                int totalCount = 0;
                DataSet ds = rptDao.DealerHistoryInvDetailReport(param, 0, int.MaxValue, out totalCount);
                //删除多余列               
                ds.Tables[0].Columns.Remove("Implant");
                ds.Tables[0].Columns.Remove("Upn");
                ds.Tables[0].Columns.Remove("ProductName");
                ds.Tables[0].Columns.Remove("ExpiredDate");
                ds.Tables[0].Columns.Remove("OnHandQuantity");
                ds.Tables[0].Columns.Remove("Lotid");
                ds.Tables[0].Columns.Remove("Invid");
                ds.Tables[0].Columns.Remove("WhmId");
                ds.Tables[0].Columns.Remove("PmaId");
                ds.Tables[0].Columns.Remove("LtmId");
                ds.Tables[0].Columns.Remove("SapUnitPrice");
                ds.Tables[0].Columns.Remove("DealerId");
                ds.Tables[0].Columns.Remove("row_number");
                //重命名列名
                ds.Tables[0].Columns["SubCompanyName"].ColumnName = "分子公司";
                ds.Tables[0].Columns["BrandName"].ColumnName = "品牌";
                ds.Tables[0].Columns["DealerName"].ColumnName = "经销商名称";
                ds.Tables[0].Columns["DealerType"].ColumnName = "经销商类型";
                ds.Tables[0].Columns["ParentDealer"].ColumnName = "上级经销商";
                ds.Tables[0].Columns["WarehouseName"].ColumnName = "仓库";
                ds.Tables[0].Columns["WhmType"].ColumnName = "仓库类型";
                ds.Tables[0].Columns["ProductLineName"].ColumnName = "产品线";
                ds.Tables[0].Columns["CustomerFaceNbr"].ColumnName = "产品型号";
                ds.Tables[0].Columns["CFNChineseName"].ColumnName = "产品中文名称";
                ds.Tables[0].Columns["CFNEnglishName"].ColumnName = "产品英文名称";
                ds.Tables[0].Columns["LotNumber"].ColumnName = "序列号";
                ds.Tables[0].Columns["QRCode"].ColumnName = "二维码";
                ds.Tables[0].Columns["ExpiredDateString"].ColumnName = "有效期";
                ds.Tables[0].Columns["UnitOfMeasure"].ColumnName = "单位";
                ds.Tables[0].Columns["OnHandQty"].ColumnName = "库存数量";
                ds.Tables[0].Columns["INV_BAK_DATE"].ColumnName = "库存日期";
                ExportFile(ds, DownloadCookie);
            }

        }

        protected void ExportFile(DataSet ds, string Cookie)
        {
            DataSet[] result = new DataSet[1];
            result[0] = ds;

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("ExportFile");
            xlsExport.Export(ht, result, Cookie);
        }



        #endregion
    }
}
