using System;
using System.Collections.Generic;
using System.DirectoryServices;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Common.Common;
using DMS.Model.WeChat;
using DMS.WeChatClient.Common;
using Senparc.Weixin.MP.AdvancedAPIs.OAuth;

namespace DMS.WeChatClient.Page
{
    public partial class Navigation : BasePage
    {
        public static Config config = new Config();
        protected void Page_Load(object sender, EventArgs e)
        {
            InitPage();
        }

        private void InitPage()
        {
            Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            var systemtype = Request.QueryString["systemtype"];
            if (!string.IsNullOrEmpty(systemtype))
            {
                hidTab.Value = systemtype;
            }

            OAuthUserInfo userInfoWeChat = CacheHelper.GetValue(Config.CacheType.OAuthUserInfo.ToString(), CurrentUserOpenId) as OAuthUserInfo;
            if (null != userInfoWeChat && !string.IsNullOrEmpty(userInfoWeChat.headimgurl) && Common.Common.IsRemoteFileExists(userInfoWeChat.headimgurl))
            {
                imgAvator.Src = userInfoWeChat.headimgurl;
            }
        }
    }
}