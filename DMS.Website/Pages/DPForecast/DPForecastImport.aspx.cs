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
using DMS.Business.DP;
using DMS.Model;
using DMS.Common;
using DMS.Business.Excel;
using System.Collections;

namespace DMS.Website.Pages.DPForecast
{
    public partial class DPForecastImport : BasePage
    {
        private IDPForecastImportService business = new DPForecastImportService();
        private XlsImport XlsImport = new XlsImport("DealerPurchaseForecastAdjust");

        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                string yera = DateTime.Now.Year.ToString();
                string month = DateTime.Now.ToString("MM");
                this.GridPanel1.Title = "M=" + yera + month;
                this.Bind_ProductLine(ProductLineStore);
               
              
            }
          
     
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
                        Title = GetLocalResourceObject("UploadClick.HasFile.Msg.Show.Title").ToString(),
                        Message = GetLocalResourceObject("UploadClick.HasFile.Msg.Show.Message").ToString()
                    });

                    return;
                }

                //构造文件名称
                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;
                //上传文件在Upload文件夹
                string file = Server.MapPath("\\Upload\\DealerPurchaseForecast\\" + newFileName);
                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                this.hiddenFileName.Text = newFileName;
                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                #endregion

                #region 读取文件到中间表
                //导入到中间表
                DataTable dt = ExcelHelper.GetDataTable(file, "sheet1");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 44)
                {
                    Ext.Msg.Alert(GetLocalResourceObject("ImportClick.IsValid.Success.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.IsValid.Success.Alert.Body").ToString()).Show();
                    return;
                }
                
                if (dt.Rows.Count >= 5)
                {
                    //调用Import方法导入
                    string strReturn = XlsImport.Import(dt);

                    //
                    if (strReturn == "Success")
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("ImportClick.IsValid.Error.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.IsValid.Error.Alert.Body").ToString()).Show();
                         

                    }
                    else if (strReturn == "Error")
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("ImportClick.IsValid.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.IsValid.Alert.Body").ToString()).Show();
                    }
                    else
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title").ToString(), strReturn).Show();
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

        protected void DownloadClick(object sender, AjaxEventArgs e)
        {           
            string cbProductLine = this.cbProductLine.SelectedItem.Value;            
            DataSet ds = business.GetYearMonth();
            if (ds.Tables[0].Rows.Count.Equals(0))
            {
                Ext.Msg.Alert(GetLocalResourceObject("DownloadClick.Msg.Title").ToString(), GetLocalResourceObject("DownloadClick.Msg.Message").ToString()).Show();
            }
            else
            {
                string strYearMonth = ds.Tables[0].Rows[0]["CDD_Calendar"].ToString();
                DataSet dsData = business.DPForecastExport(strYearMonth, cbProductLine);
                XlsExport XlsExport = new XlsExport("DealerPurchaseForecastAdjust");
                Hashtable ht = new Hashtable();
                string fileName = XlsExport.ExportWithoutDelete(ht, dsData);

                DataSet ds3MonthBP = business.Get3MonthBP();

                ExcelEdit e1 = new ExcelEdit("excel2007");
                try
                {
                    e1.Open(fileName);
                    //复制每行的计算公式
                    e1.CopyCellValue(e1.GetSheet(1), 5, 39, 5, 44, 5, 39, 5 + dsData.Tables[0].Rows.Count - 1, 44);
                    //写入3个月指标金额
                    if (ds3MonthBP.Tables[0].Rows.Count > 0)
                    {
                        e1.SetCellValue(e1.GetSheet(1), 2, 39, ds3MonthBP.Tables[0].Rows[0]["MonthlyBP1"].ToString());
                        e1.SetCellValue(e1.GetSheet(1), 2, 40, ds3MonthBP.Tables[0].Rows[0]["MonthlyBP2"].ToString());
                        e1.SetCellValue(e1.GetSheet(1), 2, 41, ds3MonthBP.Tables[0].Rows[0]["MonthlyBP3"].ToString());

                        e1.SetCellValue(e1.GetSheet(1), 2, 42, ds3MonthBP.Tables[0].Rows[0]["MonthlyBP1"].ToString());
                        e1.SetCellValue(e1.GetSheet(1), 2, 43, ds3MonthBP.Tables[0].Rows[0]["MonthlyBP2"].ToString());
                        e1.SetCellValue(e1.GetSheet(1), 2, 44, ds3MonthBP.Tables[0].Rows[0]["MonthlyBP3"].ToString());
                    }

                    e1.Save();
                }
                catch (Exception ex)
                { 
                }
                finally
                {
                    e1.Close();
                    e1 = null;
                }

                try
                {
                    string strFileName = fileName.Substring(fileName.LastIndexOf("\\")+1);
                    string strDownloadFile = Server.MapPath("~") + (Server.MapPath("~").EndsWith("\\") ? "" : "\\") + "Excel\\Export\\temp\\" + strFileName;
                    System.Web.HttpContext.Current.Server.Transfer("~\\Excel\\Export\\download.aspx?filename=" + strDownloadFile.Replace("\\", "\\\\") + "&savefilename=DealerPurchaseForecastAdjust.xlsx", false);
                     
                }
                catch (Exception ex)
                {

                }
                finally
                {
                    File.Delete(fileName);
                }
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            this.ResultStore.DataSource = XlsImport.GetErrorList((e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            this.ResultStore.DataBind();
            e.TotalCount = totalCount;
        }

    }
}