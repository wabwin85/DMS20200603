using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Lafite.RoleModel.Security;
using DMS.Model.ViewModel;
using DMS.ViewModel.Common;
using System.Data;

namespace DMS.Business
{
    public class HomeService : BaseService
    {
        public HomeVO InitPage(HomeVO model)
        {
            try
            {
                LafiteDao lafiteDao = new LafiteDao();

                model.IptUserName = UserInfo.FullName;
                InitSubCompany(model);
                model.RstMenuList = JsonHelper.DataTableToArrayList(lafiteDao.SelectUserMenu(UserInfo.Id));

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
        public HomeVO ChangeSubCompany(HomeVO model)
        {
            try
            {
                CurrentSubCompany = new KeyValue(model.IptSubCompanyId, model.IptSubCompanyName);
                //InitBrand(model, true);
                CurrentBrand = null;
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

        public HomeVO ChangeBrand(HomeVO model)
        {
            try
            {
                CurrentBrand = new KeyValue(model.IptBrandId, model.IptBrandName);
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
        private void InitSubCompany(HomeVO model)
        {
            DataSet dsAuthSubCompany = GetAuthSubCompany();
            model.LstSubCompany = JsonHelper.DataTableToArrayList(dsAuthSubCompany.Tables[0]);
            if (null == CurrentSubCompany)
            {
                if (dsAuthSubCompany.Tables.Count > 0 && dsAuthSubCompany.Tables[0].Rows.Count > 0)
                {
                    var firstSubCompany = dsAuthSubCompany.Tables[0].Rows[0];
                    if (null != firstSubCompany)
                    {
                        CurrentSubCompany = new KeyValue(firstSubCompany["Id"].ToString(),
                            firstSubCompany["ATTRIBUTE_NAME"].ToString());
                    }
                }
            }
            model.IptSubCompanyId = CurrentSubCompany?.Key;
            model.IptSubCompanyName = CurrentSubCompany?.Value;
            InitBrand(model);
        }
        private void InitBrand(HomeVO model, bool isSetNewSession = false)
        {
            if (null != CurrentSubCompany)
            {
                DataSet dsAuthBrand = GetAuthBrand(new Guid(CurrentSubCompany.Key));
                model.LstBrand = JsonHelper.DataTableToArrayList(dsAuthBrand.Tables[0]);
                if (null == CurrentBrand || isSetNewSession)
                {
                    if (dsAuthBrand.Tables.Count > 0 && dsAuthBrand.Tables[0].Rows.Count > 0)
                    {
                        var firstBrand = dsAuthBrand.Tables[0].Rows[0];
                        if (null != firstBrand)
                        {
                            CurrentBrand = new KeyValue(firstBrand["Id"].ToString(),
                                firstBrand["ATTRIBUTE_NAME"].ToString());
                        }
                        else
                        {
                            CurrentBrand = null;
                        }
                    }
                }
                model.IptBrandId = CurrentBrand?.Key;
                model.IptBrandName = CurrentBrand?.Value;
            }
            else
            {
                CurrentBrand = null;
            }
        }
    }
}
