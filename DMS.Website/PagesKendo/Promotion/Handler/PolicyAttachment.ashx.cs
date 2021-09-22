using DMS.Business.Promotion;
using DMS.Model.ViewModel;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.SessionState;

namespace DMS.Website.PagesKendo.Promotion.Handler
{
    /// <summary>
    /// PolicyAttachment 的摘要说明
    /// </summary>
    public class PolicyAttachment : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            //获取请求的动作
            string action1 = context.Request.QueryString["ActionType"];
            string action = string.IsNullOrEmpty(action1) ? context.Request.Form["ActionType"] : action1;
            //string Filetype = context.Request.QueryString["ForeignType"];
            //string filesRaw = context.Request.Form["filesRaw"];
            if (string.IsNullOrEmpty(action)) return;
            //if (string.IsNullOrEmpty(filename) || string.IsNullOrEmpty(fileEx)) return;
            switch (action)
            {
                case "SecondRate":
                    UploadFile(context);
                    break;

                case "DelPath":
                    DeleteFile(context);
                    break;
              
            }

        }

      
        private void UploadFile(HttpContext context)
        {
            IRoleModelContext _context = RoleModelContext.Current;
            UploadService _ser = new UploadService();
            UploadView _uv = new UploadView();
            string relativeFilePath = string.Empty;
            string clientFilePath = string.Empty;
            string fileName = string.Empty;
            //Guid fileId = SequentialGuid.NewSequentialGuid();
            string destFile = string.Empty;
            string fileExt = "";
            var PolicyId = context.Request.QueryString["PolicyId"];

            try
            {


                if (context.Request.Files.Count > 0)
                {
                    HttpPostedFile hpfFile = context.Request.Files[0];
                    fileName = GetFileName(hpfFile.FileName);

                    

                    string relativePath = GetRelativePath(context);

                    //检查目标目录是否存在                         
                    string fullPath = BuildPath(relativePath);

                    string strNewFileName = GetRenewName(fullPath, fileName);
                    relativeFilePath = Path.Combine(relativePath, strNewFileName);
                    clientFilePath = VirtualPathUtility.ToAbsolute(relativeFilePath);
                    //目标文件路径
                    destFile = Path.Combine(fullPath, strNewFileName);

                
                    hpfFile.SaveAs(destFile);

                    Hashtable obj = new Hashtable();
                    obj.Add("PolicyId", PolicyId);
                    obj.Add("Name", fileName);
                    obj.Add("Url", strNewFileName);
                    obj.Add("UploadUser", _context.User.Id);
                    obj.Add("UploadDate", DateTime.Now.ToShortDateString());
                    obj.Add("Type", "Policy");

                    _ser.InsertPolicyAttachment(obj);

                    _uv.FilePath = destFile;
                    _uv.FileName = fileName;
                    _uv.FileSize = fileExt;
                    
                    _uv.Status = "success";
                    _uv.Error = "文件上传成功！";

                }
            }
            catch (Exception ex)
            {
                _uv.Status = "error";
                _uv.Error = ex.Message;
            }

            context.Response.Clear();
            context.Response.AddHeader("Content-type", "text/plain;charset=UTF-8");
            context.Response.Write(JsonConvert.SerializeObject(_uv));
            //context.Response.Flush();
            //context.Response.Close();
            //Chrome浏览器会有ERR_INCOMPLETE_CHUNKED_ENCODING的问题，所以改用End()方法
            context.Response.End();
        }
        private void DeleteFile(HttpContext context)
        {
            UploadService _ser = new UploadService();
            UploadView _uv = new UploadView();
            var filepath = context.Request.Form["DelFullPath"];
            if (File.Exists(filepath))
            {
                //逻辑删除
                // _ser.DeletePolicyAttachment(id);

                File.Delete(filepath);
                _uv.Status = "success";

            }
            else
            {
                _uv.Status = "error";
                _uv.Error = "路径为空";
            }

            context.Response.Write(JsonConvert.SerializeObject(_uv));
        }

        /// <summary>
        /// 获取相对路径
        /// fromat:/d1/d2/
        /// </summary>
        /// <param name="context"></param>
        /// <param name="strFileName"></param>
        /// <returns></returns>
        public string GetRelativePath(HttpContext context)
        {
            string fileFolder = string.IsNullOrEmpty(context.Request.QueryString["ForeignType"]) ? context.Request.Form["ForeignType"] : context.Request.QueryString["ForeignType"];// folder
            string path = "~/Upload/UploadFile/";
            if (!string.IsNullOrEmpty(fileFolder.Trim()))
            {
                path = Path.Combine(path, fileFolder);
            }
            Regex r = new Regex("\\|/", RegexOptions.None);
            path = r.Replace(path, Path.DirectorySeparatorChar.ToString());
            return path;
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
        /// <summary>
        /// 查看路径是否存在，
        /// 不存在，则创建
        /// </summary>
        /// <param name="path"></param>
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

            ////用GUID作为文件名
            strNewName = string.Format("{0}_{1}{2}", DateTime.Now.ToString("yyyy-MM-dd"), Guid.NewGuid(), fileExtension);

            return strNewName;
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}