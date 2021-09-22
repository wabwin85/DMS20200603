
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : TerritoryMaster
 * Created Time: 2011-2-10 13:56:41
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
    /// TerritoryMaster的Dao
    /// </summary>
    public class TerritoryMasterDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public TerritoryMasterDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public TerritoryMaster GetObject(Guid objKey)
        {
            TerritoryMaster obj = this.ExecuteQueryForObject<TerritoryMaster>("SelectTerritoryMaster", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<TerritoryMaster> GetAll()
        {
            IList<TerritoryMaster> list = this.ExecuteQueryForList<TerritoryMaster>("SelectTerritoryMaster", null);          
            return list;
        }


        /// <summary>
        /// 查询TerritoryMaster
        /// </summary>
        /// <returns>返回TerritoryMaster集合</returns>
		public IList<TerritoryMaster> SelectByFilter(TerritoryMaster obj)
		{ 
			IList<TerritoryMaster> list = this.ExecuteQueryForList<TerritoryMaster>("SelectByFilterTerritoryMaster", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(TerritoryMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTerritoryMaster", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTerritoryMaster", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(TerritoryMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteTerritoryMaster", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(TerritoryMaster obj)
        {
            this.ExecuteInsert("InsertTerritoryMaster", obj);
        }

        #region added by bozhenfei on 20110215
        /// <summary>
        /// 根据经销商和产品线查询经销商区域
        /// </summary>
        /// <param name="table"></param>
        /// <returns></returns>
        public DataSet QueryTerritoryMasterForPurchaseOrder(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryTerritoryMasterForPurchaseOrder", table);
            return ds;
        }
        #endregion
    }
}