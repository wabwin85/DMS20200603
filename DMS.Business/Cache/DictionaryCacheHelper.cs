
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

    public sealed class DictionaryCacheHelper
    {

        public static IDictionary<string, string> GetDictionary(string type, bool isCacheable)
        {
            string cacheKey = string.Concat("cache_", type);

            ICacheManager cache = CacheFactory.GetCacheManager();

            IDictionary<string, string> dict = null;

            if (isCacheable)
            {
                object obj = cache.GetData(cacheKey);

                if (obj != null)
                    dict = (IDictionary<string, string>)obj;
            }

            if (dict == null)
            {
                dict = DictionaryHelper.GetDictionary(type);
                cache.Add(cacheKey, dict);
            }

            return dict;
        }

        public static IDictionary<string, string> GetDictionary(string type)
        {
            return GetDictionary(type, true);
        }


        public static string GetDictionaryNameById(string type, string id)
        {
            string value = string.Empty;

            IDictionary<string, string> list = GetDictionary(type);

            if (list != null)
            {
                if (list.ContainsKey(id))
                    value = list[id];
            }

            return value;
        }

    }
}
