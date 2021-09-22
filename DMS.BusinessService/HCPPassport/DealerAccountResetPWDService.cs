using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess.HCPPassport;
using DMS.ViewModel.Common;
using DMS.ViewModel.HCPPassport;
using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Security;

namespace DMS.BusinessService.HCPPassport
{
    public class DealerAccountResetPWDService : ABaseQueryService
    {
        public DealerAccountResetPWDVO Init(DealerAccountResetPWDVO model)
        {
            try
            {
                DealerAccountDao dao = new DealerAccountDao();
                DataTable tb = new DataTable();
                if (!string.IsNullOrEmpty(model.ID))
                {
                    tb = dao.SelectIDENTITYInfoList(model.ID);
                    model.IptName = tb.Rows[0]["IDENTITY_NAME"].ToString();
                    model.IptUserName= tb.Rows[0]["IDENTITY_CODE"].ToString();
                    //model.RstResultList = JsonHelper.DataTableToArrayList(dao.SelectIDENTITYMAPInfo(model.ID));                   
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

        public DealerAccountResetPWDVO Save(DealerAccountResetPWDVO model)
        {
            try
            {
                MembershipUser user = Membership.GetUser(model.IptUserName);
                if (user.IsLockedOut)
                {
                    model.ExecuteMessage.Add("帐号被锁定，请与系统管理员联系！");
                    model.IsSuccess = false;
                    return model;
                }
                string newPWD = user.ResetPassword();

                try
                {
                    bool rtn = user.ChangePassword(newPWD, model.IptNewPassword);
                    if (rtn)
                    {
                        model.ExecuteMessage.Add("修改成功！");
                        model.IsSuccess = true;
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
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }


        public static String ConvertKeyValueList(IList<KeyValue> Value)
        {
            String result = "";

            if (Value != null)
            {
                for (int i = 0; i < Value.Count; i++)
                {
                    result += Value[i].Key;
                    if (i != Value.Count - 1)
                    {
                        result += ",";
                    }
                }
            }

            return result;
        }


    }
}
