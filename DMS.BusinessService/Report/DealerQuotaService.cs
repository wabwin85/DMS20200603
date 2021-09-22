using DMS.Business;
using DMS.Business.Excel;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Specialized;
using System.Data;
using DMS.ViewModel.Report;
using DMS.ViewModel.Common;
using System.Collections.Generic;
using System.Linq;
using DMS.DataAccess;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Model;

namespace DMS.BusinessService.Report
{
    public class DealerQuotaService : ABaseQueryService,IQueryExport, IDealerFilterFac
    {
        #region Ajax Method
        ReportDao rptDao = new ReportDao();
        IRoleModelContext context = RoleModelContext.Current;
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public DealerQuotaVO Init(DealerQuotaVO model)
        {
            try
            {
                if (null != BaseService.CurrentSubCompany)
                {
                    DealerMasterDao dealerMasterDao = new DealerMasterDao();
                    DataSet dsAuthBrand = GetAuthBrand(new Guid(BaseService.CurrentSubCompany.Key));
                    model.LstBrand = JsonHelper.DataTableToArrayList(dsAuthBrand.Tables[0]);
                    model.DealerListType = "4";//默认4

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
        public DealerQuotaVO ChangeBrand(DealerQuotaVO model)
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
        public string Query(DealerQuotaVO model)
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
                
                if (!string.IsNullOrEmpty(model.QryContractNo.ToSafeString()))
                {
                    param.Add("ContractNo", model.QryContractNo.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryDealerName.ToSafeString()))
                {
                    param.Add("DealerName", model.QryDealerName.ToSafeString());
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
                DataSet ds = rptDao.DealerQuotaReport(param, start, model.PageSize, out totalCount); 
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
            if (Parameters["ExportType"].ToSafeString() == "ExportDealerQuota")
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
                
                if (!string.IsNullOrEmpty(Parameters["QryContractNo"].ToSafeString()))
                {
                    param.Add("ContractNo", Parameters["QryContractNo"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryDealerName"].ToSafeString()))
                {
                    param.Add("DealerName", Parameters["QryDealerName"].ToSafeString());
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
                DataSet ds = rptDao.DealerQuotaReport(param, 0, int.MaxValue, out totalCount);
                //删除多余列               
                ds.Tables[0].Columns.Remove("row_number");
                //重命名列名
                ds.Tables[0].Columns["SubCompanyName"].ColumnName = "分子公司";
                ds.Tables[0].Columns["BrandName"].ColumnName = "品牌";
                ds.Tables[0].Columns["ProductLineName"].ColumnName = "产品线";
                ds.Tables[0].Columns["EName"].ColumnName = "提交人";
                ds.Tables[0].Columns["ContractNo"].ColumnName = "合同编号";
                ds.Tables[0].Columns["ContractStatusCN"].ColumnName = "合同状态";
                ds.Tables[0].Columns["DivisionName"].ColumnName = "DivisionName";
                ds.Tables[0].Columns["SubBUName"].ColumnName = "SubBUName";
                ds.Tables[0].Columns["DealerName"].ColumnName = "经销商名称";
                ds.Tables[0].Columns["SAPCode"].ColumnName = "ERPCode";
                ds.Tables[0].Columns["DealerType"].ColumnName = "类型";
                ds.Tables[0].Columns["ParentDealerName"].ColumnName = "上级经销商名称";
                ds.Tables[0].Columns["ParentSAPCode"].ColumnName = "上级经销商ERPCode";
                ds.Tables[0].Columns["AgreementBegin"].ColumnName = "合同开始日期";
                ds.Tables[0].Columns["AgreementEnd"].ColumnName = "合同结束日期";
                ds.Tables[0].Columns["Year"].ColumnName = "年份";
                ds.Tables[0].Columns["Amount1"].ColumnName = "1月";
                ds.Tables[0].Columns["Amount2"].ColumnName = "2月";
                ds.Tables[0].Columns["Amount3"].ColumnName = "3月";
                ds.Tables[0].Columns["Amount4"].ColumnName = "4月";
                ds.Tables[0].Columns["Amount5"].ColumnName = "5月";
                ds.Tables[0].Columns["Amount6"].ColumnName = "6月";
                ds.Tables[0].Columns["Amount7"].ColumnName = "7月";
                ds.Tables[0].Columns["Amount8"].ColumnName = "8月";
                ds.Tables[0].Columns["Amount9"].ColumnName = "9月";
                ds.Tables[0].Columns["Amount10"].ColumnName = "10月";
                ds.Tables[0].Columns["Amount11"].ColumnName = "11月";
                ds.Tables[0].Columns["Amount12"].ColumnName = "12月";
                ds.Tables[0].Columns["AmountY"].ColumnName = "全年";
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
