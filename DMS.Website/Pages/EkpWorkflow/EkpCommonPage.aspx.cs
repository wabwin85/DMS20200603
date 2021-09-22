using DMS.Business.EKPWorkflow;
using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.EKPWorkflow
{
    public partial class EkpCommonPage : System.Web.UI.Page
    {
        public string userLoginId;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (HttpContext.Current.Items["UserLoginId"] != null) {
                userLoginId = Encryption.Encoder(HttpContext.Current.Items["UserLoginId"].ToString());
            }
            else {
                userLoginId = Encryption.Encoder(RoleModelContext.Current.User.LoginId);
            }
        }
    }
}