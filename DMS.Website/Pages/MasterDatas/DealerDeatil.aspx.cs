using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.MasterDatas
{
    using System.Collections;
    using DMS.Website.Common;
    using System.Data;
    using DMS.Business;
    using Coolite.Ext.Web;
    using DMS.Common;
    using DMS.Model;
    using Lafite.RoleModel.Security;
    using System.IO;

    public partial class DealerDeatil : BasePage
    {
        private IAttachmentBLL _attachmentBLL = new AttachmentBLL();
        private IRoleModelContext _context = RoleModelContext.Current;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (Request.QueryString["DealerId"] != null) 
                {
                    this.hdDealerId.Text = Request.QueryString["DealerId"].ToString();
                }
            }
            this.hdContextUserId.Value = _context.User.Id;
        }

        //附件
        protected void Store_RefreshAttachment(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Guid DealerID = new Guid(this.hdDealerId.Text.Equals("") ? Guid.Empty.ToString() : this.hdDealerId.Text);
            Hashtable tb = new Hashtable();
            tb.Add("DealerID", DealerID);

            DataTable dt = _attachmentBLL.GetAttachmentContract(tb, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.AttachmentStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            AttachmentStore.DataSource = dt;
            AttachmentStore.DataBind();
        }

        //附件类型
        protected void FileTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary("Dealer_Annex");
            FileTypeStore.DataSource = dicts;
            FileTypeStore.DataBind();
        }
       
        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                //逻辑删除
                _attachmentBLL.DelAttachment(new Guid(id));
                //物理删除
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\DCMS");
                File.Delete(uploadFile + "\\" + fileName);
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除失败").Show();
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

                string file = Server.MapPath("\\Upload\\UploadFile\\DCMS\\" + newFileName);


                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                Attachment attach = new Attachment();
                attach.Id = Guid.NewGuid();
                attach.MainId = new Guid(this.hdDealerId.Value.ToString());
                attach.Name = fileExtention;
                attach.Url = newFileName;
                attach.Type = this.cbFileType.SelectedItem.Value;
                attach.UploadDate = DateTime.Now;
                attach.UploadUser = new Guid(_context.User.Id);
                //维护附件信息
                bool ckUpload = _attachmentBLL.AddAttachment(attach);

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
    }
}
