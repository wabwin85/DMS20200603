
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ShipmentOperation
 * Created Time: 2010-6-13 17:07:07
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
    /// ShipmentOperation的Dao
    /// </summary>
    public class ShipmentOperationDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ShipmentOperationDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ShipmentOperation GetObject(Guid objKey)
        {
            ShipmentOperation obj = this.ExecuteQueryForObject<ShipmentOperation>("SelectShipmentOperation", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ShipmentOperation> GetAll()
        {
            IList<ShipmentOperation> list = this.ExecuteQueryForList<ShipmentOperation>("SelectShipmentOperation", null);          
            return list;
        }

        public IList<ShipmentOperation> GetShipmentOperationByHeaderId(Guid SphId)
        {
            IList<ShipmentOperation> list = this.ExecuteQueryForList<ShipmentOperation>("SelectShipmentOperationBySphId", SphId);
            return list;
        }

        /// <summary>
        /// 查询ShipmentOperation
        /// </summary>
        /// <returns>返回ShipmentOperation集合</returns>
		public IList<ShipmentOperation> SelectByFilter(ShipmentOperation obj)
		{ 
			IList<ShipmentOperation> list = this.ExecuteQueryForList<ShipmentOperation>("SelectByFilterShipmentOperation", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ShipmentOperation obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateShipmentOperation", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShipmentOperation", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ShipmentOperation obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteShipmentOperation", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ShipmentOperation obj)
        {
            this.ExecuteInsert("InsertShipmentOperation", obj);           
        }

        public int DeleteByHeaderId(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShipmentOperationByHeaderId", id);
            return cnt;
        }

    }
}