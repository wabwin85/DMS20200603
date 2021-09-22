using System;
using System.Data;
using System.Collections;
using System.Collections.Generic;

namespace DMS.Business
{
    using DMS.Model;

    public interface ITerritorys
    {
        IList<Territory> GetProvinces();
        IList<Territory> GetTerritorys();
        IList<Territory> GetTerritorysByParent(Guid parentId);
        IList<Territory> SelectByFilter(Territory territory, bool isCacheable);
        IList<Territory> SelectByFilter(Territory territory);
        DataSet GetFullTerritoryList(Hashtable obj, int start, int limit, out int totalRowCount);
        TerritoryEx GetTerritoryEx(Guid Id);
    }
}
