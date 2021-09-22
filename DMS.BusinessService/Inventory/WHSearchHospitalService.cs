using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Inventory;
using DMS.DataAccess;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.Consignment;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using System.Linq;
using System.Collections.Generic;
using System.Data;
using DMS.Business.Excel;
using System.Collections.Specialized;
using Newtonsoft.Json;
using DMS.Model;
using DMS.Business;

namespace DMS.BusinessService.Inventory
{
    public class WHSearchHospitalService : ABaseQueryService
    {
        #region Ajax Method

        public WHSearchHospitalVO Init(WHSearchHospitalVO model)
        {
            try
            {
                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_Hospital_Grade);
                model.LstHPLevel = JsonHelper.DataTableToArrayList(dicts.ToArray().ToDataSet().Tables[0]);
                ITerritorys bll = new Territorys();
                IList<Territory> provinces = bll.GetProvinces();
                model.LstHPProvince = JsonHelper.DataTableToArrayList(provinces.ToDataSet().Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public WHSearchHospitalVO ProvinceChange(WHSearchHospitalVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.QryHPProvince.Key))
                {
                    ITerritorys bll = new Territorys();

                    IList<Territory> cities = bll.GetTerritorysByParent(new Guid(model.QryHPProvince.Key.ToSafeString()));

                    model.LstHPRegion = JsonHelper.DataTableToArrayList(cities.ToDataSet().Tables[0]);
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

        public WHSearchHospitalVO RegionChange(WHSearchHospitalVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.QryHPRegion.Key))
                {
                    ITerritorys bll = new Territorys();

                    IList<Territory> town = bll.GetTerritorysByParent(new Guid(model.QryHPRegion.Key.ToSafeString()));

                    model.LstHPTown = JsonHelper.DataTableToArrayList(town.ToDataSet().Tables[0]);
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

        public string Query(WHSearchHospitalVO model)
        {
            try
            {
                IHospitals bll = new Hospitals();

                Hospital param = new Hospital();
                if (!string.IsNullOrEmpty(model.QryHPName))
                    param.HosHospitalName = model.QryHPName.ToSafeString();
                if (!string.IsNullOrEmpty(model.QryHPLevel.Key))
                    param.HosGrade = model.QryHPLevel.Key.ToSafeString();
                if (!string.IsNullOrEmpty(model.QryHPProvince.Key))
                    param.HosProvince = model.QryHPProvince.Value.ToSafeString();
                if (!string.IsNullOrEmpty(model.QryHPRegion.Key))
                    param.HosCity = model.QryHPRegion.Value.ToSafeString();
                if (!string.IsNullOrEmpty(model.QryHPTown.Key))
                    param.HosDistrict = model.QryHPTown.Value.ToSafeString();

                IList<Hospital> query = null;

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                if (RoleModelContext.Current.User.IdentityType != SR.Consts_System_Dealer_User)
                {
                    //所有医院
                    query = bll.SelectByFilter(param, start, model.PageSize, out totalCount);
                }
                else
                {
                    //经销商的授权医院
                    query = bll.SelectHospitalListOfDealerAuthorized(param, RoleModelContext.Current.User.CorpId.Value, start, model.PageSize, out totalCount);
                }

                model.RstResultList = JsonHelper.DataTableToArrayList(query.ToDataSet().Tables[0]);

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
            return JsonConvert.SerializeObject(result);
        }
        

        #endregion
    }
}
