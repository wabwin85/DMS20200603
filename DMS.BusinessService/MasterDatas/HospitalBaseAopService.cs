using System;
using DMS.Common.Common;
using DMS.Common;
using System.Data;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Business.DealerTrain;
using DMS.ViewModel.MasterDatas;
using DMS.DataAccess.ContractElectronic;
using System.Collections;
using DMS.Business;
using DMS.DataAccess;
using System.Linq;
using DMS.Model;
using System.Collections.Generic;
using Lafite.RoleModel.Security;
using DMS.Model.Data;
using System.Collections.Specialized;
using DMS.Common.Extention;
using DMS.Business.Excel;
using Newtonsoft.Json;
using DMS.Business.ERPInterface;

namespace DMS.BusinessService.MasterDatas
{
    public class HospitalBaseAopService : ABaseQueryService, IQueryExport
    {
        #region Ajax Method
        public HospitalBaseAopVO Init(HospitalBaseAopVO model)
        {
            try
            {
                model.ListBu = GetProductLine();
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

        public string Query(HospitalBaseAopVO model)
        {
            try
            {
                AOPHospitalReferenceDao dao = new AOPHospitalReferenceDao();
                Hashtable param = GetQueryConditions(model);

                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                param.Add("BrandId", BaseService.CurrentBrand?.Key);
                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = dao.GetAOPHospitalReferencesByFiller(param, start, model.PageSize, out outCont);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = outCont;
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
        public string QueryImport(HospitalBaseAopVO model)
        {
            try
            {
                AOPHospitalReferenceDao dao = new AOPHospitalReferenceDao();

                Hashtable ht = new Hashtable();
                ht.Add("UserId", UserInfo.Id);
                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = dao.GetAOPHospitalReferencesImportErrorData(ht, start, model.PageSize, out outCont);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = outCont;
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
        public HospitalBaseAopVO Delete(HospitalBaseAopVO model)
        {
            AOPHospitalReferenceDao dao = new AOPHospitalReferenceDao();
            try
            {
                if (!string.IsNullOrEmpty(model.DeleteAOPHRID))
                {
                    Hashtable param = new Hashtable();
                    param.Add("ID", model.DeleteAOPHRID);
                    dao.Delete(param);
                    dao.GenerateHospitalMarketProperty();
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("删除出错！");
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
            AOPHospitalReferenceDao dao = new AOPHospitalReferenceDao();
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(Parameters["ProductLineBumId"].ToSafeString()))
            {
                param.Add("ProductLineBumId", Parameters["ProductLineBumId"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Year"].ToSafeString()))
            {
                param.Add("Year", Parameters["Year"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["HospitalName"].ToSafeString()))
            {
                param.Add("HospitalName", Parameters["HospitalName"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["HospitalNbr"].ToSafeString()))
            {
                param.Add("HospitalNbr", Parameters["HospitalNbr"].ToSafeString());
            }

            param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
            param.Add("BrandId", BaseService.CurrentBrand?.Key);
            int totalCount = 0;
            DataSet ds = dao.GetAOPHospitalReferencesByFiller(param, 0, int.MaxValue, out totalCount);
            //删除多余列               
            ds.Tables[0].Columns.Remove("AOPHR_ID");
            ds.Tables[0].Columns.Remove("AOPHR_ProductLine_BUM_ID");
            ds.Tables[0].Columns.Remove("AOPHR_Hospital_ID");
            ds.Tables[0].Columns.Remove("AOPHR_Update_User_ID");
            ds.Tables[0].Columns.Remove("AOPHR_Update_Date");
            ds.Tables[0].Columns.Remove("row_number");
            ds.Tables[0].Columns.Remove("AOPHR_PCT_ID");
            //重命名列名
            ds.Tables[0].Columns["SubCompanyName"].ColumnName = "分子公司";
            ds.Tables[0].Columns["BrandName"].ColumnName = "品牌";
            ds.Tables[0].Columns["ProductLineName"].ColumnName = "产品线";
            ds.Tables[0].Columns["CQ_Name"].ColumnName = "产品分类";
            ds.Tables[0].Columns["AOPHR_Year"].ColumnName = "年份";
            ds.Tables[0].Columns["HOS_HospitalName"].ColumnName = "医院名称";
            ds.Tables[0].Columns["HOS_Key_Account"].ColumnName = "医院编号";
            ds.Tables[0].Columns["AOPHR_January"].ColumnName = "一月";
            ds.Tables[0].Columns["AOPHR_February"].ColumnName = "二月";
            ds.Tables[0].Columns["AOPHR_March"].ColumnName = "三月";
            ds.Tables[0].Columns["AOPHR_April"].ColumnName = "四月";
            ds.Tables[0].Columns["AOPHR_May"].ColumnName = "五月";
            ds.Tables[0].Columns["AOPHR_June"].ColumnName = "六月";
            ds.Tables[0].Columns["AOPHR_July"].ColumnName = "七月";
            ds.Tables[0].Columns["AOPHR_August"].ColumnName = "八月";
            ds.Tables[0].Columns["AOPHR_September"].ColumnName = "九月";
            ds.Tables[0].Columns["AOPHR_October"].ColumnName = "十月";
            ds.Tables[0].Columns["AOPHR_November"].ColumnName = "十一月";
            ds.Tables[0].Columns["AOPHR_December"].ColumnName = "十二月";
            
            ExportFile(ds, DownloadCookie);

        }
        protected void ExportFile(DataSet ds, string Cookie)
        {
            DataSet[] result = new DataSet[1];
            result[0] = ds;

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("ExportFile");
            xlsExport.Export(ht, result, Cookie);
        }
        private Hashtable GetQueryConditions(HospitalBaseAopVO model)
        {
            Hashtable param = new Hashtable();

            if (model.QryBu != null && !string.IsNullOrEmpty(model.QryBu.Key))
            {
                param.Add("ProductLineBumId", model.QryBu.Key);
            }
            if (!string.IsNullOrEmpty(model.QryYear))
            {
                param.Add("Year", model.QryYear);
            }
            if (!string.IsNullOrEmpty(model.QryHospitalName))
            {
                param.Add("HospitalName", model.QryHospitalName);
            }
            if (!string.IsNullOrEmpty(model.QryHospitalNbr))
            {
                param.Add("HospitalNbr", model.QryHospitalNbr);
            }
            
            return param;
        }

        #endregion
    }


}
