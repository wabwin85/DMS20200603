using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace DMS.Website.Pages.handlers
{
    using DMS.Business.Cache;

    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class DealerHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
      
            string id = context.Request["id"];

            string dealerName = string.Empty;

            if (!string.IsNullOrEmpty(id))
            {
                Guid gid = new Guid(id);

                dealerName = DealerCacheHelper.GetDealerName(gid);
            }

            context.Response.Write(dealerName);
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
