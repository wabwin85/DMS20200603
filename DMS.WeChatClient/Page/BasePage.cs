using System;
using System.Data;
using System.Net;
using System.Web;
using DMS.Common.Common;
using DMS.Model;
using DMS.WeChatClient.Common;

namespace DMS.WeChatClient.Page
{
    public class BasePage : System.Web.UI.Page
    {
        public string CurrentUserOpenId
        {
            get { return Form.Attributes["data-openid"]; }
            set { Form.Attributes.Add("data-openid", value); }
        }

        protected override void OnLoad(EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                //用于将OpenId带入到母版页的隐藏字段中
                if (Config.IsDebug)
                {
                    CurrentUserOpenId = "openid_test01";
                }
                else
                {
                    var hanlerResult = WeChatHelper.GetAuthResult(Request.QueryString["code"],
                        Request.QueryString["state"]);

                    if (hanlerResult.success)
                    {
                        CurrentUserOpenId = hanlerResult.data.ToString();
                    }
                    else
                    {
                        GoToErrorPage(hanlerResult.msg);
                    }
                }
            }
            base.OnLoad(e);
        }

        protected void GoToErrorPage(string errormsg = "链接失效，请重新从微信菜单点击进入再进行操作")
        {
            Response.Redirect(
                ResolveUrl(string.Format("~/Page/Error.aspx?ErrorInfo={0}",
                    HttpUtility.UrlEncode(EncryptHelper.EncodeBase64(errormsg)))));
        }
    }
}