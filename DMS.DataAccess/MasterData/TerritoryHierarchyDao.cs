
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : TerritoryHierarchy
 * Created Time: 2011-2-10 13:54:08
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// TerritoryHierarchy的Dao
    /// </summary>
    public class TerritoryHierarchyDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public TerritoryHierarchyDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public TerritoryHierarchy GetObject(Guid objKey)
        {
            TerritoryHierarchy obj = this.ExecuteQueryForObject<TerritoryHierarchy>("SelectTerritoryHierarchy", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<TerritoryHierarchy> GetAll()
        {
            IList<TerritoryHierarchy> list = this.ExecuteQueryForList<TerritoryHierarchy>("SelectTerritoryHierarchy", null);
            return list;
        }


        /// <summary>
        /// 查询TerritoryHierarchy
        /// </summary>
        /// <returns>返回TerritoryHierarchy集合</returns>
        public DataSet SelectByFilter(string phid)
        {
            DataSet list = this.ExecuteQueryForDataSet("SelectTerritoryHierarchy", phid);
            return list;

        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(TerritoryHierarchy obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTerritoryHierarchy", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTerritoryHierarchy", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(TerritoryHierarchy obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteTerritoryHierarchy", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(TerritoryHierarchy obj)
        {
            this.ExecuteInsert("InsertTerritoryHierarchy", obj);
        }

       

        //added by huxiang on 2011-2-11
        public DataSet GetBUList()
        {
            DataSet list = this.ExecuteQueryForDataSet("SelectBuList", null);
            return list;
        }

        /// <summary>
        /// 下一层级
        /// </summary>
        /// <param name="ParentId"></param>
        /// <returns></returns>
        public string GetLevel(string ParentId)
        {
            string level = this.ExecuteQueryForDataSet("SelectLevel", ParentId).Tables[0].Rows[0]["DICT_KEY"].ToString();
            return level;
        }

        /// <summary>
        /// 当前层级
        /// </summary>
        /// <param name="ParentId"></param>
        /// <returns></returns>
        public string GetCurrentLevel(string ParentId)
        {
            string level = this.ExecuteQueryForDataSet("SelectCurrentLevel", ParentId).Tables[0].Rows[0]["DICT_KEY"].ToString();
            return level;
        }

        public DataSet GetProductLineList(string BuId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProductLineList", BuId);
            return ds;
        }

        public DataSet GetChildNode(string ThId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectChildNode", ThId);
            return ds;
        }


        public DataSet SelectProductLineByParentId(string ParentId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProductLineByParentId", ParentId);
            return ds;
        }

        public DataSet GetProductLineById(string Buid)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProductLineByBuid", Buid);
            return ds;
        }

        public DataSet GetTerritoryByProvinceId(string ProvinceId, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTerritoryByProvinceId", ProvinceId, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet GetTerritoryByFilter(Hashtable ht, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterTerritory", ht, start, limit, out totalRowCount);
            return ds;
        }

        public int AddTerritory(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("AddTerritory", ht);
            return cnt;
        }

        public int deleteTerritory(string TemId)
        {
            int cnt = (int)this.ExecuteUpdate("deleteTerritory", TemId);
            return cnt;
        }

        public DataSet GetDealerTerritoryByTemId(string TemId, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerTerritoryByTemId", TemId, start, limit, out totalRowCount);
            return ds;
        }

        public int deleteDealerTerritory(string DTid)
        {
            int cnt = (int)this.ExecuteDelete("deleteDealerTerritory", DTid);
            return cnt;
        }

        public int deleteDealerTerritoryByTemId(string TemId)
        {
            int cnt = (int)this.ExecuteDelete("deleteDealerTerritoryByTemId", TemId);
            return cnt;
        }

        /// <summary>
        /// 区域里面查询DealerMaster
        /// </summary>
        /// <returns>返回DealerMaster</returns>
        public DataSet GetDealerByTerritory(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = ExecuteQueryForDataSet("SelectDealerByTerritory", obj, start, limit, out totalRowCount);
            return ds;
        }

        /// <summary>
        /// 插入经销商
        /// </summary>
        /// <param name="ht"></param>
        public void InsertDealerTerritory(Hashtable ht)
        {
            this.ExecuteInsert("InsertTerritoryForDealer", ht);
        }

        public DataSet validateCodeIdentical(string code)
        {
            DataSet ds = ExecuteQueryForDataSet("validateCodeIdentical", code);
            return ds;
        }
        //end
    }
}