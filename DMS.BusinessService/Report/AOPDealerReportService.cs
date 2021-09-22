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
    public class AOPDealerReportService : ABaseQueryService, IQueryExport
    {
        #region Ajax Method
        ReportDao rptDao = new ReportDao();
        IRoleModelContext context = RoleModelContext.Current;
        public AOPDealerReportVO Init(AOPDealerReportVO model)
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
        public AOPDealerReportVO ChangeBrand(AOPDealerReportVO model)
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
        public string Query(AOPDealerReportVO model)
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
                if (!string.IsNullOrEmpty(model.QryYear.ToSafeString()))
                {
                    param.Add("Year", model.QryYear.ToSafeString());
                }
                if (context.User.Id != null)
                {
                    param.Add("UserId", context.User.Id);
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = rptDao.AOPDealerReport(param, start, model.PageSize, out totalCount);
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
            if (Parameters["ExportType"].ToSafeString() == "ExportAOPDealerRpt")
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
                
                if (!string.IsNullOrEmpty(Parameters["QryYear"].ToSafeString()))
                {
                    param.Add("Year", Parameters["QryYear"].ToSafeString());
                }
                if (context.User.Id != null)
                {
                    param.Add("UserId", context.User.Id);
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                int totalCount = 0;
                DataSet ds = rptDao.AOPDealerReport(param, 0, int.MaxValue, out totalCount);
                //删除多余列               
                ds.Tables[0].Columns.Remove("AOPD_Dealer_DMA_ID");
                ds.Tables[0].Columns.Remove("AOPD_ProductLine_BUM_ID");
                ds.Tables[0].Columns.Remove("row_number");
                //重命名列名
                ds.Tables[0].Columns["SubCompanyName"].ColumnName = "分子公司";
                ds.Tables[0].Columns["BrandName"].ColumnName = "品牌";
                ds.Tables[0].Columns["DMA_ChineseName"].ColumnName = "经销商名称";
                ds.Tables[0].Columns["ATTRIBUTE_NAME"].ColumnName = "产品线";
                ds.Tables[0].Columns["AOPD_Year"].ColumnName = "年度";
                ds.Tables[0].Columns["AOPD_Amount_1"].ColumnName = "1月";
                ds.Tables[0].Columns["AOPD_Amount_2"].ColumnName = "2月";
                ds.Tables[0].Columns["AOPD_Amount_3"].ColumnName = "3月";
                ds.Tables[0].Columns["AOPD_Amount_4"].ColumnName = "4月";
                ds.Tables[0].Columns["AOPD_Amount_5"].ColumnName = "5月";
                ds.Tables[0].Columns["AOPD_Amount_6"].ColumnName = "6月";
                ds.Tables[0].Columns["AOPD_Amount_7"].ColumnName = "7月";
                ds.Tables[0].Columns["AOPD_Amount_8"].ColumnName = "8月";
                ds.Tables[0].Columns["AOPD_Amount_9"].ColumnName = "9月";
                ds.Tables[0].Columns["AOPD_Amount_10"].ColumnName = "10月";
                ds.Tables[0].Columns["AOPD_Amount_11"].ColumnName = "11月";
                ds.Tables[0].Columns["AOPD_Amount_12"].ColumnName = "12月";
                ds.Tables[0].Columns["AOPD_Amount_Y"].ColumnName = "全年";
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
