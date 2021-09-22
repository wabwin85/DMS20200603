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
    /// GetCurrentHander 的摘要说明
    /// </summary>
    public class GetCurrentHanderNew : IHttpHandler
    {
        private static ILog _log = LogManager.GetLogger(typeof(GetCurrentHander));
        public void ProcessRequest(HttpContext context)
        {
            kmReviewExtendWeserviceBLL ekpBll = new kmReviewExtendWeserviceBLL();
            GetCurrentData model = new GetCurrentData();

            try
            {
                _log.Info("GetCurrentHander start.............");
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                string data = Encoding.GetEncoding("utf-8").GetString(byts);

                model = JsonHelper.Deserialize<GetCurrentData>(data);

                model.OptionList = ekpBll.GetOperationList(model.UserAccount, model.ApplyId);

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

    
}