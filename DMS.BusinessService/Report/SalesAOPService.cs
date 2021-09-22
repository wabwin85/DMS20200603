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
    public class SalesAOPService : ABaseQueryService, IQueryExport
    {
        #region Ajax Method
        ReportDao rptDao = new ReportDao();
        IRoleModelContext context = RoleModelContext.Current;
        public SalesAOPVO Init(SalesAOPVO model)
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
        public SalesAOPVO ChangeBrand(SalesAOPVO model)
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
        public string Query(SalesAOPVO model)
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
                if (model.QryOrderDate != null && !string.IsNullOrEmpty(model.QryOrderDate.StartDate))
                {
                    param.Add("OrderDateStart", model.QryOrderDate.StartDate);
                }
                if (model.QryOrderDate != null && !string.IsNullOrEmpty(model.QryOrderDate.EndDate))
                {
                    param.Add("OrderDateEnd", model.QryOrderDate.EndDate);
                }
                if (!string.IsNullOrEmpty(model.QryCFN.ToSafeString()))
                {
                    param.Add("CFN", model.QryCFN.ToSafeString());
                }
                if (context.User.Id != null)
                {
                    param.Add("UserId", context.User.Id);
                }


                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = rptDao.DealerOrderDetailReport(param, start, model.PageSize, out totalCount);
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
            if (Parameters["ExportType"].ToSafeString() == "ExportOrderDetail")
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
                if (!string.IsNullOrEmpty(Parameters["QryOrderDateStart"].ToSafeString()))
                {
                    param.Add("OrderDateStart", Parameters["QryOrderDateStart"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryOrderDateEnd"].ToSafeString()))
                {
                    param.Add("OrderDateEnd", Parameters["QryOrderDateEnd"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryCFN"].ToSafeString()))
                {
                    param.Add("CFN", Parameters["QryCFN"].ToSafeString());
                }
                if (context.User.Id != null)
                {
                    param.Add("UserId", context.User.Id);
                }

                int totalCount = 0;
                DataSet ds = rptDao.DealerOrderDetailReport(param, 0, int.MaxValue, out totalCount);
                //删除多余列               
                ds.Tables[0].Columns.Remove("POH_SubmitUser");
                ds.Tables[0].Columns.Remove("row_number");
                //重命名列名
                ds.Tables[0].Columns["SubCompanyName"].ColumnName = "分子公司";
                ds.Tables[0].Columns["BrandName"].ColumnName = "品牌";
                ds.Tables[0].Columns["ChineseName"].ColumnName = "经销商名称";
                ds.Tables[0].Columns["SAPCode"].ColumnName = "ERPCode";
                ds.Tables[0].Columns["ProductLineName"].ColumnName = "产品线";
                ds.Tables[0].Columns["OrderNo"].ColumnName = "订单编号";
                ds.Tables[0].Columns["Order_Type"].ColumnName = "订单类型";
                ds.Tables[0].Columns["IDENTITY_NAME"].ColumnName = "操作人";
                ds.Tables[0].Columns["SubmitDate"].ColumnName = "订单日期";
                ds.Tables[0].Columns["RDD"].ColumnName = "期望到货日期";
                ds.Tables[0].Columns["OrderStatus"].ColumnName = "订单状态";
                ds.Tables[0].Columns["ConfirmDate"].ColumnName = "订单处理时间";
                ds.Tables[0].Columns["Remark"].ColumnName = "订单备注";
                ds.Tables[0].Columns["InvoiceComment"].ColumnName = "发票备注";
                ds.Tables[0].Columns["ArticleNumber"].ColumnName = "产品编号";
                ds.Tables[0].Columns["CFNChineseName"].ColumnName = "产品中文名称";
                ds.Tables[0].Columns["CFNEnglishName"].ColumnName = "产品英文名称";
                ds.Tables[0].Columns["POD_LotNumber"].ColumnName = "批号";
                ds.Tables[0].Columns["POD_QRCode"].ColumnName = "二维码";
                ds.Tables[0].Columns["RequiredQty"].ColumnName = "订购数量";
                ds.Tables[0].Columns["Amount"].ColumnName = "订单金额小计";
                ds.Tables[0].Columns["ReceiptQty"].ColumnName = "已发货数量";
                ds.Tables[0].Columns["ReceiptAmount"].ColumnName = "已发货金额小计";
                ds.Tables[0].Columns["POD_CurRegNo"].ColumnName = "注册证编号-1";
                ds.Tables[0].Columns["POD_CurManuName"].ColumnName = "生产企业(注册证-1)";
                ds.Tables[0].Columns["POD_LastRegNo"].ColumnName = "注册证编号-2";
                ds.Tables[0].Columns["POD_LastManuName"].ColumnName = "生产企业(注册证-2)";
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
