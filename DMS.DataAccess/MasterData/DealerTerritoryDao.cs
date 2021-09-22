
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DealerTerritory
 * Created Time: 2011-2-10 12:20:47
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;

namespace DMS.DataAccess
{
    /// <summary>
    /// DealerTerritory的Dao
    /// </summary>
    public class DealerTerritoryDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DealerTerritoryDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealerTerritory GetObject(Guid objKey)
        {
            DealerTerritory obj = this.ExecuteQueryForObject<DealerTerritory>("SelectDealerTerritory", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DealerTerritory> GetAll()
        {
            IList<DealerTerritory> list = this.ExecuteQueryForList<DealerTerritory>("SelectDealerTerritory", null);          
            return list;
        }


        /// <summary>
        /// 查询DealerTerritory
        /// </summary>
        /// <returns>返回DealerTerritory集合</returns>
		public IList<DealerTerritory> SelectByFilter(DealerTerritory obj)
		{ 
			IList<DealerTerritory> list = this.ExecuteQueryForList<DealerTerritory>("SelectByFilterDealerTerritory", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealerTerritory obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerTerritory", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerTerritory", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DealerTerritory obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDealerTerritory", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerTerritory obj)
        {
            this.ExecuteInsert("InsertDealerTerritory", obj);           
        }


    }
}