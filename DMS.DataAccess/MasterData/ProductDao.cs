
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : Product
 * Created Time: 2009-7-8 14:26:37
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using DMS.Model.DataInterface;
using System.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// Product的Dao
    /// </summary>
    public class ProductDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public ProductDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public Product GetObject(Guid objKey)
        {
            Product obj = this.ExecuteQueryForObject<Product>("SelectProduct", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<Product> GetAll()
        {
            IList<Product> list = this.ExecuteQueryForList<Product>("SelectProduct", null);
            return list;
        }


        /// <summary>
        /// 查询Product
        /// </summary>
        /// <returns>返回Product集合</returns>
        public IList<Product> SelectByFilter(Product obj)
        {
            IList<Product> list = this.ExecuteQueryForList<Product>("SelectByFilterProduct", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(Product obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateProduct", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Product obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteProduct", obj);
            return cnt;
        }



        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(Product obj)
        {
            this.ExecuteInsert("InsertProduct", obj);
        }

        /// <summary>
        /// 产品信息接口
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public IList<ProductData> QueryProductDataInfo()
        {
            IList<ProductData> list = this.ExecuteQueryForList<ProductData>("QueryProductDataInfo", null);
            return list;
        
        }

        /// <summary>
        /// 根据UPN获取产品信息
        /// </summary>

        public IList<ProductDataForQAComplain> QueryProductDataInfoByUPN(Hashtable ht)
        {

            IList<ProductDataForQAComplain> list = this.ExecuteQueryForList<ProductDataForQAComplain>("QueryProductDataInfoByUPN", ht);
            return list;
        }

        public DataSet P_GetAllProductList()
        {
            return this.ExecuteQueryForDataSet("P_GetAllProductList", null);
        }

        public DataSet CheckProductMinQty(Hashtable ht)
        {
            return this.ExecuteQueryForDataSet("CheckProductMinQty", ht);
        }

        public void BatchInsert(DataTable dt)
        {
            this.ExecuteBatchInsert("InterfaceERPProduct", dt);
        }
        public void ProcessERPInterface()
        {
            Hashtable ht = new Hashtable();
            this.ExecuteInsert("GC_Interface_ERPProduct", ht);
        }
    }
}