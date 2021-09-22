using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.OleDb;
using System.IO;
using Coolite.Ext.Web;
using Lafite.RoleModel.Security;
using DMS.Website.Common;
using DMS.Business;
using DMS.Model;
using DMS.Common;
using Microsoft.Practices.Unity;

namespace DMS.Website.Pages.Consignment
{
    public partial class ConsignmentApplyInit : BasePage
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        private IConsignmentApplyHeaderBLL _bll = null;
        [Dependency]
        public IConsignmentApplyHeaderBLL bll
        {
            get { return _bll; }
            set { _bll = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.ImportButton.Disabled = true;
            }
        }

        #region Store
        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = bll.SelectConsignmentApplyInitList((e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;
            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }
        #endregion

        #region
        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            if (this.FileUploadField1.HasFile)
            {
                #region 上传文件至服务器
                System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                bool error = false;

                string fileName = FileUploadField1.PostedFile.FileName;
                string fileExtention = string.Empty;
                if (fileName.LastIndexOf(".") < 0)
                {
                    error = true;
                }
                else
                {
                    fileExtention = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                    if (fileExtention != "xls" && fileExtention != "xlsx")
                    {
                        error = true;
                    }
                }

                if (error)
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "错误",
                        Message = "文件格式错误，请选择Excel文件上传！"
                    });

                    return;
                }

                //构造文件名称
                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹
                string file = Server.MapPath("\\Upload\\Consignment\\" + newFileName);

                //文件上传 
                FileUploadField1.PostedFile.SaveAs(file);
                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                #endregion

                #region 读取文件到中间表
                //导入到中间表
                DataTable dt = ExcelHelper.GetDataTable(file, "Sheet1");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 7)
                {
                    Ext.Msg.Alert("错误", "上传模板不符合要求!").Show();
                    return;
                }

                if (dt.Rows.Count > 1)
                {
                    if (bll.Import(dt, newFileName))
                    {
                        ImportData("Upload");
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "包含错误数据，请确认！").Show();
                    }
                }
                else
                {
                    Ext.Msg.Alert("错误", "数据为空，请维护数据!").Show();
                }

                #endregion

            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "错误",
                    Message = "请先选择上传文件！"
                });
            }
        }

        protected void ImportClick(object sender, AjaxEventArgs e)
        {

            ImportData("Import");
        }

        private void ImportData(string importType)
        {
            string IsValid = string.Empty;

            if (bll.VerifyConsignmentApplyInit(importType, out IsValid))
            {
                if (IsValid == "Success")
                {
                    if (importType == "Upload")
                    {
                        ImportButton.Disabled = false;
                        Ext.Msg.Alert("消息", "上传成功!").Show();
                    }
                    else
                    {
                        ImportButton.Disabled = true;
                        Ext.Msg.Alert("消息", "数据导入成功!").Show();
                    }
                }
                else if (IsValid == "Error")
                {
                    Ext.Msg.Alert("消息", "上传文件中包含错误数据，详情查看列表!").Show();
                }
                else
                {
                    Ext.Msg.Alert("消息", "数据导入异常!").Show();
                }
            }
            else
            {
                Ext.Msg.Alert("错误", "导入数据过程发生错误!").Show();
            }
        }
        #endregion

        [AjaxMethod]
        public void Save()
        {
            string IsValid = string.Empty;
            ImportData("Import");
        }

        [AjaxMethod]
        public void Delete(string id)
        {
            //business.Delete(new Guid(id));
        }
    }
}