using DMS.Business.Promotion;
using DMS.Common.Common;
using DMS.Model.ViewModel.Promotion;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.SessionState;

namespace DMS.Website.PagesKendo.Promotion.Handler
{
    /// <summary>
    /// TerminationHanler 的摘要说明
    /// </summary>
    public class TerminationHanler : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            TermainationList model = new TermainationList();
            try
            {
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                string data = Encoding.GetEncoding("utf-8").GetString(byts);

                model = JsonConvert.DeserializeObject<TermainationList>(data);
                TermainationListService service = new TermainationListService();

                if (model.Method == "InitPage")
                {
                    model = service.InitPage(model);
                }
                else if (model.Method == "Query")
                {
                    model = service.Query(model);
                }
                else if (model.Method == "Change")
                {
                    model = service.PolicyNo(model);
                }
                else if (model.Method == "Submit" || model.Method == "Save")
                {
                    string Status = model.Method == "Submit" ? "审批中" : "草稿";
                    service.TerminationSubmit(model, Status);
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