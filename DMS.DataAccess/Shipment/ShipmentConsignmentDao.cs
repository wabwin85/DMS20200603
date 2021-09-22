
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ShipmentConsignment
 * Created Time: 2014/3/17 16:15:13
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
    /// ShipmentConsignment的Dao
    /// </summary>
    public class ShipmentConsignmentDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ShipmentConsignmentDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ShipmentConsignment GetObject(Guid objKey)
        {
            ShipmentConsignment obj = this.ExecuteQueryForObject<ShipmentConsignment>("SelectShipmentConsignment", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ShipmentConsignment> GetAll()
        {
            IList<ShipmentConsignment> list = this.ExecuteQueryForList<ShipmentConsignment>("SelectShipmentConsignment", null);          
            return list;
        }


        /// <summary>
        /// 查询ShipmentConsignment
        /// </summary>
        /// <returns>返回ShipmentConsignment集合</returns>
		public IList<ShipmentConsignment> SelectByFilter(ShipmentConsignment obj)
		{ 
			IList<ShipmentConsignment> list = this.ExecuteQueryForList<ShipmentConsignment>("SelectByFilterShipmentConsignment", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ShipmentConsignment obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateShipmentConsignment", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShipmentConsignment", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ShipmentConsignment obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteShipmentConsignment", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ShipmentConsignment obj)
        {
            this.ExecuteInsert("InsertShipmentConsignment", obj);           
        }

        public DataSet SelectByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterShipmentConsignmentByHeadId", table, start, limit, out totalRowCount);
            return ds;
        }

        public int DeleteByHeaderId(Guid headId)
        {
            int cnt = (int)this.ExecuteUpdate("DeleteShipmentConsignmentByHeaderId", headId);
            return cnt;
        }

        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ShipmentConsignment> GetShipmentConsignmentByFilter(Hashtable table)
        {
            IList<ShipmentConsignment> list = this.ExecuteQueryForList<ShipmentConsignment>("QueryShipmentConsignmentByFilter", table);
            return list;
        }
    }
}