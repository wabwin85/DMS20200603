
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : StocktakingLot
 * Created Time: 2010-6-3 11:32:13
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
    /// StocktakingLot的Dao
    /// </summary>
    public class StocktakingLotDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public StocktakingLotDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public StocktakingLot GetObject(Guid objKey)
        {
            StocktakingLot obj = this.ExecuteQueryForObject<StocktakingLot>("SelectStocktakingLot", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<StocktakingLot> GetAll()
        {
            IList<StocktakingLot> list = this.ExecuteQueryForList<StocktakingLot>("SelectStocktakingLot", null);          
            return list;
        }


        /// <summary>
        /// 查询StocktakingLot
        /// </summary>
        /// <returns>返回StocktakingLot集合</returns>
		public IList<StocktakingLot> SelectByFilter(StocktakingLot obj)
		{ 
			IList<StocktakingLot> list = this.ExecuteQueryForList<StocktakingLot>("SelectByFilterStocktakingLot", obj);          
            return list;
		}

        public IList<StocktakingLot> SelectByFilter(Guid Id)
        {            
            IList<StocktakingLot> list = this.ExecuteQueryForList<StocktakingLot>("SelectByFilterStocktakingLotByStlId", Id);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(StocktakingLot obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateStocktakingLot", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteStocktakingLot", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(StocktakingLot obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteStocktakingLot", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(StocktakingLot obj)
        {
            this.ExecuteInsert("InsertStocktakingLot", obj);           
        }

        //新增盘点单时批量插入库存数据
        public object InsertAddLotInfoByActualInv(Hashtable param)
        {
            return this.ExecuteInsert("InsertAddLotInfoByActualInv", param);
        }

        //更新Lot表的盘点数量值
        public int UpdateLotCheckQty(Hashtable param)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateLotCheckQty", param);
            return cnt;
        }
    }
}