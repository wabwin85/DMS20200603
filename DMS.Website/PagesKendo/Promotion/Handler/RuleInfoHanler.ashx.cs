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
    /// RuleInfoHanler 的摘要说明
    /// </summary>
    public class RuleInfoHanler : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            RuleInfoVO model = new RuleInfoVO();
            try
            {
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                string data = Encoding.GetEncoding("utf-8").GetString(byts);

                model = JsonConvert.DeserializeObject<RuleInfoVO>(data);
                RuleInfoService service = new RuleInfoService();

                if (model.Method == "InitPage")
                {
                    model = service.InitPage(model);
                } else if (model.Method == "Save")
                {
                    model = service.Save(model);
                }
                else if (model.Method == "ShowCondition")
                {
                    model = service.ShowCondition(model);
                }
                else if (model.Method == "SaveDetail")
                {
                    model = service.SaveDetail(model);
                }
                else if (model.Method == "RemoveCondition")
                {
                    model = service.RemoveCondition(model);
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