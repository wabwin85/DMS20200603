using System;
using System.Web;

namespace DMS.WeChatClient.Page.Project
{
    public class QRCodeBasePage :System.Web.UI.Page
    {
        protected override void OnLoad(EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                this.Form.Attributes.Add("data-systemtype", "QRCode");
            }
            base.OnLoad(e);
        }
    }
}