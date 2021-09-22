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
    public class DealerJXCSummaryService : ABaseQueryService, IQueryExport
    {
        #region Ajax Method
        ReportDao rptDao = new ReportDao();
        IRoleModelContext context = RoleModelContext.Current;
        public DealerJXCSummaryVO Init(DealerJXCSummaryVO model)
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
        public DealerJXCSummaryVO ChangeBrand(DealerJXCSummaryVO model)
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
        public string Query(DealerJXCSummaryVO model)
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
                if (model.QryDealerJXSummaryYear.ToSafeString()!="")
                {
                    param.Add("Year", model.QryDealerJXSummaryYear);
                }
                if (context.User.Id != null)
                {
                    param.Add("UserId", context.User.Id);
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = rptDao.DealerJXCSummaryReport(param, start, model.PageSize, out totalCount);
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
            if (Parameters["ExportType"].ToSafeString() == "ExportDealerJXCSumary")
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
                if (!string.IsNullOrEmpty(Parameters["QryDealerJXSummaryYear"].ToSafeString()))
                {
                    param.Add("Year", Parameters["QryDealerJXSummaryYear"].ToSafeString());
                }
                if (context.User.Id != null)
                {
                    param.Add("UserId", context.User.Id);
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                int totalCount = 0;
                DataSet ds = rptDao.DealerJXCSummaryReport(param, 0, int.MaxValue, out totalCount);
                //删除多余列               
                ds.Tables[0].Columns.Remove("RDS_Years");
                ds.Tables[0].Columns.Remove("RDS_DMA_ID");
                ds.Tables[0].Columns.Remove("RDS_BUM_ID");
                ds.Tables[0].Columns.Remove("Inventory01");
                ds.Tables[0].Columns.Remove("Inventory02");
                ds.Tables[0].Columns.Remove("Inventory03");
                ds.Tables[0].Columns.Remove("Inventory04");
                ds.Tables[0].Columns.Remove("Inventory05");
                ds.Tables[0].Columns.Remove("Inventory06");
                ds.Tables[0].Columns.Remove("Inventory07");
                ds.Tables[0].Columns.Remove("Inventory08");
                ds.Tables[0].Columns.Remove("Inventory09");
                ds.Tables[0].Columns.Remove("Inventory10");
                ds.Tables[0].Columns.Remove("Inventory11");
                ds.Tables[0].Columns.Remove("Inventory12");
                ds.Tables[0].Columns.Remove("YInventory");
                ds.Tables[0].Columns.Remove("row_number");
                //重命名列名
                ds.Tables[0].Columns["SubCompanyName"].ColumnName = "分子公司";
                ds.Tables[0].Columns["BrandName"].ColumnName = "品牌";
                ds.Tables[0].Columns["RDS_Attribute_Name"].ColumnName = "产品线";
                ds.Tables[0].Columns["RDS_DMA_ChineseName"].ColumnName = "经销商中文名称";
                ds.Tables[0].Columns["RDS_DMA_EnglishName"].ColumnName = "经销商英文名称";
                ds.Tables[0].Columns["RDS_DMA_SAP_Code"].ColumnName = "ERPCode";
                ds.Tables[0].Columns["DMA_SystemStartDate"].ColumnName = "经销商开帐日期";
                ds.Tables[0].Columns["Order01"].ColumnName = "（01月）订单总金额";
                ds.Tables[0].Columns["PurchaseOrder01"].ColumnName = "（01月）发货总金额";
                ds.Tables[0].Columns["Sales01"].ColumnName = "（01月）销售总金额";
                ds.Tables[0].Columns["Operation01"].ColumnName = "（01月）报台总台数";

                ds.Tables[0].Columns["Order02"].ColumnName = "（02月）订单总金额";
                ds.Tables[0].Columns["PurchaseOrder02"].ColumnName = "（02月）发货总金额";
                ds.Tables[0].Columns["Sales02"].ColumnName = "（02月）销售总金额";
                ds.Tables[0].Columns["Operation02"].ColumnName = "（02月）报台总台数";

                ds.Tables[0].Columns["Order03"].ColumnName = "（03月）订单总金额";
                ds.Tables[0].Columns["PurchaseOrder03"].ColumnName = "（03月）发货总金额";
                ds.Tables[0].Columns["Sales03"].ColumnName = "（03月）销售总金额";
                ds.Tables[0].Columns["Operation03"].ColumnName = "（03月）报台总台数";

                ds.Tables[0].Columns["Order04"].ColumnName = "（04月）订单总金额";
                ds.Tables[0].Columns["PurchaseOrder04"].ColumnName = "（04月）发货总金额";
                ds.Tables[0].Columns["Sales04"].ColumnName = "（04月）销售总金额";
                ds.Tables[0].Columns["Operation04"].ColumnName = "（04月）报台总台数";

                ds.Tables[0].Columns["Order05"].ColumnName = "（05月）订单总金额";
                ds.Tables[0].Columns["PurchaseOrder05"].ColumnName = "（05月）发货总金额";
                ds.Tables[0].Columns["Sales05"].ColumnName = "（05月）销售总金额";
                ds.Tables[0].Columns["Operation05"].ColumnName = "（05月）报台总台数";

                ds.Tables[0].Columns["Order06"].ColumnName = "（06月）订单总金额";
                ds.Tables[0].Columns["PurchaseOrder06"].ColumnName = "（06月）发货总金额";
                ds.Tables[0].Columns["Sales06"].ColumnName = "（06月）销售总金额";
                ds.Tables[0].Columns["Operation06"].ColumnName = "（06月）报台总台数";

                ds.Tables[0].Columns["Order07"].ColumnName = "（07月）订单总金额";
                ds.Tables[0].Columns["PurchaseOrder07"].ColumnName = "（07月）发货总金额";
                ds.Tables[0].Columns["Sales07"].ColumnName = "（07月）销售总金额";
                ds.Tables[0].Columns["Operation07"].ColumnName = "（07月）报台总台数";

                ds.Tables[0].Columns["Order08"].ColumnName = "（08月）订单总金额";
                ds.Tables[0].Columns["PurchaseOrder08"].ColumnName = "（08月）发货总金额";
                ds.Tables[0].Columns["Sales08"].ColumnName = "（08月）销售总金额";
                ds.Tables[0].Columns["Operation08"].ColumnName = "（08月）报台总台数";

                ds.Tables[0].Columns["Order09"].ColumnName = "（09月）订单总金额";
                ds.Tables[0].Columns["PurchaseOrder09"].ColumnName = "（09月）发货总金额";
                ds.Tables[0].Columns["Sales09"].ColumnName = "（09月）销售总金额";
                ds.Tables[0].Columns["Operation09"].ColumnName = "（09月）报台总台数";

                ds.Tables[0].Columns["Order10"].ColumnName = "（10月）订单总金额";
                ds.Tables[0].Columns["PurchaseOrder10"].ColumnName = "（10月）发货总金额";
                ds.Tables[0].Columns["Sales10"].ColumnName = "（10月）销售总金额";
                ds.Tables[0].Columns["Operation10"].ColumnName = "（10月）报台总台数";

                ds.Tables[0].Columns["Order11"].ColumnName = "（11月）订单总金额";
                ds.Tables[0].Columns["PurchaseOrder11"].ColumnName = "（11月）发货总金额";
                ds.Tables[0].Columns["Sales11"].ColumnName = "（11月）销售总金额";
                ds.Tables[0].Columns["Operation11"].ColumnName = "（11月）报台总台数";

                ds.Tables[0].Columns["Order12"].ColumnName = "（12月）订单总金额";
                ds.Tables[0].Columns["PurchaseOrder12"].ColumnName = "（12月）发货总金额";
                ds.Tables[0].Columns["Sales12"].ColumnName = "（12月）销售总金额";
                ds.Tables[0].Columns["Operation12"].ColumnName = "（12月）报台总台数";
                ds.Tables[0].Columns["YOrder"].ColumnName = "订单总金额";
                ds.Tables[0].Columns["YPurchaseOrder"].ColumnName = "发货总金额";
                ds.Tables[0].Columns["YSales"].ColumnName = "销售总金额";
                ds.Tables[0].Columns["YOperation"].ColumnName = "报台总台数";
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
