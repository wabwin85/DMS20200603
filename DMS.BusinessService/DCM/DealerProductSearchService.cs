using DMS.Business;
using DMS.Business.Cache;
using DMS.Business.Excel;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.DCM;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using DMS.ViewModel.MasterDatas;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.Consignment;
using System.Linq;
using Newtonsoft.Json;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.DataAccess.DataInterface;

namespace DMS.BusinessService.DCM
{
    public class DealerProductSearchService : ABaseQueryService,IQueryExport
    {
        #region Ajax Method
        ICfns cfns = new Cfns();
        IRoleModelContext context = RoleModelContext.Current;
        public DealerProductSearchVO Init(DealerProductSearchVO model)
        {
            try
            {
                model.LstProductline = base.GetProductLine();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(DealerProductSearchVO model)
        {
            try
            {
                Hashtable param = new Hashtable();

                if (model.QryProductLine.ToSafeString() != "" && model.QryProductLine.Key.ToSafeString() != "")
                {
                    param.Add("ProductLineBumId", model.QryProductLine.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryCFN.ToSafeString()))
                {
                    param.Add("CustomerFaceNbr", model.QryCFN.ToSafeString());
                }
                if (context.User.CorpId != null)
                {
                    param.Add("DMA_ID", context.User.CorpId.Value.ToString());
                }
                BaseService.AddCommonFilterCondition(param);
                
                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = cfns.SelectCFNForDealerNotShare(param, start, model.PageSize, out totalCount); 
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

        public string QueryRegistration(DealerProductSearchVO model)
        {
            try
            {
                if(!string.IsNullOrEmpty(model.hidCfnId))
                {
                    Hashtable param = new Hashtable();

                    param.Add("CustomerFaceNbr", model.hidCfnId.ToSafeString());

                    int totalCount = 0;
                    int start = (model.Page - 1) * model.PageSize;
                    DataSet ds = cfns.SelectCFNRegistration(param, start, model.PageSize, out totalCount);
                    model.RstWinRegistration = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                    model.DataCount = totalCount;
                    model.IsSuccess = true;
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstWinRegistration, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        public string QueryRegistrationBylot(DealerProductSearchVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.hidCfnId))
                {
                    Hashtable param = new Hashtable();

                    if (!string.IsNullOrEmpty(model.WinProductLot.ToSafeString()))
                    {
                        param.Add("ProductLot", model.WinProductLot.ToSafeString());
                    }
                    param.Add("CustomerFaceNbr", model.hidCfnId.ToSafeString());

                    int totalCount = 0;
                    int start = (model.Page - 1) * model.PageSize;
                    DataSet ds = cfns.SelectCFNRegistrationBylot(param, start, model.PageSize, out totalCount);
                    model.RstWinRegistrationBylot = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                    model.DataCount = totalCount;
                    model.IsSuccess = true;
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstWinRegistrationBylot, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        public DealerProductSearchVO QueryRegistrationNew(DealerProductSearchVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.hidCfnId.ToSafeString()))
                {
                    var ds = cfns.SelectCFNRegistrationBylotAPI(model.hidCfnId.ToSafeString(), "注册证", "");
                    model.RstWinRegistrationNew = JsonHelper.DataTableToArrayList(ds.ToDataSet().Tables[0]);
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

        public DealerProductSearchVO QueryRegistrationBylotNew(DealerProductSearchVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.hidCfnId.ToSafeString()))
                {
                    var ds = cfns.SelectCFNRegistrationBylotAPI(model.hidCfnId.ToSafeString(), "报关单,检疫检验报告,COA", model.WinProductLotNew.ToSafeString());
                    model.RstWinRegistrationBylotNew = JsonHelper.DataTableToArrayList(ds.ToDataSet().Tables[0]);
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
            if (Parameters["ExportType"].ToSafeString() == "ExportProduct")
            {
                Hashtable param = new Hashtable();

                if (!string.IsNullOrEmpty(Parameters["QryProductLine"].ToSafeString()))
                {
                    param.Add("ProductLineBumId", Parameters["QryProductLine"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryCFN"].ToSafeString()))
                {
                    param.Add("CustomerFaceNbr", Parameters["QryCFN"].ToSafeString());
                }
                if (context.User.CorpId != null)
                {
                    param.Add("DMA_ID", context.User.CorpId.Value.ToString());
                }
                BaseService.AddCommonFilterCondition(param);

                int totalCount = 0;
                DataSet ds = cfns.SelectCFNForDealerNotShare(param, 0, int.MaxValue, out totalCount);
                //删除多余列               
                ds.Tables[0].Columns.Remove("Id");
                ds.Tables[0].Columns.Remove("Implant");
                ds.Tables[0].Columns.Remove("Share");
                ds.Tables[0].Columns.Remove("DeletedFlag");
                ds.Tables[0].Columns.Remove("ProductLineBumId");
                ds.Tables[0].Columns.Remove("LastUpdateUser");
                ds.Tables[0].Columns.Remove("LastUpdateDate");
                ds.Tables[0].Columns.Remove("AttachURL");
                ds.Tables[0].Columns.Remove("row_number");
                ds.Tables[0].Columns.Remove("Property1");
                ds.Tables[0].Columns.Remove("Property2");
                ds.Tables[0].Columns.Remove("Property4");
                ds.Tables[0].Columns.Remove("Property5");
                ds.Tables[0].Columns.Remove("Property6");
                ds.Tables[0].Columns.Remove("Property7");
                ds.Tables[0].Columns.Remove("Tool");
                ds.Tables[0].Columns.Remove("ProductCatagoryPctId");
                ds.Tables[0].Columns.Remove("AttachName");
                //重命名列名
                ds.Tables[0].Columns["CustomerFaceNbr"].ColumnName = "产品型号";
                ds.Tables[0].Columns["SubCompanyName"].ColumnName = "分子公司";
                ds.Tables[0].Columns["BrandName"].ColumnName = "品牌";
                ds.Tables[0].Columns["ProductLineName"].ColumnName = "产品线";
                ds.Tables[0].Columns["EnglishName"].ColumnName = "英文说明";
                ds.Tables[0].Columns["ChineseName"].ColumnName = "中文说明";
                ds.Tables[0].Columns["PCTName"].ColumnName = "产品分类";
                ds.Tables[0].Columns["PCTEnglishName"].ColumnName = "产品分类英文名称";
                ds.Tables[0].Columns["Description"].ColumnName = "描述";
                ds.Tables[0].Columns["Property3"].ColumnName = "单位";
                ds.Tables[0].Columns["Property8"].ColumnName = "是否可售";
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
