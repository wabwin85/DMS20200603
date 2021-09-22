using Common.Logging;
using DMS.Business.EKPWorkflow;
using DMS.Common;
using DMS.Common.Common;
using DMS.Model.EKPWorkflow;
using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace DMS.Website.Pages.EKPWorkflow
{
    /// <summary>
    /// StartInstanceHander 的摘要说明
    /// </summary>
    public class StartInstanceHanderNew : IHttpHandler
    {
        private static ILog _log = LogManager.GetLogger(typeof(StartInstanceHanderNew));
        public void ProcessRequest(HttpContext context)
        {
            kmReviewWebserviceBLL ekpBll = new kmReviewWebserviceBLL();
            StartInstanceDataNew model = new StartInstanceDataNew();

            try
            {
                _log.Info("StartInstanceHander start.............");
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                string data = Encoding.GetEncoding("utf-8").GetString(byts);

                model = JsonHelper.Deserialize<StartInstanceDataNew>(data);

                ekpBll.DoSubmit(model.UserAccount, model.ApplyId, model.ApplyNo, model.ApplyType, model.ApplySubject, model.ModelId, model.TemplateFormId,model.fdTemplateFormId);
                //ekpBll.DoAgree(model.UserAccount, model.ApplyId, "");
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                model.IsSuccess = false;
                model.ExecuteMessage = ex.Message.ToString();
                _log.Error(ex.ToString());
            }
            context.Response.Write(JsonHelper.Serialize(model));
        }


        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }

    public class StartInstanceDataNew
    {
        public string UserAccount;
        public string ApplyId;
        public string ApplyNo;
        public string ApplyType;
        public string ApplySubject;
        public string ModelId;
        public string TemplateFormId;
        public string fdTemplateFormId;
        public bool IsSuccess;
        public string ExecuteMessage;
    }
}