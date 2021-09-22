
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

    public sealed class OrganizationCacheHelper
    {

        public static IList<Lafite.RoleModel.Domain.AttributeDomain> GetDictionary(string type, bool isCacheable)
        {
            string cacheKey = string.Concat("cache_", type);

            ICacheManager cache = CacheFactory.GetCacheManager();

            IList<Lafite.RoleModel.Domain.AttributeDomain> dict = null;

            if (isCacheable)
            {
                object obj = cache.GetData(cacheKey);

                if (obj != null)
                    dict = (IList<Lafite.RoleModel.Domain.AttributeDomain>)obj;
            }

            if (dict == null)
            {
                dict = OrganizationHelper.GetAttributeListByType(type);
                cache.Add(cacheKey, dict);
            }

            return dict;
        }

        public static IList<Lafite.RoleModel.Domain.AttributeDomain> GetDictionary(string type)
        {
            return GetDictionary(type, true);
        }


        public static string GetDictionaryNameById(string type, string id)
        {
            string value = string.Empty;

            IList<Lafite.RoleModel.Domain.AttributeDomain> list = GetDictionary(type);

            IDictionary<string, string> dict = list.ToDictionary(c => c.Id, c => c.AttributeName);

            if (dict != null)
            {
                if (dict.ContainsKey(id))
                    value = dict[id];
            }

            return value;
        }

        /// <summary>
        /// Gets the json array of Attributes
        /// </summary>
        /// <param name="type">The type.</param>
        /// <returns></returns>
        public static string GetJsonArray(string type)
        {
            IList<AttributeDomain> list = GetDictionary(type);
            string json = string.Empty;

            if (list != null)
            {
                var attributes = new JArray(from c in list
                                         select new JArray(c.Id.ToString(), c.AttributeName));

                json = attributes.ToString();
            }

            return json;
        }

    }
}
