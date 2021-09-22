using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.PagesKendo
{
    public partial class Download : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //合同下载
            if (!string.IsNullOrEmpty(Request.QueryString["FilePath"]))
            {
              
                string filename = Request.QueryString["FileName"];
                string FilePath=Request.QueryString["FilePath"];
                DownloadContractFIle(filename, FilePath);
            }
        }
        private void DownloadContractFIle(string FileName,string FilePath)
        {
            string savename = FileName;

            try {

                //string filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + FilePath;

                //Response.Clear();
                //Response.Buffer = true;

                ////以字符流的形式下载文件 
                //System.IO.FileStream fs = new System.IO.FileStream(filename, System.IO.FileMode.Open);
                //byte[] bytes = new byte[(int)fs.Length];
                //fs.Read(bytes, 0, bytes.Length);
                //fs.Close();
                //Response.ContentType = "application/octet-stream";
                ////通知浏览器下载文件而不是打开 
                //Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(savename, System.Text.Encoding.UTF8));
                //Response.BinaryWrite(bytes);
                //Response.Flush();
                //Response.End();

                FilePath = HttpContext.Current.Server.MapPath(FilePath);

                Response.Clear();
                Response.Buffer = true;

                //以字符流的形式下载文件 
                System.IO.FileStream fs = new System.IO.FileStream(FilePath, System.IO.FileMode.Open);
                byte[] bytes = new byte[(int)fs.Length];
                fs.Read(bytes, 0, bytes.Length);
                fs.Close();
                Response.ContentType = "application/octet-stream";
                //通知浏览器下载文件而不是打开 
                Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(savename, System.Text.Encoding.UTF8));
                Response.BinaryWrite(bytes);
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {
                Response.Write(ex.Message.ToString());
            }
        }
    }
}