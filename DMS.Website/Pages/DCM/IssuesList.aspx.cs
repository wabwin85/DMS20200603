using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Collections;

namespace DMS.Website.Pages.DCM
{
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using Microsoft.Practices.Unity;
    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Common;
    using DMS.Model.Data;
    using System.IO;
    public partial class IssuesList : BasePage
    {
        #region 公共

        IRoleModelContext _context = RoleModelContext.Current;

        private IIssuesListBLL _bll = null;
        private IAttachmentBLL _attachBll = null;

        [Dependency]
        public IIssuesListBLL bll
        {
            get { return _bll; }
            set { _bll = value; }
        }
        [Dependency]
        public IAttachmentBLL attachBll
        {
            get { return _attachBll; }
            set { _attachBll = value; }
        }

        private bool isNew
        {
            get { return this.hfStatus.Text == "New" ? true : false; }
            set { this.hfStatus.Text = value ? "New" : "Modify"; }
        }

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (IsDealer)
                {

                    this.btnImport.Hidden = true;
                    this.btnSave.Hidden = true;

                    //为经销商时，文本框为ReadOnly状态
                    this.nfSortNo.ReadOnly = true;
                    this.taAnswer.ReadOnly = true;
                    this.taQuestion.ReadOnly = true;

                    this.btnAddAttach.Hide();
                    this.AttachmentPanel.ColumnModel.SetHidden(7, true);
                }
                else
                {
                    this.btnImport.Hidden = false;
                }

                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.IssuesListBLL.Action_IssuesList, PermissionType.Read);
                this.btnImport.Visible = pers.IsPermissible(Business.IssuesListBLL.Action_IssuesList, PermissionType.Write);
            }
        }

        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            if (this.FileUploadField1.HasFile)
            {

                bool error = false;

                string fileName = FileUploadField1.PostedFile.FileName;
                string fileExtention = string.Empty;
                string fileExt = string.Empty;
                if (fileName.LastIndexOf(".") < 0)
                {
                    error = true;
                }
                else
                {
                    fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
                    fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                }

                if (error)
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "文件错误",
                        Message = "请上传正确的文件！"
                    });

                    return;
                }

                //构造文件名称

                string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\UploadFile\\" + newFileName);


                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                this.hiddenFileName.Text = newFileName;

                Attachment attach = new Attachment();
                attach.Id = Guid.NewGuid();
                attach.MainId = new Guid(this.hfId.Text);
                attach.Name = fileExtention;
                attach.Url = newFileName;//AppSettings.HostUrl + "/Upload/UploadFile/" + newFileName;
                attach.Type = AttachmentType.Issues.ToString();
                attach.UploadDate = DateTime.Now;
                attach.UploadUser = new Guid(_context.User.Id);

                attachBll.AddAttachment(attach);

                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = "上传成功",
                    Message = "已成功上传文件！"
                });
            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "上传失败",
                    Message = "文件未被成功上传！"
                });
            }
        }

        #region Store
        public void ResultStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable table = new Hashtable();

            if (!string.IsNullOrEmpty(this.tfKeyWords.Text.Trim()))
                table.Add("KeyWords", this.tfKeyWords.Text.Trim());

            table.Add("DeleteFlag","0");

            DataSet data = bll.QuerySelectIssuesList(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            ResultStore.DataSource = data;
            ResultStore.DataBind();
        }

        protected void AttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            DataSet ds = attachBll.GetAttachmentByMainId(new Guid(this.hfId.Text), AttachmentType.Issues, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            AttachmentStore.DataSource = ds;
            AttachmentStore.DataBind();
        }
        #endregion

        #region AjaxMethod
        [AjaxMethod]
        public void Show(string id, string status)
        {
            this.hfStatus.Text = status;
            this.ClearWindow();

            //this.hfId.Text = id;
            this.hfSortNo.Text = "0";

            //修改
            if (!isNew)//id != Guid.Empty.ToString())
            {
                this.hfId.Text = id;
                this.SetValue(id);
            }
            else //新增
            {
                this.hfId.Text = Guid.NewGuid().ToString();
                this.nfSortNo.Text = (bll.getMaxSortNo() + 1).ToString();
                this.hfSortNo.Text = this.nfSortNo.Text;
            }

        }

        [AjaxMethod]
        public void SaveItem()
        {
            DMS.Model.IssuesList issues = new DMS.Model.IssuesList();

            //if (this.hfId.Text == Guid.Empty.ToString())
            //    issues.Id = Guid.NewGuid();
            //else
            issues.Id = new Guid(this.hfId.Text);
            issues.Question = this.taQuestion.Text;
            issues.Answer = this.taAnswer.Text;

            //未改变序号
            if (this.nfSortNo.Text == this.hfSortNo.Text)
            {
                //状态为新增时
                if (this.hfId.Text == Guid.Empty.ToString())
                {
                    issues.SortNo = bll.getMaxSortNo() + 1;
                }
                else
                { 
                    issues.SortNo = Convert.ToInt16(this.nfSortNo.Text);
                }

                this.SaveIssues(issues);
            }
            else
            {
                if (this.VerifySortNo(this.nfSortNo.Text))
                {
                    Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
                }
                else
                {
                    issues.SortNo = Convert.ToInt16(this.nfSortNo.Text);
                    this.SaveIssues(issues);
                }
            }
        }

        [AjaxMethod]
        public void DeleteItem(string id)
        {
            bool result = bll.DeleteIssues(new Guid(id));
        }

        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                attachBll.DelAttachment(new Guid(id));
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile");
                File.Delete(uploadFile + "\\" + fileName);

            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除失败").Show();
            }
        }
        #endregion

        #region 页面私有方法
        private void ClearWindow()
        {
            this.hfId.Clear();
            this.hfSortNo.Clear();

            this.taQuestion.Clear();
            this.taAnswer.Clear();
            this.nfSortNo.Clear();

            this.btnDelete.Hide();

            this.TabPanel1.ActiveTabIndex = 0;

            if (!IsDealer)
            {
                this.btnAddAttach.Show();
                this.AttachmentPanel.ColumnModel.SetHidden(7, false);
            }
        }

        private void SetValue(string id)
        {
            DMS.Model.IssuesList issues = bll.GetObject(new Guid(id));

            this.nfSortNo.Text = issues.SortNo.ToString();
            this.hfSortNo.Text = this.nfSortNo.Text;

            this.taAnswer.Text = issues.Answer;
            this.taQuestion.Text = issues.Question;

            this.hfId.Text = id;

            //id不为空,且不为经销商则显示‘删除’按钮
            if (!isNew && !IsDealer)//new Guid(this.hfId.Text) != Guid.Empty && !IsDealer)
            {
                this.btnDelete.Show();

                //this.btnAddAttach.Hide();
                //this.AttachmentPanel.ColumnModel.SetHidden(7, true);
            }

        }

        //判断序号是否已经存在
        private bool VerifySortNo(string SortNo)
        {
            return bll.VerifySortNo(SortNo);
        }

        private void SaveIssues(DMS.Model.IssuesList issues)
        {
            if (bll.SaveIssues(issues))
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveItem.Alert.Title").ToString(), GetLocalResourceObject("SaveIssues.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveIssues.Alert.Error.Title").ToString(), GetLocalResourceObject("SaveIssues.Alert.Error.Body").ToString()).Show();
            }
        }
        #endregion
    }
}
