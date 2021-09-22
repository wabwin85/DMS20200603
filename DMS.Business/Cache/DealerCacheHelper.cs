
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

    /// <summary>
    /// DealerCacheHelper
    /// </summary>
    public sealed class DealerCacheHelper
    {
        public const string DealerCachekey = "cache-all-dealers";


        /// <summary>
        /// Gets the all dealers , and with cache.
        /// </summary>
        /// <param name="isCacheable">if set to <c>true</c> [is cacheable].</param>
        /// <returns></returns>
        public static IList<DealerMaster> GetDealers(bool isCacheable)
        {
            ICacheManager cache = CacheFactory.GetCacheManager();

            IList<DealerMaster> dealers = null;

            if (isCacheable)
            {
                object obj = cache.GetData(DealerCachekey);

                if (obj != null)
                    dealers = (IList<DealerMaster>)obj;
            }

            if (dealers == null)
            {
                IDealerMasters bll = new DealerMasters();
                IList<DealerMaster> list = bll.GetAll();
                dealers = list;
                cache.Add(DealerCachekey, dealers);
            }

            return dealers;        
        }

        public static void ReloadDealers()
        {
            ICacheManager cache = CacheFactory.GetCacheManager();

            object obj = cache.GetData(DealerCachekey);

            if (obj != null)
            {
                cache.Remove(DealerCachekey);
            }
            GetDealers(true);
        }

        /// <summary>
        /// Gets the all dealers, and within cache.
        /// </summary>
        /// <returns></returns>
        public static IList<DealerMaster> GetDealers()
        {
            return GetDealers(true);
        }

        public static DealerMaster GetDealerById(Guid dealerId)
        {
            DealerMaster dealer = null;
            IList<DealerMaster> dealerList = GetDealers();
            dealer = dealerList.FirstOrDefault<DealerMaster>(d => d.Id.Value == dealerId);
            return dealer;
        }

        public static string GetJsonList()
        {
            IList<DealerMaster> list = GetDealers();
            string json = string.Empty;

            if (list != null)
            {
                var dealers = from c in list
                              select new { key = c.Id.Value, value = c.ChineseName };

                json = JsonHelper.Serialize(dealers);
            }

            return json;
        }


        public static string GetJsonArray()
        {
            IList<DealerMaster> list = GetDealers();
            string json = string.Empty;

            if (list != null)
            {
                var dealers = new JArray(from c in list
                                         select new JArray(c.Id.ToString(), c.ChineseName));

                json = dealers.ToString();
            }

            return json;
        }

        /// <summary>
        /// Gets the dealer's name.
        /// </summary>
        /// <param name="id">The id.</param>
        /// <returns></returns>
        public static string GetDealerName(Guid id)
        {
            string dealerName = string.Empty;

            IList<DealerMaster> list = GetDealers();

            IDictionary<Guid, string> dealers = list.ToDictionary(c => c.Id.Value, c => c.ChineseName);

            if (dealers != null)
            {
                if (dealers.ContainsKey(id))
                    dealerName = dealers[id];
            }

            return dealerName;
        }

        /// <summary>
        /// Gets the dealer's name.
        /// </summary>
        /// <param name="id">The id.</param>
        /// <returns></returns>
        public static DealerMaster GetDealer(Guid id)
        {
            IList<DealerMaster> list = GetDealers();

            DealerMaster dealer = list.FirstOrDefault<DealerMaster>(p=>p.Id==id);

            return dealer;
        }



        /// <summary>
        /// Flushes the cache.
        /// </summary>
        public static void FlushCache()
        {
            ICacheManager cache = CacheFactory.GetCacheManager();
            cache.Remove(DealerCacheHelper.DealerCachekey);          
        }


    }
}
