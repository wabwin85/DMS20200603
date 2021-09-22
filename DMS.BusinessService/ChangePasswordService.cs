using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.DataAccess;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using Lafite.RoleModel.Security;
using System.Data;
using Newtonsoft.Json;
using System.Collections.Specialized;
using DMS.Business.Excel;
using DMS.Business;
using DMS.ViewModel;
using DMS.Model;
using DMS.Business.Cache;
using Lafite.RoleModel.Service;
using System.Web.Security;
using System.Web;

namespace DMS.BusinessService
{
    public class ChangePasswordService : ABaseQueryService
    {
        #region Ajax Method
        public ChangePasswordVO Init(ChangePasswordVO model)
        {
            try
            {                
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

        public ChangePasswordVO Change(ChangePasswordVO model)
        {
            try
            {
                MembershipUser user = Membership.GetUser(RoleModelContext.Current.UserName);
                if (user.IsLockedOut)
                {
                    model.ExecuteMessage.Add("帐号被锁定，请与系统管理员联系！");
                    model.IsSuccess = false;
                    return model;
                }
                if (Membership.ValidateUser(RoleModelContext.Current.UserName, model.OldPassword))
                {
                    try
                    {
                        bool rtn = user.ChangePassword(model.OldPassword, model.NewPassword);
                        if (rtn)
                        {
                            model.ExecuteMessage.Add("修改成功！");
                            model.IsSuccess = true;
                            HttpContext.Current.Session.Remove("needchangepassword");
                        }
                        else
                        {
                            model.ExecuteMessage.Add("修改失败");
                            model.IsSuccess = false;
                        }
                    }
                    catch (Exception ex)
                    {
                        model.ExecuteMessage.Add(ex.Message);
                        model.IsSuccess = false;
                    }
                }
                else
                {
                    model.ExecuteMessage.Add("密码错误，请重新输入，请注意大小写！");
                    model.IsSuccess = false;
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
