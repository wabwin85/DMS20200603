using System;
using System.Collections;
using System.Configuration;
using System.Data;
using DMS.Website.Common;
using DMS.Business;
using Microsoft.Practices.Unity;
using DMS.Model.Data;
using Coolite.Ext.Web;
using DMS.Model;
using Lafite.RoleModel.Security;
using System.IO;
using System.Collections.Generic;
using DMS.Common;

namespace DMS.Website.Pages.Contract
{
    public partial class ContractAnnex : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IAttachmentBLL _attachmentBLL = null;
        [Dependency]
        public IAttachmentBLL attachmentBLL
        {
            get { return _attachmentBLL; }
            set { _attachmentBLL = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (Request.QueryString["Cmid"] != null && Request.QueryString["ParmetType"] != null
                    && Request.QueryString["DealerId"] != null && Request.QueryString["DealerType"] != null)
                {
                    this.hdDealerType.Value = Request.QueryString["DealerType"];

                    if (this.hdDealerType.Value.Equals(DealerType.T2.ToString()))
                    {
                        //维护二级经销商信息，附件关联经销商ID
                        this.hdCmId.Value = Request.QueryString["DealerId"];
                    }
                    else 
                    {
                        //维护一级经销商或者设备经销商，附件关联合同主表ID
                        this.hdCmId.Value = Request.QueryString["Cmid"];
                    }
                    this.hdParmetType.Value = Request.QueryString["ParmetType"];
                    if (this.hdParmetType.Value.Equals("Appointment")) 
                    {
                        this.hdParmetType.Value = SR.Const_ContractAnnex_Type_Appointment;
                    }
                    else if (this.hdParmetType.Value.Equals("Amendment")) 
                    {
                        this.hdParmetType.Value = SR.Const_ContractAnnex_Type_Amendment;
                    }
                    else if (this.hdParmetType.Value.Equals("Renewal"))
                    {
                        this.hdParmetType.Value = SR.Const_ContractAnnex_Type_Renewal;
                    }
                    else if (this.hdParmetType.Value.Equals("Termination"))
                    {
                        this.hdParmetType.Value = SR.Const_ContractAnnex_Type_Termination;
                    }
                }
            }
        }

        //附件类型
        protected void FileTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> fileType = DictionaryHelper.GetDictionary(this.hdParmetType.Value.ToString());
            FileTypeStore.DataSource = fileType;
            FileTypeStore.DataBind();
        }

        //附件
        protected void Store_RefreshAttachment(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Guid CmId = new Guid(this.hdCmId.Value.ToString());
            Hashtable tb = new Hashtable();
            tb.Add("MainId", CmId);
            tb.Add("ParType", this.hdParmetType.Value.ToString());

            DataTable dt = attachmentBLL.GetAttachment(tb, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.AttachmentStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            AttachmentStore.DataSource = dt;
            AttachmentStore.DataBind();
        }

        #region Page Event
        //附件上传
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

                this.hiddenWinFileName.Text = newFileName;

                Attachment attach = new Attachment();
                attach.Id = Guid.NewGuid();
                attach.MainId = new Guid(this.hdCmId.Value.ToString());
                attach.Name = fileExtention;
                attach.Url = newFileName;
                attach.Type = this.cbFileType.SelectedItem.Value;
                attach.UploadDate = DateTime.Now;
                attach.UploadUser = new Guid(_context.User.Id);

                attachmentBLL.AddAttachment(attach);

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
        #endregion

        #region 附件
        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                //逻辑删除
                attachmentBLL.DelAttachment(new Guid(id));
                //物理删除
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\DCMS");
                File.Delete(uploadFile + "\\" + fileName);
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除失败").Show();
            }
        }
        #endregion
    }
}
