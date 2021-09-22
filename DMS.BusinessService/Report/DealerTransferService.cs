﻿using DMS.Business;
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

namespace DMS.BusinessService.Report
{
    public class DealerTransferService : ABaseQueryService,IQueryExport
    {
        #region Ajax Method
        ReportDao rptDao = new ReportDao();
        IRoleModelContext context = RoleModelContext.Current;
        public DealerTransferVO Init(DealerTransferVO model)
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
        public DealerTransferVO ChangeBrand(DealerTransferVO model)
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
        public string Query(DealerTransferVO model)
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
                if(model.QryTransferDate != null && !string.IsNullOrEmpty(model.QryTransferDate.StartDate))
                {
                    param.Add("TransferDateStart", model.QryTransferDate.StartDate);
                }
                if (model.QryTransferDate != null && !string.IsNullOrEmpty(model.QryTransferDate.EndDate))
                {
                    param.Add("TransferDateEnd", model.QryTransferDate.EndDate);
                }
                if (!string.IsNullOrEmpty(model.QryCFN.ToSafeString()))
                {
                    param.Add("CFN", model.QryCFN.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryLotNumber.ToSafeString()))
                {
                    param.Add("LotNumber", model.QryLotNumber.ToSafeString());
                }
                if (context.User.Id != null)
                {
                    param.Add("UserId", context.User.Id);
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = rptDao.DealerTransferReport(param, start, model.PageSize, out totalCount); 
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
            if (Parameters["ExportType"].ToSafeString() == "ExportDealerTransfer")
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
                if (!string.IsNullOrEmpty(Parameters["QryTransferDateStart"].ToSafeString()))
                {
                    param.Add("TransferDateStart", Parameters["QryTransferDateStart"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryTransferDateEnd"].ToSafeString()))
                {
                    param.Add("TransferDateEnd", Parameters["QryTransferDateEnd"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryCFN"].ToSafeString()))
                {
                    param.Add("CFN", Parameters["QryCFN"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryLotNumber"].ToSafeString()))
                {
                    param.Add("LotNumber", Parameters["QryLotNumber"].ToSafeString());
                }
                if (context.User.Id != null)
                {
                    param.Add("UserId", context.User.Id);
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                int totalCount = 0;
                DataSet ds = rptDao.DealerTransferReport(param, 0, int.MaxValue, out totalCount);
                //删除多余列                
                ds.Tables[0].Columns.Remove("row_number");
                ds.Tables[0].Columns.Remove("UPN");
                ds.Tables[0].Columns.Remove("TRN_Transfer_USR_UserID");
                ds.Tables[0].Columns.Remove("CFN_Property1");
                //重命名列名
                ds.Tables[0].Columns["SubCompanyName"].ColumnName = "分子公司";
                ds.Tables[0].Columns["BrandName"].ColumnName = "品牌";
                ds.Tables[0].Columns["DMA_ChineseName"].ColumnName = "经销商名称";
                ds.Tables[0].Columns["DMA_EnglishName"].ColumnName = "经销商英文名称";
                ds.Tables[0].Columns["DMA_SAP_Code"].ColumnName = "ERPCode";
                ds.Tables[0].Columns["ProductLineName"].ColumnName = "产品线";
                ds.Tables[0].Columns["TRN_TransferNumber"].ColumnName = "移库单号";
                ds.Tables[0].Columns["IDENTITY_NAME"].ColumnName = "操作人";
                ds.Tables[0].Columns["TRN_TransferDate"].ColumnName = "移库日期";
                ds.Tables[0].Columns["FromWHName"].ColumnName = "移出仓库";
                ds.Tables[0].Columns["ToWHName"].ColumnName = "移入仓库";
                //ds.Tables[0].Columns["CFN_Property1"].ColumnName = "产品级别";
                ds.Tables[0].Columns["CFN_CustomerFaceNbr"].ColumnName = "产品编号";
                ds.Tables[0].Columns["CFN_ChineseName"].ColumnName = "产品中文名称";
                ds.Tables[0].Columns["CFN_EnglishName"].ColumnName = "产品英文名称";
                ds.Tables[0].Columns["LTM_LotNumber"].ColumnName = "批号";
                ds.Tables[0].Columns["QRCode"].ColumnName = "二维码";
                ds.Tables[0].Columns["LTM_ExpiredDate"].ColumnName = "产品有效期";
                ds.Tables[0].Columns["TLT_TransferLotQty"].ColumnName = "移动数量";
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
