using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Lafite.RoleModel.Security;
using DMS.Business;
using System.Data;
using Coolite.Ext.Web;
using System.IO;
using System.Data.OleDb;
using Microsoft.Practices.Unity;
using DMS.Website.Common;
using System.Collections;

namespace DMS.Website.Pages.Order
{
    public partial class DealerPriceImport : BasePage
    {
        private IDealerPriceBLL _bll = null;
        [Dependency]
        public IDealerPriceBLL bll
        {
            get { return _bll; }
            set { _bll = value; }
        }
        private IRoleModelContext _context = RoleModelContext.Current;

        private DealerPriceBLL business = new DealerPriceBLL();

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
            DataSet list = bll.QueryDealerPriceInitErrorData((e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.ResultStore.DataSource = list;
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
                        Title = GetLocalResourceObject("fileExtention.Msg.Show.Title").ToString(),
                        Message = GetLocalResourceObject("fileExtention.Msg.Show.Message").ToString()
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
                DataTable dt = ExcelHelper.GetDataTable(file, "sheet1");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 3)
                {
                    Ext.Msg.Alert(GetLocalResourceObject("ImportClick.IsValid.Success.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.IsValid.Success.Alert.Body").ToString()).Show();
                    return;
                }

                if (dt.Rows.Count > 1)
                {
                    if (business.Import(dt, newFileName))
                    {
                        ImportData("Upload", "");
                    }
                    else
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title2").ToString(), GetLocalResourceObject("ImportClick.Alert.Body2").ToString()).Show();
                    }
                }
                else
                {
                    Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title3").ToString(), GetLocalResourceObject("ImportClick.Alert.Body3").ToString()).Show();
                }

                #endregion

            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = GetLocalResourceObject("SaveFailure.Title").ToString(),
                    Message = GetLocalResourceObject("SaveFailure.Message").ToString()
                });
            }
        }

        protected void ImportClick(object sender, AjaxEventArgs e)
        {

            ImportData("Import", txtRemark.Text);
        }

        private void ImportData(string importType, string remark)
        {
            string IsValid = string.Empty;

            if (business.VerifyDealerPriceInit(importType, remark, out IsValid))
            {
                if (IsValid == "Success")
                {
                    if (importType == "Upload")
                    {
                        ImportButton.Disabled = true;
                        Ext.Msg.Alert(GetLocalResourceObject("ImportClick.IsValid.Error.Alert.Title").ToString(), GetLocalResourceObject("SaveSuccess.Title").ToString()).Show();
                    }
                    else
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("ImportClick.IsValid.Error.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.IsValid.Error.Alert.Body").ToString()).Show();
                    }
                }
                else if (IsValid == "Error")
                {
                    Ext.Msg.Alert(GetLocalResourceObject("ImportClick.IsValid.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.IsValid.Alert.Body").ToString()).Show();
                }
                else
                {
                    Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.Alert.Body").ToString()).Show();
                }
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title1").ToString(), GetLocalResourceObject("ImportClick.Alert.Body1").ToString()).Show();
            }

        }
        #endregion

        [AjaxMethod]
        public void Save(string id, string articleNumber, string dealer, string price, string priceTypeName)
        {
            Hashtable data = new Hashtable();
            data["Id"] = new Guid(id);
            data["ArticleNumber"] = articleNumber;
            data["Dealer"] = dealer;
            data["Price"] = price;
            data["PriceTypeName"] = priceTypeName;
            business.Update(data);
        }

        [AjaxMethod]
        public void Delete(string id)
        {
            business.Delete(new Guid(id));
        }
    }
}
