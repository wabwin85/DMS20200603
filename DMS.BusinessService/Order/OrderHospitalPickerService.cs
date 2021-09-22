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

namespace DMS.BusinessService.Order
{
    public class OrderHospitalPickerService : ABaseQueryService
    {
        public OrderHospitalPickerVO Init(OrderHospitalPickerVO model)
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
        public OrderHospitalPickerVO BindCity(OrderHospitalPickerVO model)
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
        public OrderHospitalPickerVO BindArea(OrderHospitalPickerVO model)
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

        public string Query(OrderHospitalPickerVO model)
        {
            try
            {
                IHospitals bll = new Hospitals();
                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                Guid lineId = new Guid(model.QrySelectedProductLine);
                Hashtable tb = new Hashtable();

                tb.Add("DealerID", RoleModelContext.Current.User.CorpId.Value);
                tb.Add("lineId", lineId);
                tb.Add("HosHospitalName", model.QryHospitalName);
                tb.Add("HosProvince", model.QryProvince);
                tb.Add("HosCity", model.QryCity);
                tb.Add("HosDistrict", model.QryDistrict);
                if (RoleModelContext.Current.User.CorpType == "T1")
                {
                    DataSet DB = bll.GetAuthorizationHospitalListT1(tb, start, model.PageSize, out totalCount);
                    model.RstResultList = JsonHelper.DataTableToArrayList(DB.Tables[0]);
                }
                if (RoleModelContext.Current.User.CorpType == "LP")
                {
                    DataSet DB = bll.GetAuthorizationHospitalList(tb, start, model.PageSize, out totalCount);
                    model.RstResultList = model.RstResultList = JsonHelper.DataTableToArrayList(DB.Tables[0]);
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
