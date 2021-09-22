using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace DMS.Website.PagesKendo.ContractElectronic.LPTOne
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
                case "Goodsfiles":
                    UploadFile(context, Type, NewFileName);
                    break;
            }
        }
        private void UploadFile(HttpContext context, string Type, string NewFileName)
        {
            try
            {
                HttpPostedFile hpfFile = context.Request.Files[0];
                string path = "~/Upload/ContractElectronicAttachmentTemplate/Uploadfiles/";
                var FilePath = Path.Combine(path, NewFileName+".pdf");
                var fullPath = BuildPath(FilePath);
                //var clientFilePath = VirtualPathUtility.ToAbsolute(relativeFilePath);
                //目标文件路径
                hpfFile.SaveAs(fullPath);
            }
            catch (Exception ex)
            {

            }
        }
        private static string BuildPath(string path)
        {
            if (!Path.IsPathRooted(path))
            {
                path = HttpContext.Current.Server.MapPath(path);
            }
            return Path.GetFullPath(path);
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