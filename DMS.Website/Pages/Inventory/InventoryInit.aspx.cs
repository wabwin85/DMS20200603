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

namespace DMS.Website.Pages.Shipment
{
    public partial class InventoryInit : BasePage
    {

        private IInventoryInitBLL business = new InventoryInitBLL();


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.ImportButton.Disabled = true;

            }
        }

        protected void UploadClick(object sender, AjaxEventArgs e)
        {

            //先删除上传人之前的数据
            business.DeleteByUser();

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
                        Title = GetLocalResourceObject("UploadClick.HasFile.Msg.Show.Title").ToString(),
                        Message = GetLocalResourceObject("UploadClick.HasFile.Msg.Show.Message").ToString()
                    });

                    return;
                }



                //构造文件名称

                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\InventoryInit\\" + newFileName);


                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                this.hiddenFileName.Text = newFileName;
                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                #endregion

                #region 读取文件到中间表
                //导入到中间表
                DataTable dt = ExcelHelper.GetDataTable(file, "sheet1");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 7)
                {
                    Ext.Msg.Alert(GetLocalResourceObject("ImportClick.IsValid.Success.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.IsValid.Success.Alert.Body").ToString()).Show();

                }

                if (dt.Rows.Count > 1)
                {
                    if (business.ImportDealerInv(dt, newFileName))
                    {
                        string IsValid = string.Empty;
                        if (business.VerifyDII(out IsValid, 0))
                        {
                            if (IsValid == "Error")
                            {
                                Ext.Msg.Alert(GetLocalResourceObject("ImportClick.IsValid.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.IsValid.Alert.Body").ToString()).Show();
                            }

                        }
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
                    Title = GetLocalResourceObject("UploadClick.Msg.Show.Title").ToString(),
                    Message = GetLocalResourceObject("UploadClick.Msg.Show.Message").ToString()
                });


            }

        }



        protected void UploadConfirm(object sender, AjaxEventArgs e)
        {

        }


        [AjaxMethod]
        public void ImportClick()
        {
            ImportData();

            this.ResultStore.DataBind();

        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            this.ResultStore.DataSource = business.QueryDealerInventoryErrorData((e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            this.ResultStore.DataBind();
            e.TotalCount = totalCount;
        }

        private void ImportData()
        {
            string IsValid = string.Empty;

            if (business.VerifyDII(out IsValid,1))
            {
                if (IsValid == "Success")
                {

                    Ext.Msg.Alert(GetLocalResourceObject("ImportClick.IsValid.Error.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.IsValid.Error.Alert.Body").ToString()).Show();

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

        [AjaxMethod]
        public void Save(string id, string Warehouse, string ArticleNumber, string LotNumber, string Qty, string Period)
        {
            DMS.Model.DealerInventoryInit init = new DMS.Model.DealerInventoryInit();
            init.Id = new Guid(id);
            init.Warehouse = Warehouse;
            init.ArticleNumber = ArticleNumber;
            init.LotNumber = LotNumber;
            init.Qty = Qty;
            init.UploadDate = DateTime.Now;
            init.Period = Period;
            business.UpdateDII(init);

        }

        [AjaxMethod]
        public void Delete(string id)
        {
            business.DeleteDII(new Guid(id));

        }
    }
}
