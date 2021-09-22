using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.Business.Cache;
using DMS.Model.WeChat;
using Senparc.Weixin;
using Senparc.Weixin.Exceptions;
using Senparc.Weixin.MP;
using Senparc.Weixin.MP.AdvancedAPIs;
using Senparc.Weixin.MP.AdvancedAPIs.OAuth;

namespace DMS.WeChatClient.Common
{
    public class OAuthHelper
    {
        public static string GetAuthUrl(string redirectUrl)
        {
            if (Config.IsDebug)
            {
                return redirectUrl;
            }
            else
            {
                return OAuthApi.GetAuthorizeUrl(Config.AppId, redirectUrl, Config.AppStateCode, OAuthScope.snsapi_userinfo, "code");
            }
        }

        public static HandleResult GetAuthResult(string code, string state)
        {
            HandleResult handleResult = new HandleResult { success = false };
            var cachedTokenResult =
                WeChatCacheHelper.GetValue(WeChatCacheHelper.CacheType.OAuthAccessTokenResult, code) as OAuthAccessTokenResult;

            if (string.IsNullOrEmpty(code) || state != Config.AppStateCode)
            {
                handleResult.msg = "链接失效，请重新从微信菜单点击进入再进行操作！";
            }
            else if (null != cachedTokenResult)
            {
                handleResult.success = true;
                handleResult.data = cachedTokenResult.openid;
            }
            else
            {
                try
                {
                    var result = OAuthApi.GetAccessToken(Config.AppId, Config.AppSecret, code, "authorization_code");
                    if (result.errcode != ReturnCode.请求成功)
                    {
                        handleResult.msg = "错误：" + result.errmsg;
                    }
                    else
                    {
                        OAuthUserInfo userInfoWeChat = OAuthApi.GetUserInfo(result.access_token, result.openid);
                        if (null != userInfoWeChat)
                        {
                            WeChatCacheHelper.SetValue(WeChatCacheHelper.CacheType.OAuthUserInfo, result.openid, userInfoWeChat);
                        }
                        WeChatCacheHelper.SetValue(WeChatCacheHelper.CacheType.OAuthAccessTokenResult, code, result);
                        Common.WriteLog("GetAuthResult openid:" + result.openid);
                        handleResult.success = true;
                        handleResult.data = result.openid;
                    }
                }
                catch (ErrorJsonResultException ex)
                {
                    handleResult.msg = "错误：" + ex.JsonResult.errmsg;
                    Common.WriteLog("GetAuthResult Error:" + handleResult.msg);
                }
            }
            return handleResult;
        }
    }
}