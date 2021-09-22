
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ShipmentlpConfirmHeader
 * Created Time: 2014/5/30 13:06:04
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
    /// ShipmentlpConfirmHeader的Dao
    /// </summary>
    public class ShipmentlpConfirmHeaderDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ShipmentlpConfirmHeaderDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ShipmentlpConfirmHeader GetObject(Guid objKey)
        {
            ShipmentlpConfirmHeader obj = this.ExecuteQueryForObject<ShipmentlpConfirmHeader>("SelectShipmentlpConfirmHeader", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ShipmentlpConfirmHeader> GetAll()
        {
            IList<ShipmentlpConfirmHeader> list = this.ExecuteQueryForList<ShipmentlpConfirmHeader>("SelectShipmentlpConfirmHeader", null);          
            return list;
        }


        /// <summary>
        /// 查询ShipmentlpConfirmHeader
        /// </summary>
        /// <returns>返回ShipmentlpConfirmHeader集合</returns>
		public IList<ShipmentlpConfirmHeader> SelectByFilter(ShipmentlpConfirmHeader obj)
		{ 
			IList<ShipmentlpConfirmHeader> list = this.ExecuteQueryForList<ShipmentlpConfirmHeader>("SelectByFilterShipmentlpConfirmHeader", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ShipmentlpConfirmHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateShipmentlpConfirmHeader", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShipmentlpConfirmHeader", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ShipmentlpConfirmHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteShipmentlpConfirmHeader", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ShipmentlpConfirmHeader obj)
        {
            this.ExecuteInsert("InsertShipmentlpConfirmHeader", obj);           
        }

        public ShipmentlpConfirmHeader GetShipmentlpConfirmHeaderByOrderNo(string OrderNo)
        {
            ShipmentlpConfirmHeader obj = this.ExecuteQueryForObject<ShipmentlpConfirmHeader>("GetShipmentlpConfirmHeaderByOrderNo", OrderNo);
            return obj;
        }
        public DataSet QueryShipmentlpConfirmHeaderInfoByOrderUpnLot(Hashtable ht, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryShipmentlpConfirmHeaderInfoByOrderUpnLot", ht, start, limit, out totalRowCount);
            return ds;
        }
        public void UpdateSCHConfirmDate(Hashtable ht)
        {
            this.ExecuteUpdate("UpdateSCHConfirmDateByOrderNo", ht);  
        }
        public void SaveAdjustItemPrice(Hashtable ht)
        {
            this.ExecuteUpdate("UpdateAdjustItemPriceById", ht);  
        }
    }
}