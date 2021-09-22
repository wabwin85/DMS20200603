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
    public class HospitalPickerService : ABaseQueryService
    {
        public HospitalPickerVO Init(HospitalPickerVO model)
        {
            try
            {
                IList<Territory> Provinces = Store_RefreshProvinces();
                ArrayList res = new ArrayList();
                res.AddRange(Provinces.ToList());
                model.RstResultProvincesList = res;

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
        public HospitalPickerVO BindCity(HospitalPickerVO model)
        {
            try
            {
                string parentId = model.parentId;
                IList<Territory> Provinces = Store_RefreshTerritorys(parentId);
                ArrayList res = new ArrayList();
                res.AddRange(Provinces.ToList());
                model.RstResultCityList = res;
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
        public HospitalPickerVO BindArea(HospitalPickerVO model)
        {
            try
            {
                string parentId = model.parentId;
                IList<Territory> Provinces = Store_RefreshTerritorys(parentId);
                ArrayList res = new ArrayList();
                res.AddRange(Provinces.ToList());
                model.RstResultCityList = res;

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

        public string Query(HospitalPickerVO model)
        {
            try
            {
                IHospitals bll = new Hospitals();
                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                Hashtable tb = new Hashtable();

                tb.Add("HosHospitalName", model.QryHospitalName);
                tb.Add("HosProvince", model.QryProvince);
                tb.Add("HosCity", model.QryCity);
                tb.Add("HosDistrict", model.QryDistrict);

                if (model.IsFilterAuth)
                {
                    //根据授权过滤获取医院信息
                    Guid lineId = new Guid(model.QrySelectedProductLine);

                    tb.Add("DealerID", RoleModelContext.Current.User.CorpId.Value);
                    tb.Add("lineId", lineId);

                    if (RoleModelContext.Current.User.CorpType == "T1")
                    {
                        DataSet DB = bll.GetAuthorizationHospitalListT1(tb, start, model.PageSize, out totalCount);
                        model.RstResultList = JsonHelper.DataTableToArrayList(DB.Tables[0]);
                    }
                    if (RoleModelContext.Current.User.CorpType == "LP")
                    {
                        DataSet DB = bll.GetAuthorizationHospitalList(tb, start, model.PageSize, out totalCount);
                        model.RstResultList = JsonHelper.DataTableToArrayList(DB.Tables[0]);
                    }
                    //TODO：待添加内部用户岗位和医院的过滤
                }
                else
                {
                    //根据产品线过滤获取医院信息
                    Hospital param = new Hospital();

                    param.HosProvince = model.QryProvince;
                    param.HosCity = model.QryCity;
                    param.HosDistrict = model.QryDistrict;
                    param.HosHospitalName = model.QryHospitalName;

                    IList<Hospital> query = null;
                    if ((model.IsFilterProductLine && !string.IsNullOrEmpty(model.ProductLineID)))
                    {
                        //查询当前产品线下所有医院
                        Guid lineId = new Guid(model.ProductLineID);
                        DataSet DB = bll.SelectByProductLine_DataSet(param, ExistsState.IsExists, lineId, start, model.PageSize, out totalCount);
                        model.RstResultList = JsonHelper.DataTableToArrayList(DB.Tables[0]);
                    }
                    else
                    {
                        //所有医院
                        DataSet DB = bll.SelectByFilter_DataSet(param, start, model.PageSize, out totalCount);
                        model.RstResultList = JsonHelper.DataTableToArrayList(DB.Tables[0]);
                    }
                }
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

    }
}
