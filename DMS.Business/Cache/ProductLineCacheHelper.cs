
/**********************************************
 *
 * NameSpace   : DMS.Website 
 * ClassName   : DealerCacheHelper
 * Created Time: 2009-7-17
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/


using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DMS.Business.Cache
{
    using DMS.Model;
    using Microsoft.Practices.EnterpriseLibrary.Caching;
    using DMS.Common;
    using Coolite.Ext.Web;
    using Newtonsoft.Json.Linq;
    using Lafite.RoleModel.Domain;
    using Lafite.RoleModel.Service;

    public sealed class ProductLineCacheHelper    {        private static ProductLineBLL bllProductLine = new ProductLineBLL();
        public static IList<ViewProductLine> GetCacheProductLine(bool isCacheable=true)
        {
            string cacheKey = "cache_ViewProductLine";

            ICacheManager cache = CacheFactory.GetCacheManager();

            IList<ViewProductLine> dict = null;

            if (isCacheable)
            {
                object obj = cache.GetData(cacheKey);

                if (obj != null)
                    dict = (IList<ViewProductLine>)obj;
            }

            if (dict == null)
            {
                dict = bllProductLine.SelectViewProductLine(null, null, null);
                cache.Add(cacheKey, dict);
            }

            return dict;
        }
    }
}
