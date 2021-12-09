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
                        param.Add("Province",model.Province);
                    }
                }
                if (!string.IsNullOrEmpty(model.City.ToSafeString()))
                {
                    if (model.City.Key != "")
                    {
                        param.Add("City", model.City);
                    }
                }
                if (!string.IsNullOrEmpty(model.District.ToSafeString()))
                {
                    if (model.District.Key != "")
                    {
                        param.Add("District", model.District);
                    }
                }
                if (!string.IsNullOrEmpty(model.SubCompanyName.ToSafeString()))
                    param.Add("SubCompanyName", model.SubCompanyName);
                if (!string.IsNullOrEmpty(model.BrandName.ToSafeString()))
                    param.Add("BrandName", model.BrandName);
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
            var data = new { data = model.RstResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result); 
        }

        public void Export(NameValueCollection Parameters, String DownloadCookie)
        {

        }
    }
}
