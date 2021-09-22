using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;

namespace DMS.Website.Pages
{
    public partial class ChangePassword : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string needchangepass = this.Request.QueryString["pt"];
                lbTitle.Text = "";
                
                if (!string.IsNullOrEmpty(needchangepass))
                {
                    int needchange = Convert.ToUInt16(needchangepass);
                    
                    if(needchange == 1)
                    {
                        lbTitle.Text = GetLocalResourceObject("Page_Load.lbTitle.Text1").ToString();                
                    }
                    else if(needchange == 2)
                    {
                        lbTitle.Text = GetLocalResourceObject("Page_Load.lbTitle.Text2").ToString();
                    }                    
                }
                if(this.Session["needchangepassword"] != null)
                {
                    string url = this.Request.QueryString["ReturnUrl"];
                    if(!string.IsNullOrEmpty(url))
                        this.ChangePassword1.SuccessPageUrl = url;
                }
                else 
                {
                    this.ChangePassword1.SuccessPageUrl = string.Empty;
                }
            }
        }


        protected void ChangePassword1_ChangedPassword(object sender, EventArgs e)
        {
            this.Session.Remove("needchangepassword");
        }

    }
}
