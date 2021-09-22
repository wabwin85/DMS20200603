using DMS.Website.Common;
using System;

namespace DMS.Website.Revolution.Pages
{
    public partial class ChangePassword : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
                if (this.Session["needchangepassword"] != null)
                {
                    string url = this.Request.QueryString["ReturnUrl"];
                    if (!string.IsNullOrEmpty(url))
                        this.SuccessUrl.Value = url;
                }
                else
                {
                    this.SuccessUrl.Value = string.Empty;
                }
            }
        }

    }
}
