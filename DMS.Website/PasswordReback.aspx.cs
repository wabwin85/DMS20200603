using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using System.Web.Security;

namespace DMS.Website
{

    using Lafite.RoleModel.Security;
    using LafiteProvider = Lafite.RoleModel.Provider;
    using DMS.Business;
    using Lafite.RoleModel.Service;
    using Lafite.RoleModel.Domain;
    using DMS.Model;
    using System.Data;
    using DataAccess.HCPPassport;

    public partial class PasswordReback : System.Web.UI.Page
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        private IMessageBLL _messageBLL = new MessageBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SerialNumber1.Create();
                this.hidname.Value = "";
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            PasswordReback passwordReback = new PasswordReback();
            if (!SerialNumber1.CheckSN(snvTxt1.Text))
            {
                this.lblmsg.InnerHtml = "验证码输入错误，请正确输入(不区分大小写)!";
                this.lblmsg.Style.Add("display", "block");
                SerialNumber1.Create();
                return;
            }
            string strInputUserName = this.txtUserName.Value;
            string username = strInputUserName;
            this.hidname.Value = username;
            string email = this.txtEmail.Value;

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
                            int status = 0;
                            for (int i = 0; i < dt.Rows.Count; i++)
                            {
                                username = dt.Rows[i]["IDENTITY_CODE"].ToString();
                                MembershipUser user = Membership.GetUser(username);
                                if (!user.IsApproved)
                                {
                                    if(status<=1)
                                        status = 1;
                                    continue;
                                }
                                else if(user.Email != email)
                                {
                                    if (status <= 2)
                                        status = 2;
                                    continue;
                                }
                                else
                                {
                                    if (status <= 3)
                                        status = 3;
                                    MailMessageQueue mail = new MailMessageQueue();
                                    try
                                    {
                                        string newpsw = user.ResetPassword();
                                        mail.Id = Guid.NewGuid();
                                        mail.QueueNo = "email";
                                        mail.From = "";
                                        mail.To = email;
                                        mail.Subject = string.Format("尊敬的蓝威用户{0}，您的新密码已修改", strInputUserName);
                                        mail.Body = string.Format(@"尊敬的蓝威用户 {0},</br> 您的新DMS密码是{1}", strInputUserName, newpsw);
                                        mail.Status = "Waiting";
                                        mail.CreateDate = DateTime.Now;
                                        _messageBLL.AddToMailMessageQueue(mail);
                                        this.lblmsg.InnerHtml = "密码重置成功";
                                        this.lblmsg.Style.Add("display", "block");
                                    }
                                    catch (Exception ex)
                                    {
                                        throw ex;
                                    }
                                    break;
                                }
                            }
                            if (status == 1)
                            {
                                this.lblmsg.InnerHtml = "帐号已失效，不能重置密码！";
                                this.lblmsg.Style.Add("display", "block");
                                SerialNumber1.Create();
                                return;
                            }
                            else if (status == 2)
                            {
                                this.lblmsg.InnerHtml = "账号与备案邮箱不匹配，请重新输入！";
                                this.lblmsg.Style.Add("display", "block");
                                SerialNumber1.Create();
                                return;
                            }
                        }                       
                    }                  
                }
            }
            else
            {
                this.lblmsg.InnerHtml = "请输入登录账号！";
                this.lblmsg.Style.Add("display", "block");
                SerialNumber1.Create();
                return;
            }
        }
    }
}
