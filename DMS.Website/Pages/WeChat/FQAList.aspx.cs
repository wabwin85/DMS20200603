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
using Microsoft.Practices.Unity;
using System.IO;

namespace DMS.Website.Pages.WeChat
{
    public partial class FQAList : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IWeChatBaseBLL _WhatBase = new WeChatBaseBLL();
        private const string ATTACHMENT_FILE_PATH = "\\Upload\\UploadFile\\WeChat\\";

        private IAttachmentBLL _attachmentBLL = null;
        [Dependency]
        public IAttachmentBLL attachmentBLL
        {
            get { return _attachmentBLL; }
            set { _attachmentBLL = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void StateStore_RefershData(object sender, StoreRefreshDataEventArgs e) 
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Id");
            dt.Columns.Add("Value");
            dt.Rows.Add("0", "未发布");
            dt.Rows.Add("1", "已发布");
            this.StateStore.DataSource = dt;
            this.StateStore.DataBind();
        }
        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable table = new Hashtable();
            if (!string.IsNullOrEmpty(this.tfTital.Text)) 
            {
                table.Add("Title", this.tfTital.Text);
            }
            if (!string.IsNullOrEmpty(this.cbState.SelectedItem.Value)) 
            {
                table.Add("State", this.cbState.SelectedItem.Value);
            }

            if (!string.IsNullOrEmpty(_context.User.FullName))
            {
                table.Add("UserName", _context.User.FullName);
            }

            DataSet ds = _WhatBase.GetFQA(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        protected void Store_RefreshAttachment(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Guid ContractId = new Guid(this.fqaId.Value.ToString());
            DataTable dt = attachmentBLL.GetAttachmentByMainId(ContractId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.AttachmentStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            AttachmentStore.DataSource = dt;
            AttachmentStore.DataBind();
        }

        [AjaxMethod]
        public void ShowFQAWindow()
        {
            //Init vlaue within this window control
            InitFQAWindow(true);
            this.fqaId.Text = Guid.NewGuid().ToString();
            this.fqaOperationType.Text = "Insert";
            this.gpAttachment.Reload();
            //Show Window
            this.FaqInputWindow.Show();
        }

        [AjaxMethod]
        public void EditFQAItem(string detailId)
        {
            InitFQAWindow(true);

            if (!string.IsNullOrEmpty(detailId))
            {
                LoadCorporateEntityWindow(new Guid(detailId));

                //Set Value
                this.fqaId.Text = detailId;
                this.fqaOperationType.Text = "Update";
                this.gpAttachment.Reload();
                //Show Window
                this.FaqInputWindow.Show();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        private void InitFQAWindow(bool canSubmit)
        {
            this.fqaId.Clear();
            this.fqaOperationType.Clear();
            this.tfTextTital.Clear();
            this.taTextBody.Clear();
            this.ufTextUpload.SetValue(string.Empty);
            this.cbTextState.Checked=false;
            if (canSubmit)
            {
                this.btnFqaSubmit.Visible = true;

                this.tfTextTital.ReadOnly = false;
                this.taTextBody.ReadOnly = false;
                this.cbTextState.ReadOnly = false;
            }
            else
            {
                this.btnFqaSubmit.Visible = false;

                this.tfTextTital.ReadOnly = true;
                this.taTextBody.ReadOnly = true;
                this.cbTextState.ReadOnly = true;
            }
        }

        private void LoadCorporateEntityWindow(Guid detailId)
        {
            Wechatfqa fqa = _WhatBase.GetFQAByFqaId(detailId);

            this.tfTextTital.Text = fqa.Title;
            this.taTextBody.Text = fqa.Body;
            this.cbTextState.Checked = fqa.State.HasValue ? fqa.State.Value : false;
        }

        [AjaxMethod]
        public void SubmintFqa()
        {
            string massage = "";
            if (String.IsNullOrEmpty(this.tfTextTital.Text))
            {
                massage += "请填写标题<br/>";
            }
            if (String.IsNullOrEmpty(this.taTextBody.Text))
            {
                massage += "请填写内容<br/>";
            }
            try
            {
                if (massage == "")
                {
                    Wechatfqa fqa = new Wechatfqa();
                    //Create
                    if (this.fqaOperationType.Text == "Insert")
                    {
                        Guid mianid = new Guid(this.fqaId.Text);
                        fqa.Id = mianid;
                        fqa.Title = this.tfTextTital.Text;
                        fqa.Body = this.taTextBody.Text;
                        fqa.State = this.cbTextState.Checked;
                        fqa.CreateUser = _context.User.FullName;
                        fqa.CreateDate = DateTime.Now;

                         _WhatBase.InsertFQA(fqa);
                    }
                    //Edit
                    else
                    {
                        fqa.Id = new Guid(this.fqaId.Text);
                        fqa.Title = this.tfTextTital.Text;
                        fqa.Body = this.taTextBody.Text;
                        fqa.State = this.cbTextState.Checked;

                        fqa.UpdateUser =_context.User.FullName;
                        fqa.UpdateDate = DateTime.Now;

                        _WhatBase.UpdateFQA(fqa);
                    }
                    FaqInputWindow.Hide();
                    GridPanel1.Reload();
                }
                else
                {
                    throw new Exception(massage);
                }
            }
            catch
            {
                massage = massage.Substring(0, massage.Length - 5);
                Ext.Msg.Alert("Error", massage).Show();
            }
        }

        [AjaxMethod]
        public string SavePicture()
        {
            string msg=UpLoadFile(new Guid(this.fqaId.Text));
            this.ufTextUpload.SetValue(string.Empty);
            return msg;
        }

        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                //逻辑删除
                attachmentBLL.DelAttachment(new Guid(id));
                //物理删除
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\WeChat");
                File.Delete(uploadFile + "\\" + fileName);
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除失败").Show();
            }
        }

        private string UpLoadFile(Guid mianId)
        {
            string msg = "";
            if (this.ufTextUpload.HasFile)
            {
                bool error = false;
                string fileName = ufTextUpload.PostedFile.FileName;
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
                    msg = "请上传正确的文件！";
                    return msg;
                }

                string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;
                string file = Server.MapPath(ATTACHMENT_FILE_PATH + newFileName);
                ufTextUpload.PostedFile.SaveAs(file);


                Attachment attach = new Attachment();
                attach.Id = Guid.NewGuid();
                attach.MainId = mianId;
                attach.Name = fileExtention;
                attach.Url = newFileName;
                attach.Type = "WechatFAQ";
                attach.UploadUser = new Guid(_context.User.Id);
                attach.UploadDate = DateTime.Now;

                attachmentBLL.AddAttachment(attach);

                return msg;
            }
            else
            {
                msg = "文件未被成功上传！";
                return msg;
            }
        }
    }
}
