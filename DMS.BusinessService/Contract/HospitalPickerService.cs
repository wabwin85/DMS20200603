using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.Model;
using DMS.ViewModel.Order;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DMS.ViewModel.Contract;

namespace DMS.BusinessService.Contract
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
                model.LstHospitalLevel = new ArrayList(DictionaryHelper.GetDictionary(SR.Consts_Hospital_Grade).ToList());
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
                IList<Territory> Citys = Store_RefreshTerritorys(parentId);
                ArrayList res = new ArrayList();
                res.AddRange(Citys.ToList());
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
                IList<Territory> Areas = Store_RefreshTerritorys(parentId);
                ArrayList res = new ArrayList();
                res.AddRange(Areas.ToList());
                model.RstResultAreaList = res;

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
                Guid lineId = new Guid(model.QrySelectedProductLine);
                Hospital param = new Hospital();              

                param.HosHospitalName = model.QryHospitalName;
                param.HosGrade = model.QryHospitalLevel;

                param.HosProvince = model.QryProvince;
                param.HosCity = model.QryCity;
                param.HosDistrict = model.QryDistrict;

                if (!string.IsNullOrEmpty(model.QrySelectedProductLine))
                {   //查询当前产品线下所有医院
                    IList<Hospital> hosl = bll.SelectByProductLine(param, ExistsState.IsExists, lineId, start, model.PageSize, out totalCount);
                    model.RstResultList = new ArrayList(hosl.ToList());
                }
                else
                {
                    if (RoleModelContext.Current.User.IdentityType != SR.Consts_System_Dealer_User)
                    {
                        //所有医院

                        IList<Hospital> hosl = bll.SelectByFilter(param, start, model.PageSize, out totalCount);
                        model.RstResultList = new ArrayList(hosl.ToList());
                    }
                    else
                    {
                        //经销商的授权医院
                        IList<Hospital> hosl = bll.SelectHospitalListOfDealerAuthorized(param, RoleModelContext.Current.User.CorpId.Value, start, model.PageSize, out totalCount);
                        model.RstResultList = new ArrayList(hosl.ToList());
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
