using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using DMS.Model.DataInterface;
using System.Data;

namespace DMS.DataAccess.MasterData
{
    /// <summary>
    /// ProductLineDao
    /// </summary>
    public class ProductLineDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ProductLineDao(): base()
        {
        }
		
        public String SelectProductLineName(Guid productLineId)
        {
            return this.ExecuteQueryForObject<String>("MasterData.ProductLineMap.SelectProductLineName", productLineId);
        }

        public IList<ViewProductLine> SelectViewProductLine(string subCompanyId, string brandId, string id)
        {
            Hashtable table = new Hashtable();
            table.Add("SubCompanyId", subCompanyId);
            table.Add("BrandId", brandId);
            table.Add("Id", id);
            return this.ExecuteQueryForList<ViewProductLine>("MasterData.ProductLineMap.SelectViewProductLine", table);
        }
    }
}