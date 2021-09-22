using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;
using System.Web;
using DMS.Common.Extention;

namespace DMS.Common
{
    public class WebHelper
    {
        public static String GetWebRoot()
        {
            String root = HttpRuntime.AppDomainAppVirtualPath;
            if (root.Substring(root.Length - 1, 1) != "/")
            {
                root += "/";
            }

            return root;
        }

        public static void DownloadFile(String fullName, String displayName, String cookieName)
        {
            if (File.Exists(fullName))
            {
                FileInfo fileInfo = new FileInfo(fullName);
                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpContext.Current.Server.UrlEncode(displayName));
                HttpContext.Current.Response.AddHeader("Content-Length", fileInfo.Length.ToString());
                HttpContext.Current.Response.ContentType = "application/octet-stream";
                HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.UTF8;
                HttpContext.Current.Response.WriteFile(fullName);

                ////以字符流的形式下载文件
                //FileStream fs = new FileStream(fullName, FileMode.Open);
                //byte[] bytes = new byte[(int)fs.Length];
                //fs.Read(bytes, 0, bytes.Length);
                //fs.Close();
                //HttpContext.Current.Response.ContentType = "application/octet-stream";
                ////通知浏览器下载文件而不是打开
                //HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(displayName, System.Text.Encoding.UTF8));
                //HttpContext.Current.Response.BinaryWrite(bytes);
                //HttpContext.Current.Response.Flush();
                //HttpContext.Current.Response.End();

                if (!cookieName.IsNullOrEmpty())
                {
                    HttpCookie cookie = new HttpCookie("DownloadCook");//初使化并设置Cookie的名称
                    DateTime dt = DateTime.Now;
                    TimeSpan ts = new TimeSpan(0, 0, 0, 5, 0);//过期时间为5秒钟
                    cookie.Expires = dt.Add(ts);//设置过期时间
                    cookie.Values.Add("fileDownload_" + cookieName, "true");
                    HttpContext.Current.Response.AppendCookie(cookie);
                }
            }
            else
            {
                throw new Exception("文件不存在！");
            }
        } 
    }
}
