using System;
using System.Collections.Generic;
using System.Net;
using System.Web.UI.WebControls;

namespace DMS.WeChatClient.Common
{
    public class Config
    {
        public static string BaseUrl = System.Configuration.ConfigurationManager.AppSettings["BaseUrl"];
        public static string ApiUrl = System.Configuration.ConfigurationManager.AppSettings["ApiUrl"];
        public static string BaseUrl_ServerFilePath = System.Configuration.ConfigurationManager.AppSettings["BaseUrl_ServerFilePath"];
        public static string Key = System.Configuration.ConfigurationManager.AppSettings["Key"];
        public static string Iv = System.Configuration.ConfigurationManager.AppSettings["Iv"];
        public static string AppId = System.Configuration.ConfigurationManager.AppSettings["AppId"];
        public static string AppSecret = System.Configuration.ConfigurationManager.AppSettings["AppSecret"];
        public static string ResourceVersion = System.Configuration.ConfigurationManager.AppSettings["ResourceVersion"];

        public static readonly string AppStateCode =
            System.Configuration.ConfigurationManager.AppSettings["AppStateCode"];

        public static readonly bool IsDebug =
            true.ToString()
                .Equals(System.Configuration.ConfigurationManager.AppSettings["IsDebug"].ToString(),
                    StringComparison.OrdinalIgnoreCase);

        /// <summary>
        /// 缓存类型
        /// </summary>
        public enum CacheType
        {
            OAuthAccessTokenResult,
            OAuthUserInfo,
            GlobalAccessToken
        }
    }
}