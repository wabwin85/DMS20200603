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

using Lafite.RoleModel.Domain;
using Lafite.RoleModel.Persistence;
using Lafite.RoleModel.Provider;
using Lafite.RoleModel.Service;

namespace DMS.BusinessService.MasterDatas
{
    public class TerritoryListService : ABaseQueryService
    {
        #region Ajax Method

        public TerritoryListVO Init(TerritoryListVO model)
        {
            try
            {
               
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
    

        public string Query(TerritoryListVO model)
        {
            try
            {
                ITerritorys bll = new Territorys();

                Hashtable param = new Hashtable();

                if (!string.IsNullOrEmpty(model.QryProvinceName))
                    param.Add("ProvinceName", model.QryProvinceName.ToSafeString());
                if (!string.IsNullOrEmpty(model.QryCityName))
                    param.Add("CityName", model.QryCityName.ToSafeString());
                if (!string.IsNullOrEmpty(model.QryCountyName))
                    param.Add("CountyName", model.QryCountyName.ToSafeString());
                        

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = bll.GetFullTerritoryList(param, start, model.PageSize, out totalCount);

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
            return JsonConvert.SerializeObject(result);
        }

        public string QueryUploadUserInfo(TerritoryListVO model)
        {
            try
            {
                int totalCount = 0;

                Hashtable param = new Hashtable();
                param.Add("UserId", new Guid(RoleModelContext.Current.User.Id));
                IUserBiz bll = new UserBiz();

                int start = (model.Page - 1) * model.PageSize;
                model.RstResultList = JsonHelper.DataTableToArrayList(bll.QueryUserInfoInitErrorData(param, start, model.PageSize, out totalCount).ToDataSet().Tables[0]);

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

        public TerritoryListVO ImportUserInfo(TerritoryListVO model)
        {
            try
            {
                string RtnVal = string.Empty;
                string RtnMsg = string.Empty;
                IUserBiz bll = new UserBiz();

                bll.UserInfoInitVerify(1, out RtnVal, out RtnMsg);
                if (RtnVal == "Success")
                {
                    bll.DeleteUserInfoInitByUser();
                    model.ExecuteMessage.Add("导入成功！");
                }
                else if (RtnVal == "Error")
                {
                    model.ExecuteMessage.Add("有错误信息，请修改后重新上传！");
                }
                else
                {
                    model.ExecuteMessage.Add(RtnMsg);
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
