using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using DMS.Website.Common;
using DMS.Business;
using DMS.Model;
using DMS.Common;
using System.Collections;
using System.Data;
using DMS.Business.Cache;
using DMS.Model.Data;
using Lafite.RoleModel.Security;
using Microsoft.Practices.Unity;

namespace DMS.Website.Pages.MasterDatas
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "OrderDiscountRule")]
    public partial class OrderDiscountRule : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IOrderDiscountRule business = new OrderDiscountRuleBLL();
        #endregion


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_ProductLine(ProductLineStore);
            }
        }

        #region 数据绑定
        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLineBumId", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                param.Add("Upn", this.txtUPN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtLot.Text))
            {
                param.Add("Lot", this.txtLot.Text);
            }

            DataSet ds = business.QueryOrderDiscountRule(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }
        protected void WindowUploadStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            this.WindowUploadStore.DataSource = business.QueryErrorData((e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            this.WindowUploadStore.DataBind();
            e.TotalCount = totalCount;
        }
        #endregion

        [AjaxMethod]
        public void RuleUploadShow()
        {
            this.WindowRuleInput.Show();
        }

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
                        Title = "上传出错！",
                        Message = "上传的不是Excel类型文件"
                    });

                    return;
                }

                //构造文件名称

                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\DiscountRule\\" + newFileName);


                //文件上传 
                FileUploadField1.PostedFile.SaveAs(file);
                
                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                #endregion

                #region 读取文件到中间表
                //导入到中间表
                DataTable dt = ExcelHelper.GetDataTable(file, "sheet1");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 10)
                {
                    Ext.Msg.Alert("出错", "模板错误，请选择正确模板上传数据").Show();
                    return;
                }

                if (dt.Rows.Count > 1)
                {
                    if (business.Import(dt))
                    {
                        ImportData("Upload");
                    }
                    else
                    {
                        Ext.Msg.Alert("出错", "上传错误！").Show();
                    }
                }
                else
                {
                    Ext.Msg.Alert("出错", "文件内容为空！").Show();
                }

                #endregion

            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "出错",
                    Message = "请选择上传文件"
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

            if (business.VerifyOrderDiscountRuleInit(importType, out IsValid))
            {
                if (IsValid == "Success")
                {
                    if (importType == "Upload")
                    {
                        ImportButton.Disabled = true;
                        Ext.Msg.Alert("消息", "保存成功!").Show();
                    }
                    else
                    {
                        Ext.Msg.Alert("消息", "数据导入成功!").Show();
                    }
                }
                else if (IsValid == "Error")
                {
                    Ext.Msg.Alert("消息", "数据包含错误!").Show();
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
    }
}