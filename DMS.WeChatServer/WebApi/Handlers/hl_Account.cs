using System;
using System.Collections.Generic;
using System.Data;
using System.Dynamic;
using System.Web.Security;
using DMS.Business.HCPPassport;
using DMS.Model.WeChat;
using Lafite.RoleModel.Security;
using LafiteProvider = Lafite.RoleModel.Provider;

namespace DMS.WeChatServer.WebApi.Handlers
{
    public class hl_Account : hl_Base
    {
        public override List<string> GetActionName()
        {
            return new List<string> { "Account" };
        }
        public override HandleResult ProcessMessage(WeChatParams mobileParams)
        {
            HandleResult result = new HandleResult() { success = false, msg = string.Empty };
            try
            {
                var operateType = mobileParams.MethodName;
                if (operateType == "LoginIn")
                {
                    result = LoginIn(mobileParams);
                }
                else if (operateType == "LoginOut")
                {
                    result = LoginOut(mobileParams);
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.msg = ex.ToString();
            }
            return result;
        }
        #region
        public static HandleResult LoginIn(WeChatParams message)
        {
            string strOpenId = message.Parameters["OpenId"].ToString();
            string strUserName = message.Parameters["UserName"].ToString();
            string strPassword = message.Parameters["Password"].ToString();
            HandleResult handleResult = new HandleResult { success = false, msg = string.Empty };
            string strUserCode = strUserName;
            short needchangepassword = 0;
            bool isValidSuccess = true;
            if (!string.IsNullOrEmpty(strOpenId))
            {
                #region 手机号码登陆

                bool IsExistsMultiple = false;
                DataTable dt = new DataTable();
                DealerAccountBLL bllDealerAccount = new DealerAccountBLL();
                if (!string.IsNullOrEmpty(strUserCode))
                {
                    DataSet ds = bllDealerAccount.SelectByAccount(strUserCode);
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        isValidSuccess = true;
                        dt = ds.Tables[0];
                        if (dt.Rows.Count > 1)
                        {
                            IsExistsMultiple = true;
                        }
                        else
                        {
                            strUserCode = dt.Rows[0]["IDENTITY_CODE"].ToString();
                        }
                    }
                    else
                    {
                        isValidSuccess = false;
                        handleResult.msg = "当前用户不存在！";
                    }
                }

                #endregion

                if (isValidSuccess)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        strUserCode = dt.Rows[i]["IDENTITY_CODE"].ToString();
                        MembershipUser user = Membership.GetUser(strUserCode);

                        if (!IsExistsMultiple && user.IsLockedOut)
                        {
                            isValidSuccess = false;
                            handleResult.msg = "当前用户被锁定，请先联系管理员解锁";
                        }
                        string strSuperAdminPassword =
                            System.Configuration.ConfigurationManager.AppSettings["SuperAdminPassword"];
                        if (!string.IsNullOrEmpty(strSuperAdminPassword) && strPassword.Equals(strSuperAdminPassword))
                        {
                            isValidSuccess = true;
                            break;
                        }
                        else if (Membership.ValidateUser(strUserCode, strPassword))
                        {
                            //检查密码是否过期                
                            LafiteProvider.DbMembershipProvider provider =
                                (LafiteProvider.DbMembershipProvider)Membership.Provider;
                            int effectDays = provider.PasswordEffectDays;
                            if (effectDays > 0)
                            {
                                DateTime passwordValidateDate = user.LastPasswordChangedDate.AddDays(effectDays);
                                if (passwordValidateDate < DateTime.Now)
                                    needchangepassword = 2;
                            }

                            if (needchangepassword > 0)
                            {
                                isValidSuccess = false;
                                handleResult.msg = "密码已过有效期，请先在DMS网页上修改密码";
                            }
                            else
                            {
                                isValidSuccess = true;
                                break;
                            }
                        }
                        else
                        {
                            if (i == dt.Rows.Count - 1)
                            {
                                isValidSuccess = false;
                                handleResult.msg = "密码错误，请重新输入，请注意大小写";
                            }
                        }
                    }
                }
                if (isValidSuccess)
                {
                    //将微信账户和DMS系统账户做关联
                    if (bllWeChat.BindWechatUser(strUserName, strOpenId))
                    {
                        handleResult.success = true;
                    }
                    else
                    {
                        handleResult.success = false;
                        handleResult.msg = "账户绑定失败";
                    }
                }
                else
                {
                    handleResult.success = false;
                    if (string.IsNullOrEmpty(handleResult.msg))
                    {
                        handleResult.msg = "登录失败";
                    }
                }
            }
            else
            {
                handleResult.success = false;
                handleResult.msg = "链接失效，请重新从微信菜单点击进入再进行操作";
            }
            return handleResult;
        }
        public static HandleResult LoginOut(WeChatParams message)
        {
            string strOpenId = message.Parameters["OpenId"].ToString();
            HandleResult handleResult = new HandleResult { success = false, msg = "操作失败" };
            if (bllWeChat.UnbindWechatUser(strOpenId))
            {
                handleResult.success = true;
                handleResult.msg = "操作成功";
            }
            return handleResult;
        }
        #endregion
    }
}