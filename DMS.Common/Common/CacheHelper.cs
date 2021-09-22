using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Web;

namespace DMS.Common.Common
{
    public class CacheHelper
    {
        /// <summary>
        /// 设置缓存
        /// </summary>
        /// <param name="cacheType">缓存类型</param>
        /// <param name="key">键</param>
        /// <param name="value">值</param>
        public static void SetValue(string cacheType, object key, object value,double expireHour=10)
        {
            string strApplicationKey = cacheType.ToString();
            //设置过期时间(10个小时过期)
            double expireMilliseconds = expireHour*(1000 * 60 * 60) * 1;

            if (key != null)
            {
                var htSession = new Hashtable();

                var htItem = new Hashtable
                    {
                        {key, value},
                        {"CreateTime", DateTime.Now},
                        {"ExpireMilliseconds", expireMilliseconds}
                    };

                if (HttpContext.Current.Application[strApplicationKey] != null)
                {
                    htSession = HttpContext.Current.Application[strApplicationKey] as Hashtable ?? new Hashtable();
                }

                if (htSession.ContainsKey(key))
                {
                    htSession[key] = htItem;
                }
                else
                {
                    htSession.Add(key, htItem);
                }
                HttpContext.Current.Application[strApplicationKey] = htSession;
            }
            CleanExpireItem(cacheType);
        }

        /// <summary>
        /// 获取缓存
        /// </summary>
        /// <param name="cacheType">缓存类型</param>
        /// <param name="key">键</param>
        /// <returns></returns>
        public static object GetValue(string cacheType, object key)
        {
            string strApplicationKey = cacheType.ToString();
            object objReturn = null;
            CleanExpireItem(cacheType);
            if (key != null)
            {
                var htSession = new Hashtable();

                if (HttpContext.Current.Application[strApplicationKey] != null)
                {
                    htSession = HttpContext.Current.Application[strApplicationKey] as Hashtable ?? new Hashtable();
                }

                if (htSession.ContainsKey(key))
                {
                    var htItem = htSession[key] as Hashtable;
                    if (null != htItem)
                    {
                        objReturn = htItem[key];
                    }
                }
            }

            return objReturn;
        }

        /// <summary>
        /// 清理过期的缓存
        /// </summary>
        /// <param name="cacheType">缓存类型</param>
        public static void CleanExpireItem(string cacheType)
        {
            string strApplicationKey = cacheType.ToString();
            if (HttpContext.Current.Application[strApplicationKey] == null) return;
            var htSession = HttpContext.Current.Application[strApplicationKey] as Hashtable ?? new Hashtable();

            var listExpire = new ArrayList();

            foreach (DictionaryEntry objItem in htSession)
            {
                var htItem = objItem.Value as Hashtable;
                if (null == htItem)
                {
                    listExpire.Add(objItem.Key);
                }
                else
                {
                    var dtCreateTime = (DateTime)htItem["CreateTime"];
                    var dbexpireMilliseconds = (double)htItem["ExpireMilliseconds"];
                    var dtNow = DateTime.Now;
                    if ((dtNow - dtCreateTime).TotalMilliseconds >= dbexpireMilliseconds)
                    {
                        listExpire.Add(objItem.Key);
                    }
                }
            }
            foreach (var t in listExpire)
            {
                htSession.Remove(t);
            }
        }

        /// <summary>
        /// 根据key清理缓存
        /// </summary>
        /// <param name="cacheType"></param>
        /// <param name="key"></param>
        public static void CleanItem(string cacheType, object key)
        {
            string strApplicationKey = cacheType.ToString();
            if (HttpContext.Current.Application[strApplicationKey] == null) return;
            var htSession = HttpContext.Current.Application[strApplicationKey] as Hashtable ?? new Hashtable();
            if (htSession.ContainsKey(key))
            {
                htSession.Remove(key);
            }
        }
    }
}
