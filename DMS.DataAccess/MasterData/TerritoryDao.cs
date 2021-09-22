

/**********************************************
 *
 * NameSpace   : DMS.DataAccess 
 * ClassName   : TerritoryDao
 * Created Time: 2009-7-1
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

namespace DMS.DataAccess
{
     using DMS.Model;
    
    public class TerritoryDao : BaseSqlMapDao
    {
        public IList<Territory> SelectByFilter(Territory territory)
        {
            return ExecuteQueryForList<Territory>("SelectTerritoryList", territory);
        }

        public DataSet SelectFullTerritoryList(Hashtable table, int start, int limit, out int rowCount)
        {
            //Hashtable table = new Hashtable();
            //table.Add("PositionID", string.IsNullOrEmpty(positionID) ? null : positionID);
            return this.ExecuteQueryForDataSet("SelectFullTerritoryList", table, start, limit,out rowCount, true);
        }

        public TerritoryEx GetTerritoryEx(Guid Id)
        {
            return base.ExecuteQueryForObject<TerritoryEx>("SelectFullTerritoryById", Id);
        }

        public IList<TerritoryEx> CheckTerritoryExist(TerritoryEx obj)
        {
            return base.ExecuteQueryForList<TerritoryEx>("CheckTerritoryExist", obj);
        }


        public object Insert(TerritoryEx ter)
        {
            return base.ExecuteInsert("InsertTerritory", ter);
        }
       
        public int Update(TerritoryEx ter)
        {
            return base.ExecuteUpdate("UpdateTerritory", ter);
        }
    }
}
