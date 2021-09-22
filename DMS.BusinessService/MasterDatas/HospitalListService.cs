using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.MasterDatas;
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

namespace DMS.BusinessService.MasterDatas
{
    public class HospitalListService : ABaseQueryService
    {
        #region Ajax Method

        public HospitalListVO Init(HospitalListVO model)
        {
            try
            {
                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_Hospital_Grade);
                model.LstHPLGrade = JsonHelper.DataTableToArrayList(dicts.ToArray().ToDataSet().Tables[0]);
                ITerritorys bll = new Territorys();
                IList<Territory> provinces = bll.GetProvinces();
                model.LstHPLProvince = JsonHelper.DataTableToArrayList(provinces.ToDataSet().Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public HospitalListVO ProvinceChange(HospitalListVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.QryHPLProvince.Key))
                {
                    ITerritorys bll = new Territorys();

                    IList<Territory> cities = bll.GetTerritorysByParent(new Guid(model.QryHPLProvince.Key.ToSafeString()));

                    model.LstHPLRegion = JsonHelper.DataTableToArrayList(cities.ToDataSet().Tables[0]);
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

        public HospitalListVO RegionChange(HospitalListVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.QryHPLRegion.Key))
                {
                    ITerritorys bll = new Territorys();

                    IList<Territory> town = bll.GetTerritorysByParent(new Guid(model.QryHPLRegion.Key.ToSafeString()));

                    model.LstHPLTown = JsonHelper.DataTableToArrayList(town.ToDataSet().Tables[0]);
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

        public string Query(HospitalListVO model)
        {
            try
            {
                IHospitals bll = new Hospitals();

                Hospital param = new Hospital();
                if (!string.IsNullOrEmpty(model.QryHPLName))
                    param.HosHospitalName = model.QryHPLName.ToSafeString();
                if (!string.IsNullOrEmpty(model.QryHPLDean))
                    param.HosDirector = model.QryHPLDean.ToSafeString();
                if (!string.IsNullOrEmpty(model.QryHPLGrade.Key))
                    param.HosGrade = model.QryHPLGrade.Key.ToSafeString();
                if (!string.IsNullOrEmpty(model.QryHPLProvince.Key))
                    param.HosProvince = model.QryHPLProvince.Value.ToSafeString();
                if (!string.IsNullOrEmpty(model.QryHPLRegion.Key))
                    param.HosCity = model.QryHPLRegion.Value.ToSafeString();
                if (!string.IsNullOrEmpty(model.QryHPLTown.Key))
                    param.HosDistrict = model.QryHPLTown.Value.ToSafeString();

                IList<Hospital> query = null;

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                query = bll.SelectByFilter(param, start, model.PageSize, out totalCount);

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

        public HospitalListVO DeleteData(HospitalListVO model)
        {
            try
            {
                HospitalDao dao = new HospitalDao();
                for (int i = 0; i < model.LstHosID.Count; i++)
                {
                    Hospital hospital = new Hospital();
                    hospital.HosId = model.LstHosID[i].ToSafeString().ToSafeGuid();
                    hospital.HosDeletedFlag = true;
                    hospital.HosLastModifiedDate = DateTime.Now;
                    hospital.HosLastModifiedByUsrUserid = new Guid(RoleModelContext.Current.User.Id);

                    dao.FakeDelete(hospital);
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

        #endregion
    }
}
