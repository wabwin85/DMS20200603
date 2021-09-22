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

namespace DMS.Website.Pages.Inventory
{
    public partial class InventorySafetyImport : BasePage
    {
        private IInventorySafetyBLL _bll = null;
        [Dependency]
        public IInventorySafetyBLL bll
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
                //Modify this Permission
                bool writable = pers.IsPermissible(Business.PurchaseOrderBLL.Action_OrderApply, PermissionType.Read);
                //this.SaveButton.Visible = writable;
                this.ImportButton.Visible = writable;
                //this.ResetButton.Visible = writable;
                this.DownloadButton.Visible = writable;
            }
        }

        #region Store
        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            IList<DMS.Model.InventorySafetyInit> list = bll.QueryInvenotrySafetyInitErrorData((e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.ResultStore.DataSource = list;
            this.ResultStore.DataBind();
        }
        #endregion


        #region
        protected bool UploadClick(object sender, AjaxEventArgs e)
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

                    return false;
                }

                else
                {
                    //构造文件名称

                    string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                    //上传文件在Upload文件夹

                    string file = Server.MapPath("\\Upload\\InventoryInit\\" + newFileName);


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
                    return true;
                }
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
                return false;
            }

        }

        protected void ImportClick(object sender, AjaxEventArgs e)
        {
           
            this.ResultStore.RemoveAll();
            UploadClick(sender, e);

            bool upc = UploadClick(sender, e);

            if (!upc)
            {
                return;
            }

            string file = Server.MapPath("\\Upload\\InventoryInit\\" + this.hidFileName.Text);
            string ext = System.IO.Path.GetExtension(file);
            string strConn = null;
            //读取EXCEL文件
            if (File.Exists(file))
            {
                //if (ext == ".xls")
                //{
                //    strConn = "Provider=Microsoft.Jet.OLEDB.4.0;" + "Data Source=" + file + ";" + "Extended Properties=\"Excel 8.0;HDR=NO;IMEX=1;\"";
                //}
                //else if (ext == ".xlsx")
                //{
                //    strConn = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + file + ";" + "Extended Properties=\"Excel 12.0;HDR=NO;IMEX=1;\"";
                //}

                strConn = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + file + ";" + "Extended Properties=\"Excel 12.0;HDR=NO;IMEX=1;\"";

                DataSet ds = new DataSet();
                try
                {
                    OleDbConnection conn = new OleDbConnection(strConn);

                    conn.Open();

                    OleDbDataAdapter myCommand = new OleDbDataAdapter("select * from [sheet1$]", strConn);


                    myCommand.Fill(ds, "table1");

                    conn.Close();
                }
                catch (Exception ex)
                {
                    throw ex;
                }


                //根据列数量判断文件模板是否正确
                if (ds.Tables[0].Columns.Count < 5)
                {
                    Ext.Msg.Alert("Error", GetLocalResourceObject("Ext.Msg.Alert.Error.Message").ToString()).Show();
                    return;
                }

                if (ds.Tables[0].Rows.Count > 1)
                {

                    if (bll.ImportInventorySafetyInit(ds, hidFileName.Text))
                    {
                        string IsValid = string.Empty;

                        if (bll.VerifyInvenotrySafetyInit(out IsValid))
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

            this.ResultStore.DataBind();

        }

        #endregion
    }
}
