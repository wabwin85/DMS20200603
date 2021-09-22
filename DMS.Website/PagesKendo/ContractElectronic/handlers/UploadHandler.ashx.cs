using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace DMS.Website.PagesKendo.ContractElectronic.handlers
{
    /// <summary>
    /// UploadHandler 的摘要说明
    /// </summary>
    public class UploadHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string Type1 = context.Request.QueryString["Type"];
            string Type = string.IsNullOrEmpty(Type1) ? context.Request.Form["Type"] : Type1;
            string NewFileName1 = context.Request.QueryString["NewFileName"];
            string NewFileName = string.IsNullOrEmpty(NewFileName1) ? context.Request.Form["NewFileName"] : NewFileName1;
            if (string.IsNullOrEmpty(Type) || string.IsNullOrEmpty(NewFileName)) return;

            switch (Type)
            {
                case "OtherAttachment":
                    UploadFile(context, Type, NewFileName);
                    break;
                case "UploadProxy":
                    UploadFile(context, Type, NewFileName);
                    break;
            }
        }

        private void UploadFile(HttpContext context,string Type, string NewFileName)
        {
            string status = "success";
            string msg = "";
            string relativeFilePath = string.Empty;
            string clientFilePath = string.Empty;
            string fileName = string.Empty;

            int fileSize = 0;
            try
            {
              
                string relativePath = GetRelativePath(context);
                if (context.Request.Files.Count > 0)
                {
                    HttpPostedFile hpfFile = context.Request.Files[0];
                    //检查目标目录是否存在                         
                    string fullPath = BuildPath(relativePath);
                    fileName = GetFileName(hpfFile.FileName);
                    string strNewFileName = GetRenewName(fullPath, fileName);
                    relativeFilePath = Path.Combine(relativePath, strNewFileName);
                    clientFilePath = VirtualPathUtility.ToAbsolute(relativeFilePath);
                    //目标文件路径
                    string destFile = Path.Combine(fullPath, strNewFileName);
                    hpfFile.SaveAs(destFile);
                    fileSize = hpfFile.ContentLength;
                }
                    
            }
            catch (Exception ex)
            {
                status = "failure";
                msg = ex.Message;
            }
            //string Type = context.Request.QueryString["Type"] == null ? "" : context.Request.QueryString["Type"].ToString();
            string fileId = string.Empty;//file.Id.ToString();
            context.Response.Clear();

            //context.Response.ContentType = "text/plain";
            context.Response.AddHeader("Content-type", "text/plain;charset=UTF-8");
            context.Response.Write(UploadResult(status, clientFilePath, fileName, fileSize, msg, Type, fileId));
            //context.Response.Flush();
            //context.Response.Close();
            //Chrome浏览器会有ERR_INCOMPLETE_CHUNKED_ENCODING的问题，所以改用End()方法
            context.Response.End();
           
        }
        /// <summary>
        /// 获取相对路径
        /// fromat:/d1/d2/
        /// </summary>
        /// <param name="context"></param>
        /// <param name="strFileName"></param>
        /// <returns></returns>
        public  string GetRelativePath(HttpContext context)
        {
            string fileFolder = context.Request.QueryString["Type"];// folder
            string path = "~//Upload/ContractElectronicAttachmentTemplate/Uploadfiles/";
            if (!string.IsNullOrEmpty(fileFolder))
            {
                path = Path.Combine(path, fileFolder);
            }
            Regex r = new Regex("\\|/", RegexOptions.None);
            path = r.Replace(path, Path.DirectorySeparatorChar.ToString());
            return path;
        }

        private static string BuildPath(string path)
        {
            if (!Path.IsPathRooted(path))
            {
                path = HttpContext.Current.Server.MapPath(path);
            }

            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            return Path.GetFullPath(path);
        }
        private static string GetRenewName(string path, string fileName)
        {
            string strFullPath = string.Empty;
            string strNewName = fileName;
            //文件名，不含后缀
            string fileNameNoExt = fileName;
            //文件后缀名，包含“.”
            string fileExtension = string.Empty;

            int i = fileName.LastIndexOf('.');
            if (i > 0)
            {
                //文件名，不含后缀
                fileNameNoExt = fileName.Substring(0, i - 1);
                //文件后缀
                fileExtension = fileName.Substring(i, fileName.Length - i);
            }

            ////用数字作为文件名
            //strFullPath = Path.GetFullPath(Path.Combine(path, strNewName));
            //i = 1;
            //while (File.Exists(strFullPath))
            //{
            //    strNewName = fileNameNoExt + "_" + i.ToString() + fileExtension;
            //    strFullPath = Path.GetFullPath(Path.Combine(path, strNewName));
            //    i++;
            //}
            ////用GUID作为文件名
            strNewName = string.Format("{0}_{1}{2}", DateTime.Now.ToString("yyyy-MM-dd"), Guid.NewGuid(), fileExtension);

            return strNewName;
        }
        public string UploadResult(string status, string relativePath, string fileName, int size, string error, string Type, string fileId)
        {
            var result = new
            {
                status = status,
                FilePath = relativePath,
                FileName = fileName,
                FileSize = size,
                error = error,
                Type = Type,
                ID = fileId
            };
            return DMS.Common.JsonHelper.Serialize(result);
        }
        public string GetFileName(string fileName)
        {
            int i = fileName.LastIndexOf('\\');
            if (i > 0)
            {
                return fileName.Substring(i + 1, fileName.Length - i - 1);
            }
            else
                return fileName;
        }
        //private string GetRelativePath(HttpContext context)
        //{
        //    string path= "~/Upload/ContractElectronicAttachmentTemplate/Uploadfiles/";
        //}

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}