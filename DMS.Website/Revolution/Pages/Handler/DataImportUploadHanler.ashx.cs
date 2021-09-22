using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.SessionState;
using System.Reflection;
using Spring.Context;
using Spring.Context.Support;
using DMS.ViewModel.Util.DataImport;
using DMS.Common.Extention;
using DMS.BusinessService.Util.DataImport;
using DMS.Common.Common;

namespace DMS.Website.Revolution.Pages.Handler
{
    /// <summary>
    /// DataImportUploadHanler 的摘要说明
    /// </summary>
    public class DataImportUploadHanler : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            DataImportUploadVO model = new DataImportUploadVO();
            try
            {
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                String DelegateBusiness = context.Request.QueryString["DelegateBusiness"].ToSafeString();
                String KeepFile = context.Request.QueryString["KeepFile"];

                if (DelegateBusiness.IsNullOrEmpty())
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("Empty of DelegateBusiness");
                }
                else
                {
                    model.KeepFile = KeepFile.ToSafeBool();
                    model.KeepFile = KeepFile.ToSafeBool();
                    model.Parameters = context.Request.QueryString;

                    IApplicationContext iac = ContextRegistry.GetContext();
                    IDataImportFac check = iac.GetObject(DelegateBusiness + "_Service") as IDataImportFac;

                    model = check.CreateDataImport().CheckFile(model, context.Request.Files[0]);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            context.Response.Write(JsonConvert.SerializeObject(model));
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