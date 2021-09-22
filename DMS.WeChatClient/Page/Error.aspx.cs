using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.WeChatClient.Common;

namespace DMS.WeChatClient.Page
{
    public partial class Error : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                string strErrorInfo = Request.QueryString["ErrorInfo"];
                if (!string.IsNullOrEmpty(strErrorInfo))
                {
                    lblInfo.Text = HttpUtility.UrlDecode(EncryptHelper.DecodeBase64(strErrorInfo));
                }
            }
        }
    }
}