using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.MasterDatas
{
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;

    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Common;
    using Microsoft.Practices.Unity;
    using System.Data;

    public partial class HospitalList : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;

        private IHospitals _hospitaBiz = null;//Global.SessionContainer.Resolve<IHospitals>();

        [Dependency]
        public IHospitals HospitalBiz
        {
            get { return _hospitaBiz; }
            set { _hospitaBiz = value; }
        }

        private IReportSalesBLL _reoprtSalesBiz = null;//Global.SessionContainer.Resolve<IHospitals>();

        [Dependency]
        public IReportSalesBLL ReportSalseBiz
        {
            get { return _reoprtSalesBiz; }
            set { _reoprtSalesBiz = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {

            int start = 0, limit = 0;

            limit = this.PagingToolBar1.PageSize;

            if (e.Start > 0)
            {
                start = e.Start;
                limit = e.Limit;
            }


            RefreshData(start, limit);
        }


        private void RefreshData(int start, int limit)
        {

            //IHospitals bll = new Hospitals();

            int totalCount = 0;

            Hospital param = new Hospital();

            param.HosHospitalName = this.txtSearchHospitalName.Text.Trim();
            param.HosGrade = this.cmbGrade.SelectedItem.Value;
            param.HosDirector = this.txtSearchDirector.Text.Trim();

            param.HosProvince = this.cmbProvince.SelectedItem.Text.Trim();
            param.HosCity = this.cmbCity.SelectedItem.Text.Trim();
            param.HosDistrict = this.cmbDistrict.SelectedItem.Text.Trim();

            IList<Hospital> query = HospitalBiz.SelectByFilter(param, start, limit, out totalCount);

            (this.Store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.Store1.DataBind(JsonHelper.Serialize(query));

        }

        protected void Store1_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            try
            {
                //you can add own logic for save using one of above data representation and then set e.Cancel=true for canceling Store events

                string json = e.DataHandler.JsonData;
                StoreDataHandler dataHandler = new StoreDataHandler(json);


                ChangeRecords<Hospital> data = dataHandler.CustomObjectData<Hospital>();

                //IHospitals bll = new Hospitals();

                HospitalBiz.SaveChanges(data);

                e.Cancel = true;
            }
            catch (Exception ex)
            {
                if (ex.Message.IndexOf("医院编号") > -1)
                {
                    String newMsg = ex.Message.Substring(ex.Message.IndexOf("医院编号"), ex.Message.IndexOf("重复。")+2 - ex.Message.IndexOf("医院编号:"));
                    Ext.Msg.Alert("", newMsg).Show();                   
                    throw new Exception(newMsg);
                }
                if (ex.Message.IndexOf("医院名称") > -1)
                {
                    String newMsg = ex.Message.Substring(ex.Message.IndexOf("医院名称"), ex.Message.IndexOf("重复。")+2 - ex.Message.IndexOf("医院名称:"));
                    Ext.Msg.Alert("", newMsg).Show();     
                    throw new Exception(newMsg);
                }
                
            }

        }

        public void GetHospitalID(object sender, AjaxEventArgs e) //object sender, AjaxEventArgs e
        {
            try
            {
                this.HospitalEditor1.CreateHospital();
                e.Success = true;
            }
            catch
            {
                e.Success = false;
            }
        }

        protected void Store_RefreshCities(object sender, StoreRefreshDataEventArgs e)
        {
            e.Parameters["parentId"] = this.cmbProvince.SelectedItem.Value;

            base.Store_RefreshTerritorys(sender, e);
        }

        protected void Store_RefreshDistricts(object sender, StoreRefreshDataEventArgs e)
        {
            e.Parameters["parentId"] = this.cmbCity.SelectedItem.Value;

            base.Store_RefreshTerritorys(sender, e);
        }

        /// <summary>
        /// Called when [authenticate].
        /// </summary>
        protected override void OnAuthenticate()
        {
            Permissions pers = this._context.User.GetPermissions();

            //正式使用权限时请使用Visible = false, 更安全;

            this.btnDelete.Visible = pers.IsPermissible(Business.Hospitals.Action_Hospitals, PermissionType.Write);
            this.btnInsert.Visible = pers.IsPermissible(Business.Hospitals.Action_Hospitals, PermissionType.Write);
            this.btnSave.Visible = pers.IsPermissible(Business.Hospitals.Action_Hospitals, PermissionType.Write);
            this.btnSearch.Visible = pers.IsPermissible(Business.Hospitals.Action_Hospitals, PermissionType.Read);
        }

        #region 医院上报人员列表
        protected void ReportUserStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            string hospId = this.hiddenHospId.Text;
            DataSet ds = ReportSalseBiz.QueryHospitalReportUserByFilter(hospId);

            this.ReportUserStore.DataSource = ds;
            this.ReportUserStore.DataBind();
        }

        [AjaxMethod]
        public void ShowReportUserList(string hospitalId)
        {
            this.hiddenHospId.Text = hospitalId;
        }

        [AjaxMethod]
        public void DeleteUser(string id)
        {
            ReportSalseBiz.DeleteUser(new Guid(id));
        }

        [AjaxMethod]
        public void ShowUserInfo(string id)
        {

            #region Clear Value
            this.tfWinUserName.Clear();
            this.tfWinPhone.Clear();
            this.cbWinActive.Checked = true;
            this.cbWinHasWebChat.Checked = false;
            this.hiddenReportUserId.Clear();
            #endregion

            #region Clear Controler Status
            this.tfWinUserName.Disabled = false;
            this.tfWinPhone.Disabled = false;
            #endregion

            //仅当修改的时候执行赋值和控件赋状态
            if (!string.IsNullOrEmpty(id))
            {
                HospitalReportUser user = ReportSalseBiz.getHospitalReportUserById(new Guid(id));
                #region Set Value
                this.hiddenReportUserId.Text = id;
                this.tfWinUserName.Text = user.UserName;
                this.tfWinPhone.Text = user.Phone;
                if (user.IsActive.HasValue && user.IsActive.Value)
                {
                    this.cbWinActive.Checked = true;
                }
                else
                {
                    this.cbWinActive.Checked = false;
                }
                if (string.IsNullOrEmpty(user.WeChat))
                {
                    this.cbWinHasWebChat.Checked = false;
                }
                else
                {
                    this.cbWinHasWebChat.Checked = true;
                }
                #endregion

                #region Set Controler Status
                if (this.cbWinHasWebChat.Checked)
                {
                    this.tfWinUserName.Disabled = true;
                    this.tfWinPhone.Disabled = true;
                }
                else
                {
                    this.tfWinUserName.Disabled = false;
                    this.tfWinPhone.Disabled = false;
                }
                #endregion
            }

        }

        [AjaxMethod]
        public void SaveUserInfo()
        {
            HospitalReportUser user = new HospitalReportUser();
            //新增
            if (string.IsNullOrEmpty(this.hiddenReportUserId.Text))
            {
                user.Id = Guid.NewGuid();
                user.HospitalId = new Guid(this.hiddenHospId.Text);
                user.UserName = this.tfWinUserName.Text.Trim();
                user.Phone = this.tfWinPhone.Text.Trim();
                user.WeChat = null;
                user.IsActive = this.cbWinActive.Checked;
                user.IsDeleted = false;
                user.CreateUser = new Guid(_context.User.Id);
                user.CreateDate = DateTime.Now;
                user.UpdateUser = null;
                user.UpdateDate = null;

                if (ReportSalseBiz.CheckUserPhoneExist(user.Id.ToString(), user.Phone))
                {
                    Ext.Msg.Alert("Error", "该手机号已经存在！").Show();
                }
                else
                {
                    ReportSalseBiz.SaveUser(user);
                    UserDeatailWindows.Hide();
                    ReportUserPanel.Reload();
                }
            }
            else//修改
            {
                user.Id = new Guid(this.hiddenReportUserId.Text);
                user.HospitalId = new Guid(this.hiddenHospId.Text);
                user.UserName = this.tfWinUserName.Text.Trim();
                user.Phone = this.tfWinPhone.Text.Trim();
                user.IsActive = this.cbWinActive.Checked;
                user.UpdateUser = new Guid(_context.User.Id);
                user.UpdateDate = DateTime.Now;

                if (ReportSalseBiz.CheckUserPhoneExist(user.Id.ToString(), user.Phone))
                {
                    Ext.Msg.Alert("Error", "该手机号已经存在！").Show();
                }
                else if (!this.cbWinHasWebChat.Checked && checkHasBinding(user.Id))
                {
                    Ext.Msg.Alert("Error", "数据已更新请重新选择！").Show();
                }
                else
                {
                    ReportSalseBiz.UpdateHospitalReportUserByFilter(user);
                    UserDeatailWindows.Hide();
                    ReportUserPanel.Reload();
                }
            }


        }

        private bool checkHasBinding(Guid id)
        {
            HospitalReportUser user = ReportSalseBiz.getHospitalReportUserById(id);
            if (user != null && !string.IsNullOrEmpty(user.WeChat))
            {
                return true;
            }

            return false;
        }
        #endregion
    }
}
