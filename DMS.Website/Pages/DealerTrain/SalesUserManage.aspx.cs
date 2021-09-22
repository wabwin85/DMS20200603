using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using DMS.Business;
using Lafite.RoleModel.Security;
using DMS.Business.DealerTrain;
using Coolite.Ext.Web;
using DMS.Model;
using System.Collections;
using System.Data;

namespace DMS.Website.Pages.DealerTrain
{
    public partial class SalesUserManage : BasePage
    {
        #region 公用
        private CommandoUserBLL _commandoUserBLL = new CommandoUserBLL();
        private IWeChatBaseBLL _wechatBll = new WeChatBaseBLL();
        private IDealerMasters _dealerMastersBll = new DealerMasters();
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
                this.Bind_DealerList(this.StoDealerList);
            }
        }

        #region 销售查询

        protected void StoDealerSalesList_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet query = _commandoUserBLL.GetDealerSalesList(this.QryDealerName.Text, this.QrySalesName.Text, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagDealerSalesList.PageSize : e.Limit), out totalCount);
            (this.StoDealerSalesList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.StoDealerSalesList.DataSource = query;
            this.StoDealerSalesList.DataBind();
        }

        #endregion

        #region 销售维护

        protected void StoDealerSalesInfo_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
        }

        [AjaxMethod]
        public void ShowDealerSalesInfo(string dealerSalesId)
        {
            this.IptRtnVal.Clear();
            this.IptRtnMsg.Clear();

            this.IptDealer.SelectedItem.Value = string.Empty;
            this.IptSalesName.Clear();
            this.IptSalesSexM.Checked = true;
            this.IptSalesSexF.Checked = false;
            this.IptSalesPhone.Clear();
            this.IptSalesEmail.Clear();

            BindDealerSalesInfo(dealerSalesId);
            this.WdwDealerSalesInfo.Show();
        }

        private void BindDealerSalesInfo(string dealerSalesId)
        {
            if (dealerSalesId.Equals("00000000-0000-0000-0000-000000000000"))
            {
                this.IptDealerSalesId.Value = dealerSalesId;
                this.IptDealer.Enabled = true;
            }
            else
            {
                this.IptDealerSalesId.Value = dealerSalesId;
                this.IptDealer.Enabled = false;

                BusinessWechatUser user = _wechatBll.GetUserByUserId(new Guid(dealerSalesId));

                this.IptDealer.SelectedItem.Value = user.DealerId.ToString();
                this.IptSalesSexM.Checked = user.Sex.Equals("1");
                this.IptSalesSexF.Checked = !user.Sex.Equals("1");
                this.IptSalesName.Text = user.UserName;
                this.IptSalesPhone.Text = user.Phone;
                this.IptSalesEmail.Text = user.Email;
            }
        }

        [AjaxMethod]
        public void SaveDealerSalesInfo()
        {
            this.IptRtnVal.Clear();
            this.IptRtnMsg.Clear();

            if (IsPageNew)
            {
                BusinessWechatUser user = new BusinessWechatUser();
                user.Id = Guid.NewGuid();
                user.DealerId = new Guid(this.IptDealer.SelectedItem.Value);
                DealerMaster dm = _dealerMastersBll.GetDealerMaster(user.DealerId.Value);
                if (dm != null)
                {
                    user.DealerName = dm.ChineseName;
                    user.DealerType = dm.DealerType;
                }
                user.UserName = this.IptSalesName.Text;
                user.Phone = this.IptSalesPhone.Text;
                user.Post = "Sales";
                user.Sex = this.IptSalesSexM.Checked ? "1" : "0";
                user.Email = this.IptSalesEmail.Text;
                user.Status = "Active";

                if (CheckUserBind(user, "insert"))
                {
                    Random rad = new Random();
                    user.Rv1 = rad.Next(1000, 10000).ToString();

                    _wechatBll.InsertUser(user);
                    //_commandoUserBLL.SendMail(user.Rv1, user.Email);
                    //_commandoUserBLL.SendMassage(user.Rv1, user.Phone);

                    Hashtable obj = new Hashtable();
                    obj.Add("DmaId", user.DealerId.Value.ToString());
                    obj.Add("UserId", user.Id.ToString());

                    _wechatBll.InsertUserProductLine(obj);

                    DMS.Model.DealerSales ds = new DMS.Model.DealerSales();
                    ds.DealerSalesId = user.Id;
                    ds.WeChatUserId = user.Id;
                    ds.CreateTime = DateTime.Now;
                    ds.CreateUser = new Guid(_context.User.Id);
                    ds.UpdateTime = DateTime.Now;
                    ds.UpdateUser = new Guid(_context.User.Id);

                    _commandoUserBLL.AddDealerSalesInfo(ds);
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
                user.Id = new Guid(this.IptDealerSalesId.Text);
                user.UserName = this.IptSalesName.Text;
                user.Phone = this.IptSalesPhone.Text;
                user.Post = "Sales";
                user.Sex = this.IptSalesSexM.Checked ? "1" : "0";
                user.Email = this.IptSalesEmail.Text;
                user.Status = "Active";

                if (CheckUserBind(user, "update"))
                {
                    _wechatBll.UpdateUser(user);
                    IptRtnVal.Text = "True";
                }
                else
                {
                    IptRtnVal.Text = "False";
                    IptRtnMsg.Text = "该手机号已被注册！";
                }
            }
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
        public void DeleteDealerSalesInfo(string dealerSalesId)
        {
            _commandoUserBLL.RemoveDealerSalesInfo(new Guid(dealerSalesId));
        }

        #endregion

        #region 销售导入

        protected void StoWechatUserList_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet query = _commandoUserBLL.GetRemainWechatUserList(this.QryWechatDealerName.Text, this.QryWechatSalesName.Text, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagWechatUserList.PageSize : e.Limit), out totalCount);
            (this.StoWechatUserList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.StoWechatUserList.DataSource = query;
            this.StoWechatUserList.DataBind();
        }

        [AjaxMethod]
        public void SaveWechatUser(string param)
        {
            param = param.Substring(0, param.Length - 1);
            String[] dealerSalesList = param.Split(',');
            foreach (String dealerSalesId in dealerSalesList)
            {
                DMS.Model.DealerSales ds = new DMS.Model.DealerSales();
                ds.DealerSalesId = new Guid(dealerSalesId);
                ds.WeChatUserId = new Guid(dealerSalesId);
                ds.CreateTime = DateTime.Now;
                ds.CreateUser = new Guid(_context.User.Id);
                ds.UpdateTime = DateTime.Now;
                ds.UpdateUser = new Guid(_context.User.Id);

                _commandoUserBLL.AddDealerSalesInfo(ds);
            }
            StoWechatUserList.DataBind();
        }

        #endregion
    }
}
