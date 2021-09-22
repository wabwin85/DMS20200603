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
    /// PolicyInfo 的摘要说明
    /// </summary>
    public class PolicyTemplateHanler : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            PolicyTemplateVO model = new PolicyTemplateVO();
            try
            {
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                string data = Encoding.GetEncoding("utf-8").GetString(byts);

                model = JsonConvert.DeserializeObject<PolicyTemplateVO>(data);
                PolicyTemplateService service = new PolicyTemplateService();

                if (model.Method == "InitPage")
                {
                    model = service.InitPage(model);
                }
                else if (model.Method == "ConvertAdvance")
                {
                    model = service.ConvertAdvance(model);
                }
                else if (model.Method == "Save")
                {
                    model = service.Save(model);
                }
                else if (model.Method == "Preview")
                {
                    model = service.Preview(model);
                }
                else if (model.Method == "Submit")
                {
                    model = service.Submit(model);
                }
                else if (model.Method == "ReloadFactor")
                {
                    model = service.ReloadFactor(model);
                }
                else if (model.Method == "RemoveFactor")
                {
                    model = service.RemoveFactor(model);
                }
                else if (model.Method == "ReloadRule")
                {
                    model = service.ReloadRule(model);
                }
                else if (model.Method == "RemoveRule")
                {
                    model = service.RemoveRule(model);
                }
                else if (model.Method == "ReloadAttachment")
                {
                    model = service.ReloadAttachment(model);
                }
                else if (model.Method == "RemoveAttachment")
                {
                    model = service.RemoveAttachment(model);
                }
                else if (model.Method == "ReloadSummary")
                {
                    model = service.ReloadSummary(model);
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