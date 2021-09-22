using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.Model;
using DMS.Business;
using System.Data;
using DMS.Business.Cache;

namespace DMS.Website.Service
{
    public class RefreshDealerCacheService : IHttpHandler
    {
        #region Service


        #endregion

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ClearContent();
            context.Response.ContentType = "text/plain";
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

            string token = context.Request.Params["Token"];

            string Massage = "";
          
            //参数判断
            if (string.IsNullOrEmpty(token) || !token.Equals("3CE40E56-B8E4-43C6-B056-DB02D3EB6827"))
            {
                Massage = "Error";
            }
            else
            {
                try
                {
                    DealerCacheHelper.ReloadDealers();
                    Massage = "Success";
                }
                catch
                {
                    Massage = "Error";
                }
            }
            context.Response.Write(Massage);
            context.Response.End();
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
