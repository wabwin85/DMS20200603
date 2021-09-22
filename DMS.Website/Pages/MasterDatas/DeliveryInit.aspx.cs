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

namespace DMS.Website.Pages.MasterDatas
{
    public partial class DeliveryInit : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.ImportButton.Disabled = true;
            }
        }

        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            if (this.FileUploadField1.HasFile)
            {

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
                        Title = GetLocalResourceObject("UploadClick.fileExtention.Msg.Show.Title").ToString(),
                        Message = GetLocalResourceObject("UploadClick.fileExtention.Msg.Show.Message").ToString()
                    });

                    return;
                }

                //构造文件名称

                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\DeliveryInit\\" + newFileName);


                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                this.hiddenFileName.Text = newFileName;

                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = GetLocalResourceObject("UploadClick.Msg.Show.Title").ToString(),
                    Message = GetLocalResourceObject("UploadClick.Msg.Show.Message").ToString()
                });
            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = GetLocalResourceObject("UploadClick.Msg.Show.Title1").ToString(),
                    Message = GetLocalResourceObject("UploadClick.Msg.Show.Message1").ToString()
                });
            }
        }

        protected void ImportClick(object sender, AjaxEventArgs e)
        {
            string file = Server.MapPath("\\Upload\\DeliveryInit\\" + this.hiddenFileName.Text);
            string ext = System.IO.Path.GetExtension(file);
            string strConn = null;
            //读取EXCEL文件
            if (File.Exists(file))
            {
                //if (ext == ".xls")
                //{
                //    strConn = "Provider=Microsoft.Jet.OLEDB.4.0;" + "Data Source=" + file + ";" + "Extended Properties=Excel 8.0;";
                //}
                //else if (ext == ".xlsx")
                //{
                //    strConn = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + file + ";" + "Extended Properties=Excel 12.0;";
                //}

                strConn = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + file + ";" + "Extended Properties=Excel 12.0;";

                OleDbConnection conn = new OleDbConnection(strConn);

                conn.Open();

                OleDbDataAdapter myCommand = new OleDbDataAdapter("select * from [sheet1$]", strConn);

                DataSet ds = new DataSet();
                myCommand.Fill(ds, "table1");

                conn.Close();

                //根据列数量判断文件模板是否正确
                if (ds.Tables[0].Columns.Count != 11)
                {
                    Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.Alert.Body").ToString()).Show();
                    return;
                }

                if (ds.Tables[0].Rows.Count > 0)
                {
                    IDeliveryNotes business = new DeliveryNotes();

                    if (business.Import(this.hiddenFileName.Text, ds))
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title1").ToString(), GetLocalResourceObject("ImportClick.Alert.Body1").ToString(), new MessageBox.ButtonsConfig
                        {
                            Ok = new MessageBox.ButtonConfig
                            {
                                Handler = "Coolite.AjaxMethods.GeneratePOReceipt();",
                                Text = GetLocalResourceObject("ImportClick.Ok.Text").ToString()
                            }
                        }).Show();
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
            }
            this.ResultStore.DataBind();
        }

        [AjaxMethod]
        public void GeneratePOReceipt()
        {
            IDeliveryNotes business = new DeliveryNotes();
            string IsValid = string.Empty;
            if (business.Generate(out IsValid))
            {
                if (IsValid == "Success")
                {
                    Ext.Msg.Alert(GetLocalResourceObject("GeneratePOReceipt.IsValid.Success.Alert.Title").ToString(), GetLocalResourceObject("GeneratePOReceipt.IsValid.Success.Alert.Body").ToString()).Show();
                }
                else
                {
                    Ext.Msg.Alert(GetLocalResourceObject("GeneratePOReceipt.IsValid.Alert.Title").ToString(), GetLocalResourceObject("GeneratePOReceipt.IsValid.Alert.Body").ToString()).Show();
                }
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("GeneratePOReceipt.Alert.Title").ToString(), GetLocalResourceObject("GeneratePOReceipt.Alert.Body").ToString()).Show();
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            IDeliveryNotes business = new DeliveryNotes();
            int totalCount = 0;
            IList<DMS.Model.DeliveryInit> list = business.QueryErrorDeliveryInit((e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;
            this.ResultStore.DataSource = list;
            this.ResultStore.DataBind();
        }
    }
}
