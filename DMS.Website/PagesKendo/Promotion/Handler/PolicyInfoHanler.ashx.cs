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
    public class PolicyInfoHanler : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            PolicyInfoVO model = new PolicyInfoVO();
            try
            {
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                string data = Encoding.GetEncoding("utf-8").GetString(byts);

                model = JsonConvert.DeserializeObject<PolicyInfoVO>(data);
                PolicyInfoService service = new PolicyInfoService();

                if (model.Method == "InitPage")
                {
                    model = service.InitPage(model);
                }
                else if (model.Method == "ChangeProductLine")
                {
                    model = service.ChangeProductLine(model);
                }
                else if (model.Method == "ChangePolicyType")
                {
                    model = service.ChangePolicyType(model);
                }
                else if (model.Method == "ChangeTopType")
                {
                    model = service.ChangeTopType(model);
                }
                else if (model.Method == "Save")
                {
                    model = service.Save(model);
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

                else if(model.Method== "ReloadLook")
                {
                    model = service.ReloadLook(model);
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