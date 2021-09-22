using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace DMS.Website.Excel.Export
{
    public partial class download : System.Web.UI.Page
    {
        private string filename;
        private string savefilename;
        private string downloadtype;
        protected void Page_Load(object sender, EventArgs e)
        {
            filename = Request.QueryString["filename"].ToString();
            savefilename = Request.QueryString["savefilename"].ToString();
            downloadtype = Request.QueryString["DownloadType"].ToString();
            DownloadFile();
            //DownloadFileNew();
        }

        //使用OutputStream.Write分块下载文件,解决大文件下载
        protected string DownloadFileNew()
        {
            string strError = string.Empty;
            //指定块大小
            long chunkSize = 204800;
            //建立一个200K的缓冲区
            byte[] buffer = new byte[chunkSize];
            //已读的字节数
            long dataToRead = 0;
            FileStream stream = null;
            try
            {
                //打开文件
                stream = new FileStream(filename, FileMode.Open, FileAccess.Read, FileShare.Read);
                dataToRead = stream.Length;
                //添加Http头
                HttpContext.Current.Response.ContentType = "application/octet-stream";
                HttpContext.Current.Response.AddHeader("Content-Disposition", "attachement;filename=" + HttpUtility.UrlEncode(savefilename, System.Text.Encoding.UTF8));
                HttpContext.Current.Response.AddHeader("Content-Length", dataToRead.ToString());
                while (dataToRead > 0)
                {
                    if (HttpContext.Current.Response.IsClientConnected)
                    {
                        int length = stream.Read(buffer, 0, Convert.ToInt32(chunkSize));
                        HttpContext.Current.Response.OutputStream.Write(buffer, 0, length);
                        HttpContext.Current.Response.Flush();
                        //HttpContext.Current.Response.Clear();
                        buffer = new Byte[chunkSize];
                        dataToRead = dataToRead - length;
                    }
                    else
                    {
                        //防止client失去连接
                        dataToRead = -1;
                    }
                }
            }
            catch (Exception ex)
            {
                strError = ex.Message;
            }
            finally
            {
                if (stream != null)
                {
                    stream.Close();
                }
                HttpContext.Current.Response.Close();
            }
            return strError;
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

                    if (fi.Extension == "xls")
                    {
                        Response.ContentType = "application/vnd.ms-excel";
                    }
                    else
                    {
                        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    }

                    Response.WriteFile(filename);

                    if (!String.IsNullOrEmpty(downloadtype))
                    {
                        HttpCookie cookie = new HttpCookie("DownloadCook");//初使化并设置Cookie的名称
                        DateTime dt = DateTime.Now;
                        TimeSpan ts = new TimeSpan(0, 0, 0, 5, 0);//过期时间为5秒钟
                        cookie.Expires = dt.Add(ts);//设置过期时间
                        cookie.Values.Add("fileDownload_" + downloadtype, "true");
                        Response.AppendCookie(cookie);
                    }

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