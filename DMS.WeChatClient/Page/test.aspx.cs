using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.WeChatClient.Common;

namespace DMS.WeChatClient.Page
{
    public partial class test : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            WeChatHelper.GetAuthUrl("https://dmswechattest.bpmedtech.com/WeChatClient/Page/Navigation.aspx");
        }
    }
}