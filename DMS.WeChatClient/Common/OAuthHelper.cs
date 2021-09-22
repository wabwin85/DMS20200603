using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DMS.Common.Common;
using DMS.Model.WeChat;
using Senparc.Weixin;
using Senparc.Weixin.Cache;
using Senparc.Weixin.Exceptions;
using Senparc.Weixin.MP;
using Senparc.Weixin.MP.AdvancedAPIs;
using Senparc.Weixin.MP.AdvancedAPIs.OAuth;
using Senparc.Weixin.MP.CommonAPIs;
using Senparc.Weixin.MP.Containers;
using Senparc.Weixin.MP.Entities;
using Senparc.Weixin.MP.Helpers;

namespace DMS.WeChatClient.Common
{
    public class WeChatHelper
    {
        private const int tokenExpireSeconds = 7020;
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
                CacheHelper.GetValue(Config.CacheType.OAuthAccessTokenResult.ToString(), code) as OAuthAccessTokenResult;

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
                            CacheHelper.SetValue(Config.CacheType.OAuthUserInfo.ToString(), result.openid, userInfoWeChat);
                        }
                        CacheHelper.SetValue(Config.CacheType.OAuthAccessTokenResult.ToString(), code, result);
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

        public static string GetTimestamp()
        {
            return JSSDKHelper.GetTimestamp();
        }

        public static string GetNoncestr()
        {
            return JSSDKHelper.GetNoncestr();
        }

        public static string GetAccessToken()
        {
            string strAccessToken =
                CacheHelper.GetValue(Config.CacheType.GlobalAccessToken.ToString(),
                    Config.CacheType.GlobalAccessToken.ToString()) as string;
            if (string.IsNullOrEmpty(strAccessToken))
            {
                strAccessToken = CommonApi.GetToken(Config.AppId, Config.AppSecret).access_token;
                UpdateAccessTokenToSenparcCache(strAccessToken);//GetJsSignature()要用到AccessToken
                CacheHelper.SetValue(Config.CacheType.GlobalAccessToken.ToString(),
                    Config.CacheType.GlobalAccessToken.ToString(), strAccessToken, 1.5);
            }
            return strAccessToken;
        }

        private static void UpdateAccessTokenToSenparcCache(string accessToken)
        {
            var cic = LocalContainerCacheStrategy.Instance;
            var oldBag = cic.Get(Config.AppId);
            AccessTokenBag bag = new AccessTokenBag();

            lock (bag)
            {
                if ((bag.AccessTokenExpireTime <= DateTime.Now))
                {
                    bag.AccessTokenResult = new AccessTokenResult()
                    {
                        access_token = accessToken,
                        expires_in = tokenExpireSeconds
                    };
                    bag.AccessTokenExpireTime = DateTime.Now.AddSeconds(tokenExpireSeconds);
                }
            }

            if (oldBag != null)
            {
                AccessTokenBag old = (AccessTokenBag)oldBag;
                old.AccessTokenResult = bag.AccessTokenResult;
                old.AccessTokenExpireTime = bag.AccessTokenExpireTime;
                cic.Update(Config.AppId, old);
            }
            else
            {
                bag.AppId = Config.AppId;
                bag.AppSecret = Config.AppSecret;
                cic.InsertToCache(Config.AppId, bag);
            }
        }


        public static string GetJsSignature(string RequestUrl, string Timestamp, string NonceStr)
        {
            string strSignature;

            string strJsApiTicket = string.Empty;
            string strTimestamp = Timestamp;
            string strNonceStr = NonceStr;
            string strAccessToken = GetAccessToken();//调用该方法防止JsApiTicketContainer.TryGetJsApiTicket()自己调用微信接口取AccessToken
            strJsApiTicket = JsApiTicketContainer.TryGetJsApiTicket(Config.AppId, Config.AppSecret);
            strSignature = JSSDKHelper.GetSignature(strJsApiTicket, strNonceStr, strTimestamp, RequestUrl);

            return strSignature;
        }
    }
}