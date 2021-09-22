/**********************************************
 *
 * NameSpace   : DMS.Business 
 * ClassName   : Territorys
 * Created Time: 2009-7 
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using DMS.DataAccess;
    using DMS.Model;
    using Microsoft.Practices.EnterpriseLibrary.Caching;

    /// <summary>
    /// Territorys 省、市、区县

    /// </summary>
    public class Territorys : BaseBusiness, ITerritorys
    {
        private ICacheManager _cache = null;
        //private const string Cache_Provinces = "cache_Provinces";
        private const string Cache_Territorys = "cache_Territorys";

        public Territorys()
        {
            _cache = CacheFactory.GetCacheManager();
        }


        public IList<Territory> SelectByFilter(Territory territory, bool isCacheable)
        {
            IList<Territory> list = null;
            if (isCacheable)
            {
                object obj = _cache.GetData(Cache_Territorys);
                if (obj != null)
                    list = (IList<Territory>)obj;
            }

            if (list == null)
            {
                using (TerritoryDao dao = new TerritoryDao())
                {
                    list = dao.SelectByFilter(territory);

                    _cache.Add(Cache_Territorys, list);
                }
            }

            return list;
        }

        public IList<Territory> SelectByFilter(Territory territory)
        {
            return SelectByFilter(territory, true);
        }

        public IList<Territory> GetTerritorys()
        {
            return SelectByFilter(null, true);
        }

        public IList<Territory> GetProvinces()
        {
            IList<Territory> list = this.GetTerritorys();

            var query = from p in list
                        where p.ParentId == null
                        orderby p.Description
                        select p ;

            return query.ToList<Territory>();
        }

        public IList<Territory> GetTerritorysByParent(Guid parentId)
        {

            IList<Territory> list = this.GetTerritorys();

            var query = from p in list
                        where p.ParentId == parentId
                        orderby p.Description
                        select p;

            return query.ToList<Territory>();
        }

        public DataSet GetFullTerritoryList(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (TerritoryDao dao = new TerritoryDao())
            {
                return dao.SelectFullTerritoryList(obj, start, limit, out totalRowCount);                
            }
        }

        public TerritoryEx GetTerritoryEx(Guid Id)
        {
            using (TerritoryDao dao = new TerritoryDao())
            {
                return dao.GetTerritoryEx(Id);
            }
        }
    }
}
