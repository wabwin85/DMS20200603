
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : Warehouse
 * Created Time: 2009-7-10 14:08:13
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
    /// Warehouse的Dao
    /// </summary>
    public class WarehouseDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public WarehouseDao(): base()
        {
        }

        /// <summary>
        /// 获得现有量不是零的库存记录数。用来检查某个仓库是否为空。记录数大于零时该仓库不空，为零时仓库是空仓库。
        /// </summary>
        /// <param name="warehouseId"></param>
        /// <returns></returns>
        public int recordsOfHaveQtyInWarehouse(Guid warehouseId)
        {
            return QueryForCount("SelectWarehouseRecordCount", warehouseId);
        }

        /// <summary>
        /// 返回改
        /// </summary>
        /// <param name="warehouseName"></param>
        /// <returns></returns>
        public int recordsOfSameWarehouseName(Hashtable table)
        {
            return QueryForCount("SelectWarehouseName", table);
        }

        /// <summary>
        /// 返回改

        /// </summary>
        /// <param name="warehouseName"></param>
        /// <returns></returns>
        public int recordsOfSameWarehouseCode(string code)
        {
            return QueryForCount("SelectWarehouseCode", code);
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public Warehouse GetObject(Guid objKey)
        {
            Warehouse obj = this.ExecuteQueryForObject<Warehouse>("SelectWarehouse", objKey);           
            return obj;
        }

        public IList<Warehouse> GetObjectByDealer(Guid objKey)
        {
            IList<Warehouse> list = this.ExecuteQueryForList<Warehouse>("SelectWarehouseByDealer", objKey);
            return list;
        }

        public IList<Warehouse> GetAllByDealer(Guid objKey)
        {
            IList<Warehouse> list = this.ExecuteQueryForList<Warehouse>("SelectAllWarehouseByDealer", objKey);
            return list;
        }

        public DataTable GetAllByDealerDT(string id,string Type1, string Type2,string Type3)
        {
            DataTable ds = new DataTable();
            Hashtable t = new Hashtable();
            t.Add("WHM_DMA_ID", id);
            t.Add("Type1", Type1);
            t.Add("Type2", Type2);
            t.Add("Type3", Type3);
            if (string.IsNullOrEmpty(Type3))
            {
                ds = this.ExecuteQueryForDataSet("SelectWarehouseByDealerDT", t).Tables[0];
            }
            else
            {
                ds = this.ExecuteQueryForDataSet("SelectWarehouseByDealerT2", t).Tables[0];
            }
            return ds;
        }
        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<Warehouse> GetAll()
        {
            IList<Warehouse> list = this.ExecuteQueryForList<Warehouse>("SelectWarehouse", null);          
            return list;
        }

        /// <summary>
        /// 通过用户Guid查询Warehouse
        /// </summary>
        /// <returns>返回Warehouse集合</returns>
        public IList<Warehouse> GetWarehouseByUserID(Guid objKey)
        {
            IList<Warehouse> list = this.ExecuteQueryForList<Warehouse>("SelectByUserID", objKey);
            return list;
        }

        /// <summary>
        /// 通过hashtable查询Warehouse
        /// </summary>
        /// <returns>返回Warehouse集合</returns>
        public IList<Warehouse> SelectByHashtableForCreateSystemHoldWH(Hashtable obj)
        {
            IList<Warehouse> list = this.ExecuteQueryForList<Warehouse>("SelectByHashtableForCreateSystemHoldWH", obj);
            return list;
        }

        /// <summary>
        /// 通过hashtable查询Warehouse
        /// </summary>
        /// <returns>返回Warehouse集合</returns>
        public IList<Warehouse> GetWarehouseByHashtable(Hashtable obj)
        {
            IList<Warehouse> list = this.ExecuteQueryForList<Warehouse>("SelectByHashtable", obj);
            return list;
        }

        public IList<Warehouse> GetWarehouseByHashtable(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            IList<Warehouse> list = this.ExecuteQueryForList<Warehouse>("SelectByHashtable", obj, start, limit, out totalRowCount);
            return list;
        }


        /// <summary>
        /// 查询Warehouse
        /// </summary>
        /// <returns>返回Warehouse集合</returns>
		public IList<Warehouse> SelectByFilter(Warehouse obj)
		{ 
			IList<Warehouse> list = this.ExecuteQueryForList<Warehouse>("SelectByFilterWarehouse", obj);          
            return list;
		}

        /// <summary>
        /// 查询Warehouse,得到翻页用的Warehouse集合
        /// </summary>
        /// <returns>返回DealerMaster集合</returns>
        public IList<Warehouse> SelectByFilter(Warehouse obj, int start, int limit, out int totalRowCount)
        {
            IList<Warehouse> list = this.ExecuteQueryForList<Warehouse>("SelectByFilterWarehouse", obj, start, limit, out totalRowCount);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(Warehouse obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateWarehouse", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Warehouse obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteWarehouse", obj);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(Warehouse obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteWarehouse", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(Warehouse obj)
        {
            this.ExecuteInsert("InsertWarehouse", obj);           
        }

        public void InsertWhm(Warehouse obj)
        {
            this.ExecuteInsert("InsertWhm", obj);  
        }

        /// <summary>
        /// 查询导出
        /// </summary>
        /// <returns>返回Warehouse集合</returns>
        public DataSet GetWarehouseForExport(Hashtable obj)
        {
            DataSet list = this.ExecuteQueryForDataSet("SelectByHashtableForExport", obj);
            return list;
        }

        public DataSet GetWarehouseTypeById(Guid obj)
        {
            DataSet list = this.ExecuteQueryForDataSet("GetWarehouseTypeById", obj);
            return list;
        }

        public DataSet GetNoLimitWarehouse(Hashtable obj)
        {
            DataSet list = this.ExecuteQueryForDataSet("QueryDealerWarehouseIsLimit", obj);
            return list;
        }
    }
}