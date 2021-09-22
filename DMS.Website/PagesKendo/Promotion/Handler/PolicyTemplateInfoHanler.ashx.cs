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
    /// PolicyTemplateInfoHanler 的摘要说明
    /// </summary>
    public class PolicyTemplateInfoHanler : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            PolicyTemplateInfoVO model = new PolicyTemplateInfoVO();
            try
            {
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                string data = Encoding.GetEncoding("utf-8").GetString(byts);

                model = JsonConvert.DeserializeObject<PolicyTemplateInfoVO>(data);
                PolicyTemplateInfoService service = new PolicyTemplateInfoService();

                if (model.Method == "InitPage")
                {
                    model = service.InitPage(model);
                }
                else if (model.Method == "ChangePolicyType")
                {
                    model = service.ChangePolicyType(model);
                }
                else if (model.Method == "Save")
                {
                    model = service.Save(model);
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