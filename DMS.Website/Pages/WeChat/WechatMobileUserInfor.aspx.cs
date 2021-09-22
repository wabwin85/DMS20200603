using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using System.Collections;
using System.Data;
using DMS.Business;
using DMS.Model;

namespace DMS.Website.Pages.WeChat
{
    public partial class WechatMobileUserInfor : BasePage
    {
        private IWeChatBaseBLL _WhatBase = new WeChatBaseBLL();
        private IMessageBLL _messageBLL = new MessageBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) 
            {
                this.hfDealerId.Value = "";
                this.hfDealerType.Value = "";
                this.lbDealerName.Text = "";
                if (this.Request.QueryString["DealerId"] != null &&
                    this.Request.QueryString["DealerName"] != null && this.Request.QueryString["DealerType"] != null)
                {
                    this.lbDealerName.Text = this.Request.QueryString["DealerName"].ToString();
                    this.hfDealerId.Value = this.Request.QueryString["DealerId"].ToString();
                    this.hfDealerType.Value = this.Request.QueryString["DealerType"].ToString();
                    bindDdl();
                }
                else 
                {
                    this.Response.Redirect("~/WechatLogin.aspx");
                }
            }
        }

        private void bindDdl() 
        {
            Hashtable obj = new Hashtable();
            DataSet ds = _WhatBase.GetUserPosition(obj);
            this.cbTextPosition.DataSource = ds;
            this.cbTextPosition.DataBind();
        }

        protected void btnSubmintUser_Click(object sender, EventArgs e)
        {
            string massage = "";
            if (String.IsNullOrEmpty(this.tfTextName.Text))
            {
                massage += "请填写姓名<br/>";
            }
            if (String.IsNullOrEmpty(this.nfTextPhone.Text))
            {
                massage += "请填写手机号码<br/>";
            }
            if (String.IsNullOrEmpty(this.cbTextPosition.SelectedItem.Value))
            {
                massage += "请选择职位<br/>";
            }
            if (String.IsNullOrEmpty(this.tfTextMail.Text))
            {
                massage += "请填写邮箱<br/>";
            }


            if (massage == "")
            {
                BusinessWechatUser user = new BusinessWechatUser();
                //Create
                user.Id = Guid.NewGuid();
                user.UserName = this.tfTextName.Text;
                user.Phone = this.nfTextPhone.Text;
                //user.NickName = this.tfTextNickName.Text;
                user.Post = this.cbTextPosition.SelectedItem.Value;
                user.Sex = (this.ddlGender.SelectedValue == "radioSexB" ? "1" : "0");
                user.Email = this.tfTextMail.Text;
                user.DealerId = new Guid(this.hfDealerId.Value) ;
                user.DealerName = this.lbDealerName.Text;
                user.DealerType = this.hfDealerType.Value;
                user.Status = "Active";

                if (CheckUserBind(user, "insert"))
                {
                    Random rad = new Random();
                    user.Rv1 = rad.Next(1000, 10000).ToString();

                    _WhatBase.InsertUser(user);
                    SendMail(user.Rv1, user.Email);
                    SendMassage(user.Rv1, user.Phone);

                    Hashtable obj = new Hashtable();
                    obj.Add("DmaId", user.DealerId.Value.ToString());
                    obj.Add("UserId", user.Id.ToString());

                    _WhatBase.InsertUserProductLine(obj);
                }
                else
                {
                    massage = "该手机号已被注册！<br/>";
                }
            }
            if (!massage.Equals(""))
            {
                massage = massage.Substring(0, massage.Length - 5);
                this.ltMassage.Text = massage;
            }
            else
            {
                clearValues();
                Response.Write("<Script lanuage='javascript'>alert('注册成功！')</Script>");
            }

            
        }

        private bool CheckUserBind(BusinessWechatUser user, string OperatType)
        {
            Hashtable obj = new Hashtable();
            obj.Add("Phone", user.Phone);
            DataTable dt = _WhatBase.GetUser(obj).Tables[0];

            if (dt.Rows.Count > 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        private void SendMail(string Verifi, string MailAddress)
        {
            MailMessageTemplate mailMessage = _messageBLL.GetMailMessageTemplate("EMAL_DRM_WECHART_VERIFI");

            MailMessageQueue mail = new MailMessageQueue();
            mail.Id = Guid.NewGuid();
            mail.QueueNo = "email";
            mail.From = "";
            mail.To = MailAddress;
            mail.Subject = mailMessage.Subject;
            mail.Body = mailMessage.Body.Replace("{#VERIFI}", Verifi);
            mail.Status = "Waiting";
            mail.CreateDate = DateTime.Now;
            _messageBLL.AddToMailMessageQueue(mail);
        }

        private void SendMassage(string Verifi, string massageTo)
        {
            ShortMessageQueue massage = new ShortMessageQueue();
            massage.Id = Guid.NewGuid();
            massage.QueueNo = "sms";
            massage.To = massageTo;
            massage.Message = "您的BSC微信验证码为：" + Verifi + "   请在微信中输入：“手机号”+“空格”+“验证码” ，进行账号绑定【无需输入“+”号  例如：13800000000 2161】";
            massage.Status = "Waiting";
            massage.CreateDate = DateTime.Now;
            _messageBLL.AddToShortMessageQueue(massage);
        }

        private void clearValues() 
        {
            this.tfTextName.Text = "";
            this.tfTextMail.Text = "";
            this.nfTextPhone.Text="";
            this.ddlGender.SelectedIndex = 0;
            this.cbTextPosition.SelectedIndex = 0;
            this.ltMassage.Text = "";

        }
    }
}
