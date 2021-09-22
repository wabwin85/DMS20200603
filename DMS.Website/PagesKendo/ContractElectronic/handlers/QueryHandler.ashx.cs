using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using System.Text;
using DMS.Common.Common;
using DMS.Model;
using DMS.Business;
using System.Web.SessionState;

namespace DMS.Website.PagesKendo.ContractElectronic.handlers
{
    /// <summary>
    /// QueryHandler 的摘要说明
    /// </summary>
    public class QueryHandler : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            QueryView model = new QueryView();
            try
            {
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                string data = Encoding.GetEncoding("utf-8").GetString(byts);

                model = JsonConvert.DeserializeObject<QueryView>(data);
                QueryService service = new QueryService();

                if (model.Method == "InitPageLPT1")
                {
                    model.QryIsT2 = "1";
                    model = service.SelectAllContractByApproved(model);
                }
                else if (model.Method == "InitPageT2")
                {
                    model.QryIsT2 = "2";
                    model = service.SelectAllContractByApproved(model);
                }
                else if (model.Method == "QueryLPORT1")
                {
                    model = service.SelectAllContractByApproved(model);
                }
                else if (model.Method == "QueryT2")
                {
                    model = service.SelectAllContractByApproved(model);
                }
                else if (model.Method == "ChangeProductLine")
                {
                    model = service.SelectClassContractByBU(model);
                }
                else if (model.Method == "QueryEffectState")
                {
                    model = service.SelectEffectStateById(model);
                }
                else if (model.Method == "CheckIfCanAuthorization")
                {
                    model = service.CheckIfCanAuthorization(model);
                }
                else if (model.Method == "GetContractDetailInfo")
                {
                    model = service.GetContractDetailInfo(model);
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