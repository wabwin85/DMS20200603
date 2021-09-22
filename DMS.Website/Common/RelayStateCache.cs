using Com.Zealan.Saml.Bindings;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.Practices.EnterpriseLibrary.Caching.Expirations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DMS.Website.Common
{
    public class RelayStateCache
    {
        // Methods
        public static string Add(RelayState relayState)
        {
            string key = Guid.NewGuid().ToString();

            ICacheManager cache = CacheFactory.GetCacheManager();

            cache.Add(key, relayState, CacheItemPriority.Normal, new DMSCacheItemRefreshAction(), new AbsoluteTime(TimeSpan.FromMinutes(5)));

            return key;
        }

        public static RelayState Get(string key)
        {
            ICacheManager cache = CacheFactory.GetCacheManager();
            
            return (RelayState)cache.GetData(key);
        }

        public static void Remove(string key)
        {
            ICacheManager cache = CacheFactory.GetCacheManager();

            cache.Remove(key);
        }
        
    }

    /// <summary>
    /// 自定义缓存刷新操作
    /// </summary>
    [Serializable]
    public class DMSCacheItemRefreshAction : ICacheItemRefreshAction
    {
        #region ICacheItemRefreshAction 成员
        /// <summary>
        /// 自定义刷新操作
        /// </summary>
        /// <param name="removedKey">移除的键</param>
        /// <param name="expiredValue">过期的值</param>
        /// <param name="removalReason">移除理由</param>
        void ICacheItemRefreshAction.Refresh(string removedKey, object expiredValue, CacheItemRemovedReason removalReason)
        {
            if (removalReason == CacheItemRemovedReason.Expired)
            {
                ICacheManager cache = CacheFactory.GetCacheManager();
                cache.Add(removedKey, expiredValue);
            }
        }
        #endregion
    }

}