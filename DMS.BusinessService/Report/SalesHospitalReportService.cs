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
    public class SalesHospitalReportService : ABaseQueryService, IQueryExport
    {
        #region Ajax Method
        ReportDao rptDao = new ReportDao();
        IRoleModelContext context = RoleModelContext.Current;
        public SalesHospitalReportVO Init(SalesHospitalReportVO model)
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
        public SalesHospitalReportVO ChangeBrand(SalesHospitalReportVO model)
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
        public string Query(SalesHospitalReportVO model)
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
                if (context.User.Id != null)
                {
                    param.Add("UserId", context.User.Id);
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = rptDao.SalesHospitalReport(param, start, model.PageSize, out totalCount);
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
            if (Parameters["ExportType"].ToSafeString() == "salesHospital")
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
                if (context.User.Id != null)
                {
                    param.Add("UserId", context.User.Id);
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                int totalCount = 0;
                DataSet ds = rptDao.SalesHospitalReport(param, 0, int.MaxValue, out totalCount);
                //删除多余列               
                ds.Tables[0].Columns.Remove("HOS_ID");
                ds.Tables[0].Columns.Remove("HOS_HospitalShortName");
                ds.Tables[0].Columns.Remove("HOS_Grade");
                ds.Tables[0].Columns.Remove("HOS_Key_Account");
                ds.Tables[0].Columns.Remove("HOS_PublicEmail");
                ds.Tables[0].Columns.Remove("HOS_Town");
                ds.Tables[0].Columns.Remove("HOS_Website");
                ds.Tables[0].Columns.Remove("HOS_DailyOutpatient");

                ds.Tables[0].Columns.Remove("HOS_ICU_BedNumber");
                ds.Tables[0].Columns.Remove("HOS_BedsCount");
                ds.Tables[0].Columns.Remove("HOS_Fax");
                ds.Tables[0].Columns.Remove("HOS_ActiveFlag");
                ds.Tables[0].Columns.Remove("HOS_CreatedDate");
                ds.Tables[0].Columns.Remove("HOS_CreatedBy");
                ds.Tables[0].Columns.Remove("HOS_ChiefEquipment");
                ds.Tables[0].Columns.Remove("HOS_Director");

                ds.Tables[0].Columns.Remove("HOS_ChiefEquipmentContact");
                ds.Tables[0].Columns.Remove("HOS_DirectorContact");
                ds.Tables[0].Columns.Remove("HOS_DeletedFlag");
                ds.Tables[0].Columns.Remove("HOS_LastModifiedDate");
                ds.Tables[0].Columns.Remove("HOS_LastModifiedBy_USR_UserID");
                ds.Tables[0].Columns.Remove("SRN_HOS_ID");
                ds.Tables[0].Columns.Remove("SRH_USR_UserID");

                ds.Tables[0].Columns.Remove("BUM_ID");
                ds.Tables[0].Columns.Remove("row_number");
                //重命名列名
                ds.Tables[0].Columns["SubCompanyName"].ColumnName = "分子公司";
                ds.Tables[0].Columns["BrandName"].ColumnName = "品牌";
                ds.Tables[0].Columns["IDENTITY_NAME"].ColumnName = "销售人员";
                ds.Tables[0].Columns["attribute_name"].ColumnName = "产品线";
                ds.Tables[0].Columns["Region"].ColumnName = "销售人员所属销售区域";
                ds.Tables[0].Columns["HOS_HospitalName"].ColumnName = "负责医院名称";
                ds.Tables[0].Columns["HOS_Province"].ColumnName = "医院省份";
                ds.Tables[0].Columns["HOS_City"].ColumnName = "医院地区";
                ds.Tables[0].Columns["HOS_District"].ColumnName = "医院县市（区）";
                ds.Tables[0].Columns["HOS_PostalCode"].ColumnName = "医院邮编";
                ds.Tables[0].Columns["HOS_Address"].ColumnName = "医院地址";
                ds.Tables[0].Columns["HOS_Phone"].ColumnName = "医院电话";
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
