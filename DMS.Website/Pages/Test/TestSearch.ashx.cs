using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using Coolite.Ext.Web;
using DMS.Business;
using DMS.Model;

namespace DMS.Website.Pages.Test
{
    /// <summary>
    /// $codebehindclassname$ 的摘要说明
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class TestSearch : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/json";

            var start = 0;
            var limit = 10;
            var sort = string.Empty;
            var dir = string.Empty;
            var query = string.Empty;
            var totalCount = 0;

            if (!string.IsNullOrEmpty(context.Request["start"]))
            {
                start = int.Parse(context.Request["start"]);
            }

            if (!string.IsNullOrEmpty(context.Request["limit"]))
            {
                limit = int.Parse(context.Request["limit"]);
            }

            if (!string.IsNullOrEmpty(context.Request["sort"]))
            {
                sort = context.Request["sort"];
            }

            if (!string.IsNullOrEmpty(context.Request["dir"]))
            {
                dir = context.Request["dir"];
            }

            if (!string.IsNullOrEmpty(context.Request["query"]))
            {
                query = context.Request["query"];
            }
            Hospitals HospitalBiz = new Hospitals();
            Hospital param = new Hospital();

            param.HosHospitalName = query;
            param.HosGrade = string.Empty;
            param.HosDirector = string.Empty;

            param.HosProvince = string.Empty;
            param.HosCity = string.Empty;
            param.HosDistrict = string.Empty;

            IList<Hospital> list = HospitalBiz.SelectByFilter(param, start, limit, out totalCount);

            context.Response.Write(string.Format("{{totalCount:{1},'result':{0}}}", JSON.Serialize(list), totalCount));
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
