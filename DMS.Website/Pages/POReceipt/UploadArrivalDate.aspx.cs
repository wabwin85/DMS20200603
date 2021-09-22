using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Business;
using DMS.Website.Common;
using Microsoft.Practices.Unity;
using Coolite.Ext.Web;
using System.Data;
using System.Data.OleDb;
using System.IO;
using Lafite.RoleModel.Security;

namespace DMS.Website.Pages.POReceipt
{
    public partial class UploadArrivalDate : BasePage
    {
        private IArrivalDate _bll = null;
        [Dependency]
        public IArrivalDate bll
        {
            get { return _bll; }
            set { _bll = value; }
        }
        private IRoleModelContext _context = RoleModelContext.Current;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                bool writable = pers.IsPermissible(Business.ArrivalDate.Action_UploadArrivalDate, PermissionType.Write);
                this.SaveButton.Visible = writable;
                this.ImportButton.Visible = writable;
                this.ResetButton.Visible = writable;
                this.DownloadButton.Visible = writable;
            }
        }

        #region Store
        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DataSet ds = bll.GetArrivalDateErrorList(new Guid(_context.User.Id),this.hidFileName.Text);
            this.Store1.DataSource = ds;
            this.Store1.DataBind();
        }
        #endregion


        #region
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
                        Title = GetLocalResourceObject("fileExtention.Msg.Show.Title").ToString(),
                        Message = GetLocalResourceObject("fileExtention.Msg.Show.Message").ToString()
                    });

                    return;
                }

                //构造文件名称

                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\ArrivalDate\\" + newFileName);


                //文件上传 
                FileUploadField1.PostedFile.SaveAs(file);

                this.hidFileName.Text = newFileName;

                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = GetLocalResourceObject("SaveSuccess.Title").ToString(),
                    Message = GetLocalResourceObject("SaveSuccess.Message").ToString()
                });
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

            string file = Server.MapPath("\\Upload\\ArrivalDate\\" + this.hidFileName.Text);
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
                if (ds.Tables[0].Columns.Count != 3)
                {
                    Ext.Msg.Alert("Error", GetLocalResourceObject("Ext.Msg.Alert.Error.Message").ToString()).Show();
                    return;
                }

                if (ds.Tables[0].Rows.Count > 0)
                {

                    if (bll.ImportArrivalDate(ds, hidFileName.Text))
                    {
                        string IsValid = string.Empty;

                        if (bll.Verify(out IsValid,this.hidFileName.Text))
                        {
                            if (IsValid == "Success")
                            {
                                Ext.Msg.Alert("Message", GetLocalResourceObject("IsValid.Success.Ext.Msg.Alert.Message").ToString()).Show();
                            }
                            else if (IsValid == "Error")
                            {
                                Ext.Msg.Alert("Message", GetLocalResourceObject("IsValid.Error.Ext.Msg.Alert.Message").ToString()).Show();
                            }
                            else
                            {
                                Ext.Msg.Alert("Message", GetLocalResourceObject("IsValid.Ext.Msg.Alert.Message").ToString()).Show();
                            }
                        }
                        else
                        {
                            Ext.Msg.Alert("Error", GetLocalResourceObject("ImportSendInvoice.Ext.Msg.Alert.Message").ToString()).Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("Error", GetLocalResourceObject("ImportSendInvoice.Ext.Msg.Alert.Message").ToString()).Show();
                    }
                }
                else
                {
                    Ext.Msg.Alert("Error", GetLocalResourceObject("ImportSendInvoice.Failure.Ext.Msg.Alert.Message").ToString()).Show();
                }
            }
            this.Store1.DataBind();
        }

        #endregion
    }
}
