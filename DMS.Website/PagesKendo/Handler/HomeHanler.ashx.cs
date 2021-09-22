using DMS.Business;
using DMS.Business.Promotion;
using DMS.Common.Common;
using DMS.Model.ViewModel;
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
    /// HomeHanler 的摘要说明
    /// </summary>
    public class HomeHanler : IHttpHandler ,IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            HomeVO model = new HomeVO();
            try
            {
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                string data = Encoding.GetEncoding("utf-8").GetString(byts);

                model = JsonConvert.DeserializeObject<HomeVO>(data);
                HomeService service = new HomeService();

                if (model.Method == "InitPage")
                {
                    model = service.InitPage(model);
                }
                else if (model.Method == "ChangeSubCompany")
                {
                    model = service.ChangeSubCompany(model);
                }
                else if (model.Method == "ChangeBrand")
                {
                    model = service.ChangeBrand(model);
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