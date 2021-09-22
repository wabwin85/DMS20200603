using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business;
using System.Collections;
using System.Data;
using DMS.Model.Data;
using DMS.Model;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using DMS.Common;
using Microsoft.Practices.Unity;
using System.IO;


namespace DMS.Website.Pages.Promotion
{
    public partial class PolicyAttachment : BasePage
    {
        #region 公用
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();
        #endregion

        public string InstanceId
        {
            get
            {
                return this.hidInstanceId.Text;
            }
            set
            {
                this.hidInstanceId.Text = value.ToString();
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (this.Request.QueryString["InstanceID"] != null)
                {
                    if (this.Request.QueryString["Type"] != null && (this.Request.QueryString["Type"].ToString().Equals("Gift")|| this.Request.QueryString["Type"].ToString().Equals("GiftInit")))
                    {
                        this.hidType.Value = this.Request.QueryString["Type"].ToString();
                        this.hidInstanceId.Value = this.Request.QueryString["InstanceID"].ToString();
                    }
                    else
                    {
                        this.hidType.Value = "Policy";
                        Hashtable obj = new Hashtable();
                        obj.Add("PolicyNo", this.Request.QueryString["InstanceID"].ToString());

                        DataTable dt = _business.GetProPolicyByHash(obj).Tables[0];
                        if (dt.Rows.Count > 0)
                        {
                            this.hidInstanceId.Value = dt.Rows[0]["PolicyId"].ToString();
                        }
                    }
                }
            }
        }

        protected void AttachmentStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("PolicyId", this.InstanceId);
            obj.Add("Type", this.hidType.Value.ToString());
            int totalCount = 0;
            this.AttachmentStore.DataSource = _business.QueryPolicyAttachment(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount);
            this.AttachmentStore.DataBind();
            e.TotalCount = totalCount;
        }

        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                //逻辑删除
                _business.DeletePolicyAttachment(id);
                //物理删除
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\Promotion");
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

                string file = Server.MapPath("\\Upload\\UploadFile\\Promotion\\" + newFileName);


                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                Hashtable obj = new Hashtable();
                obj.Add("PolicyId", this.InstanceId);
                obj.Add("Name", fileExtention);
                obj.Add("Url", newFileName);
                obj.Add("UploadUser", "cbc11bd3-c91d-4e5f-840e-a5e700eed84a");
                obj.Add("UploadDate", DateTime.Now.ToShortDateString());
                obj.Add("Type", this.hidType.Value.ToString());
                //维护附件信息
                _business.InsertPolicyAttachment(obj);

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
