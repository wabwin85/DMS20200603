using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Excel.Export
{
    public partial class downloadAll : System.Web.UI.Page
    {
        private string filename;
        private string savefilename;
        private string type;
        protected void Page_Load(object sender, EventArgs e)
        {
            filename = Request.QueryString["filename"].ToString().Replace(" ", "+");
            savefilename = Request.QueryString["savefilename"].ToString();
            type = Request.QueryString["type"].ToString();
            DownloadFile();
        }

        protected string DownloadFile()
        {

            string strError = string.Empty;
            //文件创建成功
            if (string.IsNullOrEmpty(strError) && System.IO.File.Exists(filename))
            {
                //int intStart = filename.LastIndexOf("\\") + 1;
                //string saveFileName = filename.Substring(intStart, filename.Length - intStart);
                try
                {
                    System.IO.FileInfo fi = new System.IO.FileInfo(filename);

                    Response.Clear();
                    Response.Charset = "gb2312";
                    Response.Buffer = true;
                    this.EnableViewState = false;
                    Response.ContentEncoding = System.Text.Encoding.GetEncoding("GB2312");

                    Response.AppendHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(savefilename, System.Text.Encoding.UTF8));
                    Response.AppendHeader("Content-Length", fi.Length.ToString());
                    Response.ContentType = getContentType(type);

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

        private string getContentType(string requestType)
        {
            string strReturn = "application/octet-stream";

            switch (requestType.ToLower())
            {
                case "rar": strReturn = "application/rar"; break;
                case "zip": strReturn = "application/rar"; break;
            }
            return strReturn;
        }
    }
}