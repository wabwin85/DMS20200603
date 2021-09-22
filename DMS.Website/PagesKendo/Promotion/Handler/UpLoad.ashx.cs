using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using Newtonsoft.Json;
using Microsoft.Office.Interop.Excel;
using System.Web.UI;
using System.IO;
using DMS.Common;
using System.Text.RegularExpressions;
using DMS.Business;
using DMS.Website.Common;
using System.Data;
using DMS.Business.Promotion;
using DMS.Model.ViewModel;

namespace DMS.Website.PagesKendo.Promotion.Handler
{
    /// <summary>
    /// UpLoad 的摘要说明
    /// </summary>
    public class UpLoad : IHttpHandler
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
                case "Remove":
                    DeleteFile(context);
                    break;
                case "ParseRate":
                    ParseRate(context);
                    break;
                case "DownLoad":
                    DownLoad(context);
                    break;
                case "DelPath":
                    DeleteFile(context);
                    break;
                case "Load":
                    Load(context);
                    break;
                default:
                    break;
            }

        }

        private void Load(HttpContext context)
        {
            UploadService _ser = new UploadService();
            UploadView _uv = new UploadView();
            string MaintainType = context.Request.Form["MaintainType"];
            string PolicyFactorId = context.Request.Form["PolicyFactorId"];
            string pId = context.Request.QueryString["PolicyID"];
            string FactorClass = context.Request.Form["FactorClass"];
            _uv.PID = pId;
            _uv.MaintainType = MaintainType;
            _uv.PolicyFactorID = PolicyFactorId;
            _uv.PolicyFactorType = FactorClass;
            _ser.ParseFile(_uv);

            context.Response.Clear();
            context.Response.AddHeader("Content-type", "text/plain;charset=UTF-8");

            context.Response.Write(JsonConvert.SerializeObject(_uv));
            context.Response.End();
        }

        private void DeleteType(UploadView uv)
        {
            var maintainType = uv.MaintainType;
            UploadService _ser = new UploadService();

            if (maintainType == "SecondRate")
            {
                //先删除上传人之前的数据
                _ser.DeletePolicyPointRatioByUserId();
            }
            else if (maintainType == "TopVal")
            {
                _ser.DeleteTopValueByUserId();
            }
            else if (maintainType == "ProTarget")
            {
                //FactId,PolicyFactorId两个参数,暂时的
                _ser.DeleteProductIndexByUserId(uv.PolicyFactorType, uv.PolicyFactorID);
            }
            else if(maintainType== "Fiexd")
            {
                _ser.DeleteProductStandardPriceByUserId();
            }
        }
        private void UploadFile(HttpContext context)
        {
            UploadService _ser = new UploadService();
            UploadView _uv = new UploadView();
            string relativeFilePath = string.Empty;
            string clientFilePath = string.Empty;
            string fileName = string.Empty;
            //Guid fileId = SequentialGuid.NewSequentialGuid();
            string destFile = string.Empty;
            //政策id
            string pId = context.Request.QueryString["PolicyID"];
            //模板列数一般固定
            string FieldCount = context.Request.QueryString["FieldCount"];
            //sheetName
            string SheetName = context.Request.QueryString["SheetName"];
            //根据按钮的不同，值也不同
            string MaintainType = context.Request.QueryString["MaintainType"];
            //封顶值类型
            string topvalType = context.Request.QueryString["TopvalType"];
            //因素类型
            string FactorClass = context.Request.QueryString["FactorClass"];
            //因素id
            string FactorId = context.Request.QueryString["PolicyFactorId"];

            //政策ID
            _uv.PID = pId;
            _uv.MaintainType = MaintainType;
            _uv.SheetName = SheetName;
            _uv.FieldCount = FieldCount;
            _uv.TopValType = topvalType;           
            _uv.PolicyFactorID = FactorId;
            _uv.PolicyFactorType = FactorClass;
            if (string.IsNullOrEmpty(MaintainType))
            {
                _uv.Status = "error";
                _uv.Error = "MaintainType为空或不存在！";

            }
            else
            {
                //根据维护按钮的不同，通过用户iD删除相应中间表之前传入的数据
                DeleteType(_uv);

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
                        //hpfFile.ContentLength;

                        _uv.FilePath = destFile;


                        _uv = _ser.IsValidRate(_uv);


                        if (_uv.Status != "error")
                        {
                            _uv.Status = "success";
                            _uv.Error = "文件上传成功！";
                        }
                    }
                }
                catch (Exception ex)
                {
                    _uv.Status = "error";
                    _uv.Error = ex.Message;
                }
            }
            context.Response.Clear();
            context.Response.AddHeader("Content-type", "text/plain;charset=UTF-8");
            context.Response.Write(JsonConvert.SerializeObject(_uv));
            //context.Response.Flush();
            //context.Response.Close();
            //Chrome浏览器会有ERR_INCOMPLETE_CHUNKED_ENCODING的问题，所以改用End()方法
            context.Response.End();
        }

        private void DownLoad(HttpContext context)
        {
            UploadView _uv = new UploadView();
            _uv.DownLoadFileName = context.Request.Form["DownLoadFileName"];
            string relativePath = GetRelativePath(context);
            string fullPath = BuildPath(relativePath);
            _uv.FilePath = Path.Combine(fullPath, _uv.DownLoadFileName);
            if (File.Exists(_uv.FilePath))
            {
                _uv.Status = "success";
            }
            else
            {
                _uv.Status = "error";
                _uv.Error = "模板不存在";

            }
            context.Response.Clear();
            context.Response.AddHeader("Content-type", "text/plain;charset=UTF-8");
            context.Response.Write(JsonConvert.SerializeObject(_uv));
            context.Response.End();
        }

        private void ParseRate(HttpContext context)
        {
            UploadService _ser = new UploadService();
            UploadView _uv = new UploadView();

            string fullpath = context.Request.Form["UpLoadUrl"];
            string SheetName = context.Request.Form["SheetName"];
            
            string PolicyFactorId = context.Request.Form["PolicyFactorId"];
            string FactorClass = context.Request.Form["FactorClass"];
            //根据按钮的不同，值也不同
            string MaintainType = context.Request.Form["MaintainType"];
            string pId = context.Request.Form["PolicyID"];
            string FieldCount = context.Request.Form["FieldCount"];
            try
            {
                _uv.MaintainType = MaintainType;
                _uv.UpLoadUrl = fullpath;
                _uv.SheetName = SheetName;
                _uv.FieldCount = FieldCount;
                _uv.PID = pId;
                _uv.PolicyFactorID = PolicyFactorId;
                _uv.PolicyFactorType = FactorClass;
                _uv = _ser.ParseFile(_uv);
            }
            catch (Exception ex)
            {
                _uv.Status = "error";
                _uv.Error = ex.Message;
            }

            context.Response.Clear();
            context.Response.AddHeader("Content-type", "text/plain;charset=UTF-8");

            context.Response.Write(JsonConvert.SerializeObject(_uv));
            context.Response.End();
        }
        ///<summary>
        ///DataTable转Json
        ///</summary>
        ///<param name="dt"></param>
        ///<returns></returns>
        public string DataTableToJson(System.Data.DataTable dt)
        {
            if (dt.Rows.Count <= 0)
            {
                return "";
            }


            StringBuilder jsonBuilder = new System.Text.StringBuilder();

            jsonBuilder.Append("[");
            for (int i = 1; i < dt.Rows.Count; i++)
            {
                jsonBuilder.Append("{");
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    jsonBuilder.Append("\"");
                    jsonBuilder.Append(dt.Columns[j].ColumnName);
                    jsonBuilder.Append("\":\"");
                    jsonBuilder.Append(dt.Rows[i][j].ToString());
                    jsonBuilder.Append("\",");
                }
                jsonBuilder.Remove(jsonBuilder.Length - 1, 1);
                jsonBuilder.Append("},");
            }
            jsonBuilder.Remove(jsonBuilder.Length - 1, 1);
            jsonBuilder.Append("]");

            return jsonBuilder.ToString();
        }
        //Delete file from the server
        private void DeleteFile(HttpContext context)
        {
            UploadView _uv = new UploadView();
            var filepath = context.Request.Form["DelFullPath"];
            if (File.Exists(filepath))
            {
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

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }


        private static void ReturnOptions(HttpContext context)
        {
            context.Response.AddHeader("Allow", "DELETE,GET,HEAD,POST,PUT,OPTIONS");
            context.Response.StatusCode = 200;
        }
   

        public string UploadResult(string status, string relativePath, string fileName, int size, string error, string ctlId, string fileId)
        {
            var result = new
            {
                status = status,
                FilePath = relativePath,
                FileName = fileName,
                FileSize = size,
                error = error,
                ctlId = ctlId,
                ID = fileId
            };
            return JsonHelper.Serialize(result);
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
            string path = "~/Upload/";
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
    }
}