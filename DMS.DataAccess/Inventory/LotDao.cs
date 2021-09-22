
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : Lot
 * Created Time: 2009-7-17 4:26:14 PM
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
    /// Lot的Dao
    /// </summary>
    public class LotDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public LotDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public Lot GetObject(Guid objKey)
        {
            Lot obj = this.ExecuteQueryForObject<Lot>("SelectLot", objKey);           
            return obj;
        }

        public Lot SelectLotForReturn(Hashtable ht)
        {
            Lot obj = this.ExecuteQueryForObject<Lot>("SelectLotForReturn", ht);
            return obj;
        }

        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<Lot> GetAll()
        {
            IList<Lot> list = this.ExecuteQueryForList<Lot>("SelectLot", null);          
            return list;
        }

        /// <summary>
        /// 通过Hashtable查询Lot
        /// </summary>
        /// <param name="obj"></param>
        /// <returns>返回Lot集合</returns>
        public IList<Lot> SelectLotsByLotMasterAndWarehouse(Hashtable ht)
        {
            IList<Lot> list = this.ExecuteQueryForList<Lot>("SelectLotsByLotMasterAndWarehouse", ht);
            return list;
        }

        /// <summary>
        /// 查询Lot
        /// </summary>
        /// <returns>返回Lot集合</returns>
		public IList<Lot> SelectByFilter(Lot obj)
		{ 
			IList<Lot> list = this.ExecuteQueryForList<Lot>("SelectByFilterLot", obj);          
            return list;
		}

        /// <summary>
        /// 通过hashtable更新实体
        /// </summary>
        /// <param name="ht">ht:ID,Add Value</param>
        /// <returns>更新数目</returns>
        public int UpdateLotWithQty(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateLotWithQty", ht);            
            return cnt;
        }

        /// <summary>
        /// 通过hashtable更新实体
        /// </summary>
        /// <param name="ht">LtmId，InvId，OnHandQty</param>
        /// <returns>更新数目</returns>
        public int UpdateLotWithLotMasterWarehouseAndQty(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateLotWithLotMasterWarehouseAndQty", ht);            
            return cnt;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(Lot obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateLot", obj);
            return cnt;
        }


        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Lot obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteLot", obj);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(Lot obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteLot", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(Lot obj)
        {
            this.ExecuteInsert("InsertLot", obj);           
        }


    }
}