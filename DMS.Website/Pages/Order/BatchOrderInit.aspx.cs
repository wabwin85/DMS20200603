using Coolite.Ext.Web;
using DMS.Business;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using Microsoft.Practices.Unity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Order
{
    public partial class BatchOrderInit : BasePage
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        private IBatchOrderInitBLL business = new BatchOrderInitBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.ImportButton.Disabled = true;

            }            
        
        }


        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            //删除用户数据

             business.DeleteBatchOrderInit(new Guid(_context.User.Id));

          

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
                        Title ="文件错误",
                        Message = "请使用正确的模板文件，模板文件为EXCEL",
                    });

                    return;
                }

                //构造文件名称

                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\Order\\" + newFileName);


                //文件上传 
                FileUploadField1.PostedFile.SaveAs(file);

                this.hidFileName.Text = newFileName;
                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                #endregion

                #region 读取文件到中间表
                //导入到中间表
                DataTable dt = ExcelHelper.GetDataTable(file,"sheet1");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 13)
                {
                    
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = "错误",
                        Message = "请使用正确模板!",
                    });
                    return;
                }

                if (dt.Rows.Count > 1)
                {
                    if (business.ImportLP(dt, newFileName))
                    {
                        ImportData("Upload");
                    }
                    else
                    {
                        
                        Ext.Msg.Show(new MessageBox.Config
                        {
                            Buttons = MessageBox.Button.OK,
                            Icon = MessageBox.Icon.ERROR,
                            Title = "错误",
                            Message = "Excel数据格式错误!",
                        });
                    }
                }
                else
                {
                   
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = "错误",
                        Message = "没有数据可导入!",
                    });
                }

                #endregion

            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = "上传失败",
                    Message = "文件未被成功上传!",
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

            if (business.VerifyBatchOrderInitBLL(importType, out IsValid))
            {
                if (IsValid == "Success")
                {
                    if (importType == "Upload")
                    {
                        ImportButton.Disabled = true;
                       
                        Ext.Msg.Show(new MessageBox.Config
                        {
                            Buttons = MessageBox.Button.OK,
                            Icon = MessageBox.Icon.INFO,
                            Title = "消息",
                            Message = "已成功上传文件!",
                        });
                    }
                    else
                    {                      
                        Ext.Msg.Show(new MessageBox.Config
                        {
                            Buttons = MessageBox.Button.OK,
                            Icon = MessageBox.Icon.INFO,
                            Title = "消息",
                            Message = "数据导入成功!",
                        });
                    }
                }
                else if (IsValid == "Error")
                {
                   
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = "消息",
                        Message = "数据包含错误!",
                    });
                }
                else
                {
                   
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = "消息",
                        Message = "数据导入异常!",
                    });
                }
            }
            else
            {               
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "消息",
                    Message = "导入数据过程发生错误!",
                });
            }

        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet list = business.QueryBatchOrderInitErrorData((e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.ResultStore.DataSource = list;
            this.ResultStore.DataBind();
        }
    }
}