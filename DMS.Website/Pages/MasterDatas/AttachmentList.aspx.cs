using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using System.Data;
using Microsoft.Practices.Unity;
using DMS.Business;
using DMS.Model.Data;
using DMS.Model;
using Coolite.Ext.Web;
using System.IO;
using Lafite.RoleModel.Security;

namespace DMS.Website.Pages.MasterDatas
{
    public partial class AttachmentList : BasePage
    {
        //单据Id
        public Guid InstanceId
        {
            get
            {
                return new Guid(this.hiddenInstanceId.Text);
            }
            set
            {
                this.hiddenInstanceId.Text = value.ToString();
            }
        }

        //存放文件的名称
        public string FolderName
        {
            get
            {
                return this.hiddenFolderName.Text;
            }
            set
            {
                this.hiddenFolderName.Text = value.ToString();
            }
        }

        //允许上传附件
        public bool CanUploadFile
        {
            get
            {
                return this.hiddenCanUploadFile.Text == "1" ? true : false;
            }
            set
            {
                this.hiddenCanUploadFile.Text = value.ToString();
            }
        }

        //允许删除附件
        public bool CanDeleteFile
        {
            get
            {
                return this.hiddenCanDeleteFile.Text == "1" ? true : false;
            }
            set
            {
                this.hiddenCanDeleteFile.Text = value.ToString();
            }
        }

        IRoleModelContext _context = RoleModelContext.Current;
        
        private IAttachmentBLL _attachBll = null;
        
        [Dependency]
        public IAttachmentBLL attachBll
        {
            get { return _attachBll; }
            set { _attachBll = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (Request.QueryString["AuthorizationId"] == null || string.IsNullOrEmpty(Request.QueryString["AuthorizationId"].ToString()))
                {
                    Response.Write("请选择经销商授权重新进入");
                    Response.End();
                }
                if (Request.QueryString["FolderName"] == null || string.IsNullOrEmpty(Request.QueryString["FolderName"].ToString()))
                {
                    Response.Write("为设置附件上传文件夹");
                    Response.End();
                }
                this.hiddenInstanceId.Text = Request.QueryString["AuthorizationId"].ToString();
                this.hiddenFolderName.Text = Request.QueryString["FolderName"].ToString();
                this.hiddenCanUploadFile.Text = Request.QueryString["CanUploadFile"] == null || string.IsNullOrEmpty(Request.QueryString["CanUploadFile"].ToString()) ? "0" : Request.QueryString["CanUploadFile"].ToString();
                this.hiddenCanDeleteFile.Text = Request.QueryString["CanDeleteFile"] == null || string.IsNullOrEmpty(Request.QueryString["CanDeleteFile"].ToString()) ? "0" : Request.QueryString["CanDeleteFile"].ToString();

                this.Show();
            }
        }

        protected void AttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            DataSet ds = attachBll.GetAttachmentByMainId(this.InstanceId, (AttachmentType)Enum.Parse(typeof(AttachmentType), FolderName), (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarAttachement.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            AttachmentStore.DataSource = ds;
            AttachmentStore.DataBind();
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
                string file = Server.MapPath("\\Upload\\UploadFile\\" + FolderName + "\\" + newFileName);
                string strFolderPath = Server.MapPath("\\Upload\\UploadFile\\" + FolderName);
                if (!Directory.Exists(strFolderPath))
                {
                    Directory.CreateDirectory(strFolderPath);
                }
                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                this.hiddenFileName.Text = newFileName;

                Attachment attach = new Attachment();
                attach.Id = Guid.NewGuid();
                attach.MainId = this.InstanceId;
                attach.Name = fileExtention;
                attach.Url = newFileName;
                attach.Type = FolderName;
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

        protected void ShowAttachmentWindow(object sender, AjaxEventArgs e)
        {
            this.hidRtnVal.Clear();
            this.hidRtnMsg.Clear();
            this.AttachmentWindow.Show();
        }

        private void Show()
        {
            if (CanUploadFile)
            {
                this.btnAddAttach.Disabled = false;
            }
            else
            {
                this.btnAddAttach.Disabled = true;
            }

            if (CanDeleteFile)
            {
                this.gpAttachment.ColumnModel.SetHidden(7, false);
            }
            else
            {
                this.gpAttachment.ColumnModel.SetHidden(7, true);
            }

            gpAttachment.Reload();
        }

        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                attachBll.DelAttachment(new Guid(id));
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\" + FolderName);
                File.Delete(uploadFile + "\\" + fileName);
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除附件失败，请联系DMS技术支持").Show();
            }
        }
    }
}
