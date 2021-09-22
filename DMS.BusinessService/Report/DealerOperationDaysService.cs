using DMS.Business;
using DMS.Business.Excel;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
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
    public class DealerOperationDaysService : ABaseQueryService, IQueryExport
    {
        #region Ajax Method
        ReportDao rptDao = new ReportDao();
        IRoleModelContext context = RoleModelContext.Current;
        public DealerOperationDaysVO Init(DealerOperationDaysVO model)
        {
            try
            {
                if (null != BaseService.CurrentSubCompany)
                {
                    DataSet dsAuthBrand = GetAuthBrand(new Guid(BaseService.CurrentSubCompany.Key));
                    model.LstBrand = JsonHelper.DataTableToArrayList(dsAuthBrand.Tables[0]);

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
        public DealerOperationDaysVO ChangeBrand(DealerOperationDaysVO model)
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
        public string Query(DealerOperationDaysVO model)
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
                if (model.QryUseDate != null && !string.IsNullOrEmpty(model.QryUseDate.StartDate))
                {
                    param.Add("UseDateStart", model.QryUseDate.StartDate);
                }
                if (model.QryUseDate != null && !string.IsNullOrEmpty(model.QryUseDate.EndDate))
                {
                    param.Add("UseDateEnd", model.QryUseDate.EndDate);
                }
                if (!string.IsNullOrEmpty(model.QryWorkDay.ToSafeString()))
                {
                    param.Add("WorkDay", model.QryWorkDay.ToSafeString());
                }
                if (context.User.Id != null)
                {
                    param.Add("UserId", context.User.Id);
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = rptDao.DealerOperationDaysReport(param, start, model.PageSize, out totalCount);
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
            if (Parameters["ExportType"].ToSafeString() == "ExportDodRpt")
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
                if (!string.IsNullOrEmpty(Parameters["QryUseDateStart"].ToSafeString()))
                {
                    param.Add("UseDateStart", Parameters["QryUseDateStart"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryUseDateEnd"].ToSafeString()))
                {
                    param.Add("UseDateEnd", Parameters["QryUseDateEnd"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryWorkDay"].ToSafeString()))
                {
                    param.Add("WorkDay", Parameters["QryWorkDay"].ToSafeString());
                }
                if (context.User.Id != null)
                {
                    param.Add("UserId", context.User.Id);
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                int totalCount = 0;
                DataSet ds = rptDao.DealerOperationDaysReport(param, 0, int.MaxValue, out totalCount);
                //删除多余列               
                ds.Tables[0].Columns.Remove("DealerID");
                ds.Tables[0].Columns.Remove("row_number");
                ds.Tables[0].Columns.Remove("ProductLineName");
                //重命名列名
                ds.Tables[0].Columns["SubCompanyName"].ColumnName = "分子公司";
                ds.Tables[0].Columns["BrandName"].ColumnName = "品牌";
                ds.Tables[0].Columns["DMA_ChineseName"].ColumnName = "经销商名称";
                //ds.Tables[0].Columns["ProductLineName"].ColumnName = "产品线";
                ds.Tables[0].Columns["POReceiptInUseDays"].ColumnName = "收货操作天数";
                ds.Tables[0].Columns["POReceiptRate"].ColumnName = "收货操作频率";
                ds.Tables[0].Columns["ShipmentInUseDays"].ColumnName = "销售操作天数";
                ds.Tables[0].Columns["ShipmentRate"].ColumnName = "销售操作频率";
                ds.Tables[0].Columns["InventoryAdjustInUseDays"].ColumnName = "库存调整天数";
                ds.Tables[0].Columns["InventoryAdjustRate"].ColumnName = "库存调整频率";
                ds.Tables[0].Columns["TransferInUseDays"].ColumnName = "移库操作天数";
                ds.Tables[0].Columns["TransferRate"].ColumnName = "移库操作频率";
                ds.Tables[0].Columns["RentInUseDays"].ColumnName = "借货出库操作天数";
                ds.Tables[0].Columns["RentRate"].ColumnName = "借货出库操作频率";
                
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
