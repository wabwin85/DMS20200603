using System;
using DMS.Model;
using System.Data;
using System.Collections;
using System.Collections.Generic;

namespace DMS.Business
{
    public interface ITerritoryBLL
    {
        /// <summary>
        /// 得到BU列表
        /// </summary>
        /// <returns></returns>
        DataSet GetBUList();

        /// <summary>
        /// 得到层级
        /// </summary>
        /// <param name="ParentId"></param>
        /// <param name="flag">0:返回当前层级,1:返回下一层级</param>
        /// <returns></returns>
        string GetLevel(string ParentId, int flag);

        /// <summary>
        /// 得到产品线列表
        /// </summary>
        /// <param name="BuId"></param>
        /// <returns></returns>
        DataSet GetProductLineList(string BuId);

        void InsertTerritoryHierarchy(TerritoryHierarchy th);

        void UpdateTerritoryHierarchy(TerritoryHierarchy th);

        DataSet GetTerritoryHierarchyByThid(string obj);

        DataSet GetChildNode(string ThId);

        DataSet GetProductLineByParentId(string ParentId);

        DataSet GetProductLineById(string Buid);

        void DeleteTerritoryHierarchy(Guid th);

        DataSet GetTerritoryByProvinceId(string ProvinceId, int start, int limit, out int totalRowCount);

        bool GetTerritoryByProvinceId(string ProvinceId);

        DataSet GetTerritoryByFilter(Hashtable ht, int start, int limit, out int totalRowCount);

        bool AddTerritory(string ProvinceId, string[] TemId);

        bool deleteTerritory(string[] TemId);

        DataSet GetDealerTerritoryByTemId(string TemId, int start, int limit, out int totalRowCount);

        void deleteDealerTerritory(string DTid);

        DataSet GetDealerByTerritory(Hashtable obj, int start, int limit, out int totalRowCount);

        bool InsertDealerTerritory(string TemId, string[] DmaId);

        bool validateCodeIdentical(string code);
    }
}
