
/**********************************************
 *
 * NameSpace   : DMS.Website 
 * ClassName   : DealerCacheHelper
 * Created Time: 2009-7-27
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business.Cache
{
    using DMS.Model;
    using Microsoft.Practices.EnterpriseLibrary.Caching;
    using Coolite.Ext.Web;
    using Newtonsoft.Json.Linq;

    public sealed class ClassificationCacheHelper
    {
        public const string ClassificationCachekey = "cache-all-classifications";


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public static IList<PartsClassification> GetClassifications(bool isCacheable)
        {
            ICacheManager cache = CacheFactory.GetCacheManager();

            IList<PartsClassification> parts = null;



            if (isCacheable)
            {
                object obj = cache.GetData(ClassificationCachekey);

                if (obj != null)
                    parts = (IList<PartsClassification>)obj;
            }

            if (parts == null)
            {
                IProductClassifications bll = new ProductClassifications();

                IList<PartsClassification> list = bll.GetAll();
                parts = list;
                cache.Add(ClassificationCachekey, parts);
            }

            return parts;
        }

        /// <summary>
        /// Gets the classifications.
        /// </summary>
        /// <returns></returns>
        public static IList<PartsClassification> GetClassifications()
        {
            return GetClassifications(true);
        }



        public static string GetJsonArray()
        {
            IList<PartsClassification> list = GetClassifications();
            string json = string.Empty;

            if (list != null)
            {
                var parts = new JArray(from c in list
                                         select new JArray(c.Id.ToString(), c.Name, c.ProductLineId.Value.ToString()));

                json = parts.ToString();
            }

            return json;
        }

    }
}
