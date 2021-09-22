
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : SapWarehouseAddress
 * Created Time: 2013/10/11 11:21:29
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
    /// SapWarehouseAddress的Dao
    /// </summary>
    public class SapWarehouseAddressDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public SapWarehouseAddressDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public SapWarehouseAddress GetObject(Guid objKey)
        {
            SapWarehouseAddress obj = this.ExecuteQueryForObject<SapWarehouseAddress>("SelectSapWarehouseAddress", objKey);           
            return obj;
        }

        public SapWarehouseAddress GetObjectByCode(string Code)
        {
            SapWarehouseAddress obj = this.ExecuteQueryForObject<SapWarehouseAddress>("SelectSapWarehouseAddressByCode", Code);
            return obj;
        }
        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<SapWarehouseAddress> GetAll()
        {
            IList<SapWarehouseAddress> list = this.ExecuteQueryForList<SapWarehouseAddress>("SelectSapWarehouseAddress", null);          
            return list;
        }


        /// <summary>
        /// 查询SapWarehouseAddress
        /// </summary>
        /// <returns>返回SapWarehouseAddress集合</returns>
		public IList<SapWarehouseAddress> SelectByFilter(SapWarehouseAddress obj)
		{ 
			IList<SapWarehouseAddress> list = this.ExecuteQueryForList<SapWarehouseAddress>("SelectByFilterSapWarehouseAddress", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(SapWarehouseAddress obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateSapWarehouseAddress", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteSapWarehouseAddress", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(SapWarehouseAddress obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteSapWarehouseAddress", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(SapWarehouseAddress obj)
        {
            this.ExecuteInsert("InsertSapWarehouseAddress", obj);           
        }

        public IList<SapWarehouseAddress> QuerySapWarehouseAddressByDmaID(Hashtable table)
        {
            IList<SapWarehouseAddress> list = this.ExecuteQueryForList<SapWarehouseAddress>("QuerySapWarehouseAddressByDmaID", table);
            return list;
        }
    }
}