
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : QueryInventory
 * Created Time: 2009-8-7 8:53:53 PM
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
    /// QueryInventory的Dao
    /// </summary>
    public class QueryInventoryDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数

        /// </summary>
		public QueryInventoryDao(): base()
        {
        }
		
        /// <summary>
        /// 查询QueryInventory
        /// </summary>
        /// <returns>返回QueryInventory集合</returns>
		public IList<QueryInventory> SelectByFilter(Hashtable ht)
		{
            IList<QueryInventory> list = this.ExecuteQueryForList<QueryInventory>("SelectInventoryForMetronicUser", ht);          
            return list;
		}

        public IList<QueryInventory> SelectForDealer(Guid DealerId, string SubCompanyId, string BrandId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("value", DealerId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            IList<QueryInventory> list = this.ExecuteQueryForList<QueryInventory>("SelectInventoryForDealer",ht );
            return list;
        }

        public IList<QueryInventory> SelectByFilter(Hashtable ht, int start, int limit, out int totalRowCount)
        {
            IList<QueryInventory> list = this.ExecuteQueryForList<QueryInventory>("SelectInventoryForMetronicUser", ht, start, limit, out totalRowCount);
            return list;
        }

        public DataSet SelectByFilterDataSet(Hashtable ht, int start, int limit, out int totalRowCount)
        {

            DataSet ds = this.ExecuteQueryForDataSet("SelectInventoryForBSCUserDataSet", ht, start, limit, out totalRowCount);            
            return ds;
        }

        public Decimal GetInventoryListSum(Hashtable ht)
        {

            Decimal invSum = this.ExecuteQueryForObject<Decimal>("SelectInventorySumForBSCUser", ht);
            return invSum;
        }


        public DataSet SelectInventoryByDealerForExpired(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInventoryByDealerForExpired", ht);
            return ds;
        }

        /// <summary>
        /// 查询QueryInventory
        /// </summary>
        /// <returns>返回QueryInventory集合</returns>
        public DataSet SelectDataSetByFilter(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportInventoryForUser", ht);
            return ds;
        }

        /// <summary>
        /// 导出平台ABC产品分类库存
        /// </summary>
        /// <returns>返回QueryInventory集合</returns>
        public DataSet ExportLPInventoryABCDataSetByFilter(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportLPInventoryABCForUser", ht);
            return ds;
        }

        public DataSet SelectInventoryLotForQABSCComplainsDataSet(Hashtable ht)
        {

            DataSet ds = this.ExecuteQueryForDataSet("SelectInventoryLotForQABSCComplainsDataSet", ht);
            return ds;
        }

        public DataSet SelectInventoryUPNForQABSCComplainsDataSet(Hashtable ht)
        {

            DataSet ds = this.ExecuteQueryForDataSet("SelectInventoryUPNForQABSCComplainsDataSet", ht);
            return ds;
        }

        public DataSet SelectInventoryWHMForQABSCComplainsDataSet(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInventoryWHMForQABSCComplainsDataSet", ht);
            return ds;
        }

        public DataSet SelectInventoryLotForQACRMComplainsDataSet(Hashtable ht)
        {

            DataSet ds = this.ExecuteQueryForDataSet("SelectInventoryLotForQACRMComplainsDataSet", ht);
            return ds;
        }

        public DataSet SelectInventoryUPNForQACRMComplainsDataSet(Hashtable ht)
        {

            DataSet ds = this.ExecuteQueryForDataSet("SelectInventoryUPNForQACRMComplainsDataSet", ht);
            return ds;
        }

        public DataSet SelectInventoryWHMForQACRMComplainsDataSet(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInventoryWHMForQACRMComplainsDataSet", ht);
            return ds;
        }

        public DataSet SelectNPOIDataSetByFilter(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportNPOIInventoryForUser", ht);
            return ds;
        }
      // add  hou zhi yong 
        public DataSet SelectInventoryPrice(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInventoryPrice", table, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet ExportNPOIInventoryPrice(Hashtable  ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportNPOIInventoryPrice", ht);
            return ds;
        }

        #region Added By Song Yuqi For 经销商投诉退换货 On 2017-08-23
        public DataSet SelectInventoryForComplainsDataSet(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return this.ExecuteQueryForDataSet("SelectInventoryForComplainsDataSet", table, start, limit, out totalRowCount);
        }

        public DataSet SelectInventoryWarehouseForComplainsDataSet(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return this.ExecuteQueryForDataSet("SelectInventoryWarehouseForComplainsDataSet", table, start, limit, out totalRowCount);
        }

        public DataSet QueryDealerComplainProductSaleDate(Hashtable table)
        {
            return this.ExecuteQueryForDataSet("QueryDealerComplainProductSaleDate", table);
        }

        #endregion
        public DataSet SelectNearEffectInventoryDataSet(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectNearEffectInventoryDataSet", ht);
            return ds;
        }
    }
}