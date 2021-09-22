using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Shipment
{
    public partial class Download : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string filename = Request.QueryString["filename"];
            DownloadFile(filename);
        }

        protected string DownloadFile(string filename)
        {

            string strError = string.Empty;
            //文件创建成功
            if (string.IsNullOrEmpty(strError) && System.IO.File.Exists(filename))
            {
                int intStart = filename.LastIndexOf("\\") + 1;
                string saveFileName = filename.Substring(intStart, filename.Length - intStart);
                try
                {
                    System.IO.FileInfo fi = new System.IO.FileInfo(filename);

                    Response.Clear();
                    Response.Charset = "utf-8";
                    Response.Buffer = true;
                    this.EnableViewState = false;
                    Response.ContentEncoding = System.Text.Encoding.UTF8;

                    Response.AppendHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(saveFileName, System.Text.Encoding.UTF8));
                    Response.AppendHeader("Content-Length", fi.Length.ToString());
                    Response.ContentType = "application/vnd.ms-excel";

                    Response.WriteFile(filename);
                    Response.Flush();
                    Response.Close();

                    Response.End();

                }
                catch (Exception ex)
                {
                    strError = ex.Message;
                }
            }
            return strError;
        }
    }
}
