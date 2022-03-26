using DMS.Business;
using DMS.Business.MasterData;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.Model;
using DMS.ViewModel.MasterDatas.Extense;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Data;
using DMS.Business.Excel;

namespace DMS.BusinessService.MasterDatas
{
    public class InvHospitalService: ABaseQueryService, IQueryExport
    {

        IRoleModelContext _context = RoleModelContext.Current;
        IInvHospitalBLL business = new InvHospitalBLL();

        public InvHospitalCfgVO Init(InvHospitalCfgVO model)
        {
            try
            {
                ITerritorys bll = new Territorys();
                IList<Territory> provinces = bll.GetProvinces();
                model.LstProvinces = JsonHelper.DataTableToArrayList(provinces.ToDataSet().Tables[0]);
               
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(InvHospitalCfgVO model) 
        { 
            try
            {
                Hashtable param = new Hashtable();
                if(!string.IsNullOrEmpty(model.Province.ToSafeString()))
                {
                    if(model.Province.Key != "")
                    {
                        param.Add("Province",model.Province.Value);
                    }
                }
                if (!string.IsNullOrEmpty(model.City.ToSafeString()))
                {
                    if (model.City.Key != "")
                    {
                        param.Add("City", model.City.Value);
                    }
                }
                if (!string.IsNullOrEmpty(model.District.ToSafeString()))
                {
                    if (model.District.Key != "")
                    {
                        param.Add("District", model.District.Value);
                    }
                } 
                if (!string.IsNullOrEmpty(model.HospitalName))
                    param.Add("HospitalName",model.HospitalName);
                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryInvHospitalCfg(param, start, model.PageSize, out totalCount);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;

            }
            catch(Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.RstResultList, total = model.DataCount,exception=model.ExecuteMessage };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result); 
        }

        public InvHospitalCfgVO ProvinceChange(InvHospitalCfgVO model) 
        {
            try
            {
                if (!string.IsNullOrEmpty(model.Province.Key))
                {
                    ITerritorys bll = new Territorys();

                    IList<Territory> cities = bll.GetTerritorysByParent(new Guid(model.Province.Key.ToSafeString()));

                    model.LstCities = JsonHelper.DataTableToArrayList(cities.ToDataSet().Tables[0]);
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

        public InvHospitalCfgVO RegionChange(InvHospitalCfgVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.City.Key))
                {
                    ITerritorys bll = new Territorys();

                    IList<Territory> town = bll.GetTerritorysByParent(new Guid(model.City.Key.ToSafeString()));

                    model.LstDistricts = JsonHelper.DataTableToArrayList(town.ToDataSet().Tables[0]);
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

        public InvHospitalCfgVO Delete(InvHospitalCfgVO model)
        {
            bool tag = false;
            try
            {
                if (!string.IsNullOrEmpty(model.DeleteSeleteIDs))
                {
                    tag = business.Delete(model.DeleteSeleteIDs);
                    model.IsSuccess = true;
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

        public void Export(NameValueCollection Parameters, String DownloadCookie)
        {
            Hashtable param = new Hashtable();
            if(!string.IsNullOrEmpty(Parameters["province"].ToSafeString()))
            {
                param.Add("Province", Parameters["province"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["city"].ToSafeString()))
            {
                param.Add("City", Parameters["city"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["district"].ToSafeString()))
            {
                param.Add("District", Parameters["district"].ToSafeString());
            }
             
            if (!string.IsNullOrEmpty(Parameters["hospitalName"].ToSafeString()))
                param.Add("HospitalName", Parameters["hospitalName"].ToSafeString());

            DataSet ds = business.QueryInvHospitalCfgExport(param);
            DataSet dsExport = new DataSet("发票医院映射表");

            if (ds != null)
            {
                DataTable dt = 
                    ds.Tables[0];
                DataTable dtData = dt.Copy();

                if (null != dtData)
                {
                    Dictionary<string, string> dict = new Dictionary<string, string>
                        { 
                            {"DMSHospitalName","DMS医院名称"},
                            {"InvHospitalName","发票医院名称"},
                            {"Hos_Code", "医院编号"},
                            {"Hos_SFECode", "SFE医院编号"},
                            {"Hos_Province", "省份"},
                            {"Hos_City", "地区"},
                            {"Hos_District", "区县"}  
                        };

                    CommonFunction.SetColumnIndexAndRemoveColumn(dtData, dict);
                    dsExport.Tables.Add(dtData);
                }

                ExportFile(dsExport, DownloadCookie);
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
    }
}
