using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Business.DealerTrain;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using Coolite.Ext.Web;
using System.Data;
using DMS.Model;
using DMS.Business;
using System.Collections;
using DMS.Common;

namespace DMS.Website.Pages.DealerTrain
{
    public partial class BscUserManage : BasePage
    {
        #region 公用
        private CommandoUserBLL _commandoUserBLL = new CommandoUserBLL();
        private IWeChatBaseBLL _wechatBll = new WeChatBaseBLL();
        IRoleModelContext _context = RoleModelContext.Current;
        public bool IsPageNew
        {
            get
            {
                return (this.IptIsNew.Text == "True" ? true : false);
            }
            set
            {
                this.IptIsNew.Text = value.ToString();
            }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
            }
        }

        #region 波科用户查询

        protected void StoBscUserList_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet query = _commandoUserBLL.GetBscUserList(this.QryUserName.Text, this.QryUserType.SelectedItem.Value, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagBscUserList.PageSize : e.Limit), out totalCount);
            (this.StoBscUserList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.StoBscUserList.DataSource = query;
            this.StoBscUserList.DataBind();
        }

        protected void StoUserType_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> trainOnlineType = DictionaryHelper.GetDictionary(SR.BscUser_UserType);
            StoUserType.DataSource = trainOnlineType;
            StoUserType.DataBind();
        }

        #endregion

        #region 波科用户维护

        [AjaxMethod]
        public void ShowBscUserInfo(string bscUserId)
        {
            this.IptRtnVal.Clear();
            this.IptRtnMsg.Clear();

            this.IptUserName.Clear();
            this.IptUserSexM.Checked = true;
            this.IptUserSexF.Checked = false;
            this.IptUserPhone.Clear();
            this.IptUserEmail.Clear();
            this.IptUserTypeLecturer.Checked = false;
            this.IptUserTypeTeacher.Checked = false;
            this.IptUserTypeManager.Checked = false;

            BindBscUserInfo(bscUserId);
            this.BtnAddDealer.Disabled = !this.IptUserTypeTeacher.Checked;
            this.WdwBscUserInfo.Show();
        }

        private void BindBscUserInfo(string bscUserId)
        {
            if (bscUserId.Equals("00000000-0000-0000-0000-000000000000"))
            {
                this.IptBscUserId.Value = Guid.NewGuid().ToString();
            }
            else
            {
                this.IptBscUserId.Value = bscUserId;

                Hashtable user = _commandoUserBLL.GetBscUserInfo(bscUserId);

                this.IptUserSexM.Checked = user["UserSex"].ToString().Equals("1");
                this.IptUserSexF.Checked = !user["UserSex"].ToString().Equals("1");
                this.IptUserName.Text = user["UserName"].ToString();
                this.IptUserPhone.Text = user["UserPhone"].ToString();
                this.IptUserEmail.Text = user["UserEmail"].ToString();

                String[] userTypeList = user["UserType"].ToString().Split(new string[] { ";" }, StringSplitOptions.RemoveEmptyEntries);
                foreach (String userType in userTypeList)
                {
                    (this.IptUserType.FindControl("IptUserType" + userType) as Checkbox).Checked = true;
                }
            }
        }

        protected void StoTeacherDealerList_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            String bscUserId = e.Parameters["BscUserId"].ToString();
            if (!String.IsNullOrEmpty(bscUserId))
            {
                int totalCount = 0;
                DataSet query = _commandoUserBLL.GetTeacherDealerList(bscUserId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagTeacherDealerList.PageSize : e.Limit), out totalCount);
                (this.StoTeacherDealerList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                this.StoTeacherDealerList.DataSource = query;
                this.StoTeacherDealerList.DataBind();
            }
        }

        [AjaxMethod]
        public void SaveBscUserInfo()
        {
            this.IptRtnVal.Clear();
            this.IptRtnMsg.Clear();

            if (IsPageNew)
            {
                BusinessWechatUser user = new BusinessWechatUser();
                user.Id = new Guid(this.IptBscUserId.Value.ToString());
                user.DealerId = new Guid("FB62D945-C9D7-4B0F-8D26-4672D2C728B7");
                user.DealerName = "BSC(HQ)";
                user.UserName = this.IptUserName.Text;
                user.Phone = this.IptUserPhone.Text;
                user.Sex = this.IptUserSexM.Checked ? "1" : "0";
                user.Email = this.IptUserEmail.Text;
                user.Status = "Active";

                if (CheckUserBind(user, "insert"))
                {
                    Random rad = new Random();
                    user.Rv1 = rad.Next(1000, 10000).ToString();

                    _wechatBll.InsertUser(user);
                    _commandoUserBLL.SendMail(user.Rv1, user.Email);
                    _commandoUserBLL.SendMassage(user.Rv1, user.Phone);

                    BscUser bu = new BscUser();
                    bu.BscUserId = user.Id;
                    bu.WeChatUserId = user.Id;
                    String userType = "";
                    if (this.IptUserTypeLecturer.Checked)
                    {
                        userType += "Lecturer;";
                    }
                    if (this.IptUserTypeTeacher.Checked)
                    {
                        userType += "Teacher;";
                    }
                    if (this.IptUserTypeManager.Checked)
                    {
                        userType += "Manager;";
                    }
                    bu.UserType = userType;
                    bu.CreateTime = DateTime.Now;
                    bu.CreateUser = new Guid(_context.User.Id);
                    bu.UpdateTime = DateTime.Now;
                    bu.UpdateUser = new Guid(_context.User.Id);

                    _commandoUserBLL.AddBscUserInfo(bu);
                    IptRtnVal.Text = "True";
                }
                else
                {
                    IptRtnVal.Text = "False";
                    IptRtnMsg.Text = "该手机号已被注册！";
                }
            }
            else
            {
                BusinessWechatUser user = new BusinessWechatUser();
                user.Id = new Guid(this.IptBscUserId.Value.ToString());
                user.UserName = this.IptUserName.Text;
                user.Phone = this.IptUserPhone.Text;
                user.Sex = this.IptUserSexM.Checked ? "1" : "0";
                user.Email = this.IptUserEmail.Text;

                if (CheckUserBind(user, "update"))
                {
                    _wechatBll.UpdateUser(user);

                    BscUser bu = new BscUser();
                    bu.BscUserId = new Guid(this.IptBscUserId.Value.ToString());
                    String userType = "";
                    if (this.IptUserTypeLecturer.Checked)
                    {
                        userType += "Lecturer;";
                    }
                    if (this.IptUserTypeTeacher.Checked)
                    {
                        userType += "Teacher;";
                    }
                    if (this.IptUserTypeManager.Checked)
                    {
                        userType += "Manager;";
                    }
                    bu.UserType = userType;
                    bu.UpdateTime = DateTime.Now;
                    bu.UpdateUser = new Guid(_context.User.Id);

                    _commandoUserBLL.ModifyBscUserInfo(bu);

                    IptRtnVal.Text = "True";
                }
                else
                {
                    IptRtnVal.Text = "False";
                    IptRtnMsg.Text = "该手机号已被注册！";
                }
            }

            this.IptIsNew.Text = "False";
        }

        private bool CheckUserBind(BusinessWechatUser user, string OperatType)
        {
            Hashtable obj = new Hashtable();
            obj.Add("Phone", user.Phone);
            DataTable dt = _wechatBll.GetUser(obj).Tables[0];
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

        [AjaxMethod]
        public void DeleteBscUserInfo(String bscUserId)
        {
            _commandoUserBLL.RemoveBscUserInfo(new Guid(bscUserId));
            BusinessWechatUser user = new BusinessWechatUser();
            user.Id = new Guid(bscUserId);
            user.Status = "Delete";
            _wechatBll.UpdateUserStatus(user);
            _commandoUserBLL.RemoveAllTeacherDealer(bscUserId);
        }

        [AjaxMethod]
        public void DeleteDealer(String bscUserId, String dealerId)
        {
            this.IptRtnVal.Clear();
            this.IptRtnMsg.Clear();

            _commandoUserBLL.RemoveTeacherDealer(bscUserId, dealerId);
        }

        #endregion

        #region 培训讲师对应经销商维护

        protected void StoDealerList_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            String bscUserId = e.Parameters["BscUserId"].ToString();
            if (!String.IsNullOrEmpty(bscUserId))
            {
                int totalCount = 0;
                DataSet query = _commandoUserBLL.GetRemainTeacherDealerList(bscUserId, this.QryDealerName.Text, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagDealerList.PageSize : e.Limit), out totalCount);
                (this.StoDealerList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                this.StoDealerList.DataSource = query;
                this.StoDealerList.DataBind();
            }
        }

        [AjaxMethod]
        public void SaveDealer(string param)
        {
            param = param.Substring(0, param.Length - 1);
            _commandoUserBLL.AddTeacherDealer(this.IptBscUserId.Value.ToString(), param.Split(','));
            StoDealerList.DataBind();
        }

        #endregion
    }
}
