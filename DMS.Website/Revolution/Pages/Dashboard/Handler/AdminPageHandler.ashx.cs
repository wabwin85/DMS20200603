using DMS.BusinessService.Dashboard;
using DMS.Common.Common;
using DMS.ViewModel.Dashboard;
using Newtonsoft.Json;
using System;
using System.Text;
using System.Web;

namespace DMS.Website.Revolution.Pages.Dashboard.Handler
{
    /// <summary>
    /// AdminPageHandler1 的摘要说明
    /// </summary>
    public class AdminPageHandler1 : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            AdminPageVO model = new AdminPageVO();
            try
            {
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                string data = Encoding.GetEncoding("utf-8").GetString(byts);

                model = JsonConvert.DeserializeObject<AdminPageVO>(data);
                AdminPageService service = new AdminPageService();

                model = service.Init(model);

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