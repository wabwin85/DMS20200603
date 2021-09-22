using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.OleDb;
using System.IO;

namespace DMS.Website.Pages.MasterDatas
{
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;

    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Common;
    using Microsoft.Practices.Unity;
 
    public partial class CFNBatch : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private ICfns _cfns = Global.ApplicationContainer.Resolve<ICfns>();

        protected void Page_Load(object sender, EventArgs e)
        {

        }


        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            //string tpl = "Uploaded file: {0}<br/>Size: {1} bytes";

            if (this.FileUploadField1.HasFile)
            {
                //总记录条数、成功条数、失败条数
                int intTotal = 0;
                int intSuccess = 0;
                int intFalse = 0;

                string nam = FileUploadField1.PostedFile.FileName;


                int i = nam.LastIndexOf(".");

                string newext = nam.Substring(i);

                DateTime now = DateTime.Now;

                //构造文件名称 年+月+日+时+分+秒+文件长度
                string newname = now.Year.ToString() + now.Month.ToString() + now.Day.ToString() + now.Hour.ToString() + now.Minute.ToString() + now.Second.ToString() + FileUploadField1.PostedFile.ContentLength.ToString();

                //上传文件在Upload文件夹
                string file = Server.MapPath("\\Upload\\" + newname + newext);

                //判断文件类型
                if (newext.ToUpper() != ".XLS" && newext.ToUpper() != ".XLSX") 
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "文件错误",
                        Message = "请使用正确的模板文件，模板文件为EXCEL文件！"
                    });

                    return;
                }

                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);
                

                //读取EXCEL文件
                if (File.Exists(file))
                    _cfns.ImportFromExcel(file,ref intTotal, ref intSuccess, ref intFalse);

                

                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = "上传成功",
                    //Message = string.Format(tpl, this.FileUploadField1.PostedFile.FileName, this.FileUploadField1.PostedFile.ContentLength)
                    Message = "已成功上传文件，在共计" + intTotal + "条数据中，"+ intSuccess + "条产品数据导入成功，" + intFalse + "条产品数据导入失败！"
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

         /// <summary>
        /// Called when [authenticate].
        /// </summary>
        protected override void OnAuthenticate()
        {
            Permissions pers = this._context.User.GetPermissions();

            //正式使用权限时请使用Visible = false, 更安全;

            this.SaveButton.Visible = pers.IsPermissible(Business.Cfns.Action_CFNBatch, PermissionType.Write);
        

        }
    }
}
