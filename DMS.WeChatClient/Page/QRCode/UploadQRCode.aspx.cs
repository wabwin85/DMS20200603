using System;
using System.Collections.Generic;
using System.Data;
using System.Dynamic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Model.WeChat;
using DMS.WeChatClient.Common;
using DMS.WeChatClient.Page.Project;
using Newtonsoft.Json;

namespace DMS.WeChatClient.Page.QRCode
{
    public partial class UploadQRCode : QRCodeBasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static HandleResult GetWxConfigParameter(string url)
        {
            HandleResult result = new HandleResult() { success = false, msg = string.Empty };
            try
            {
                DateTime dtBeginGetWxConfigParameter = System.DateTime.Now;
                string appId = Config.AppId;
                string accessToken = WeChatHelper.GetAccessToken();//取AccessToken用于下面几个方法
                string timestamp = WeChatHelper.GetTimestamp();
                string nonceStr = WeChatHelper.GetNoncestr();
                string signature = WeChatHelper.GetJsSignature(url, timestamp, nonceStr);
                result.data = new
                {
                    timestamp = timestamp,
                    nonceStr = nonceStr,
                    signature = signature,
                    appId = appId
                };
                result.success = true;
            }
            catch (Exception e)
            {
                result.success = false;
                result.msg = e.Message;
            }
            return result;
        }

    }
}