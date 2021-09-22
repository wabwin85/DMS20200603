using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Controls
{
    using Lafite.RoleModel.Security;
    using DMS.Business.Data;
    using Coolite.Ext.Web;

    using System.Web.Security;

    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.ClientID)]
    public partial class TopControl : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.lbWelcome.Text = this.LoginName;
            }
        }


        //private const string WelcomeFormat = "欢迎, {0}, {1}";
        public string LoginName
        {
            get
            {
                if (HttpContext.Current.User.Identity.IsAuthenticated)
                {
                    string corpName = string.Empty;

                    IRoleModelContext context = RoleModelContext.Current;
                    corpName = context.User.GetCorporationName();


                    string welcome = string.Format(GetLocalResourceObject("WelcomeFormat").ToString(), 
                        corpName == string.Empty ? "BSC":corpName,
                            //_context.User.LoginId,
                            //HttpContext.Current.User.Identity.Name
                            context.User.FullName + "(" + context.User.LoginId +")"
                        );

                    return welcome;
                }
                else
                    return string.Empty;
            }
        }


        [AjaxMethod]
        public void Logout()
        {
            IRoleModelContext context = RoleModelContext.Current;
            if(context != null)
                context.User.FlushCache();

            FormsAuthentication.SignOut();
            this.Response.Redirect(FormsAuthentication.LoginUrl);
        }
    }
}