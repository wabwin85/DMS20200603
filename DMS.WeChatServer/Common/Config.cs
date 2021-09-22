using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
using System.Web.UI.WebControls;

namespace DMS.WeChatServer.Common
{
    public class Config
    {
        public static string Key = ConfigurationManager.AppSettings["Key"];
        public static string Iv = ConfigurationManager.AppSettings["Iv"];

        public static string BPPlatformServiceUser = ConfigurationManager.AppSettings["BPPlatformServiceUser"];
        public static string BPPlatformServicePassword = ConfigurationManager.AppSettings["BPPlatformServicePassword"];
    }
}