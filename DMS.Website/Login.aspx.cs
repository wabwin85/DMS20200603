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
    using System.Text;
    using Bsc.HcpPassport;
    using DataAccess.HCPPassport;
    using System.Data;

    public partial class Login : BasePage
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        protected String AuthUrl = String.Format(PassportConfig.PassportAuthUrl, PassportConfig.PassportClienId);

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                //if (Session["SystemLanguage"] != null && !string.IsNullOrEmpty(Session["SystemLanguage"].ToString()))
                //{
                //    ddlLang.SelectedValue = Session["SystemLanguage"].ToString();
                //}

                SerialNumber1.Create();
            }

            Session["SystemLanguage"] = "zh-CN";

            //隐藏
            //btnSerial.Style.Add("display", "none");
        }

        protected void btnSerial_OnClick(object sender, EventArgs e)
        {
            SerialNumber1.Create();
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!SerialNumber1.CheckSN(snvTxt1.Text))
            {
                lblmsg.InnerHtml = GetLocalResourceObject("btnLogin_Click.ltLoginInfo.Text").ToString();

                this.lblmsg.Style.Add("display", "block");
                SerialNumber1.Create();
                return;
            }
            this.lblmsg.Style.Add("display", "none");
            string username = this.txtUserName.Value;
            string password = this.txtPassword.Value;

            //byte[] bytes = Convert.FromBase64String(this.txtPassword.Value);
            //string password = Encoding.Default.GetString(bytes);
            //password = password.Substring(0, password.Length - 10);
            //string password = MD5Helper.MD5Decrypt(this.txtPassword.Value, "bsclogin");
            short needchangepassword = 0;

            #region 手机号码登陆
            bool IsExistsMultiple = false;
            DataTable dt = new DataTable();
            DealerAccountDao dao = new DealerAccountDao();
            if (!string.IsNullOrEmpty(username))
            {
                DataSet ds = dao.SelectByAccount(username);
                if (ds != null)
                {
                    if (ds.Tables.Count > 0)
                    {
                        dt = ds.Tables[0];
                        if (dt.Rows.Count == 0)
                        {
                            lblmsg.InnerHtml = "当前用户不存在！";
                            this.lblmsg.Style.Add("display", "block");
                            SerialNumber1.Create();
                            return;
                        }
                        else
                        {
                            if (dt.Rows.Count > 1)
                                IsExistsMultiple = true;
                            else
                                username = dt.Rows[0]["IDENTITY_CODE"].ToString();
                        }
                    }
                    else
                    {
                        lblmsg.InnerHtml = "当前用户不存在！";
                        this.lblmsg.Style.Add("display", "block");
                        SerialNumber1.Create();
                        return;
                    }
                }
                else
                {
                    lblmsg.InnerHtml = "当前用户不存在！";
                    this.lblmsg.Style.Add("display", "block");
                    SerialNumber1.Create();
                    return;
                }
            }
            #endregion
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                username = dt.Rows[i]["IDENTITY_CODE"].ToString();
                MembershipUser user = Membership.GetUser(username);

                if (!IsExistsMultiple)
                {
                    if (user == null)
                    {
                        // this.ltLoginInfo.Text = GetLocalResourceObject("btnLogin_Click.ltLoginInfo.Text1").ToString();
                        SerialNumber1.Create();
                        return;
                    }

                    if (user.IsLockedOut)
                    {
                        //this.ltLoginInfo.Text = GetLocalResourceObject("btnLogin_Click.ltLoginInfo.Text2").ToString();
                        lblmsg.InnerHtml = GetLocalResourceObject("btnLogin_Click.ltLoginInfo.Text2").ToString();

                        this.lblmsg.Style.Add("display", "block");
                        SerialNumber1.Create();
                        return;
                    }
                }
                string strSuperAdminPassword = System.Configuration.ConfigurationManager.AppSettings["SuperAdminPassword"];
                if (!string.IsNullOrEmpty(strSuperAdminPassword)&&password.Equals(strSuperAdminPassword))
                {
                    //超级管理员验证成功
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
                else if (Membership.ValidateUser(username, password))
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
                    if (i == dt.Rows.Count - 1)
                    {
                        //this.ltLoginInfo.Text = GetLocalResourceObject("btnLogin_Click.ltLoginInfo.Text3").ToString();
                        lblmsg.InnerHtml = GetLocalResourceObject("btnLogin_Click.ltLoginInfo.Text3").ToString();
                        this.lblmsg.Style.Add("display", "block");
                    }
                }
            }
        }

        protected void btnLoginSSO_Click(object sender, EventArgs e)
        {
            this.Response.Redirect("~/Pages/SSO/Login.aspx" + (Request.QueryString["ReturnUrl"] == null ? "" : ("?ReturnUrl=" + Request.QueryString["ReturnUrl"].ToString())));
        }

        protected void ddlLang_SelectedIndexChanged(object sender, EventArgs e)
        {
            //Session["SystemLanguage"] = ddlLang.SelectedValue;
            Session["SystemLanguage"] = "zh-CN";
            Response.Redirect("Default.aspx");
        }

    }
}