using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using DMS.Model;
using Coolite.Ext.Web;
using Lafite.RoleModel.Security;
using DMS.Business;
using System.Collections;
using System.Data;

namespace DMS.Website.Pages.WeChat
{
    public partial class WeChatUserList : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IWeChatBaseBLL _WhatBase = new WeChatBaseBLL();
        private IDealerMasters _dealerMasters = new DealerMasters();
        private IMessageBLL _messageBLL = new MessageBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["pt"]))
                {
                    hiddenRetrun.Clear();
                 //如果是从登陆界面进入，弹出维护框
                    if (Request.QueryString["pt"].ToString() == "1")
                    {
                        hiddenRetrun.Text = Request.QueryString["pt"].ToString();
                        this.btnReturn.Hidden =true;
                        ShowUserWindow();
                    }
                }
            }
        }

        protected void PositionStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj=new Hashtable ();
            DataSet ds = _WhatBase.GetUserPosition(obj);
            this.PositionStore.DataSource = ds;
            this.PositionStore.DataBind();
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable table = new Hashtable();
            if (!string.IsNullOrEmpty(this.tfName.Text))
            {
                table.Add("UserName", this.tfName.Text);
            }
            if (!string.IsNullOrEmpty(this.cbPosition.SelectedItem.Value))
            {
                table.Add("Post", this.cbPosition.SelectedItem.Value);
            }
            if (RoleModelContext.Current.User.CorpType != null)
            {
                table.Add("DealerId", RoleModelContext.Current.User.CorpId.ToString());
            }

            DataSet ds = _WhatBase.GetUser(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();

            //刷新结果集后重新判断是否显示“返回按钮”
            if (hiddenRetrun.Text == "1")
            {
                Hashtable ht = new Hashtable();
                ht.Add("DealerId", RoleModelContext.Current.User.CorpId.ToString());
                DataSet Dmds = _WhatBase.GetUser(ht);
                if (Dmds.Tables[0].Rows.Count > 0)
                {
                    //如果已维护了该经销商，返回按钮显示
                    this.btnReturn.Hidden = false;
                }
                else
                {
                    this.btnReturn.Hidden = true;
                }
            }
        }

        [AjaxMethod]
        public void ShowUserWindow()
        {
            InitUserWindow(true);

            //Show Window
            this.UserInputWindow.Show();
        }

        [AjaxMethod]
        public void EditUserItem(string detailId)
        {
            InitUserWindow(true);

            if (!string.IsNullOrEmpty(detailId))
            {
                LoadUserWindow(new Guid(detailId));

                //Set Value
                this.userId.Text = detailId;

                //Show Window
                this.UserInputWindow.Show();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        [AjaxMethod]
        public void DeleteUserItem(string detailId)
        {
            try
            {
                if (!string.IsNullOrEmpty(detailId))
                {
                    BusinessWechatUser user = new BusinessWechatUser();
                    user.Id = new Guid(detailId);
                    user.Status = "Delete";
                    _WhatBase.UpdateUserStatus(user);
                }
            }
            catch (Exception ex) 
            {
                Ext.Msg.Alert("Message", ex.ToString()).Show();
            }
        }

        private void InitUserWindow(bool canSubmit)
        {
            this.userId.Clear();
            this.tfTextName.Clear();
            this.tfTextNickName.Clear();
            this.nfTextPhone.Clear();
            this.cbTextPosition.SelectedItem.Value = "";
            this.radioSexB.Checked=true;
            this.radioSexG.Checked=false;
            this.tfTextMail.Clear();
            if (canSubmit)
            {
                this.btnUserSubmit.Visible = true;

                this.tfTextName.ReadOnly = false;
                this.tfTextNickName.ReadOnly = false;
                this.nfTextPhone.ReadOnly = false;
                this.cbTextPosition.ReadOnly = false;
                this.radioSexB.ReadOnly = false;
                this.radioSexG.ReadOnly = false;
                this.tfTextMail.ReadOnly = false;
            }
            else
            {
                this.btnUserSubmit.Visible = true;

                this.tfTextName.ReadOnly = true;
                this.tfTextNickName.ReadOnly = true;
                this.nfTextPhone.ReadOnly = true;
                this.cbTextPosition.ReadOnly = true;
                this.radioSexB.ReadOnly = true;
                this.radioSexG.ReadOnly = true;
                this.tfTextMail.ReadOnly = true;
            }
        }

        private void LoadUserWindow(Guid detailId)
        {
            BusinessWechatUser user = _WhatBase.GetUserByUserId(detailId);

            this.tfTextName.Text = user.UserName;
            this.tfTextNickName.Text = user.NickName;
            this.nfTextPhone.Text = user.Phone;
            this.cbTextPosition.SelectedItem.Value = user.Post;
            this.tfTextMail.Text = user.Email;
            if (user.Sex.Equals("1"))
            {
                this.radioSexB.Checked = true;
                this.radioSexG.Checked = false;
            }
            else 
            {
                this.radioSexB.Checked = false;
                this.radioSexG.Checked = true;
            }

            
        }

        [AjaxMethod]
        public string SubmintUser()
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
                if (string.IsNullOrEmpty(this.userId.Text))
                {
                    user.Id = Guid.NewGuid();
                    user.UserName = this.tfTextName.Text;
                    user.Phone = this.nfTextPhone.Text;
                    user.NickName = this.tfTextNickName.Text;
                    user.Post = this.cbTextPosition.SelectedItem.Value;
                    user.Sex = this.radioSexB.Checked ? "1" : "0";
                    user.Email = this.tfTextMail.Text;
                    user.Status = "Active";
                    if (RoleModelContext.Current.User.CorpType != null)
                    {
                        user.DealerId = RoleModelContext.Current.User.CorpId.Value;
                        DealerMaster dm = _dealerMasters.GetDealerMaster(user.DealerId.Value);
                        if (dm != null)
                        {
                            user.DealerName = dm.ChineseName;
                        }
                        user.DealerType = RoleModelContext.Current.User.CorpType;
                    }
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
                //Edit
                else
                {
                    user.Id = new Guid(this.userId.Text);
                    user.UserName = this.tfTextName.Text;
                    user.Phone = this.nfTextPhone.Text;
                    user.NickName = this.tfTextNickName.Text;
                    user.Post = this.cbTextPosition.SelectedItem.Value;
                    user.Sex = this.radioSexB.Checked ? "1" : "0";
                    user.Email = this.tfTextMail.Text;
                    if (CheckUserBind(user, "update"))
                    {
                        _WhatBase.UpdateUser(user);
                    }
                    else
                    {
                        massage = "该手机号已被注册！<br/>";
                    }
                }
            }
            if (!massage.Equals("")) massage = massage.Substring(0, massage.Length - 5);

            return massage;
            
         
        }
        
        [AjaxMethod]
        public void Retrun()
        {
          
            Response.Redirect("~/Default.aspx");
        }

        private bool CheckUserBind(BusinessWechatUser user, string OperatType) 
        {
            Hashtable obj = new Hashtable();
            obj.Add("Phone", user.Phone);
            DataTable dt= _WhatBase.GetUser(obj).Tables[0];
            if (OperatType.Equals("insert")) 
            {
                if (dt.Rows.Count > 0)
                {
                    return false;
                }
                else 
                {
                    return true;
                }
            }
            else if (OperatType.Equals("update")) 
            {
                if (dt.Rows.Count > 1) 
                {
                    return false;
                }
                else if (dt.Rows.Count == 1)
                {
                    if (user.Id != new Guid(dt.Rows[0]["Id"].ToString()))
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    }
                }
                else 
                {
                    return true;
                }
            }
            
            return true;
        }

        private void SendMail(string Verifi,string MailAddress) 
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

        //private void SendMassage(string Verifi, string massageTo)
        //{
        //    ShortMessageQueue massage = new ShortMessageQueue();
        //    massage.Id = Guid.NewGuid();
        //    massage.QueueNo="sms";
        //    massage.To = massageTo;
        //    massage.Message = "您的BSC微信验证码为：" + Verifi + "   请在微信中输入：“手机号”+“空格”+“验证码” ，进行账号绑定【无需输入“+”号  例如：13800000000 2161】";
        //    massage.Status = "Waiting";
        //    massage.CreateDate = DateTime.Now;
        //    _messageBLL.AddToShortMessageQueue(massage);
        //}

        private void SendMassage(string Verifi, string massageTo)
        {
            ShortMessageTemplate temp = _messageBLL.GetShortMessageTemplate("SMS_WECHACT_REGISTOR");

            MessageTaskSend massage = new MessageTaskSend();
            massage.SendMode = "2";
            massage.EmailWechatContent = temp.Template.Replace("#Verification#", Verifi);
            massage.MsgPhone = massageTo;
            massage.HtmlTranslationFLG = "1";
            massage.InsertQueFLG = "0";
            massage.SendAdminFLG = "0";
            massage.InsertTime = DateTime.Now;
            massage.InsertOrigin = "songw2";
            massage.GUID = "DMS-"+Guid.NewGuid().ToString();

            _messageBLL.AddToShortMessagTask(massage);
        }

    }
}
