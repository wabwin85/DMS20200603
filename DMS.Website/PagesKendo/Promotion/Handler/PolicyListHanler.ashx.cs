using DMS.Business.Promotion;
using DMS.Common.Common;
using DMS.Model.ViewModel.Promotion;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.SessionState;

namespace DMS.Website.PagesKendo.Promotion.Handler
{
    /// <summary>
    /// PolicyList 的摘要说明
    /// </summary>
    public class PolicyListHanler : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            PolicyListVO model = new PolicyListVO();
            try
            {
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                string data = Encoding.GetEncoding("utf-8").GetString(byts);

                model = JsonConvert.DeserializeObject<PolicyListVO>(data);
                PolicyListService service = new PolicyListService();

                if (model.Method == "InitPage")
                {
                    model = service.InitPage(model);
                }
                else if (model.Method == "Query")
                {
                    model = service.Query(model);
                }
                else if (model.Method == "RemovePolicy")
                {
                    model = service.RemovePolicy(model);
                }
                else if (model.Method == "CopyPolicy")
                {
                    model = service.CopyPolicy(model);
                }
                else if (model.Method == "ChangeProductLine")
                {
                    model = service.ChangeProductLine(model);
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